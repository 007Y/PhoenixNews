//
//  BigImageViewController.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/17.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "BigImageViewController.h"

@interface BigImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.backgroundColor = [UIColor blackColor];
    
    //如果不加在最下面, 按钮没办法显示出来
    [self.view insertSubview:scrollView atIndex:0];
    
    
    _imageView = [[UIImageView alloc] init];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.model.img[0][@"url"]]];
    
    [scrollView addSubview:_imageView];
    // 图片的尺寸
    _imageView.x = 0;
    _imageView.width = ScreenWidth;
    
    if([self.model.img[0][@"size"][@"width"] intValue] != 0){
    _imageView.height = [self.model.img[0][@"size"][@"height"] intValue] * ScreenWidth / [self.model.img[0][@"size"][@"width"] intValue];
    }else{
        return;
    }
    if (_imageView.height > ScreenHeight) { // 图片过长
        _imageView.y = 0;
        scrollView.contentSize = CGSizeMake(0, _imageView.height);
    } else { // 图片居中显示
        _imageView.centerY = ScreenHeight * 0.5;
    }
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
