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
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        NSDate *date = [NSDate date];
        NSString * dateStr = [fmt stringFromDate:date];
        NSArray * arr = [dateStr componentsSeparatedByString:@" "];
        
        NSArray * arrtime = [_updateTime componentsSeparatedByString:@" "];
        if ([arr[0] isEqualToString:arrtime[0]]) {
            NSString * timeb1 = [arrtime.lastObject substringToIndex:5];
            return timeb1;
        }else{
            
            NSString * timeb = [arrtime.firstObject substringFromIndex:5];

            return timeb;
        }
        

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
