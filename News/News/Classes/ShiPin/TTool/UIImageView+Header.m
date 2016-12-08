//
//  UIImageView+Header.m
//  Team
//
//  Created by wyzc on 16/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "UIImageView+Header.h"
#import "UIImage+Circle.h"

@implementation UIImageView (Header)
- (void)setHeader:(NSString *)url
{
    [self setCircleHeader:url];
}
- (void)setCircleHeader:(NSString *)url
{
    WEAKSELF;
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         // 如果图片下载失败，就不做任何处理，按照默认的做法：会显示占位图片
         if (image == nil) return;
         
         weakSelf.image = [image circleImage];
     }];
}
@end
