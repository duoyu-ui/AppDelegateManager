//
//  FYPokerHistoryHubView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPokerHistoryHubView.h"

#import "FYPokerHistoryHubCell.h"
static NSString *const FYPokerHistoryHubCellID = @"FYPokerHistoryHubCellID";
@interface FYPokerHistoryHubView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , copy) pokerHistoryBlock block;
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIView *headerView;
@property (nonatomic , strong) UILabel *gameNumberLab;
@property (nonatomic , strong) UIButton *selectBtn;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray<FYBestNiuNiuHistoryData*> *dataSource;
@property (nonatomic , strong) UIView *footerView;
@end
@implementation FYPokerHistoryHubView

+ (void)showWithDataSource:(NSArray<FYBestNiuNiuHistoryData*>*)dataSource Block:(pokerHistoryBlock)block{
    FYPokerHistoryHubView *hview = [[FYPokerHistoryHubView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hview];
    hview.block = ^{
        block();
    };
    [hview showWithDataSource:dataSource];
}
- (void)showWithDataSource:(NSArray<FYBestNiuNiuHistoryData*>*)dataSource{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataSource = dataSource;
        [self.dataSource enumerateObjectsUsingBlock:^(FYBestNiuNiuHistoryData *list, NSUInteger idx, BOOL * _Nonnull stop) {
            self.dataSource[idx].state = BestNiuNiuHistoryCardState;
        }];
        [self.tableView reloadData];
        CGFloat H = 0;
        if (self.dataSource.count < 5 ) {
            H = self.dataSource.count * 40;
        }else{
            H = 40 * 5;
        }
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(H));
        }];
    });
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
      
    }
    return self;
}
- (void)initSubView{
    [self addSubview:self.bgView];
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.gameNumberLab];
    [self addSubview:self.tableView];
    [self addSubview:self.footerView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    ///状态栏 + 导航栏高度 + 头部(40) + 扑克牌头部
    CGFloat headerViewX = [UIApplication sharedApplication].statusBarFrame.size.height + pokerWinsLossesHeadViewHigh + kNavBarHeight + 40;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(headerViewX));
        make.right.left.equalTo(self);
        make.height.equalTo(@(45));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@(0));
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    CGFloat titleW = kScreenWidth / 4;//标题宽
    [self.gameNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.centerY.equalTo(self.headerView);
        make.width.mas_equalTo(titleW);
    }];
    NSArray <NSString *>*titles = @[NSLocalizedString(@"牌面", nil),
                                    NSLocalizedString(@"大小", nil),
                                    NSLocalizedString(@"单双", nil)];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = idx;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"pokerHistoryHub_title_sel_icon"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"pokerHistoryHub_title_sel_icon"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"pokerHistoryHub_title_nor_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(bestNiuNiudataSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerY.equalTo(self.headerView);
            make.width.equalTo(@(titleW));
            make.left.equalTo(self.gameNumberLab.mas_right).offset(titleW * idx);
        }];
        if (idx == 0) {
            [self bestNiuNiudataSwitch:btn];
        }
    }];
}
///单选
- (void)bestNiuNiudataSwitch:(UIButton *)btn{
    [self.dataSource enumerateObjectsUsingBlock:^(FYBestNiuNiuHistoryData *list, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (btn.tag) {
            case 0:
                self.dataSource[idx].state = BestNiuNiuHistoryCardState;
                break;
            case 1:
                self.dataSource[idx].state = BestNiuNiuHistorysize;
                break;
            case 2:
                self.dataSource[idx].state = BestNiuNiuHistorySingle;
                break;
            default:
                break;
        }
    }];
    [self.tableView reloadData];
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
}

- (void)dismis{
    if (self.block != nil) {
        self.block();
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FYPokerHistoryHubCell *cell = [tableView dequeueReusableCellWithIdentifier:FYPokerHistoryHubCellID];
    if (self.dataSource.count > indexPath.row) {
        cell.list = self.dataSource[indexPath.row];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count > 5 ? 5 : self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismis)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = HexColor(@"#C5C5C5");
    }
    return _headerView;
}
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = COLOR_RGBA(0, 0, 0, 0.55);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismis)];
        [_footerView addGestureRecognizer:tap];
    }
    return _footerView;
}
- (UILabel *)gameNumberLab{
    if (!_gameNumberLab) {
        _gameNumberLab = [[UILabel alloc]init];
        _gameNumberLab.font = [UIFont systemFontOfSize:16];
        _gameNumberLab.textColor = UIColor.blackColor;
        _gameNumberLab.text = NSLocalizedString(@"期数", nil);
        _gameNumberLab.textAlignment = NSTextAlignmentCenter;
    }
    return _gameNumberLab;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[FYPokerHistoryHubCell class] forCellReuseIdentifier:FYPokerHistoryHubCellID];
    }
    return _tableView;
}
@end
