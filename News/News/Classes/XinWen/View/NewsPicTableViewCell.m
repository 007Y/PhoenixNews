//
//  NewsPicTableViewCell.m
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsPicTableViewCell.h"
@interface NewsPicTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *slideCount;
@property (weak, nonatomic) IBOutlet UILabel *commentsall;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation NewsPicTableViewCell
- (void)setModel:(NewsModel *)model{
    _model = model;
    NSArray * arr = model.style[@"image"];
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:arr[0]]];
    [self.image2 sd_setImageWithURL:[NSURL URLWithString:arr[1]]];
    [self.image3 sd_setImageWithURL:[NSURL URLWithString:arr[2]]];
    self.commentsall.text = model.commentsall;
    self.title.text = model.title;
    self.updateTime.text = model.updateTime;
    self.slideCount.text = [NSString stringWithFormat:@"%@",model.style[@"slideCount"]];
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
