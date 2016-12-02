//
//  NewsSlideModel.h
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsSlideModel : NSString
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
//更新时间
@property(nonatomic,strong)NSString *updateTime;
//style( slideCount  NSArray image)
@property(nonatomic,strong)NSDictionary *style;


@end
