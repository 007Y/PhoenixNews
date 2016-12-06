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
//type
@property(nonatomic,strong)NSString *type;
//评论地址commentsUrl
@property(nonatomic,strong)NSString *commentsUrl;
//总评论数
@property(nonatomic,strong)NSString *commentsall;
//来源
@property(nonatomic,strong)NSString *source;
//有视频
@property(nonatomic,assign,getter=hasvideo)BOOL * hasVideo;
//有slider
@property(nonatomic,assign,getter=hasslide)BOOL * hasSlide;
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
- (CGFloat)cellHeight;

@end
