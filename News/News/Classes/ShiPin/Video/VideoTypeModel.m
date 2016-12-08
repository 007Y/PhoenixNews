//
//  VideoTypeModel.m
//  Team
//
//  Created by wyzc on 16/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "VideoTypeModel.h"

@implementation VideoTypeModel
+ (void)load{
    
    [VideoTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    
}
- (NSString *)description{
    return [NSString stringWithFormat:@"%@",self.ID];
}
//- (NSString *)description{
//    return [NSString stringWithFormat:@"name=%@,id=%@",self.name,self.ID];
//}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
