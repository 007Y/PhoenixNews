//
//  SuperViewController.h
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SuperModel.h"

@interface SuperViewController : UITableViewController

//帖子的类型, 将来子类只需要重写这个方法实现页面的不同
- (InvitationType)type;

@end
