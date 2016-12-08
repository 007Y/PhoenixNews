//
//  WorldViewController.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/15.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "WorldViewController.h"

@interface WorldViewController ()

@end

@implementation WorldViewController
- (InvitationType)type
{
    return InvitationTypeWord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
