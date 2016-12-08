//
//  BeautyTableViewCell.m
//  News
//
//  Created by 李冬 on 2016/12/5.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "BeautyTableViewCell.h"
@interface BeautyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UILabel *comentLabel;

@property(nonatomic,assign)int width1;
@property(nonatomic,assign)int height1;

@end
@implementation BeautyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(NewsModel *)model{
    _model = model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.img[0][@"url"]]];
    self.zanLabel.text = [NSString stringWithFormat:@"%d",model.likes];
    self.comentLabel.text  = model.commentsall;
//     [self.image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)]];

    
}



- (IBAction)share:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
