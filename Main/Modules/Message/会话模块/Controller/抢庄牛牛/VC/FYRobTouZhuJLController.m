//
//  FYRobTouZhuJLController.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYRobTouZhuJLController.h"
#import "FYRobNNTouZhuJiLuCell.h"
#import "FYLhhTouZhuJiLuCell.h"
#import "FYRobNNJiLuModel.h"
#import "FYNNJiLuController.h"
static NSString *const FYRobNNTouZhuJiLuCellID = @"FYRobNNTouZhuJiLuCellID";
static NSString *const FYLhhTouZhuJiLuCellID = @"FYLhhTouZhuJiLuCellID";
@interface FYRobTouZhuJLController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray <FYRobNNTouZhuJiLuList*>*dataSoure;
/**接龙数据源*/
@property (nonatomic, strong) NSMutableArray <FYRobSolitaireTouZhuJiLuList*>*sdataSoure;

/** 页码*/
@property (nonatomic, assign) NSInteger page;

@end

@implementation FYRobTouZhuJLController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self initUI];
    [self makeRefresh];
}


- (void)makeRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSoure removeAllObjects];
        [self.sdataSoure removeAllObjects];
        self.page = 1;
        [self loadRobBetting];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadRobBetting];
    }];
}

- (void)initUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = NSLocalizedString(@"投注记录", nil);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadRobBetting {
    if (self.type == 7) {
        [NET_REQUEST_MANAGER getSolitaireRecordPageWithGroupId:self.chatId page:self.page type:self.type success:^(id object) {
            if ([object[@"code"] integerValue] == 0){
                 NSArray <FYRobSolitaireTouZhuJiLuList*>*lists = [FYRobSolitaireTouZhuJiLuList mj_objectArrayWithKeyValuesArray:object[@"data"][@"records"]];
                if (lists.count < 40) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
                [lists enumerateObjectsUsingBlock:^(FYRobSolitaireTouZhuJiLuList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.sdataSoure addObject:obj];
                }];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } fail:^(id object) {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [[FunctionManager sharedInstance]handleFailResponse:object];
        }];
    }else{
        [NET_REQUEST_MANAGER getRobBettingRecordChatId:self.chatId page:self.page success:^(id object) {
            if ([object[@"code"] integerValue] == 0){
                NSArray <FYRobNNTouZhuJiLuList*>*lists = [FYRobNNTouZhuJiLuList mj_objectArrayWithKeyValuesArray:object[@"data"][@"records"]];
                if (lists.count < 40) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
                
                [lists enumerateObjectsUsingBlock:^(FYRobNNTouZhuJiLuList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.dataSoure addObject:obj];
                }];
                
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        } fail:^(id object) {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [[FunctionManager sharedInstance]handleFailResponse:object];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 7) {
        return self.sdataSoure.count;
    }else{
        return self.dataSoure.count;
    }
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 7) {
        FYLhhTouZhuJiLuCell *cell = [tableView dequeueReusableCellWithIdentifier:FYLhhTouZhuJiLuCellID forIndexPath:indexPath];
        if (self.sdataSoure.count > indexPath.row) {
            cell.slist = self.sdataSoure[indexPath.row];
        }
        return cell;
    }else if (self.type == 6) {
        FYLhhTouZhuJiLuCell *cell = [tableView dequeueReusableCellWithIdentifier:FYLhhTouZhuJiLuCellID forIndexPath:indexPath];
        FYRobNNTouZhuJiLuList *list = self.dataSoure[indexPath.row];
        if (self.dataSoure.count > indexPath.row) {
            cell.list = list;
        }
        return cell;
    }else{
        FYRobNNTouZhuJiLuCell *cell = [tableView dequeueReusableCellWithIdentifier:FYRobNNTouZhuJiLuCellID forIndexPath:indexPath];
        if (self.dataSoure.count > indexPath.row) {
            cell.list = self.dataSoure[indexPath.row];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc]init];
    header.layer.shadowColor = UIColor.blackColor.CGColor;
    header.layer.shadowOffset = CGSizeMake(0, 1);
    header.layer.shadowOpacity = 0.2;
    header.backgroundColor = UIColor.whiteColor;
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
    CGFloat w = 0;
    if (self.type == 7) {
        [titles addObjectsFromArray: @[NSLocalizedString(@"期数", nil),NSLocalizedString(@"抢包", nil),NSLocalizedString(@"扣除下局", nil),NSLocalizedString(@"盈亏", nil),NSLocalizedString(@"游戏时间", nil)]];
             w = SCREEN_WIDTH / 6;
    }else if (self.type == 6){
        [titles addObjectsFromArray: @[NSLocalizedString(@"期数", nil),NSLocalizedString(@"投注", nil),NSLocalizedString(@"押注", nil),NSLocalizedString(@"盈利", nil),NSLocalizedString(@"结束时间", nil)]];
        w = SCREEN_WIDTH / 6;
    }else{
        [titles addObjectsFromArray: @[NSLocalizedString(@"期数", nil),NSLocalizedString(@"投注", nil),NSLocalizedString(@"盈利", nil),NSLocalizedString(@"结束时间", nil)]];
         w = SCREEN_WIDTH / 5;
    }

    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = UIColor.blackColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [header addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(w * idx);
            make.centerY.equalTo(header);
            make.width.mas_equalTo( (idx == (titles.count - 1)) ? (w * 2) : w);
        }];
        lab.text = obj;
    }];
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 7){
        return;
    }
    FYRobNNTouZhuJiLuList *model = self.dataSoure[indexPath.row];
    FYNNJiLuController *vc = [[FYNNJiLuController alloc]init];
    if (model.period != nil) {
        vc.period = model.period;
        vc.type = self.type;
        vc.chatId = self.chatId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Setter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FYRobNNTouZhuJiLuCell class] forCellReuseIdentifier:FYRobNNTouZhuJiLuCellID];
        [_tableView registerClass:[FYLhhTouZhuJiLuCell class] forCellReuseIdentifier:FYLhhTouZhuJiLuCellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}



- (NSMutableArray <FYRobNNTouZhuJiLuList*>*)dataSoure {
    
    if (!_dataSoure) {
        
        _dataSoure = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSoure;
}
- (NSMutableArray<FYRobSolitaireTouZhuJiLuList *> *)sdataSoure{
    if (!_sdataSoure) {
        _sdataSoure = [NSMutableArray arrayWithCapacity:0];
      }
      return _sdataSoure;
}
@end
