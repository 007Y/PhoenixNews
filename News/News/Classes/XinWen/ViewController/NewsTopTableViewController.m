//
//  NewsTopTableViewController.m
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsTopTableViewController.h"
#import "NewsVideoTableViewCell.h"
#import "NewsTopTableViewCell.h"
#import "NewsPicTableViewCell.h"
#import "NewsModel.h"
#import "NewsSlideModel.h"
@interface NewsTopTableViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *newsTopArray;
@property(nonatomic,strong)NSMutableArray *newsPicArray;
@property(nonatomic,strong)NSMutableArray * picArray;
@end
static NSString * const topRedifier = @"topRedifier";
static NSString * const videoRedifier = @"videoRedifier";
static NSString * const picRedifier = @"picRedifier";

@implementation NewsTopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _picArray = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
//    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100) imageURLStringsGroup:_picArray];
//    self.tableView.tableHeaderView = scrollView;
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NewsTopTableViewCell.class) bundle:nil] forCellReuseIdentifier:topRedifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NewsVideoTableViewCell.class) bundle:nil] forCellReuseIdentifier:videoRedifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NewsPicTableViewCell.class) bundle:nil] forCellReuseIdentifier:picRedifier];
    
    
    [self requestData];
    
}
- (void)requestData{
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    [session GET:NewsTopUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * arr = responseObject[0][@"item"];
        
        _dataArray = [NewsModel mj_objectArrayWithKeyValuesArray:arr];
        
               for (NewsModel * model in _dataArray) {
                   NSLog(@"%@",model.type);
//                   if (model.type && [model.type isEqualToString:@"slide"] ) {
//                       [_picArray addObject:model.thumbnail];
//
//                   }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.tableView.mj_header endRefreshing];
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
    
    
    NewsTopTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:topRedifier forIndexPath:indexPath];
    NewsPicTableViewCell * picCell = [tableView dequeueReusableCellWithIdentifier:picRedifier forIndexPath:indexPath];
    NewsVideoTableViewCell * videoCell = [tableView dequeueReusableCellWithIdentifier:videoRedifier forIndexPath:indexPath];
    if ([_dataArray[indexPath.row][@"type"] isEqualToString:@"slide"]) {
        return picCell;
    }else if ([_dataArray[indexPath.row][@"type"] containsString:@"video"]){
        return videoCell;
    }
    
    
    // Configure the cell...
    
    
    
//    topCell.model = _dataArray[indexPath.row];
    return topCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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
