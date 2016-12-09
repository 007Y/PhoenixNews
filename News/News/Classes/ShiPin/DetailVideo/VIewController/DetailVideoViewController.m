//
//  DetailVideoViewController.m
//  Team
//
//  Created by wyzc on 16/12/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "VideoCommentTableViewCell.h"
#import "RelativeVideoTableViewCell.h"
#import "TotalCommentViewController.h"
#import "CommentHeaderView.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <time.h>

@interface DetailVideoViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
//实现视频播放
@property (strong,nonatomic) AVPlayerViewController *moviePlayer;
@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) AVPlayerItem *item;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic, weak) AFHTTPSessionManager *manager;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;

//评论量(joint_count)和上个页面的用的值不一样
@property (nonatomic, strong) NSNumber * count;

@end

static NSString * const reuseID = @"reuse";
static NSString * const HeaderId = @"reuse";

@implementation DetailVideoViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:self.imageName]];
    self.titleLable.text = self.lableTitle;

    //添加点击手势实现播放
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Click:)];
    
    [self.playButton addGestureRecognizer:singleTap];
    
    [self setUpTableView];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

//请求数据
- (void)requestData{
    
    WEAKSELF;
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"type"] = @"hot";
    
    [self.manager GET:CELLHOTCOMMNETVIDEOURL(1, self.guid) parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",task.currentRequest.URL);
        
        weakSelf.hotComments = [CommentVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"comments"][@"hottest"]];
//        NSLog(@"wewewewewew%lu",(unsigned long)weakSelf.hotComments.count);
        
        weakSelf.count = responseObject[@"join_count"];
        
        //给评论量按钮赋值
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.commentButton setTitle:[NSString stringWithFormat:@"%@",weakSelf.count]  forState:UIControlStateNormal];
        });
       
        [weakSelf.detailTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if ([error code] == NSURLErrorCancelled) {
            
            return;
            
        }
            NSLog(@"评论页请求错误%@",error);
           
            
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击返回按钮
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//
- (void)setUpTableView{
    [self requestData];
    
    self.detailTableView.separatorColor = [UIColor clearColor];

    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
    [self.detailTableView registerNib:[UINib nibWithNibName:@"VideoCommentTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    [self.detailTableView registerClass:[CommentHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderId];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.hotComments.count == 0) {
        return 0;
    }

    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderId];
    // 覆盖文字
    header.button.hidden = YES;
    header.text = @"热门评论";
    
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.hotComments.count > 5) {
        if (indexPath.row == 5) {
            return 60;
        }else{
            CGRect rect = [[self.hotComments[indexPath.row] comment_contents] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            return rect.size.height+100;
        }
    }else if (self.hotComments.count > 0){
        if (indexPath.row == self.hotComments.count) {
            return 60;
        }else{
            CGRect rect = [[self.hotComments[indexPath.row] comment_contents] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            return rect.size.height+100;
        }
    }else{
        return 0;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.hotComments.count > 5) {
        return 6;
    }else if(self.hotComments.count > 0){
        return self.hotComments.count +1;
    }
    return self.hotComments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //当row=5的时候,有cell重用的问题
//    VideoCommentTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[VideoCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
//    }
   
    VideoCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    
    if(self.hotComments.count > 5){
        
        if (indexPath.row < 5) {
            cell.commentModel = self.hotComments[indexPath.row];
        }
        if (indexPath.row == 5) {
//            cell.userImageView.hidden = YES;
//            cell.addressLable.hidden = YES;
//            cell.approveLable.hidden = YES;
//            cell.nameLable.hidden = YES;
//            cell.approveButton.hidden = YES;
            
            [cell.userImageView removeFromSuperview];
            [cell.addressLable removeFromSuperview];
            [cell.approveLable removeFromSuperview];
            [cell.approveButton removeFromSuperview];
            [cell.nameLable removeFromSuperview];
            
            cell.commentLable.textAlignment = NSTextAlignmentCenter;
            cell.commentLable.text = @"查看更多";
            
        }
        
    }else if(self.hotComments.count > 0){
        
        
        if (indexPath.row == self.hotComments.count) {
                       [cell.userImageView removeFromSuperview];
            [cell.addressLable removeFromSuperview];
            [cell.approveLable removeFromSuperview];
            [cell.approveButton removeFromSuperview];
            [cell.nameLable removeFromSuperview];
            
            cell.commentLable.textAlignment = NSTextAlignmentCenter;
            cell.commentLable.text = @"查看更多";
            
        }
        if (indexPath.row < self.hotComments.count) {
            cell.commentModel = self.hotComments[indexPath.row];
        }

    }else{
        cell.commentModel = self.hotComments[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if (self.hotComments.count > 0) {
        //判断是否是最后一个cell
        if (indexPath.row == [self.detailTableView numberOfRowsInSection:0]-1 ) {
            TotalCommentViewController * totalVC = [[TotalCommentViewController alloc]init];
            totalVC.guid = self.guid;
            [self presentViewController:totalVC animated:YES completion:nil];
        }else{
            
            // 取出cell
            VideoCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            
            // 设置菜单内容
            menu.menuItems = @[
                               [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                               [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                               [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)]
                               ];
            
            // 显示位置
            CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, 1);
            [menu setTargetRect:rect inView:cell];
            
            // 显示出来
            [menu setMenuVisible:YES animated:YES];
        }
    }

}

- (void)Click:(id)sender{
    
    NSURL * url = [NSURL URLWithString:self.videourl];
    //设置流媒体视频路径
    self.item=[AVPlayerItem playerItemWithURL:url];
    
    //设置AVPlayer中的AVPlayerItem
    self.player=[AVPlayer playerWithPlayerItem:self.item];
    
    //初始化AVPlayerViewController
    self.moviePlayer=[[AVPlayerViewController alloc]init];
    
    self.moviePlayer.player=self.player;
    
    [self.view addSubview:self.moviePlayer.view];
    
    //设置AVPlayerViewController的frame
    self.moviePlayer.view.frame=self.videoImageView.frame;
    [self.player play];

}

#pragma mark - UIMenuController处理
//只有成为第一响应者时menu才会弹出
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//顶
- (void)ding:(UIMenuController *)menu
{
   
}
//回复
- (void)reply:(UIMenuController *)menu
{
    }
//举报
- (void)warn:(UIMenuController *)menu
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
