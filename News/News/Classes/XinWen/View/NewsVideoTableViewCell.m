//
//  NewsVideoTableViewCell.m
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsVideoTableViewCell.h"
@interface NewsVideoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UIImageView *liveImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsall;
@end

@implementation NewsVideoTableViewCell


- (void)setModel:(NewsModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.thumbnailImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
   
    self.commentsall.text = model.commentsall;
    if (![model.type containsString:@"live"]) {
        self.liveImage.hidden = YES;
        self.sourceLabel.text = model.source;
    }else{
        self.sourceLabel.text = @"进行中...";
        self.sourceLabel.textColor = [UIColor redColor];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
