//
//  DetailViewController.h
//  News
//
//  Created by 李冬 on 2016/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperModel.h"
@interface DetailViewController : UIViewController
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString * commenturl;
@property(nonatomic,strong)NSString * commentall;
@property(nonatomic,strong) SuperModel *model;
@end
