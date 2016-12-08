//
//  VideoTableViewCell.h
//  TeamNews
//
//  Created by wyzc on 16/12/1.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface VideoTableViewCell : UITableViewCell
@property(nonatomic,strong)VideoModel * model;


//覆盖在上面的大按钮(跳转页面)
@property (weak, nonatomic) IBOutlet UIButton *bigButton;
//视频中间的播放按钮
@property (weak, nonatomic) IBOutlet UIButton *centrolButton;
//视频图片
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@end
