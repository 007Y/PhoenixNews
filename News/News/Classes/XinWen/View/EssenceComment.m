//
//  EssenceComment.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "EssenceComment.h"
#import "MJExtension.h"

@implementation EssenceComment
+ (void)load{
    
    [EssenceComment mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@%@", _user,_content];
}
@end
