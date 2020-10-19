//
//  FYSearchViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYSearchViewController+EmptyDataSet.h"
#import "FYSearchViewController.h"
#import "FYSearchBarView.h"
//
#import "FYSearchButtonTableCell.h"
#import "FYSearchButtonModel.h"


@interface FYSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>
//
@property (nonatomic, assign) CGFloat searchContainerHeight;
@property (nonatomic, assign) CGFloat topHeaderContainerHeight;
//
@property (nonatomic, strong) UIView *topHeaderContainer;
@property (nonatomic, strong) UIView *searchTextContainer;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, copy) NSString *searchTextPlaceholder; // 搜索提示信息
//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) NSArray<NSString *> *cellClassNames; // 搜索结果展示 cell

@end


@implementation FYSearchViewController

#pragma mark - Actions

- (void)pressCancleButtonAcion:(id)button
{
    WEAKSELF(weakSelf)
    [self dismissViewControllerAnimated:NO completion:^{
        if (weakSelf.closeActionBlock) {
            [weakSelf clearSearchViewController];
            weakSelf.closeActionBlock(weakSelf);
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self pressCancleButtonAcion:nil];
}


#pragma mark - Life Cycle


#pragma mark - Life Cycle

+ (instancetype)alertSearchController:(NSString *)searchTextPlaceholder delegate:(id<FYSearchViewControllerDelegate>)delegate cellClass:(NSArray<NSString *> *)cellClassNames;
{
    FYSearchViewController *instance = [[FYSearchViewController alloc] initWithSearchTextPlaceholder:searchTextPlaceholder delegate:delegate cellClass:cellClassNames];
    return instance;
}

- (instancetype)initWithSearchTextPlaceholder:(NSString *)searchTextPlaceholder delegate:(id<FYSearchViewControllerDelegate>)delegate cellClass:(NSArray<NSString *> *)cellClassNames
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _cellClassNames = cellClassNames;
        _tableViewDataSource = @[].mutableCopy;
        _searchTextPlaceholder = searchTextPlaceholder;
        _searchContainerHeight = [FYSearchBarView heightOfSearchBar]; // 搜索 10 + searchHeight + 10
        _topHeaderContainerHeight = [FYSearchBarView heightOfSearchBar] + STATUS_BAR_HEIGHT;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.searchTextField becomeFirstResponder];
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
    
    // 注册 TableView Cell
    for (NSString *cellClassName in self.cellClassNames) {
        [self.tableView registerClass:NSClassFromString(cellClassName) forCellReuseIdentifier:CELL_IDENTIFIER_FOR_SEARCH(cellClassName)];
    }
    
    // 搜索 Button Cell
    [self.tableView registerClass:[FYSearchButtonTableCell class] forCellReuseIdentifier:[FYSearchButtonTableCell reuseIdentifier]];
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
    
    id model = [self.tableViewDataSource objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[FYSearchButtonModel class]]) {
        NSString *cellIdentifier = [FYSearchButtonTableCell reuseIdentifier];
        FYSearchButtonTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[FYSearchButtonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fySearchTableView:cellForRowAtIndexPath:dataSource:cellIdentifier:)]) {
            NSString *cellClassName = self.cellClassNames.firstObject;
            NSString *cellIdentifier = CELL_IDENTIFIER_FOR_SEARCH(cellClassName);
            return [self.delegate fySearchTableView:tableView cellForRowAtIndexPath:indexPath dataSource:self.tableViewDataSource cellIdentifier:cellIdentifier];
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableViewDataSource || self.tableViewDataSource.count <= 0) {
        return FLOAT_MIN;
    }
    
    id model = [self.tableViewDataSource objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[FYSearchButtonModel class]]) {
        return [FYSearchButtonTableCell heightOfSearchButton];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fySearchTableView:heightForRowAtIndexPath:dataSource:)]) {
            return [self.delegate fySearchTableView:tableView heightForRowAtIndexPath:indexPath dataSource:self.tableViewDataSource];
        }
    }
    
    return FLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.tableViewDataSource.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }
    
    id model = [self.tableViewDataSource objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[FYSearchButtonModel class]]) {
        FYSearchButtonModel *realModel = (FYSearchButtonModel *)model;
        [self doSearchResultByKeyword:realModel.content];
    } else {
        WEAKSELF(weakSelf)
        [self dismissViewControllerAnimated:NO completion:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(fySearchTableView:didSelectRowAtIndexPath:dataSource:)]) {
                [weakSelf.delegate fySearchTableView:tableView didSelectRowAtIndexPath:indexPath dataSource:weakSelf.tableViewDataSource];
            }
            if (weakSelf.closeActionBlock) {
                [weakSelf clearSearchViewController];
                weakSelf.closeActionBlock(weakSelf);
            }
        }];
    }
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
    
    // 显示搜索按钮
    if (self.hasSearchButtonCell) {
        [self doShowSearchButtonTableCell:textString];
    }
    // 搜索操作
    else {
        [self doSearchResultByKeyword:textString];
    }
    
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
    
    if (VALIDATE_STRING_EMPTY(textString)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"搜索内容不能为空", nil))
        [self setTableViewDataSource:@[].mutableCopy];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
        return YES;
    }
    
    // 关闭键盘
    [self doKeyBoardEndEditing];
    
    // 搜索操作
    [self doSearchResultByKeyword:textString];
    
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
    if(!_topHeaderContainer) {
        _topHeaderContainer= [[UIView alloc] init];
        [_topHeaderContainer setBackgroundColor:[UIColor whiteColor]];
    }
    return _topHeaderContainer;
}

- (UIView *)searchTextContainer
{
    if(!_searchTextContainer) {
        _searchTextContainer= [UIView new];
        [_searchTextContainer setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [_searchTextContainer addCornerRadius:5.0f];
    }
    return _searchTextContainer;
}

- (UITextField *)searchTextField
{
    if(!_searchTextField) {
        _searchTextField = [UITextField new];
        [_searchTextField setDelegate:self];
        [_searchTextField setReturnKeyType:UIReturnKeySearch];
        [_searchTextField setBorderStyle:UITextBorderStyleNone];
        [_searchTextField setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_searchTextField setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)]];
        [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_searchTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.searchTextPlaceholder attributes:@{ NSForegroundColorAttributeName : COLOR_HEXSTRING(@"#B3B3B3") }]];
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
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [tableView setBackgroundView:backgroundView];
        [tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        // 空白页展示
        [tableView setEmptyDataSetSource:self];
        [tableView setEmptyDataSetDelegate:self];
        
        _tableView = tableView;
    }
    return _tableView;
}


#pragma mark - Private

- (void)doKeyBoardEndEditing
{
    [self.view endEditing:YES];
}

- (void)doSearchResultByKeyword:(NSString *)keyword
{
    if (VALIDATE_STRING_EMPTY(keyword)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"搜索内容不能为空", nil))
        if (self.delegate && [self.delegate respondsToSelector:@selector(fySearchResultByKeyword:isSearch:)]) {
            return [self.delegate fySearchResultByKeyword:keyword isSearch:NO];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fySearchResultByKeyword:isSearch:)]) {
        return [self.delegate fySearchResultByKeyword:keyword isSearch:YES];
    }
}

/// 显示搜索按钮（需要点击搜索按钮 Cell，方可执行）
- (void)doShowSearchButtonTableCell:(NSString *)keyword
{
    if (VALIDATE_STRING_EMPTY(keyword)) {
        return;
    }
    
    FYSearchButtonModel *model = [FYSearchButtonModel new];
    [model setImageUrl:@"AddGroupSearch_icon"];
    [model setContent:keyword];
    [self setTableViewDataSource:@[model].mutableCopy];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}

- (void)reloadSearchTableWithDataSource:(NSMutableArray *)dataSource
{
    if (!dataSource || dataSource.count <= 0) {
        [self setTableViewDataSource:@[].mutableCopy];
    } else {
        [self setTableViewDataSource:dataSource];
    }
    
    WEAKSELF(weakSelf)
    dispatch_main_async_safe(^{
        [weakSelf.tableView setHidden:NO];
        [weakSelf.tableView reloadData];
    });
}

- (void)clearSearchViewController
{
    [self setTableViewDataSource:@[].mutableCopy];
    [self.searchTextField setText:@""];
    
    WEAKSELF(weakSelf)
    dispatch_main_async_safe(^{
        [weakSelf.tableView setHidden:YES];
        [weakSelf.tableView reloadData];
    });
}


@end

