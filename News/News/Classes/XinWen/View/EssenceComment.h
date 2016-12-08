//
//  EssenceComment.h
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EssenceUser.h"

@interface EssenceComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;

/** 文字内容 */
@property (nonatomic, copy) NSString *content;

/** 用户 */
@property (nonatomic, strong) EssenceUser *user;

/** 点赞数 */
@property (nonatomic, assign) NSInteger like_count;


@end
