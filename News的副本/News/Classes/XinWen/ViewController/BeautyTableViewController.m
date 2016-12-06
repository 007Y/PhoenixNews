//
//  BeautyTableViewController.m
//  News
//
//  Created by 李冬 on 2016/12/5.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "BeautyTableViewController.h"
#import "NewsModel.h"
#import "BeautyTableViewCell.h"
#import "BeautyCateTableViewController.h"
@interface BeautyTableViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *nameArray;
@property(nonatomic,strong)NSMutableArray *typeArray;
@property(nonatomic,strong)NSMutableArray *clickArray;
@property(nonatomic,strong)NSString * nameString;
@property(nonatomic,assign)int page;
@end
static NSString * const BeautyRedifier = @"BeautyRedifier";
@implementation BeautyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.estimatedRowHeight = ScreenHeight;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(BeautyTableViewCell.class) bundle:nil] forCellReuseIdentifier:BeautyRedifier];
    [self refresh];
    //更改自带tableView的位置
    self.tableView.contentInset = UIEdgeInsetsMake(64+35, 0, 49, 0);
    //同时更改右侧指示条的位置
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    

}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (void)refresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
}

- (void)requestData{
    WeakSelf;
    _page = 1;
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
        [session GET:Beauty(1) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _dataArray = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"body"]];
        _nameArray = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self setupTableViewHeader];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}



- (void)requestMoreData{
    WeakSelf;
    _page ++;
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    [session GET:Beauty(_page) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * mu = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"body"]];
        
        [_dataArray addObjectsFromArray:mu];
        
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)setupTableViewHeader{
    
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    scroll.contentSize = CGSizeMake(80 * _nameArray.count, 30);
    for (int i = 0; i < _nameArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [scroll addSubview:button];

        button.frame = CGRectMake(i * 60 + 20 * i + 1, 2.5, 40, 25);
        NewsModel * model = _nameArray[i];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        scroll.showsHorizontalScrollIndicator = NO;
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tableView.tableHeaderView = scroll;

}
- (void)click:(UIButton *)sender{
    int i =(int)sender.tag - 1000;
   
    NewsModel * model = _nameArray[i];
    _nameString = model.name;
    [self requestData:model.type];
    
    
    
}
- (void)requestData:(NSString *)str{
    WeakSelf;
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    [session GET:BeautyCate(str) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _clickArray = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"body"]];
        
         BeautyCateTableViewController * cate = [[BeautyCateTableViewController alloc] initWithStyle:UITableViewStylePlain];
        cate.navigationItem.title = weakSelf.nameString;
        cate.arr = _clickArray;
        [weakSelf.navigationController pushViewController:cate animated:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  [_dataArray[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeautyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BeautyRedifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
