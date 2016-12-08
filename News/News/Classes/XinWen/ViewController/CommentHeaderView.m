//
//  CommentHeaderView.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/16.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CommentHeaderView.h"

@interface CommentHeaderView ()

//显示文字的label
@property (nonatomic, weak) UILabel *label;

@end


@implementation CommentHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor grayColor];
        
        // label
        UILabel *label = [[UILabel alloc] init];
      
        label.textColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.label = label;
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.right.equalTo(@-10);
            
            
        }];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    self.label.text = text;
}


@end
