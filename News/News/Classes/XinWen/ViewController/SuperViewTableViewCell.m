//
//  SuperViewTableViewCell.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "SuperViewTableViewCell.h"
#import "UIImageView+Header.h"
#import "CommentHeaderView.h"



@interface SuperViewTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *text_label;//文字

@property (weak, nonatomic) IBOutlet UIButton *dingButton;

@property (weak, nonatomic) IBOutlet UIButton *repostButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;





@end

@implementation SuperViewTableViewCell

#pragma mark --lazy load



- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置cell的背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
}

- (void)setModel:(SuperModel *)model
{
    _model = model;
    

    self.text_label.text = model.text;
    
    
    // 设置底部工具条的数字
    [self setupButtonTitle:self.dingButton number:model.ding placeholder:@"顶"];
    [self setupButtonTitle:self.repostButton number:model.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:model.comment placeholder:@"评论"];
    
    
    
}

//按钮的设置
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
