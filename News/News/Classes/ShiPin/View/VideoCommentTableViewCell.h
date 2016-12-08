//
//  VideoCommentTableViewCell.h
//  Team
//
//  Created by wyzc on 16/12/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentVideoModel.h"

@interface VideoCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property(nonatomic,strong)CommentVideoModel * commentModel;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;
@property (weak, nonatomic) IBOutlet UILabel *approveLable;

@end
