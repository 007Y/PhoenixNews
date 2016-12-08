//
//  HoursTableViewController.m
//  News
//
//  Created by 李冬 on 2016/12/5.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HoursTableViewController.h"
#import "NewsModel.h"
#import "NewsTopTableViewCell.h"
#import "WebViewController.h"
#import "DetailViewController.h"
#import "NewsCommentViewController.h"
@interface HoursTableViewController ()
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * timeArray;
@end
static NSString * const topRedifier = @"topRedifier";
@implementation HoursTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"24小时";
    _dataArray = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tabBarController.tabBar.hidden = YES;
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NewsTopTableViewCell.class) bundle:nil] forCellReuseIdentifier:topRedifier];
    self.tableView.contentInset = UIEdgeInsetsMake(65+15, 0, -35, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestData];
}
- (void)requestData{
//    WeakSelf;
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    [session GET:HoursUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * arr = responseObject[0][@"item"];
        NSArray * arr1 = [NewsModel mj_objectArrayWithKeyValuesArray:arr];
        for (int j = 23; j >= 0; j --) {
            NSMutableArray * moArr = [NSMutableArray array];

            for (int i = 0; i < arr1.count; i ++) {
                NewsModel * model = arr1[i];
                if (model.updateTime.length > 0) {
                if ([[model.updateTime substringToIndex:2] intValue] == j) {
                    [moArr addObject:model];
                          }
                }
               
            }
            
            if (moArr.count > 0) {
                
                [_dataArray addObject:moArr];
            }


        }

                       [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * arr = _dataArray[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topRedifier forIndexPath:indexPath];
    NSArray * ar = _dataArray[indexPath.section];
        cell.model = ar[indexPath.row];
    // Configure the cell...
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NewsModel * model = _dataArray[section][0];
    return[NSString stringWithFormat:@"%@00",[model.updateTime substringToIndex:3]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (NSString *)updateTime:(NSString *)updateTime{
    
    NSArray * arrtime = [updateTime componentsSeparatedByString:@" "];
    NSString * timeb = [arrtime.lastObject substringToIndex:5];
    return timeb;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSArray * ar = _dataArray[indexPath.section];
    NewsModel * model = ar[indexPath.row];
    DetailViewController * detail = [[DetailViewController alloc] init];
    detail.url = model.ID;
    detail.commenturl = model.commentsUrl;
    detail.commentall = model.commentsall;
    [self presentViewController:detail animated:YES completion:^{
        
    }];
//    NewsCommentViewController * com = [[NewsCommentViewController alloc] init];
//    com.commenturl = model.commentsUrl;
//    com.url = model.ID;
//    [self.navigationController pushViewController:com animated:YES];
//    
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
