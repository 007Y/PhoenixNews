//
//  RelativeVideoTableViewCell.m
//  Team
//
//  Created by wyzc on 16/12/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "RelativeVideoTableViewCell.h"
@interface RelativeVideoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *durationLable;


@end

@implementation RelativeVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRelativeModel:(RelativeVideoModel *)relativeModel{
    _relativeModel = relativeModel;
    
    _titleLable.text = relativeModel.name;
    _addressLable.text = relativeModel.columnName;
    
    NSInteger minute = relativeModel.duration/60;
    NSInteger second = relativeModel.duration%60;
    
    _durationLable.text = [NSString stringWithFormat:@"%ld'%ld''",(long)minute,(long)second];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
