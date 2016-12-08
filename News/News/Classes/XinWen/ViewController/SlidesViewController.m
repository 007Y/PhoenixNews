//
//  SlidesViewController.m
//  News
//
//  Created by 李冬 on 2016/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "SlidesViewController.h"
#import "SlideModel.h"
#import "NewsCommentViewController.h"
@interface SlidesViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UITextField *commenttext;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *shoucangbutton;




@property(nonatomic,strong)NSMutableArray *slideArray;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)UILabel * label;
@end

@implementation SlidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requstData];
    [self.comment setTitle:self.commentall forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (void)requstData{
    WeakSelf;
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    [session GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = responseObject[@"body"];
        _slideArray = [SlideModel mj_objectArrayWithKeyValuesArray:dic[@"slides"]];
        

        
        [weakSelf getscroll];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}
- (void)getscroll{
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60)];
    scroll.pagingEnabled = YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;
    scroll.contentSize =CGSizeMake(ScreenWidth * _slideArray.count, ScreenHeight);
    for (int i = 0 ; i < _slideArray.count; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight - 60)];
        
        
        SlideModel * model = _slideArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        [scroll addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *str = [NSString stringWithFormat:@"  %d/%ld  %@",i + 1,_slideArray.count,model.descriptio];
        CGRect rect = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40,2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(i * ScreenWidth + 10, ScreenHeight - 200 - rect.size.height, ScreenWidth - 20, rect.size.height)];
        label.textColor = [UIColor whiteColor];
        label.userInteractionEnabled = YES;
        label.numberOfLines = 0;
        label.tag = 500 + i;
        label.text = str;
        [scroll addSubview:label];
        
        
    }
    
    [self.view addSubview:scroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
- (IBAction)shoucang:(id)sender {
}
- (IBAction)fengxiang:(id)sender {
}
- (IBAction)comment:(id)sender {
    
    NewsCommentViewController * com = [[NewsCommentViewController alloc] init];
    com.url = self.commenturl;
    [self presentViewController:com animated:YES completion:^{
        
    }];
    
    
}
- (IBAction)backbutton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//- (void)pan{
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//    
//    int index = self.scroll.contentOffset.x / ScreenWidth;
//    UILabel * label = [self.view viewWithTag:index + 500];
//    [label addGestureRecognizer:pan];
//    
//}
//- (void)panAction:(UIPanGestureRecognizer *)sender{
//        CGPoint  ponit = [sender translationInView:self.view];
//    int index = self.scroll.contentOffset.x / ScreenWidth;
//    UILabel * label = [self.view viewWithTag:index + 500];
//    NSLog(@"%f",ponit.y);
//    if (1) {
//       label.transform = CGAffineTransformMake(1, 0, 0, 1, 10
//                                               , ponit.y);
//    }
//   
//}
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
