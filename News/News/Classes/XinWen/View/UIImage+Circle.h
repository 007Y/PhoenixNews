//
//  UIImage+Circle.h
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/16.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Circle)
/**
 * 返回一张圆形图片
 */
- (instancetype)circleImage;

/**
 * 返回一张圆形图片
 */
+ (instancetype)circleImageNamed:(NSString *)name;
@end
