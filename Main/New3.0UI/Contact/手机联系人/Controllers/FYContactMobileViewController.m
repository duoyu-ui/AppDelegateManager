//
//  FYContactMobileViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "FYContactMobileViewController.h"
#import "FYContactMobileTableViewCell.h"
#import "FYContactMobileSectionModel.h"
#import "FYContactMobileSearchModel.h"
#import "FYMobilePerson.h"
//
#import "UITableView+SCIndexView.h"
#import "FYIndexViewHeaderView.h"
//
#import "FYMobileContactManager.h"
#import "FYMobilePerson.h"
//
#import "FYSearchViewController.h"
#import "FYSearchBarView.h"


@interface FYContactMobileViewController () <UITableViewDelegate, UITableViewDataSource, FYSearchViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) FYSearchViewController *searchViewController;
@property (nonatomic, strong) FYSearchBarView *tableHeaderView;
//
@property (nonatomic, strong) NSMutableArray<FYContactMobileSearchModel *> *tableViewSearchSource;

@end

@implementation FYContactMobileViewController


#pragma mark - Actions

/// 搜索
- (void)pressSearchButtonAction
{
    WEAKSELF(weakSelf)
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchViewController setCloseActionBlock:^(UIViewController * _Nonnull fromViewController) {
        [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
        [fromViewController dismissViewControllerAnimated:NO completion:nil];
    }];
    [self presentViewController:self.searchViewController animated:YES completion:^{}];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshHeader = NO;
        self.hasRefreshFooter = NO;
        self.isAutoLayoutSafeAreaBottom = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [[FYMobileContactManager sharedInstance] accessContactsComplection:^(BOOL succeed, NSArray<FYMobilePerson *> *contacts) {
        PROGRESS_HUD_DISMISS
        [weakSelf doRefreshTableViewByContacts:contacts];
    }];
}

- (void)tableViewRefreshSetting:(UITableView *)tableView
{
    [self.tableViewRefresh setShowsVerticalScrollIndicator:NO];
    [self.tableViewRefresh setTableHeaderView:self.tableHeaderView];
    
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configuration];
    configuration.indexItemHeight = 13.0f;
    configuration.indexItemsSpace = margin * 0.25f;
    configuration.indexItemRightMargin = margin * 0.5f;
    configuration.indexItemTextColor = COLOR_HEXSTRING(@"#555555");
    configuration.indexItemSelectedTextColor = COLOR_HEXSTRING(@"#FFFFFF");
    configuration.indexItemSelectedBackgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    //
    self.tableViewRefresh.sc_indexViewConfiguration = configuration;
    self.tableViewRefresh.sc_translucentForTableViewInNavigationBar = NO;
}


- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYContactMobileTableViewCell class] forCellReuseIdentifier:[FYContactMobileTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:FYIndexViewHeaderView.class forHeaderFooterViewReuseIdentifier:FYIndexViewHeaderView.reuseID];
}

/// 刷新通讯录数据
- (void)doRefreshTableViewByContacts:(NSArray<FYMobilePerson *> *)contacts
{
    // 数据处理
    NSMutableArray<FYContactMobileSectionModel *> *allSectionModels = [FYContactMobileSectionModel getContactMobileDataSource:contacts];
    NSMutableArray<NSString *> *sectionIndexTitle = [FYContactMobileSectionModel getContactMobileSectionTitles:allSectionModels];
    
    // 所有数据
    [self setTableDataRefresh:allSectionModels];
    
    // 刷新表格
    dispatch_main_async_safe(^{
        // 刷新表格
        if (self.tableDataRefresh.count > 0) {
            [self.tableViewRefresh reloadData];
        } else {
            [self.tableViewRefresh reloadData];
            [self setIsEmptyDataSetShouldDisplay:YES];
            [self.tableViewRefresh reloadEmptyDataSet];
        }
        
        // 右边索引
        [self.tableViewRefresh setSc_indexViewDataSource:sectionIndexTitle.copy];
        [self.tableViewRefresh setSc_startSection:1];
    });
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableDataRefresh.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= section) {
        return 0;
    }
    FYContactMobileSectionModel *sectionItem = self.tableDataRefresh[section];
    return sectionItem.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath cellIdentifier:[FYContactMobileTableViewCell reuseIdentifier] dataSource:self.tableDataRefresh isSearch:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYContactMobileTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FYIndexViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FYIndexViewHeaderView.reuseID];
    FYContactMobileSectionModel *sectionItem = self.tableDataRefresh[section];
    [headerView configWithTitle:sectionItem.title];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FYIndexViewHeaderView.headerViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYContactMobileSectionModel *sectionModel = [self.tableDataRefresh objectAtIndex:indexPath.section];
    if (indexPath.row < sectionModel.persons.count) {
        id model = [sectionModel.persons objectAtIndex:indexPath.row];
        [self doSelectRowAtObjectModel:model];
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据越界", nil))
    }
}


#pragma mark - FYSearchViewControllerDelegate

/// 输入关键字搜索Action
- (void)fySearchResultByKeyword:(NSString *)searchText isSearch:(BOOL)isSeach
{
    if (!isSeach) {
        return;
    }
    
    // 搜索过滤
    __block NSMutableArray *searchResultData = [NSMutableArray array];
    __block NSMutableArray<FYContactMobileSearchModel *> *searchContactResust = [NSMutableArray array];
    [self.tableDataRefresh enumerateObjectsUsingBlock:^(FYContactMobileSectionModel * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        [section.persons enumerateObjectsUsingBlock:^(FYMobilePerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self isContainerKeyword:searchText atMobilePerson:obj]) {
                [searchResultData addObj:obj];
                //
                FYContactMobileSearchModel *resModel = [[FYContactMobileSearchModel alloc] init];
                [resModel setSearchKey:searchText];
                [searchContactResust addObj:resModel];
            }
        }];
    }];
    
    // 搜索结果
    [self.tableViewSearchSource setArray:searchContactResust];
    [self.searchViewController reloadSearchTableWithDataSource:searchResultData];
}

- (BOOL)isContainerKeyword:(NSString *)keyword atMobilePerson:(FYMobilePerson *)model
{
    NSString *fullName = model.fullName;
    NSString *phone = model.phones.firstObject.phone;
    if ([fullName containsString:keyword]
        || [phone containsString:keyword]) {
        return YES;
    }
    
    return NO;
}

/// 搜索结果展示 Cell
- (UITableViewCell *)fySearchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource cellIdentifier:(NSString *)cellIdentifier
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath cellIdentifier:cellIdentifier dataSource:dataSource isSearch:YES];
}

/// 搜索结果展示 CellHeight
- (CGFloat)fySearchTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{
    return [FYContactMobileTableViewCell height];
}

/// 点击搜索结果详情
- (void)fySearchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{
    id model = [dataSource objectAtIndex:indexPath.row];
    [self doSelectRowAtObjectModel:model];
}


#pragma mark - MFMessageComposeViewControllerDelegate

/// 短信发送成功后的回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MessageComposeResultCancelled: {
            // 用户取消发送
            break;
        }
        case MessageComposeResultFailed: {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"短信发送失败!", nil))
            break;
        }
        case MessageComposeResultSent: {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"短信发送成功!", nil))
            break;
        }
        default: {
            break;
        }
    }
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"手机联系人", nil);
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter & Setter

- (FYSearchBarView *)tableHeaderView
{
    if (!_tableHeaderView) {
        WEAKSELF(weakSelf)
        CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH, [FYSearchBarView heightOfSearchBar]);
        _tableHeaderView = [[FYSearchBarView alloc] initWithFrame:frame searchPlaceholder:NSLocalizedString(@"搜索", nil)];
        [_tableHeaderView setSearchActionBlock:^{
            [weakSelf pressSearchButtonAction];
        }];
    }
    return _tableHeaderView;
}

- (FYSearchViewController *)searchViewController
{
    if (!_searchViewController) {
        NSArray<NSString *> *cellClassNames = @[ NSStringFromClass([FYContactMobileTableViewCell class]) ];
        _searchViewController = [FYSearchViewController alertSearchController:NSLocalizedString(@"请输入联系人姓名", nil) delegate:self cellClass:cellClassNames];
    }
    return _searchViewController;
}

- (NSMutableArray *)tableViewSearchSource
{
    if (!_tableViewSearchSource) {
        _tableViewSearchSource = [NSMutableArray new];
    }
    return _tableViewSearchSource;
}


#pragma mark - Private

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString *)cellIdentifier dataSource:(NSMutableArray *)dataSource isSearch:(BOOL)isSearch
{
    id model = nil;
    FYContactMobileSearchModel *searchModel = nil;
    if (isSearch) {
        model = [dataSource objectAtIndex:indexPath.row];
        searchModel = [self.tableViewSearchSource objectAtIndex:indexPath.row];
    } else {
        FYContactMobileSectionModel *sectionModel = [dataSource objectAtIndex:indexPath.section];
        if (indexPath.row < sectionModel.persons.count) {
            model = [sectionModel.persons objectAtIndex:indexPath.row];
        }
    }

    FYContactMobileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FYContactMobileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:model searchResModel:searchModel isSearch:isSearch];
    return cell;
}

- (void)doSelectRowAtObjectModel:(FYMobilePerson *)person
{
    if([MFMessageComposeViewController canSendText])  {
        NSString *shareInfo = [NSString stringWithFormat:NSLocalizedString(@"诚邀你注册%@，官方下载地址：", nil), [[FunctionManager sharedInstance] getApplicationName]];
        NSString *shareLinkUrl = [NSString stringWithFormat:@"%@?code=%@",APPINFORMATION.address,APPINFORMATION.userInfo.invitecode];
        NSString *content = [NSString stringWithFormat:@"%@%@", shareInfo, shareLinkUrl];
        //
        FYPhone *phone = person.phones.firstObject;
        NSString *telephone = [NSString stringWithFormat:@"%@", phone.phone];
        NSArray<NSString *> *recipients = [NSArray arrayWithObject:telephone];
        //
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.body = content;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"模拟器不能使用此功能", nil))
    }
}


@end

