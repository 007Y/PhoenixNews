//
//  NewsTopTableViewCell.m
//  News
//
//  Created by 李冬 on 2016/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NewsTopTableViewCell.h"
@interface NewsTopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *commetsall;
@property (weak, nonatomic) IBOutlet UILabel *timeLbel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end
@implementation NewsTopTableViewCell




- (void)setModel:(NewsModel *)model{
    _model = model;
    [_thumbnailImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    _title.text = model.title;
    _commetsall.text = model.commentsall;
    if (model.hasVideo) {
        _timeLbel.text = model.updateTime;

        [self.icon setImage:[UIImage imageNamed:@""]];
        return;
    }else if(model.hasSlide){
        _timeLbel.text = model.updateTime;

        [self.icon setImage:[UIImage imageNamed:@""]];
        return;
    }else if([model.type isEqualToString: @"topic2"]){
        self.timeLbel.hidden = YES;
        self.timeLbel.text = nil;
    }else{
        _timeLbel.text = model.updateTime;
        self.icon.hidden = YES;
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
