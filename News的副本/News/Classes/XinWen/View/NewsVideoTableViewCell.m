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
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation NewsVideoTableViewCell


- (void)setModel:(NewsModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.thumbnailImage.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbnailImage.clipsToBounds = YES;
    [self.thumbnailImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.commentsall.text = model.commentsall;
    if (![model.type containsString:@"live"]) {
        self.liveImage.hidden = YES;
        self.sourceLabel.text = model.phvideo[@"channelName"];
        self.sourceLabel.textColor = [UIColor blackColor];
        int tim = [model.phvideo[@"length"]  intValue];
        self.timeLabel.textColor = [UIColor whiteColor];
        int fen;
        int miao = tim % 60;
        self.timeLabel.text = [NSString stringWithFormat:@"%02d",miao];
        if (tim > 60) {
            fen =  tim / 60;
            self.timeLabel.text = [NSString stringWithFormat:@"%02d'%02d\"",fen,miao];
        }
    }else{
        self.button.hidden = YES;
        self.commentImage.hidden = YES;
        self.timeLabel.hidden = YES;
        self.sourceLabel.text = @"进行中...";
        self.sourceLabel.textColor = [UIColor redColor];
    }
}

- (IBAction)click:(id)sender {
    
    
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
