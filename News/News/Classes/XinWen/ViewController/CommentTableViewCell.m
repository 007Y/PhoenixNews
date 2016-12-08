//
//  CommentTableViewCell.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/16.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "EssenceComment.h"
#import "EssenceUser.h"
#import "UIImageView+Header.h"

@interface CommentTableViewCell ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
//评论内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
//点赞数量
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    // Initialization code
}

- (void)setComment:(EssenceComment *)comment
{
    _comment = comment;
    
    
    [self.profileImageView setHeader:comment.user.profile_image];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
