//
//  FYBankcardUnBindViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBankcardUnBindViewController.h"
#import "FYBankCardUnBindTableViewCell.h"
#import "FYMyBankCardModel.h"
#import "FYBankItemModel.h"

@interface FYBankcardUnBindViewController () <FYBankCardUnBindTableViewCellDelegate>

@end


@implementation FYBankcardUnBindViewController


#pragma mark - Actions

/// 解绑银行卡
- (void)didSelectRowAtUnBindBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF(weakSelf)
    AlertViewCus *alertView = [AlertViewCus createInstanceWithView:nil];
    [alertView.textLabel setFont:[UIFont systemFontOfSize:16]];
    [alertView showWithText:NSLocalizedString(@"确定解绑银行卡？", nil) button1:NSLocalizedString(@"取消", nil) button2:NSLocalizedString(@"确认", nil) callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if (tag == 1) {
            [self doUnBindBankCardWithBankCardModel:model then:^(BOOL success) {
                if (success) {
                    ALTER_INFO_MESSAGE(NSLocalizedString(@"解绑成功", nil))
                    NSMutableArray<FYMyBankCardModel *> *myBankCardModels = [self.tableDataRefresh objectAtIndex:indexPath.section];
                    FYMyBankCardModel *delModel = [myBankCardModels objectAtIndex:indexPath.row];
                    [myBankCardModels removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableDataRefresh replaceObjectAtIndex:indexPath.section withObject:myBankCardModels];
                    if (myBankCardModels.count < 1) { // 已经没有绑定的银行卡了
                        [APPINFORMATION.userInfo setIsTiedCard:NO];
                        [weakSelf setCurrentBankCardModel:nil];
                        [weakSelf setTableDataRefresh:[FYMyBankCardModel buildingDataModlesForUnBind:nil selectedModel:nil then:nil]];
                        !weakSelf.finishUnBindMyBankCardBlock ?: weakSelf.finishUnBindMyBankCardBlock(nil,myBankCardModels);
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    } else {
                        if (delModel.isSelected) { // 解绑的是选中状态的银行卡
                            // 默认选中第一个
                            FYMyBankCardModel *defBankCarModel = myBankCardModels.firstObject;
                            [defBankCarModel setIsSelected:YES];
                            [weakSelf setCurrentBankCardModel:defBankCarModel];
                        }
                        !weakSelf.finishUnBindMyBankCardBlock ?: weakSelf.finishUnBindMyBankCardBlock(weakSelf.currentBankCardModel,myBankCardModels);
                    }
                    [weakSelf.tableViewRefresh reloadData];
                } else {
                    ALTER_INFO_MESSAGE(NSLocalizedString(@"解绑失败", nil))
                }
            }];
        }
    }];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshFooter = NO;
    }
    return self;
}

- (instancetype)initWithBankCardModel:(FYMyBankCardModel *)bankCardModel
{
    self = [self init];
    if (self) {
        self.currentBankCardModel = bankCardModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏底线
    [self.navigationBarHairlineImageView setHidden:YES];
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYBankCardUnBindTableViewCell class] forCellReuseIdentifier:[FYBankCardUnBindTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestMyBankList;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"银行卡 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    WEAKSELF(weakSelf);
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        weakSelf.tableDataRefresh = @[].mutableCopy;
        return weakSelf.tableDataRefresh;
    }

    // 获取绑定的银行卡列表
    NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSArray<NSDictionary *> *arrayOfDicts = [data arrayForKey:@"paymentList"];
    if ([arrayOfDicts isKindOfClass:[NSArray class]]) {
        bankCardModels = [FYMyBankCardModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    }
    
    // 获取绑定的银行卡列表
    weakSelf.tableDataRefresh = [FYMyBankCardModel buildingDataModlesForUnBind:bankCardModels selectedModel:self.currentBankCardModel then:^(FYMyBankCardModel * selectedBankCardModel) {
        if (selectedBankCardModel) {
            [APPINFORMATION.userInfo setIsTiedCard:YES];
            [weakSelf setCurrentBankCardModel:selectedBankCardModel];
            !weakSelf.finishUnBindMyBankCardBlock ?: weakSelf.finishUnBindMyBankCardBlock(selectedBankCardModel,bankCardModels);
        }
    }];

    return weakSelf.tableDataRefresh;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableDataRefresh.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:section];
    return sectionModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:indexPath.section];
    FYMyBankCardModel *myBankCardModel = [sectionModel objectAtIndex:indexPath.row];
    
    switch (myBankCardModel.cellType) {
        case FYMyBankCardCellTypeCard: {
            FYBankCardUnBindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBankCardUnBindTableViewCell reuseIdentifier]];
            if (cell == nil) {
                cell = [[FYBankCardUnBindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBankCardUnBindTableViewCell reuseIdentifier]];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = myBankCardModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:indexPath.section];
    FYMyBankCardModel *myBankCardModel = [sectionModel objectAtIndex:indexPath.row];
    
    switch (myBankCardModel.cellType) {
        case FYMyBankCardCellTypeCard: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBankCardUnBindTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBankCardUnBindTableViewCell *cell) {
                cell.model = myBankCardModel;
            }];
        };
        default:
            break;
    }
    
    return FLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, SEPARTOR_MARGIN_HEIGHT)];
    [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, SEPARTOR_MARGIN_HEIGHT)];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SEPARTOR_MARGIN_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_WITHDRAW_BANKCARD_UNBIND;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Private

- (void)doUnBindBankCardWithBankCardModel:(FYMyBankCardModel *)bankCardModel then:(void (^)(BOOL success))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getUnbindBankcardWhitPaymentId:bankCardModel.uuid.stringValue success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"解绑银行卡成功 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO);
        } else {
            !then ?: then(YES);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"解绑银行卡失败 => \n%@", nil), error);
        !then ?: then(NO);
    }];
}



@end

