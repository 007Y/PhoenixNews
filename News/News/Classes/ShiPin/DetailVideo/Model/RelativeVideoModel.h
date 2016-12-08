//
//  RelativeVideoModel.h
//  Team
//
//  Created by wyzc on 16/12/7.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelativeVideoModel : NSObject
//请求cell数据需要的id
@property(nonatomic,strong)NSString * guid;
//标题
@property(nonatomic,strong)NSString * name;
//新闻来源
@property(nonatomic,strong)NSString * columnName;
//视频时长
@property(nonatomic,assign)NSInteger duration;



@end
