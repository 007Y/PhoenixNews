//
//  SuperViewController.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "SuperViewController.h"
#import "SuperModel.h"
#import "SuperViewTableViewCell.h"

#import "MJExtension.h"

#import "CommentViewController.h"

@interface SuperViewController ()
/** 请求 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;

@end

@implementation SuperViewController
static NSString * const SuperCellId = @"suwerperCell";
#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSString *)aParam
{
    return @"list";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置tableViewController 自带的tabelView
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
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    
    // 发送请求
    
    WeakSelf;

    
    [self.manager GET:FUWUQIDIZHi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        weakSelf.topics = [SuperModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
       
        // 存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        //刷新表格
        [weakSelf.tableView reloadData];
        
       //结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    
}
- (void)loadMoreData{
    
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;
    

    // 发送请求
    WeakSelf;
    
    [self.manager GET:FUWUQIDIZHi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
        
     
        NSArray *moreTopics = [SuperModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [weakSelf.topics addObjectsFromArray:moreTopics];
        // 存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}


- (void)setupTable
{
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:215 /255.0 green:215/255.0 blue:215/255.0 alpha:1];
    
    //更改自带tableView的位置
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35, 0, 49, 0);
    
    //同时更改右侧指示条的位置
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SuperViewTableViewCell class]) bundle:nil] forCellReuseIdentifier:SuperCellId];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    SuperViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SuperCellId];
    
    
    cell.model = self.topics[indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 在这个方法中，已经将cell的高度 和 中间内容的frame 计算完毕
    SuperModel *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentViewController *comment = [[CommentViewController alloc] init];
    
    comment.model = self.topics[indexPath.row];
    
    [self.navigationController pushViewController:comment animated:YES];
    
}




@end
