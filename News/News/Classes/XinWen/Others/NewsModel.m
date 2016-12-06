//
//  NewsModel.m
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+(void)load{
    [NewsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}
- (NSString *)updateTime{
    if (_updateTime.length > 0) {
        NSArray * arrtime = [_updateTime componentsSeparatedByString:@" "];
        NSString * timeb = [arrtime.lastObject substringToIndex:5];
        return timeb;

    }
    return _updateTime;
}
- (NSString *)commentsall{
    int all = [_commentsall intValue];
    if (all > 9999) {
        float al = all / 10000.0;
        return [NSString stringWithFormat:@"%.2f万",al];
    }
    return _commentsall;
}
- (CGFloat)cellHeight{
    NSDictionary * sizeDic = self.img[0];
    int width = [sizeDic[@"size"][@"width"] intValue];
    int height = [sizeDic[@"size"][@"height"] intValue];
    return height * ScreenWidth / width +10 + 10 + 15;
}



@end
