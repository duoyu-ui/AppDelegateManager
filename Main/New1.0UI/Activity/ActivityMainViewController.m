//
//  ActivityMainViewController.m
//  Project
//
//  Created by fangyuan on 2019/3/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ActivityMainViewController.h"
#import "ActivityDetail1ViewController.h"
#import "ActivityDetail2ViewController.h"
#import "UIImageView+WebCache.h"

@interface ActivityMainViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSArray *_dataArray;
    BOOL _pauseAni;
}
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *aniObjArray;

/*
 * The system message number view
 */
@property (nonatomic, strong) NotiItemView *notify;

@end

@implementation ActivityMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"活动奖励", nil);
    self.view.backgroundColor = COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;

    self.aniObjArray = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero  style:UITableViewStylePlain];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = 120;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(-10);
    }];
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf requestData];
    }];

    [self requestData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    UIBarButtonItem *rightButtonItem = [self createBarButtonItemWithImage:ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE
                                                                  target:self
                                                                   action:@selector(rightBtnClick)
                                                               offsetType:CFCNavBarButtonOffsetTypeRight
                                                               imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
}

- (void)leftBtnClick
{
    FYSystemNewMessageController *vc = [FYSystemNewMessageController new];
//    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)rightBtnClick
{
    WebViewController *vc = [[WebViewController alloc] initWithUrl:AppModel.shareInstance.commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"客服", nil);
    [self.navigationController pushViewController:vc animated:true];
}

- (void)update
{
    if(_pauseAni)
        return;
    NSMutableArray *newArray = [NSMutableArray array];
    for (UIView *view in self.aniObjArray) {
        CGPoint point = [view.superview convertPoint:view.center toView:self.view];
        if(point.y < 0 || point.y > self.view.frame.size.height)
            continue;
        [newArray addObject:view];
    }
    if(newArray.count == 0)
        return;
    NSInteger random = arc4random()%newArray.count;
    if(random >= newArray.count)
        random = newArray.count - 1;
    UIView *view = newArray[random];
    if([view isKindOfClass:[UIImageView class]]){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gaoGuang1"]];
        imgView.alpha = 1.0;
        [view addSubview:imgView];
        imgView.frame = CGRectMake(view.bounds.size.width, -10, imgView.image.size.width, view.bounds.size.height + 20);
        [UIView animateWithDuration:1.0 animations:^{
            imgView.alpha = 0.5;
            imgView.frame = CGRectMake(-imgView.bounds.size.width, -10, imgView.image.size.width, view.bounds.size.height + 20);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 8;
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(cell).offset(10);
            make.bottom.equalTo(cell).offset(-4);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [view addSubview:imgView];
        imgView.backgroundColor = COLOR_X(230, 230, 230);
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view);
            make.bottom.equalTo(cell);
        }];
        imgView.tag = 1;
        [self.aniObjArray addObject:imgView];
        
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    
    UIImageView *imgView = [cell viewWithTag:1];
    [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArray[indexPath.row];
    NSInteger type = [dic[@"type"] integerValue];
    if (type == RewardType_bzsz || type == RewardType_ztlsyj || type == RewardType_yqhycz || type == RewardType_czjl || type == RewardType_zcdljl) { //6000豹子顺子奖励 5000直推流水佣金 1110邀请好友充值 1100充值奖励 2100注册登录奖励
        ActivityDetail1ViewController *vc = [[ActivityDetail1ViewController alloc] init];
        vc.infoDic = dic;
        vc.imageUrl = dic[@"bodyImg"];
        vc.title = dic[@"mainTitle"];
        vc.hiddenNavBar = YES;
        vc.top = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(type == RewardType_fbjl
            ||type == RewardType_qbjl
            ||type == RewardType_jjj) { // 3000发包奖励 4000抢包奖励 7000救济金
        ActivityDetail2ViewController *vc = [[ActivityDetail2ViewController alloc] init];
        vc.infoDic = dic;
        vc.title = dic[@"mainTitle"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
        vc.imageUrl = ![FunctionManager isEmpty:dic[@"bodyImg"]]?dic[@"bodyImg"]:@"";
        vc.hiddenNavBar = YES;
        vc.title = dic[@"mainTitle"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestData
{
    WEAK_OBJ(weakSelf, self);
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getActivityListWithSuccess:^(id object) {
        PROGRESS_HUD_DISMISS
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf requestDataBack:object];
    } fail:^(id object) {
        PROGRESS_HUD_DISMISS
        [weakSelf.tableView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)requestDataBack:(NSDictionary *)response
{
    FYLog(@"%@", response);
    
    if (!NET_REQUEST_SUCCESS(response)) {
        ALTER_HTTP_MESSAGE(response)
        return;
    }
    
    NSDictionary *dict = NET_REQUEST_DATA(response);
    _dataArray = [dict arrayForKey:@"records"];
    if(_dataArray.count == 0){
        ALTER_INFO_MESSAGE(NSLocalizedString(@"暂无数据", nil));
        return;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.navigationController.navigationBarHidden == YES)
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _pauseAni = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _pauseAni = YES;
}

@end
