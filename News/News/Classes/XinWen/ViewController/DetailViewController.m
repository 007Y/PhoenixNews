//
//  DetailViewController.m
//  News
//
//  Created by 李冬 on 2016/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailsPage.h"
@interface DetailViewController ()
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
}
- (void)requestData{
    WeakSelf;
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    [session GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DetailsPage * model = [[DetailsPage alloc] init];
        [model setValuesForKeysWithDictionary:responseObject[@"body"]];
        [weakSelf label:model.title time:model.updateTime source:model.source webViw:model.text];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (void)label:(NSString *)title time:(NSString *)updateTime source:(NSString *)source webViw:(NSString *)HTML{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 80)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:25];
    //    [self.view addSubview:titleLabel];
    
    
    CGFloat timeY = CGRectGetMaxY(titleLabel.frame) + 5;
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, timeY, ScreenWidth - 20, 30)];
    timeLabel.text = [NSString stringWithFormat:@"%@ %@",updateTime,source];
    [self.view addSubview:timeLabel];
    CGFloat webY = CGRectGetMaxY(timeLabel.frame) + 5;
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0,65, ScreenWidth, ScreenHeight-50)];
    
    [web.scrollView addSubview:titleLabel];
    [web.scrollView addSubview:timeLabel];
    web.scrollView.subviews[0].frame = CGRectMake(0, webY, ScreenWidth, ScreenHeight - timeY - 50);
    web.backgroundColor = [UIColor whiteColor];
    [web loadHTMLString:HTML baseURL:nil];
    [self.view addSubview:web];
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
