//
//  FYGroupTypeSettingViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGroupTypeSettingViewController.h"
#import "FYRedPacketListModel.h"

@interface FYGroupTypeSettingViewController ()
//
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSArray<FYRedPacketListModel *> *arrayOfGroupType;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayOfGroupTypeButtons;
//
@property (nonatomic, strong) FYRedPacketListModel *selectedModel;
@property (nonatomic, copy) FYGroupTypeSettingSelectedBlock confirmSelectedBlock;
//
@property (nonatomic, copy) NSString *selectedIndex;

@end

@implementation FYGroupTypeSettingViewController

#pragma mark - Actions

- (void)pressNavBarButtonActionCancle:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressConfirmButtonAction:(UIButton *)button
{
    if (VALIDATE_STRING_EMPTY(self.selectedIndex)) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.confirmSelectedBlock) {
        self.confirmSelectedBlock(self.selectedModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressGroupTypeButtonAction:(UIButton *)button
{
    NSUInteger index = button.tag - 8000;
    
    if (index >= self.arrayOfGroupType.count || index >= self.arrayOfGroupType.count) {
        FYLog(NSLocalizedString(@"数组越界，请检测代码。", nil));
        return;
    }
    
    [self setSelectedIndex:[NSString stringWithFormat:@"%ld", index]];
    [self setSelectedModel:[self.arrayOfGroupType objectAtIndex:index]];
    [self.arrayOfGroupTypeButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            dispatch_main_async_safe(^{
                [obj addBorderWithColor:COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT cornerRadius:0.0f andWidth:1.5f];
            });
        } else {
            dispatch_main_async_safe(^{
                [obj addBorderWithColor:COLOR_HEXSTRING(@"#D9D9D9") cornerRadius:0.0f andWidth:1.5f];
            });
        }
    }];
}


#pragma mark - Life Cycle

- (instancetype)initWidthGroupTypeListModels:(NSArray<FYRedPacketListModel *> *)arrayOfGroupType
                               selectedModel:(FYRedPacketListModel *)selectedModel
                               completeBlock:(FYGroupTypeSettingSelectedBlock)confirmSelectedBlock
{
    self = [super init];
    if (self) {
        _selectedIndex = @"";
        _selectedModel = selectedModel;
        _arrayOfGroupType = arrayOfGroupType;
        _confirmSelectedBlock = confirmSelectedBlock;
        //
        [self setupSelectedIndex];
    }
    return self;
}

- (void)setupSelectedIndex
{
    if (!self.selectedModel) {
        return;
    }
    
    WEAKSELF(weakSelf)
    [self.arrayOfGroupType enumerateObjectsUsingBlock:^(FYRedPacketListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == weakSelf.selectedModel.type) {
            [self setSelectedIndex:[NSString stringWithFormat:@"%ld", idx]];
            *stop = YES;
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    {
        UIBarButtonItem *cancleButtonItem = [self createBarButtonItemWithTitle:NSLocalizedString(@"取消", nil) action:@selector(pressNavBarButtonActionCancle:) offsetType:CFCNavBarButtonOffsetTypeLeft];
        [self.navigationItem setLeftBarButtonItem:cancleButtonItem];
    }
    
    [self createMainUIView];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    UIScrollView *rootScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [scrollView setShowsVerticalScrollIndicator:YES];
        [self.view addSubview:scrollView];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                if (@available(iOS 11.0, *)) {
                    make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                } else {
                    make.top.equalTo(self.view.mas_top);
                    make.bottom.equalTo(self.view.mas_bottom);
                }
            } else {
                make.top.equalTo(self.view.mas_top);
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
        
        scrollView;
    });
    rootScrollView.mas_key = @"rootScrollView";
    
    UIView *containerView = ({
        UIView *view = [[UIView alloc] init];
        [rootScrollView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rootScrollView);
            make.width.equalTo(rootScrollView);
            if (IS_IPHONE_X) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
    
    // 选择区域
    UIView *lastItemView = nil;
    if (self.arrayOfGroupType.count > 0) {
        int colum = 3;
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat top_bottom_gap = margin * 1.5f;
        CGFloat left_right_gap = margin * 1.5f;
        CGFloat item_gap = margin;
        CGFloat itemWidth = (SCREEN_WIDTH - left_right_gap*2.0f - item_gap*(colum-1)) / colum;
        CGFloat itemHeight = itemWidth * 1.3f;
        CGFloat itemImageInset = itemWidth * 0.26f;
        CGFloat autoNameFontSize = CFC_AUTOSIZING_FONT(13.0f);
        
        _arrayOfGroupTypeButtons = [NSMutableArray<UIButton *> array];
        for (NSInteger idx = 0; idx < self.arrayOfGroupType.count; idx ++) {
            FYRedPacketListModel *groupTypeModel = [self.arrayOfGroupType objectAtIndex:idx];
            // 容器
            lastItemView = ({
                UIView *itemContainerView = [[UIView alloc] init];
                [containerView addSubview:itemContainerView];
                [itemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(itemWidth));
                    make.height.equalTo(@(itemHeight));
                    if (!lastItemView) {
                        make.top.equalTo(containerView.mas_top).offset(top_bottom_gap);
                        make.left.equalTo(containerView.mas_left).offset(left_right_gap);
                    } else {
                        if (idx % colum == 0) {
                            make.top.equalTo(lastItemView.mas_bottom).offset(item_gap);
                            make.left.equalTo(containerView.mas_left).offset(left_right_gap);
                        } else {
                            make.top.equalTo(lastItemView.mas_top);
                            make.left.equalTo(lastItemView.mas_right).offset(item_gap);
                        }
                    }
                }];
                
                UIButton *button = ({
                    NSString *imgeUrl = [self getButtonImageUrlByGroupType:groupTypeModel];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [itemContainerView addSubview:button];
                    [button setTag:8000+idx];
                    [button setBackgroundColor:[UIColor whiteColor]];
                    [button setImageEdgeInsets:UIEdgeInsetsMake(itemImageInset, itemImageInset, itemImageInset, itemImageInset)];
                    [button setImage:[UIImage imageNamed:imgeUrl] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(pressGroupTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (!VALIDATE_STRING_EMPTY(self.selectedIndex) && idx == self.selectedIndex.integerValue) {
                        [button addBorderWithColor:COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT
                                      cornerRadius:0.0f
                                          andWidth:1.5f];
                    } else {
                        [button addBorderWithColor:COLOR_HEXSTRING(@"#D9D9D9") cornerRadius:0.0f andWidth:1.5f];
                    }
                    
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.right.equalTo(itemContainerView);
                        make.height.equalTo(itemContainerView.mas_width);
                    }];
                    
                    button;
                });
                button.mas_key = [NSString stringWithFormat:@"button%ld", idx];
                
                // 标题
                UILabel *titleLabel = ({
                    UILabel *label = [UILabel new];
                    [itemContainerView addSubview:label];
                    [label setText:groupTypeModel.showName];
                    [label setFont:[UIFont boldSystemFontOfSize:autoNameFontSize]];
                    [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(itemContainerView.mas_left).offset(margin*0.5f);
                        make.right.equalTo(itemContainerView.mas_right).offset(-margin*0.5f);
                        make.centerY.equalTo(itemContainerView.mas_bottom).multipliedBy(0.884615f);
                    }];
                    
                    label;
                });
                titleLabel.mas_key = [NSString stringWithFormat:@"titleLabel%ld", idx];
                
                [_arrayOfGroupTypeButtons addObject:button];
                
                itemContainerView;
            });
            lastItemView.mas_key = [NSString stringWithFormat:@"itemView%ld", idx];
        }
    }
    
    // 确认按钮
    UIButton *confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button defaultStyleButton];
        [containerView addSubview:button];
        [button.layer setBorderWidth:0.0f];
        [button setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastItemView.mas_bottom).offset(margin*4.0f);
            make.left.equalTo(containerView.mas_left).offset(margin*2.0f);
            make.right.equalTo(containerView.mas_right).with.offset(-margin*2.0f);
            make.height.equalTo(@(CFC_AUTOSIZING_WIDTH(SYSTEM_GLOBAL_BUTTON_HEIGHT)));
        }];
        
        button;
    });
    self.confirmButton = confirmButton;
    self.confirmButton.mas_key = @"confirmButton";

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(confirmButton.mas_bottom).offset(margin*5.0f).priority(749);
    }];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_GROUP_TYPE_CHOICE;
}


#pragma mark - Private

- (NSString *)getButtonImageUrlByGroupType:(FYRedPacketListModel *)modle
{
    if (0 == modle.type) { /// 福利
        return @"icon_game_fl";
    } else if (1 == modle.type) { /// 扫雷
        return @"icon_game_sl";
    } else if (2 == modle.type) { /// 牛牛
        return @"icon_game_nn";
    } else if (3 == modle.type) { /// 禁抢
        return ICON_COMMON_PLACEHOLDER;
    } else if (4 == modle.type) { /// 抢庄牛牛
        return @"icon_game_qznn";
    } else if (5 == modle.type) { /// 二八杠
        return @"icon_game_rbg";
    } else if (6 == modle.type) { /// 龙虎斗
        return @"icon_game_lhd";
    } else if (7 == modle.type) { /// 接龙
        return @"icon_game_jl";
    } else if (8 == modle.type) { /// 二人牛牛
        return @"icon_game_nner";
    } else if (9 == modle.type) { /// 超级扫雷
        return @"icon_game_cjsl";
    }
    return ICON_COMMON_PLACEHOLDER;
}


@end

