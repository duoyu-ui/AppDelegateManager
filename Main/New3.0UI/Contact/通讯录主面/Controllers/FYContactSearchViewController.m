//
//  FYContactSearchViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactMainViewController.h"
#import "FYContactSearchViewController+EmptyDataSet.h"
#import "FYContactSearchViewController.h"
#import "FYContactSearchTableViewCell.h"
#import "FYContactSectionModel.h"
#import "FYContactSearchModel.h"
#import "FYContactsModel.h"


@interface FYContactSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>
//
@property (assign, nonatomic) CGFloat searchContainerHeight;
@property (assign, nonatomic) CGFloat topHeaderContainerHeight;
//
@property (nonatomic, strong) UIView *topHeaderContainer;
@property (nonatomic, strong) UIView *searchTextContainer;
@property (nonatomic, strong) UITextField *searchTextField;
//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) NSMutableArray *tableViewOriginSource;
//
@property (nonatomic, strong) NSMutableArray<FYContactSearchModel *> *tableViewSearchSource;

@end


@implementation FYContactSearchViewController

#pragma mark - Actions

- (void)pressCancleButtonAcion:(id)button
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.cancleActionBlock) {
            self.cancleActionBlock();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self pressCancleButtonAcion:nil];
}


#pragma mark - Life Cycle

+ (instancetype)alertSearchController:(NSMutableArray *)dataSource delegate:(id<FYContactSearchViewControllerDelegate>)delegate
{
    FYContactSearchViewController *instance = [[FYContactSearchViewController alloc] initWithDataSource:dataSource delegate:delegate];
    return instance;
}

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource delegate:(id<FYContactSearchViewControllerDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _tableViewOriginSource = dataSource;
        _tableViewDataSource = @[].mutableCopy;
        _tableViewSearchSource = @[].mutableCopy;
        _searchContainerHeight = TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SEARCH; // 搜索 10 + searchHeight + 10
        _topHeaderContainerHeight = TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SEARCH + STATUS_BAR_HEIGHT;
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_RGBA(0, 0, 0, 0.3)];
    
    [self viewDidAddSearchView];
    
    [self viewDidAddSearchTableView];
}

- (void)viewDidAddSearchView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat search_button_top_bottom_gap = 10.0f;
    
    // 容器
    [self.view addSubview:self.topHeaderContainer];
    [self.topHeaderContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.topHeaderContainerHeight);
    }];
    
    // 搜索
    [self.topHeaderContainer addSubview:self.searchTextContainer];
    [self.searchTextContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topHeaderContainer.mas_top).offset(search_button_top_bottom_gap+STATUS_BAR_HEIGHT);
        make.left.equalTo(self.topHeaderContainer.mas_left).offset(margin);
        make.bottom.equalTo(self.topHeaderContainer.mas_bottom).offset(-search_button_top_bottom_gap);
    }];
    
    // 取消
    UIButton *cancleButton = ({
        UIButton *button = [self createButtonWithTitle:NSLocalizedString(@"取消", nil) action:@selector(pressCancleButtonAcion:)];
        [self.topHeaderContainer addSubview:button];
        [button addBorderWithColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT cornerRadius:5 andWidth:0.0f];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchTextContainer.mas_centerY);
            make.right.equalTo(self.topHeaderContainer.mas_right);
            make.height.equalTo(self.searchTextContainer.mas_height);
            make.width.mas_equalTo(NAVIGATION_BAR_BUTTON_MAX_WIDTH);
        }];
        
        button;
    });
    cancleButton.mas_key = @"cancleButton";
    
    // 搜索
    [self.searchTextContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cancleButton.mas_left);
    }];
    
    // 图片
    UIImageView *iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.searchTextContainer addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_search"]];
        
        CGFloat imageSize = self.searchContainerHeight * 0.264f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchTextContainer.mas_left).offset(margin*0.8f);
            make.centerY.equalTo(self.searchTextContainer.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    iconImageView.mas_key = @"iconImageView";
    
    // 搜索
    [self.searchTextContainer addSubview:self.searchTextField];
    [self.searchTextField becomeFirstResponder];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(margin*0.8f);
        make.right.equalTo(self.searchTextContainer.mas_right);
        make.top.equalTo(self.searchTextContainer.mas_top);
        make.bottom.equalTo(self.searchTextContainer.mas_bottom);
    }];
}

- (void)viewDidAddSearchTableView
{
    [self.view addSubview:self.tableView];
    [self.tableView setHidden:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableViewDataSource) {
        return 0;
    }
    return self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableViewDataSource || self.tableViewDataSource.count <= 0) {
        return nil;
    }
    
    FYContactsModel *contactModel = self.tableViewDataSource[indexPath.row];
    FYContactSearchModel *searchModel = [self.tableViewSearchSource objectAtIndex:indexPath.row];
    
    FYContactSearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYContactSearchTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYContactSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYContactSearchTableViewCell reuseIdentifier]];
    }
    [cell setIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setContactsModel:contactModel searchResModel:searchModel];
    
    // 新的朋友
    if (FYContactsLocalTypeMyNewFriends == contactModel.localType) {
        cell.badge = [IMContactsModule sharedInstance].allVerifyFriendEntities.count;
    }
    // 我的群组
    else if (FYContactsLocalTypeMyJoinGroups == contactModel.localType) {
        cell.badge = [IMContactsModule sharedInstance].allVerifyGroupEntities.count;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableViewDataSource || self.tableViewDataSource.count <= 0) {
        return FLOAT_MIN;
    }
    
    return TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_SEARCH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.tableViewDataSource.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        id objModel = self.tableViewDataSource[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didContactSearchResultAtObjectModel:)]) {
            [self.delegate didContactSearchResultAtObjectModel:objModel];
        }
        if (self.cancleActionBlock) {
            self.cancleActionBlock();
        }
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    FYLog(NSLocalizedString(@"搜索关键定 => %@", nil), textString);
    
    if (VALIDATE_STRING_EMPTY(textString)) {
        [self setTableViewDataSource:@[].mutableCopy];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
        return YES;
    }
    
    NSMutableArray *searchResArr = [self searchOriginSourceByKeyword:textString];
    if (!searchResArr || searchResArr.count <= 0) {
        [self setTableViewDataSource:@[].mutableCopy];
    } else {
        [self setTableViewDataSource:searchResArr];
    }
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self setTableViewDataSource:@[].mutableCopy];
    [self.tableView setHidden:YES];
    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *textString = textField.text;
    FYLog(NSLocalizedString(@"搜索关键定 => %@", nil), textString);
    
    // 搜索内容为空
    if (VALIDATE_STRING_EMPTY(textString)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"搜索内容不能为空", nil))
        [self setTableViewDataSource:@[].mutableCopy];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
        return YES;
    }
    
    // 关闭键盘
    [self doKeyBoardEndEditing];
    
    // 执行搜索操作
    NSMutableArray *searchResArr = [self searchOriginSourceByKeyword:textString];
    if (!searchResArr || searchResArr.count <= 0) {
        [self setTableViewDataSource:@[].mutableCopy];
    } else {
        [self setTableViewDataSource:searchResArr];
    }
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    
    return YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self doKeyBoardEndEditing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self doKeyBoardEndEditing];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter/Setter

- (UIView *)topHeaderContainer
{
    if(!_topHeaderContainer)
    {
        _topHeaderContainer= [[UIView alloc] init];
        [_topHeaderContainer setBackgroundColor:[UIColor whiteColor]];
    }
    return _topHeaderContainer;
}

- (UIView *)searchTextContainer
{
    if(!_searchTextContainer)
    {
        _searchTextContainer= [UIView new];
        [_searchTextContainer setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [_searchTextContainer addCornerRadius:5.0f];
    }
    return _searchTextContainer;
}

- (UITextField *)searchTextField
{
    if(!_searchTextField)
    {
        _searchTextField = [UITextField new];
        [_searchTextField setDelegate:self];
        [_searchTextField setReturnKeyType:UIReturnKeySearch];
        [_searchTextField setBorderStyle:UITextBorderStyleNone];
        [_searchTextField setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_searchTextField setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)]];
        [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_searchTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入用户昵称", nil) attributes:@{ NSForegroundColorAttributeName : COLOR_HEXSTRING(@"#B3B3B3") }]];
    }
    return _searchTextField;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, self.topHeaderContainerHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.topHeaderContainerHeight);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setEstimatedRowHeight:80.0f];
        [tableView setSectionHeaderHeight:FLOAT_MIN];
        [tableView setSectionFooterHeight:FLOAT_MIN];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setBackgroundColor:[UIColor whiteColor]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [tableView setBackgroundView:backgroundView];
        [tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        // 空白页展示
        [tableView setEmptyDataSetSource:self];
        [tableView setEmptyDataSetDelegate:self];
        
        //
        [tableView registerClass:[FYContactSearchTableViewCell class] forCellReuseIdentifier:[FYContactSearchTableViewCell reuseIdentifier]];
        _tableView = tableView;
    }
    return _tableView;
}


#pragma mark - Private

- (void)doKeyBoardEndEditing
{
    [self.view endEditing:YES];
}

- (NSMutableArray *)searchOriginSourceByKeyword:(NSString *)keyword
{
    __block NSMutableArray *searchResust = [NSMutableArray array];
    __block NSMutableArray<FYContactSearchModel *> *searchContactResust = [NSMutableArray array];
    
    [self.tableViewOriginSource enumerateObjectsUsingBlock:^(FYContactSectionModel * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        [section.contacts enumerateObjectsUsingBlock:^(FYContactsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self isContainerKeyword:keyword atContactModel:obj]) {
                [searchResust addObj:obj];
                //
                BOOL isShowNickSearch = [self isShowNickSearchKeyword:keyword atContactModel:obj];
                FYContactSearchModel *resModel = [[FYContactSearchModel alloc] init];
                [resModel setSearchKey:keyword];
                [resModel setIsShowNick:isShowNickSearch];
                [searchContactResust addObj:resModel];
            }
        }];
    }];
    
    // 搜索消息结果
    [self.tableViewSearchSource setArray:searchContactResust];
    
    return searchResust;
}

- (BOOL)isContainerKeyword:(NSString *)keyword atContactModel:(FYContactsModel *)model
{
    NSString *nick = model.nick;
    NSString *friendNick = model.friendNick;
    
    if ([nick containsString:keyword]
        || [friendNick containsString:keyword]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isShowNickSearchKeyword:(NSString *)keyword atContactModel:(FYContactsModel *)model
{
    NSString *nick = model.nick;
    NSString *friendNick = model.friendNick;
 
    if (VALIDATE_STRING_EMPTY(friendNick) ) {
        return NO;
    }

    if ([friendNick containsString:keyword]) {
        return NO;
    }
    
    if ([nick containsString:keyword]) {
        return YES;
    }
    
    return NO;
}


@end

