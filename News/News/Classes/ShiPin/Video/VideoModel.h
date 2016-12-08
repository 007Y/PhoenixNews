//
//  VideoModel.h
//  Team
//
//  Created by wyzc on 16/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
//标题
@property(nonatomic,strong)NSString * title;
//视频的图片
@property(nonatomic,strong)NSString * videoImage;
//视频时长(秒)
@property(nonatomic,assign)NSInteger duration;
//评论量
@property(nonatomic,assign)NSInteger commentsall;
//播放量
@property(nonatomic,assign)NSInteger playTime;
//视频网址
@property(nonatomic,strong)NSString * video_url;
//
@property(nonatomic,strong)NSString * guid;

@end
