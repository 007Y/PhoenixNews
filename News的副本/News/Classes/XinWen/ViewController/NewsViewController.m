//
//  NewsViewController.m
//  News
//
//  Created by 李冬 on 2016/12/1.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTopTableViewController.h"
#import "HoursTableViewController.h"
#import "BeautyTableViewController.h"
@interface NewsViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray * buttonArray;
@property(nonatomic,strong)UIButton *selectedTitleButton;
@property(nonatomic,strong)UIView * titleBottomView;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)NSMutableArray * viewArray;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupScroll];
    [self setNavgationBar];
    [self setupTitle];
    [self addChildVc];
    

    
    // Do any additional setup after loading the view.
}
- (void)setNavgationBar{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appicon"]];
    

    
    UIButton *LeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [LeftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [LeftButton setImage:[UIImage imageNamed:@"24icon"] forState:UIControlStateNormal];
    [LeftButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:LeftButton];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"24icon"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
- (void)leftClick:(UIButton *)sender{
    HoursTableViewController * hour = [[HoursTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:hour animated:YES];
}
- (void)rightClick:(UIButton *)sender{
    
}
- (void)setupTitle{
    
    UIScrollView * buttonView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth,35)];
//    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH,35)];
    buttonView.contentSize = CGSizeMake(ScreenWidth , 35);
    [self.view addSubview:buttonView];
    buttonView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    NSMutableArray * title = [NSMutableArray arrayWithObjects:@"头条",@"推荐",@"美女",@"段子", nil];
    for (int i = 0; i < title.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
         button.frame = CGRectMake(i * ScreenWidth / title.count, 0, ScreenWidth / title.count, 35);
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(inView:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
        [buttonView addSubview:button];
        
    }
    UIButton * firstButton = _buttonArray.firstObject;
    [firstButton.titleLabel sizeToFit];
    //指示器
    UIView * titleBottomView = [[UIView alloc] initWithFrame:CGRectMake(firstButton.center.x - firstButton.titleLabel.frame.size.width/2.0, 35 - 1, firstButton.titleLabel.frame.size.width, 1)];
    self.titleBottomView = titleBottomView;
    titleBottomView.backgroundColor = [UIColor redColor];;
    [buttonView addSubview:titleBottomView];
    [self inView:firstButton];
}

- (void)inView:(UIButton *)sender{
    //转换上一个sender的selected的状态
    self.selectedTitleButton.selected = NO;
    sender.selected =YES;
    self.selectedTitleButton = sender;
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.center = CGPointMake(sender.center.x, 34);
    }];
    CGPoint offset = self.scroll.contentOffset;
    offset.x = ScreenWidth * [self.buttonArray indexOfObject:sender];
    [self.scroll setContentOffset:offset animated:YES];
    
}

- (void)setupScroll{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scroll = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scroll.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight);
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    int index = scrollView.contentOffset.x / ScreenHeight;
    //确定选中的button
    [self inView:self.buttonArray[index]];
}
- (void)addChildVc{
    NewsTopTableViewController * top = [[NewsTopTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:top];
    top.view.frame = self.scroll.bounds;
    [self.scroll addSubview:top.view];
    BeautyTableViewController *beauty = [[BeautyTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:beauty];
    beauty.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
    [self.scroll addSubview:beauty.view];
    
    
    
    
    
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    int index = scrollView.contentOffset.x / ScreenWidth;
//    UIViewController * willShowChildVc = self.childViewControllers[index];
    // 如果控制器的view已经被创建过，就直接返回
//    if (willShowChildVc.isViewLoaded) return;
//    
//    // 添加子控制器的view到scrollView身上
//    willShowChildVc.view.frame = scrollView.bounds;
//    [scrollView addSubview:willShowChildVc.view];
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
