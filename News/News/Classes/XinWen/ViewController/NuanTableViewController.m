//
//  NuanTableViewController.m
//  News
//
//  Created by 李冬 on 2016/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NuanTableViewController.h"
#import "NewsVideoTableViewCell.h"
#import "NewsTopTableViewCell.h"
#import "NewsPicTableViewCell.h"
#import "NewsModel.h"
#import "DetailViewController.h"
#import "SlidesViewController.h"

@interface NuanTableViewController ()<SDCycleScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *slideArray;
@property(nonatomic,assign)int page;

@end

@implementation NuanTableViewController
static NSString * const topRedifier = @"topRedifier";
static NSString * const videoRedifier = @"videoRedifier";
static NSString * const picRedifier = @"picRedifier";

- (void)viewDidLoad {
    _slideArray = [NSMutableArray array];
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    
    //更改自带tableView的位置
    self.tableView.contentInset = UIEdgeInsetsMake(64+35, 0, 49, 0);
    //同时更改右侧指示条的位置
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NewsTopTableViewCell.class) bundle:nil] forCellReuseIdentifier:topRedifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NewsVideoTableViewCell.class) bundle:nil] forCellReuseIdentifier:videoRedifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NewsPicTableViewCell.class) bundle:nil] forCellReuseIdentifier:picRedifier];
    
    [self refresh];
    
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
    [session GET:[NSString stringWithFormat:@"http://api.iclient.ifeng.com/ClientNews?id=NXWPD,FOCUSNXWPD&page=%d",_page] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSArray * arr2 = responseObject[0][@"item"];
        _dataArray = [NewsModel mj_objectArrayWithKeyValuesArray:arr2];
        
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
    [session GET:[NSString stringWithFormat:@"http://api.iclient.ifeng.com/ClientNews?id=NXWPD,FOCUSNXWPD&page=%d",_page] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * arr = responseObject[0][@"item"];
        NSMutableArray * mu = [NewsModel mj_objectArrayWithKeyValuesArray:arr];
        
        [_dataArray addObjectsFromArray:mu];
        
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
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
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsModel * model = _dataArray[indexPath.row];
    if ([model.type isEqualToString:@"slide"]) {
        NewsPicTableViewCell * picCell = [tableView dequeueReusableCellWithIdentifier:picRedifier forIndexPath:indexPath];
        picCell.accessoryType = UITableViewCellAccessoryNone;
        
        picCell.model = _dataArray[indexPath.row];
        return picCell;
    }else if ([model.type containsString:@"video"] || [model.type containsString:@"live"]){
        NewsVideoTableViewCell * videoCell = [tableView dequeueReusableCellWithIdentifier:videoRedifier forIndexPath:indexPath];
        videoCell.accessoryType = UITableViewCellAccessoryNone;
        
        
        videoCell.model = _dataArray[indexPath.row];
        return videoCell;
    }
    
    
    // Configure the cell...
    
    NewsTopTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:topRedifier forIndexPath:indexPath];
    topCell.model = _dataArray[indexPath.row];
    topCell.accessoryType = UITableViewCellAccessoryNone;
    
    return topCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel * model = _dataArray[indexPath.row];
    
    
    if ([model.type containsString:@"video"] || [model.type containsString:@"live"]) {
        
        return 230;
    }else if([model.type containsString:@"slide"])
    {
        return 150;
    }
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel * model = _dataArray[indexPath.row];
    if ([model.type isEqualToString:@"slide"]) {
        SlidesViewController * slide = [[SlidesViewController alloc] init];
        slide.url = model.ID;
        [self.navigationController pushViewController:slide animated:YES];
        
    }else if ([model.type containsString:@"video"] || [model.type containsString:@"live"]){
        
    }else{
        DetailViewController * detail = [[DetailViewController alloc] init];
        detail.url = model.ID;
        detail.commenturl = model.commentsUrl;
        detail.commentall = model.commentsall;
        [self presentViewController:detail animated:YES completion:^{
            
        }];
    }
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
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
