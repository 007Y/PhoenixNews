//
//  CommentVideoModel.h
//  Team
//
//  Created by wyzc on 16/12/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentVideoModel : NSObject
//用户名
@property(nonatomic,strong)NSString * uname;
//评论内容
@property(nonatomic,strong)NSString * comment_contents;
//用户省份
@property(nonatomic,strong)NSString * ip_from;
//点赞量
@property(nonatomic,strong)NSString * uptimes;
//用户头像
@property(nonatomic,strong)NSString * userFace;
//评论的id
@property(nonatomic,strong)NSString * comment_id;
//用户的idc
@property(nonatomic,strong)NSString * user_id;

//对谁的评论(里面包含被评论人的信息)
@property(nonatomic,strong)NSArray * parent;

@end
