//
//  NewsNavViewController.m
//  News
//
//  Created by 李冬 on 2016/12/1.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsNavViewController.h"

@interface NewsNavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NewsNavViewController


+ (void)initialize{
    
    //创建 bar 实例
    UINavigationBar * bar = [UINavigationBar appearance];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"tou_1242"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
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
