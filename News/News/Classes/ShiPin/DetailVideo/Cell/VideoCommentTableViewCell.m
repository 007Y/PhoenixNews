//
//  VideoCommentTableViewCell.m
//  Team
//
//  Created by wyzc on 16/12/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "VideoCommentTableViewCell.h"
#import "UIImageView+Header.h"
@interface VideoCommentTableViewCell()




@end

@implementation VideoCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCommentModel:(CommentVideoModel *)commentModel{
    
    _commentModel = commentModel;
    
    [_userImageView setHeader:commentModel.userFace];
    
    _nameLable.text = commentModel.uname;
    _addressLable.text = commentModel.ip_from;
    _approveLable.text = commentModel.uptimes;
    _commentLable.text = commentModel.comment_contents;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
