//
//  CommentTableViewCell.h
//  段子
//
//  Created by wyzc on 2016/11/16.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EssenceComment;

@interface CommentTableViewCell : UITableViewCell

/** 评论模型数据 */
@property (nonatomic, strong) EssenceComment *comment;

@end
