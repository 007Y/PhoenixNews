//
//  SuperModel.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "SuperModel.h"
#import "NSDate+Time.h"
#import "MJExtension.h"
@implementation SuperModel
//不匹配的键值转换成匹配的, 为了将来字典转模型准备
+ (void)load{
    
    [SuperModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"large_image" : @"image0",
                 @"topComment" : @"top_cmt[0]"
                 };
    }];
}
//创建时间
- (NSString *)created_at
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // NSString -> NSDate
    NSDate *createdAtDate = [fmt dateFromString:_created_at];
    
    // 比较【发帖时间】和【手机当前时间】的差值
    NSDateComponents *cmps = [createdAtDate intervalToNow];
    
    if (createdAtDate.isThisYear) {
        if (createdAtDate.isToday) { // 今天
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1分钟 =< 时间差距 <= 59分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else if (createdAtDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        } else { // 今年的其他时间
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        } 
    } else { // 非今年
        return _created_at;
    }
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        // cell的高度
        _cellHeight = 55;
        
        //文字的宽度
        CGFloat textW = ScreenWidth - 2 * 10;
        // 计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        
        _cellHeight += textH + 10;
        
        // 中间内容的高度
        if (self.type != InvitationTypeWord) {
            CGFloat contentW = textW;
            // 图片的高度 * 内容的宽度 / 图片的宽度
            CGFloat contentH = self.height * (contentW / self.width);
            
            if (contentH >= ScreenHeight) { // 一旦图片的显示高度超过一个屏幕，就让图片高度为200
                contentH = 200;
                self.bigPicture = YES;
            }
            
            CGFloat contentX = 10;
            CGFloat contentY = _cellHeight;
            self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
            
            _cellHeight += contentH + 10;
        }

        // 评论
        if (self.topComment) {
            NSString *username = self.topComment.user.username;
            NSString *content = self.topComment.content;
            NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
            // 评论内容的高度
            CGFloat cmtTextH = [cmtText boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
            
            _cellHeight += 20 + cmtTextH + 10;
        }
        
        // 工具条的高度 += 底部工具条的高度
        _cellHeight += 35 + 10;
    }
    return _cellHeight;
}

@end
