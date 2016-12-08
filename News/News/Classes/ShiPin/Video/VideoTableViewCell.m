//
//  VideoTableViewCell.m
//  TeamNews
//
//  Created by wyzc on 16/12/1.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "VideoTableViewCell.h"
@interface VideoTableViewCell()
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLable;


//视频时长
@property (weak, nonatomic) IBOutlet UILabel *centrolLable;


//播放量
@property (weak, nonatomic) IBOutlet UIButton *playAmountButton;
//评论量
@property (weak, nonatomic) IBOutlet UIButton *CommentAmountButton;



@end

@implementation VideoTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
    
    // Initialization code
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setModel:(VideoModel *)model{
    _model = model;
    self.titleLable.text = model.title;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.videoImage]];
    if (model.playTime >= 10000) {
        [self.playAmountButton setTitle:[NSString stringWithFormat:@"%.1f万",(float)model.playTime/10000] forState:UIControlStateNormal];
        
    }else{
        [self.playAmountButton setTitle:[NSString stringWithFormat:@"%zd",model.playTime] forState:UIControlStateNormal];
    }
    
    [self.CommentAmountButton setTitle:[NSString stringWithFormat:@"%zd",model.commentsall] forState:UIControlStateNormal];
    
    
    NSInteger minute = model.duration / 60;
    NSInteger second = model.duration % 60;
    self.centrolLable.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
