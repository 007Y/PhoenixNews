//
//  FoundSlidesTableViewCell.m
//  News
//
//  Created by 李冬 on 2016/12/8.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "FoundSlidesTableViewCell.h"
@interface FoundSlidesTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *slideCount;
@property (weak, nonatomic) IBOutlet UILabel *commentsall;
@property (weak, nonatomic) IBOutlet UILabel *source;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation FoundSlidesTableViewCell
- (void)setModel:(NewsModel *)model{
    _model = model;
    NSArray * arr = model.style[@"images"];
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:arr[0]]];
    [self.image2 sd_setImageWithURL:[NSURL URLWithString:arr[1]]];
    [self.image3 sd_setImageWithURL:[NSURL URLWithString:arr[2]]];
    self.commentsall.text = model.commentsall;
    self.title.text = model.title;
    self.source.text = model.source;
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
