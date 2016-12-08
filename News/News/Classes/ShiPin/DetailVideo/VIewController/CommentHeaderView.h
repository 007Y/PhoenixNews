//
//  CommentHeaderView.h
//  Team
//
//  Created by wyzc on 16/12/8.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentHeaderView : UITableViewHeaderFooterView
/** 显示标题的文字 */
@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIButton * button;
@end
