//
//  NewsModel.m
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
- (NSString *)description{
    return [NSString stringWithFormat:@"%d %d",self.hasSlide,self.hasVideo];
}
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
    
    NSArray * arrtime = [_updateTime componentsSeparatedByString:@" "];
    NSString * timeb = [arrtime.lastObject substringToIndex:5];
    return timeb;
}
- (NSString *)commentsall{
    int all = [_commentsall intValue];
    if (all > 9999) {
        float al = all / 10000.0;
        return [NSString stringWithFormat:@"%.2f万",al];
    }
    return _commentsall;
}
@end
