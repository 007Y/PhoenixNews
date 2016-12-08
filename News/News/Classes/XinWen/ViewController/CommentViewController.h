//
//  CommentViewController.h
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/16.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuperModel;


@interface CommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) SuperModel *model;

@end
