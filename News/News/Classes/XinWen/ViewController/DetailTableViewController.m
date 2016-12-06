//
//  DetailTableViewController.m
//  News
//
//  Created by 李冬 on 2016/12/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DetailsPage.h"
@interface DetailTableViewController ()
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self requestData];
}
- (void)requestData{
    WeakSelf;
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    [session GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DetailsPage * model = [[DetailsPage alloc] init];
        [model setValuesForKeysWithDictionary:responseObject[@"body"]];
        
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[model.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers  error:&error];
//        GDataXMLDocument * xmlDocu = [[GDataXMLDocument alloc] initWithData:[model.text dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
//        GDataXMLElement * rootEle = xmlDocu.rootElement;
//
//        NSArray * arr = rootEle.children;
//        for (GDataXMLElement * grandElement in arr) {
//            //得到节点值
//            NSString * str = grandElement.stringValue;
//            for (GDataXMLElement * graEle in grandElement.children) {
//                NSLog(@"%@",graEle.stringValue);
//                //            Student * stu = [_dataArray lastObject];
////                [stu setValue:graEle.stringValue forKey:graEle.localName];
//            }
////            [_dataArray addObject:stu];
//        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
