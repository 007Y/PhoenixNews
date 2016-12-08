//
//  SuperModel.h
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EssenceComment.h"
//C枚举
typedef enum {
    /** 全部 */
    InvitationTypeAll = 1,
    
    /** 图片 */
    InvitationTypePicture = 10,
    
    /** 段子(文字) */
   InvitationTypeWord = 29,

    
}InvitationType;
@interface SuperModel : NSObject
/** id */
@property (nonatomic, copy) NSString *ID; // id
// 用户 -- 发帖者
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 类型 */
@property (nonatomic, assign) InvitationType type;
/**评论 */
@property (nonatomic, strong) EssenceComment *topComment;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 大图 */
@property (nonatomic, copy) NSString *large_image;
/***** 额外增加的属性 ******/
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect contentFrame;
/** 是否大图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

@end
