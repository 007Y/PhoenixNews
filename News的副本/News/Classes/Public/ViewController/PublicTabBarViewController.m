//
//  PublicTabBarViewController.m
//  News
//
//  Created by 李冬 on 2016/12/1.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "PublicTabBarViewController.h"
#import "NewsViewController.h"
#import "NewsNavViewController.h"
#import "MyTableViewController.h"
#import "VideosViewController.h"
#import "FoundViewController.h"
@interface PublicTabBarViewController ()

@end

@implementation PublicTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBar];
    // Do any additional setup after loading the view.
}
- (void)setTabBar{
    // UIControlStateNormal状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 文字大小
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    // 统一给所有的UITabBarItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法, 才可以通过appearance对象来统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [self setChildVc];
    
}
- (void)setChildVc{
    NewsNavViewController * nav = [[NewsNavViewController alloc] initWithRootViewController:[[NewsViewController alloc] init]];
    [self addChildVc:nav title:@"新闻" image:@"tabbar_news" selectedImage:@"tabbar_news_selected"];
    VideosViewController * video = [[VideosViewController alloc] init];
    [self addChildVc:video title:@"视频" image:@"tabbar_vision" selectedImage:@"tabbar_vision_selected"];
    FoundViewController * found = [[FoundViewController alloc] init];
    [self addChildVc:found title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    MyTableViewController * my = [[MyTableViewController alloc] init];
    [self addChildVc:my title:@"我的" image:@"tabbar_my" selectedImage:@"tabbar_my_selected"];

}
- (void)addChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    
    [self addChildViewController:vc];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
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
