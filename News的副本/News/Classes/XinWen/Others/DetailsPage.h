//
//  DetailsPage.h
//  News
//
//  Created by 李冬 on 2016/12/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsPage : NSObject
//title
@property(nonatomic,strong)NSString *title;
//thumbnail_doc(size,url(图片))
@property(nonatomic,strong)NSDictionary * thumbnail_doc;
//source
@property(nonatomic,strong)NSString *source;
//editorcode(作者)
@property(nonatomic,strong)NSString *editorcode;
//editTime
@property(nonatomic,strong)NSString *editTime;
//updateTime
@property(nonatomic,strong)NSString *updateTime;
//commentCount Y
@property(nonatomic,assign)int commentCount;
//hasVideo
@property(nonatomic,strong)NSString *hasVideo;
//text(正文)
@property(nonatomic,strong)NSString *text;
//img(url,size(图片))
@property(nonatomic,strong)NSArray *img;

@end
