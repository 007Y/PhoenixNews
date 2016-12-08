//
//  VideoModel.m
//  Team
//
//  Created by wyzc on 16/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
+ (void)load{
    
    [VideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"videoImage":@"image"};
    }];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
