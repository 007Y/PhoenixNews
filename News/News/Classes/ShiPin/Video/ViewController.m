//
//  ViewController.m
//  Team
//
//  Created by wyzc on 16/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ViewController.h"
#import "VideoTableViewCell.h"
#import "VideoModel.h"
#import "VideoTypeModel.h"
#import "DetailVideoViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>


@property(nonatomic,strong)VideoTableViewCell * cell;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;

@property (nonatomic, weak) AFHTTPSessionManager *manager;
//用于存放model
@property(nonatomic,strong)NSMutableArray * muArray;
//存放type
@property(nonatomic,strong)NSMutableArray * typeArray;

/** 标题栏底部的指示器 */ //小红条
@property (nonatomic, strong) UIView *titleBottomView;

@property (nonatomic, strong) UIButton *selectedTitleButton;

@property(nonatomic,assign)int page;

@property(nonatomic,strong)UIScrollView * scrollView;
//存放添加的按钮
@property(nonatomic,strong)NSMutableArray * titleButtonsArr;
//
@property(nonatomic,strong)NSString * idType;
@end

static NSString * const reuseID = @"reuse";

@implementation ViewController

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (NSMutableArray *)titleButtonsArr{
    if (!_titleButtonsArr) {
        _titleButtonsArr = [NSMutableArray array];
    }
    return _titleButtonsArr;
}
- (NSMutableArray *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
        
    }
    return _typeArray;
}
- (void)viewWillAppear:(BOOL)animated{
    
}


////+++++++++++++++++++++++++
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //把精选添加到type数组
    VideoTypeModel * model = [[VideoTypeModel alloc]init];
    model.ID = @"jingxuan";
    model.name = @"精选";
    [self.typeArray insertObject:model atIndex:0];
    WEAKSELF;
    //队列请求,防止请求被取消
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf requestTypeData];
    });
    
//    [self setupRefresh];
    _page = 1;
    
    self.videoTableView.delegate = self;
    self.videoTableView.dataSource = self;
    [self.videoTableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
}


- (void)setupScrollView
{

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [[UIScrollView alloc] init];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.frame = self.topView.frame;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_typeArray.count * 90, 0);
    [self.navigationController.view addSubview:_scrollView];
    
   
    
    NSInteger count = self.typeArray.count;

    CGFloat titleButtonH = self.topView.height;
    
    for (int i = 0; i < count; i ++) {
        UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.backgroundColor = [UIColor whiteColor];
        NSString * strName =[self.typeArray[i] name];
        [button setTitle:strName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 210+i;
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        button.y = 0;
        button.height = titleButtonH;
        button.width = 90;
        button.x = i * button.width;
        [self.scrollView addSubview:button];
        [self.titleButtonsArr addObject:button];
        
    }
    
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtonsArr.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.height = 1;
    titleBottomView.y = _topView.height - titleBottomView.height;
    [_scrollView addSubview:titleBottomView];
    _titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮(默认显示第一个按钮的页面)
    UIButton *firstTitleButton = self.titleButtonsArr.firstObject;
    [firstTitleButton.titleLabel sizeToFit];

    [self titleClick:firstTitleButton];

    
}
//请求type数据
- (void)requestTypeData{
    WEAKSELF;
    
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [self.manager GET:EMMENCEURL(1) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",task.currentRequest.URL);
            NSMutableArray * muarr = [VideoTypeModel mj_objectArrayWithKeyValuesArray:responseObject[0][@"types"]];
//        NSLog(@"%lu",(unsigned long)weakSelf.typeArray.count);
        [weakSelf.typeArray addObjectsFromArray:muarr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupScrollView];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"视频页请求错误%@",error);
        
    }];
    
}

- (void)titleClick:(UIButton *)titleButton{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;//

    
    NSInteger index = titleButton.tag-210;
    NSLog(@"%ld",(long)index);
    _idType = [self.typeArray[index] ID];
    
    //添加红色线view动画
    [UIView animateWithDuration:0.05 animations:^{
        self.titleBottomView.width = titleButton.width;
        self.titleBottomView.centerX = self.selectedTitleButton.centerX;
    }];

    [self setupRefresh];
   
  
}

- (void)setupRefresh
{
    [self requestData];
    WEAKSELF;
    //下拉
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestData];
        
    }];
    // 自动改变透明度
    self.videoTableView.mj_header.automaticallyChangeAlpha = YES;
    // 马上进入刷新状态
    [self.videoTableView.mj_header beginRefreshing];
    //上拉
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)loadMoreData{
    _page ++;
    WEAKSELF;
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"页数是是 %d",_page);
    [self.manager GET:EMMENCEURL(_page) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",task.currentRequest.URL);
        NSMutableArray * muuu = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[0][@"item"]];
        [weakSelf.muArray addObjectsFromArray:muuu];

        
        
        [weakSelf.videoTableView reloadData];
        [weakSelf.videoTableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"视频页请求错误%@",error);
        [weakSelf.videoTableView.mj_footer endRefreshing];
        
    }];

    
    
}
- (void)requestData{
    WEAKSELF;
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    NSLog(@"6666%@",_idType);
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"typeid"] = _idType;
    param[@"listtype"] = @"list";
    
    if ([_idType isEqualToString:@"jingxuan"]) {
        [self.manager GET:EMMENCEURL(1) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//             NSLog(@"%@",task.currentRequest.URL);
            weakSelf.muArray = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[0][@"item"]];
            
            [weakSelf.videoTableView reloadData];
            
            [weakSelf.videoTableView.mj_header endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"视频页请求错误%@",error);
            [weakSelf.videoTableView.mj_header endRefreshing];
            
        }];

    }else{
        [self.manager GET:EMMENCEURL(1) parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",task.currentRequest.URL);
            
            weakSelf.muArray = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[0][@"item"]];
            
            [weakSelf.videoTableView reloadData];
            
            [weakSelf.videoTableView.mj_header endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"视频页请求错误%@",error);
            [weakSelf.videoTableView.mj_header endRefreshing];
            
        }];

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.muArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    _cell.model = self.muArray[indexPath.row];

    [_cell.centrolButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailVideoViewController * detaVC = [[DetailVideoViewController alloc]init];
    detaVC.videourl = [_muArray[indexPath.row] video_url];
    detaVC.lableTitle = [_muArray[indexPath.row] title];
    detaVC.imageName = [_muArray[indexPath.row] videoImage];
    
    detaVC.guid = [_muArray[indexPath.row] guid];
    detaVC.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:detaVC animated:YES completion:nil];
}
- (void)clickButton:(NSIndexPath *)indexPath{
    
   
    
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
