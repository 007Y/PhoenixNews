//
//  CommentHeaderView.m
//  Team
//
//  Created by wyzc on 16/12/8.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CommentHeaderView.h"

@interface CommentHeaderView ()
//显示文字的label
//@property (nonatomic, weak) UILabel *label;
//@property (nonatomic, weak) UIButton * button;
@end

@implementation CommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
   self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor grayColor];
        
        // label
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.label = label;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        NSString * str = @"举报";
        NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,str.length)];
        
        [button setAttributedTitle:attri forState:UIControlStateNormal];
        
        [self.contentView addSubview:button];
        self.button = button;
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            
            
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@-15);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            
            
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
