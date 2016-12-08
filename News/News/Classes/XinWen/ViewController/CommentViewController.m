//
//  CommentViewController.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/16.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CommentViewController.h"

#import "SuperViewTableViewCell.h"
#import "CommentTableViewCell.h"
#import "SuperModel.h"
#import "EssenceComment.h"
#import "EssenceUser.h"
#import "UIBarButtonItem+Creat.h"
#import "UIView+Category.h"
#import "CommentHeaderView.h"

#import "MJExtension.h"


@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

/** AFN */
@property (nonatomic, weak) AFHTTPSessionManager *manager;

/** 暂时存储：最热评论 */
@property (nonatomic, strong) EssenceComment *topComment;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;

- (int)aaa;

@end

@implementation CommentViewController

static NSString * const CommentCellId = @"comment";

static NSString * const HeaderId = @"header";


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子的最热评论数据
    if (self.topComment) {
        self.model.topComment = self.topComment;
        self.model.cellHeight = 0;
    }
}
#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
 
    
    //为了解决push进来tableView被导航条挡住的问题
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self setupTable];

    [self setupRefresh];

  
}

- (void)setupRefresh
{
    [self requsetData];

    
    __weak __typeof(self) weakSelf = self;
    //下拉
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requsetData];
        
    }];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    //上拉
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)requsetData{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.model.ID;
    params[@"hot"] = @1;
    
    // 发送请求
    WeakSelf;
    
    [self.manager GET:FUWUQIDIZHi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 意味着没有评论数据
            
            // 结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            
            // 返回
            return;
        }
        // 最热评论
        weakSelf.hotComments = [EssenceComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        weakSelf.latestComments = [EssenceComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
            //            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreData{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.model.ID;
    params[@"lastcid"] = [self.latestComments.lastObject ID];
    
    // 发送请求
    WeakSelf;
    [self.manager GET:FUWUQIDIZHi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 最新评论
        NSArray *newComments = [EssenceComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
            //            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        } else { // 应该还会有下一页数据
            // 结束刷新(恢复到普通状态，仍旧可以继续刷新)
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)setupTable
{
    self.tableView.backgroundColor = [UIColor grayColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:CommentCellId];
    
    [self.tableView registerClass:[CommentHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderId];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 处理模型数据
    //为了在显示的也的第一个cell上去掉最新评论
    if (self.model.topComment) {
        self.topComment = self.model.topComment;
        self.model.topComment = nil;
        self.model.cellHeight = 0;
    }
    
    // celll
    SuperViewTableViewCell *cell = [SuperViewTableViewCell viewFromXib];
    cell.model = self.model;
    cell.frame = CGRectMake(0, 0, ScreenWidth, self.model.cellHeight);
    
    // 设置header
    UIView *header = [[UIView alloc] init];
    header.height = cell.height + 2 * 10;
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
}


#pragma mark - 监听键盘位置的变化,从而改变下册输入条的位置
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 工具条平移的距离 == 屏幕高度 - 键盘最终的Y值
    self.bottomSpace.constant = ScreenHeight - [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    //这个动画有没有都可以
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hotComments.count) return 2;
    if (self.latestComments.count) return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.hotComments.count) {
        return self.hotComments.count;
    }
    
    return self.latestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellId];
    
    // 获得对应的评论数据
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    
    // 传递模型给cell
    cell.comment = comments[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderId];
    // 覆盖文字
    if (section == 0 && self.hotComments.count) {
        header.text = @"最热评论";
    } else {
        header.text = @"最新评论";
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
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


//拖拽时不能再显示键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - UIMenuController处理
//只有成为第一响应者时menu才会弹出
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 获得当前选中的评论
- (EssenceComment *)selectedComment
{
    // 获得被选中的cell的行号
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    NSInteger row = indexPath.row;
    
    // 获得评论数据
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    
    return comments[row];
}

//顶
- (void)ding:(UIMenuController *)menu
{
    NSLog(@"顶 - %@ %@",self.selectedComment.user.username,self.selectedComment.content);
}
//回复
- (void)reply:(UIMenuController *)menu
{
    NSLog(@"回复 - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}
//举报
- (void)warn:(UIMenuController *)menu
{
    NSLog(@"举报 - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
