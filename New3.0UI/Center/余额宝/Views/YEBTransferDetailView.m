//
//  YEBTransferDetailView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferDetailView.h"
#import "YEBTransferDetailHeaderView.h"
#import "YEBTransferDetailCell.h"
#import "YEBFinancialInfoModel.h"
#import "YEBAccountInfoModel.h"


@interface YEBTransferDetailView ()

@property (nonatomic, assign) NSInteger type;

@end


@implementation YEBTransferDetailView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    self.backgroundColor = COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
    [self registerNib:[UINib nibWithNibName:@"YEBTransferDetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.rowHeight = 54;
    [self loadDataWithType:self.type];
    self.noDataImage = @"state_empty";
    self.pageSize = 20;
    return self;
}

- (void)allBtnClick {
    
    kWeakly(self);
    NSArray *titles = @[NSLocalizedString(@"全部", nil), NSLocalizedString(@"转入", nil), NSLocalizedString(@"转出", nil), NSLocalizedString(@"收益", nil)];
    DYMenuView *view = [DYMenuLabelView onShowWithTargetView:self.headerView.allBtn titles:titles finished:^(NSInteger index) {
        weakself.type = index;
        [weakself loadDataWithType:index];
        [weakself.headerView.allBtn setTitle:[NSString stringWithFormat:@"%@ ▽", titles[index]] forState:UIControlStateNormal];
    }];
    view.defaultSelected = self.type;
}

- (void)loadDataWithType:(NSInteger)type {
    
    self.loadDataCallback = ^(NSUInteger pageIndex, DYTableView_Result _Nonnull result) {
        [[NetRequestManager sharedInstance] getMoneyDetailWithPageIndex:pageIndex pageSize:20 type:type isASC:NO success:^(id object) {
            NSDictionary *JSONObject = [object mj_JSONObject];
            NSArray *records = JSONObject[@"data"][@"records"];
            
            NSMutableArray *models = [YEBFinancialInfoModel mj_objectArrayWithKeyValuesArray:records];
            result(models);
                           
        } fail:^(id object) {
            
        }];
    };
    [self loadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.tableHeaderView) {
        self.tableHeaderView = [YEBTransferDetailHeaderView headerView];
        self.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140);
        [self.headerView.allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.headerView.totalMoney.text = [NSString stringWithFormat:@"￥ %.2f",self.model.m_totalMoney];
        self.headerView.profitLabel.text = [NSString stringWithFormat:@"￥ %.2f",self.model.m_totalEarnings];
        //
        self.headerView.titleTotalMoneyLabel.text = NSLocalizedString(@"总金额", nil);
        self.headerView.titleProfitShouYiLabel.text = NSLocalizedString(@"累计收益", nil);
        self.headerView.titleLast3MonthLabel.text = NSLocalizedString(@"展示近3个月明细", nil);
        [self.headerView.allBtn setTitle:NSLocalizedString(@"全部", nil) forState:UIControlStateNormal];
    }
}




- (YEBTransferDetailHeaderView *)headerView {
    
    return (YEBTransferDetailHeaderView *)self.tableHeaderView;
}

@end
