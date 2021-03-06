//
//  NewsModel.h
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
//头像
@property(nonatomic,strong)NSString *thumbnail;
//标题
@property(nonatomic,strong)NSString *title;
//id
@property(nonatomic,strong)NSString *ID;
//url
@property(nonatomic,strong)NSString *url;
//type
@property(nonatomic,strong)NSString *type;
//评论地址commentsUrl
@property(nonatomic,strong)NSString *commentsUrl;
//总评论数
@property(nonatomic,strong)NSString *commentsall;
//来源
@property(nonatomic,strong)NSString *source;
//有视频
@property(nonatomic,assign,getter=hasVideo)BOOL * hasVideo;
//有slider
@property(nonatomic,assign,getter=hasSlide)BOOL * hasSlide;
//link
@property(nonatomic,strong)NSDictionary *link;
//更新时间
@property(nonatomic,strong)NSString *updateTime;
//style( slideCount  NSArray image)
@property(nonatomic,strong)NSDictionary *style;
//点赞数
@property(nonatomic,assign)int likes;
//beauty img(获取size)
@property(nonatomic,strong)NSArray * img;
//bearty name
@property(nonatomic,strong)NSString *name;
//phvideo
@property(nonatomic,strong)NSDictionary *phvideo;



- (CGFloat)cellHeight;

@end
