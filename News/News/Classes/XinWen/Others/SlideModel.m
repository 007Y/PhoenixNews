//
//  SlideModel.m
//  News
//
//  Created by 李冬 on 2016/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "SlideModel.h"

@implementation SlideModel
+(void)load{
    [SlideModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descriptio" : @"description"
                 };
    }];
}
@end
