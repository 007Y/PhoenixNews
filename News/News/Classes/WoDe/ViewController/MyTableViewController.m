//
//  MyTableViewController.m
//  News
//
//  Created by 李冬 on 2016/12/1.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyViewHeader.h"
@interface MyTableViewController ()
@property (nonatomic, strong)NSString *imageViewCacheSize;

@property(nonatomic,strong)NSArray * titles;
@end
static NSString * const MyRedifier = @"MyRedifier";

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
        [self getImageCache];

    
    
//    _titles = @[@"  夜间",@"  设置",@"  清除缓存"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MyViewHeader" owner:nil options:nil];
    MyViewHeader * view = nibView[0];
    view.frame = CGRectMake(0, 0, ScreenWidth, 200);
    self.tableView.tableHeaderView =view;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MyRedifier];
}
- (void)getImageCache{
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    float temp = [cache getSize];
    if (temp >= 1024) {
        
        _imageViewCacheSize = [NSString stringWithFormat:@"%.2fM",temp/1024/1024];
    }else{
        
        _imageViewCacheSize = [NSString stringWithFormat:@"%.2fKB",temp/1024];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRedifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.text = _titles[indexPath.row];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"清除缓存";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 160, 15, 140, 30)];
        label.text = _imageViewCacheSize;
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = label;
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"免责声明";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2){
        cell.textLabel.text = @"关于我们";
        UILabel *labele = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 160, 15, 140, 30)];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *version = [userDefault objectForKey:@"APP_VERSION"];
        labele.text = version;
        labele.textColor = [UIColor redColor];
        labele.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = labele;
        
    }else{
        cell.textLabel.text = @"服务条款";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    



    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"缓存清除将不会回复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"清除缓存成功" preferredStyle:UIAlertControllerStyleAlert];
            [self  showDetailViewController:alert1 sender:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [alert1 dismissViewControllerAnimated:YES completion:^{
                    
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    UILabel *label =(UILabel *)cell.accessoryView;
                    label.text = @"0.0";
                    
                }];
            });
            
        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self showDetailViewController:alert sender:nil];
        
    }else if (indexPath.section == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"免责声明" message:@"本APP旨在技术分享，不涉及任何商业利益。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

        
    }else if (indexPath.section == 2){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于我们" message:@"我们是ios团队，专注开发iOS应用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

    }else{
        
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
