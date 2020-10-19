//
//  FYBankSearchViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBankSearchViewController+EmptyDataSet.h"
#import "FYBankSearchViewController.h"
#import "FYBankItemModel.h"

CGFloat const TOP_TITLE_AREA_HEIGHT = 45.0; // 标题
CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_BANK_SEARCH = 55.0; // 搜索

// Cell Identifier
NSString * const CELL_IDENTIFIER_BANK_SEARCH_TABLEVIEW_CELL = @"FYBankSearchCelldentifier";


@interface FYBankSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
//
@property (assign, nonatomic) CGFloat topAlphaHeight;
@property (assign, nonatomic) CGFloat searchContainerHeight;
@property (assign, nonatomic) CGFloat topHeaderContainerHeight;
//
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIView *topHeaderContainer;
@property (nonatomic, strong) UIView *searchTextContainer;
@property (nonatomic, strong) UITextField *searchTextField;
//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) NSMutableArray *tableViewOriginSource;
//
@property (nonatomic, strong) FYBankItemModel *selectedModel;

@end


@implementation FYBankSearchViewController

#pragma mark - Actions

- (void)pressCancleButtonAcion:(id)button
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cancleActionBlock) {
            self.cancleActionBlock();
        }
    }];
}


#pragma mark - Life Cycle

+ (instancetype)alertSearchController:(NSMutableArray *)dataSource selected:(FYBankItemModel *)itemModel delegate:(id<FYBankSearchViewControllerDelegate>)delegate
{
    FYBankSearchViewController *instance = [[FYBankSearchViewController alloc] initWithDataSource:dataSource selected:itemModel delegate:delegate];
    return instance;
}

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource selected:(FYBankItemModel *)itemModel delegate:(id<FYBankSearchViewControllerDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _selectedModel = itemModel;
        _tableViewOriginSource = dataSource;
        _tableViewDataSource = dataSource.mutableCopy;
        _topAlphaHeight = SCREEN_HEIGHT * 0.25f;
        _searchContainerHeight = TABLEVIEW_HEADER_HEIGHT_FOR_BANK_SEARCH; // 搜索10+searchHeight+10
        _topHeaderContainerHeight = TABLEVIEW_HEADER_HEIGHT_FOR_BANK_SEARCH + TOP_TITLE_AREA_HEIGHT;
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
        make.top.mas_equalTo(self.view.mas_top).offset(self.topAlphaHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.topHeaderContainerHeight);
    }];
    
    // 标题
    [self.topHeaderContainer addSubview:self.topTitleLabel];
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.topHeaderContainer);
        make.height.equalTo(@(TOP_TITLE_AREA_HEIGHT));
    }];
    
    // 搜索
    [self.topHeaderContainer addSubview:self.searchTextContainer];
    [self.searchTextContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTitleLabel.mas_bottom).offset(search_button_top_bottom_gap);
        make.left.equalTo(self.topHeaderContainer.mas_left).offset(margin);
        make.bottom.equalTo(self.topHeaderContainer.mas_bottom).offset(-search_button_top_bottom_gap);
    }];
    
    // 取消
    UIButton *cancleButton = ({
        UIButton *button = [self createButtonWithTitle:NSLocalizedString(@"取消", nil) action:@selector(pressCancleButtonAcion:)];
        [self.topHeaderContainer addSubview:button];
        [button addBorderWithColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT cornerRadius:5 andWidth:1.0];
        
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
    [self.tableView reloadData];
    
    // 默认选中项
    if (self.selectedModel) {
        WEAKSELF(weakSelf)
        __block NSInteger selectedIndex = 0;
        [self.tableViewOriginSource enumerateObjectsUsingBlock:^(FYBankItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.uuid.integerValue == weakSelf.selectedModel.uuid.integerValue) {
                selectedIndex = idx;
                *stop = YES;
            }
        }];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
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

    FYBankItemModel *model = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BANK_SEARCH_TABLEVIEW_CELL];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_BANK_SEARCH_TABLEVIEW_CELL];
    }
    CGFloat imageSize = 30;
    [cell.imageView setImage:[model.bankCardImage imageByScalingProportionallyToSize:CGSizeMake(imageSize, imageSize)]];
    [cell.textLabel setText:model.title];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)]];
    {
        UILabel *accessoryView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [accessoryView addCornerRadius:5];
        if (model.uuid.integerValue != self.selectedModel.uuid.integerValue) {
            [accessoryView setBackgroundColor:[UIColor whiteColor]];
        } else {
            [accessoryView setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        }
        [cell setAccessoryView:accessoryView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableViewDataSource || self.tableViewDataSource.count <= 0) {
        return FLOAT_MIN;
    }
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.tableViewDataSource.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }
    
    id objModel = self.tableViewDataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBankModelSearchResultAtObjectModel:)]) {
        [self.delegate didBankModelSearchResultAtObjectModel:objModel];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.cancleActionBlock) {
            self.cancleActionBlock();
        }
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (VALIDATE_STRING_EMPTY(textString)) {
        [self setTableViewDataSource:self.tableViewOriginSource];
        [self.tableView reloadData];
        return YES;
    }
    
    NSMutableArray *searchResArr = [self searchOriginSourceByKeyword:textString];
    if (!searchResArr || searchResArr.count <= 0) {
        [self setTableViewDataSource:self.tableViewOriginSource];
    } else {
        [self setTableViewDataSource:searchResArr];
    }
    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self setTableViewDataSource:self.tableViewOriginSource];
    [self.tableView reloadData];
    
    return YES;
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

- (UILabel *)topTitleLabel
{
    if(!_topTitleLabel)
    {
        _topTitleLabel= [[UILabel alloc] init];
        [_topTitleLabel setText:NSLocalizedString(@"选择银行", nil)];
        [_topTitleLabel setTextColor:[UIColor whiteColor]];
        [_topTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_topTitleLabel setFont:FONT_NAVIGATION_BAR_TITLE_DEFAULT];
        [_topTitleLabel setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    }
    return _topTitleLabel;
}

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
        [_searchTextField setBorderStyle:UITextBorderStyleNone];
        [_searchTextField setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_searchTextField setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)]];
        [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_searchTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入银行名称", nil) attributes:@{ NSForegroundColorAttributeName : COLOR_HEXSTRING(@"#B3B3B3") }]];
    }
    return _searchTextField;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat frameY = self.topAlphaHeight + self.topHeaderContainerHeight;
        CGRect frame = CGRectMake(0.0f, frameY, self.view.bounds.size.width, self.view.bounds.size.height-frameY);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setEstimatedRowHeight:80.0f];
        [tableView setTableHeaderView:[UIView new]];
        [tableView setTableFooterView:[UIView new]];
        [tableView setSectionHeaderHeight:FLOAT_MIN];
        [tableView setSectionFooterHeight:FLOAT_MIN];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setBackgroundColor:[UIColor whiteColor]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_BANK_SEARCH_TABLEVIEW_CELL];
        _tableView = tableView;
    }
    return _tableView;
}


#pragma mark - Private

- (NSMutableArray *)searchOriginSourceByKeyword:(NSString *)keyword
{
    __block NSMutableArray *searchResust = [NSMutableArray array];
    
    [self.tableViewOriginSource enumerateObjectsUsingBlock:^(FYBankItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.title containsString:keyword]) {
            [searchResust addObj:obj];
        }
    }];
    
    return searchResust;
}


@end

