//
//  TotalCommentViewController.m
//  Team
//
//  Created by wyzc on 16/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "TotalCommentViewController.h"
#import "VideoCommentTableViewCell.h"
#import "CommentHeaderView.h"

@interface TotalCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *totalTableView;

@property (nonatomic, weak) AFHTTPSessionManager *manager;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;

@property(nonatomic,assign)int page;

@end

static NSString * const reuseID = @"reuse";
static NSString * const HeaderId = @"reuse";

@implementation TotalCommentViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
//    [self requestData];
    // Do any additional setup after loading the view from its nib.
}
- (void)setUpTableView{
//    [self requestData];
    _page = 1;
    [self setupRefresh];
    self.totalTableView.delegate = self;
    self.totalTableView.dataSource = self;
    
    [self.totalTableView registerNib:[UINib nibWithNibName:@"VideoCommentTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    [self.totalTableView registerClass:[CommentHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderId];
}

- (void)setupRefresh
{
    [self requestData];
    WEAKSELF;
    //下拉
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.totalTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestData];
        
    }];
    // 自动改变透明度
    self.totalTableView.mj_header.automaticallyChangeAlpha = YES;
    // 马上进入刷新状态
    [self.totalTableView.mj_header beginRefreshing];
    //上拉
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.totalTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)loadMoreData{
    _page ++;
    WEAKSELF;
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"type"] = @"all";
    
    [self.manager GET:CELLHOTCOMMNETVIDEOURL(_page, self.guid) parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",task.currentRequest.URL);
        
        NSMutableArray * muu = [CommentVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"comments"][@"newest"]];
        
        [weakSelf.latestComments addObjectsFromArray:muu];
        //给评论量按钮赋值
        
        
        [weakSelf.totalTableView reloadData];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"join_count"] intValue]) {
            
            // 已经完全加载完毕
            weakSelf.totalTableView.mj_footer.hidden = YES;
            
        } else { // 应该还会有下一页数据
            // 结束刷新(恢复到普通状态，仍旧可以继续刷新)
            [weakSelf.totalTableView.mj_footer endRefreshing];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf.totalTableView.mj_footer endRefreshing];
        
        if ([error code] == NSURLErrorCancelled) {
            
            return;
            
        }
        NSLog(@"评论页请求错误%@",error);
        
    }];
    
}

- (void)requestData{
    
    WEAKSELF;
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"type"] = @"all";
    
    [self.manager GET:CELLHOTCOMMNETVIDEOURL(1, self.guid) parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",task.currentRequest.URL);
        
        weakSelf.hotComments = [CommentVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"comments"][@"hottest"]];
                NSLog(@"wewewewewew%lu",(unsigned long)weakSelf.hotComments.count);
        
        weakSelf.latestComments = [CommentVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"comments"][@"newest"]];
        
        //给评论量按钮赋值
        
        
        [weakSelf.totalTableView reloadData];
        [weakSelf.totalTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf.totalTableView.mj_header endRefreshing];

        if ([error code] == NSURLErrorCancelled) {
            
            return;
            
        }
        NSLog(@"评论页请求错误%@",error);
        
        
    }];
    
}

- (IBAction)backClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderId];
    // 覆盖文字
    if (section == 0) {
        header.text = @"热门评论";
    } else {
        header.text = @"网友评论";
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGRect rect = [[self.hotComments[indexPath.row] comment_contents] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        return rect.size.height+100;

    }
    CGRect rect = [[self.latestComments[indexPath.row] comment_contents] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height+100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.hotComments.count;
    }
    return self.latestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (indexPath.section == 0) {
        cell.commentModel = self.hotComments[indexPath.row];
    }else{
        cell.commentModel = self.latestComments[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取出cell
    VideoCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    // 设置菜单内容
    menu.menuItems = @[
                       [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)]
                       ];
    
    // 显示位置
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, 1);
    [menu setTargetRect:rect inView:cell];
    
    // 显示出来
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - UIMenuController处理
//只有成为第一响应者时menu才会弹出
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//顶
- (void)ding:(UIMenuController *)menu
{
    
}
//回复
- (void)reply:(UIMenuController *)menu
{
}
//举报
- (void)warn:(UIMenuController *)menu
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
