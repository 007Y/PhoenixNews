//
//  TotalCommentViewController.m
//  Team
//
//  Created by wyzc on 16/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "VideoCommentTableViewCell.h"
#import "DetailsPage.h"
#define CELLHOTCOMMNETVIDEOURL(page,guid) [NSString stringWithFormat:@"http://icomment.ifeng.com/geti.php?pagesize=20&p=%d&docurl=%@",page,guid]
@interface NewsCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *totalTableView;
@property (weak, nonatomic) IBOutlet UITextField *commenttext;

@property (nonatomic, weak) AFHTTPSessionManager *manager;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;

@property(nonatomic,assign)int page;

@end

static NSString * const reuseID = @"reuse";
static NSString * const HeaderId = @"reuse";

@implementation NewsCommentViewController

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
    UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60)];
    _totalTableView = tableview;
    self.totalTableView.delegate = self;
    self.totalTableView.dataSource = self;
    
    [self.totalTableView registerNib:[UINib nibWithNibName:@"VideoCommentTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    [self.view addSubview:_totalTableView];
}

- (void)setupRefresh
{
    [self requestData];
    WeakSelf;
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
    WeakSelf;
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    [self.manager GET:CELLHOTCOMMNETVIDEOURL(_page, self.commenturl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        
    }];
    
}

- (void)requestData{
    _page = 0;
    WeakSelf;
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    
    [self.manager GET:CELLHOTCOMMNETVIDEOURL(0, self.commenturl)  parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.hotComments = [CommentVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"comments"][@"hottest"]];
        weakSelf.latestComments = [CommentVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"comments"][@"newest"]];
        
        //给评论量按钮赋值
        
        
        [weakSelf.totalTableView reloadData];
        [weakSelf.totalTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf.totalTableView.mj_header endRefreshing];
        
        if ([error code] == NSURLErrorCancelled) {
            
            return;
            
        }
        
        
    }];
    
}


#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
    NSLog(@"%ld",self.latestComments.count);
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray * arr = @[@"热门评论",@"最新评论"];
    return arr[section];
}
- (IBAction)backclick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
