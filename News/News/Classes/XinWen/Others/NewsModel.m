//
//  NewsModel.m
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
+(void)load{
    [NewsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}
- (NSString *)updateTime{
    
    NSArray * arrtime = [_updateTime componentsSeparatedByString:@" "];
    NSString * timeb = [arrtime.lastObject substringToIndex:4];
    return timeb;
}

@end
