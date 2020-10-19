//
//  FYBillingSearchFilterButtonCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBillingSearchFilterButtonCell.h"
#import "FYBillingSearchFilterModel.h"

@interface FYBillingSearchFilterButtonCell ()
/**
 * 根容器组件
 */
@property (nonnull, nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器组件
 */
@property (nonnull, nonatomic, strong) UIView *publicContainerView;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end

@implementation FYBillingSearchFilterButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma make 创建子控件
- (void)createViewAtuoLayout
{
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0.0f);
            make.top.equalTo(@0.0f);
            make.right.equalTo(@0.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        view;
    });
    self.rootContainerView = rootContainerView;
    self.rootContainerView.mas_key = @"rootContainerView";
    
    // 公共容器
    UIView *publicContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view.layer setMasksToBounds:YES];
        [view setBackgroundColor:[UIColor whiteColor]];
        [rootContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
}


#pragma mark - 设置数据模型
- (void)setMenuModel:(id)menuModel
{
    // 类型安全检查
    if (![menuModel isKindOfClass:[FYBillingSearchFilterModel class]]) {
        return;
    }
    
    _menuModel = menuModel;
    
    FYBillingSearchFilterModel *realModel = (FYBillingSearchFilterModel *)menuModel;
    
    // 删除控件
    [self.publicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (realModel.items.count > 0) {
        
        // 图片 - 标题 - 详情
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        int colum = 2;
        CGFloat top_gap = margin * 2.0f;
        CGFloat bottom_gap = 0.0f;
        CGFloat itemWidth = SCREEN_WIDTH * 0.5f;
        CGFloat itemHeight = SYSTEM_GLOBAL_BUTTON_HEIGHT;
        
        // 分割线
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
            [self.publicContainerView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.publicContainerView.mas_top);
                make.left.right.equalTo(self.publicContainerView);
                make.height.mas_equalTo(0.0f);
            }];
            
            view;
        });
        self.separatorLineView = separatorLineView;
        self.separatorLineView.mas_key = @"separatorLineView";
        
        // 选项
        UIView *lastItemView = nil;
        for (int index = 0; index < realModel.items.count; index ++) {
            
            FYBillingFilterModel *filterModel = [realModel.items objectAtIndex:index];

            UIColor *textColor = [UIColor whiteColor];
            UIColor *bgColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
            if (FYBillingFilterButtonTypeReset == filterModel.buttonType) {
                textColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
                bgColor = COLOR_HEXSTRING(@"#FCE4E4");
            }
            
            // 容器
            UIView *itemView = ({
                UIView *itemContainerView = [[UIView alloc] init];
                [itemContainerView setTag:8000+index];
                [self.publicContainerView addSubview:itemContainerView];
                [itemContainerView setBackgroundColor:bgColor];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressItemView:)];
                [itemContainerView addGestureRecognizer:tapGesture];
                
                [itemContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(itemWidth));
                    make.height.equalTo(@(itemHeight));
                    
                    if (!lastItemView) {
                        make.top.equalTo(self.publicContainerView.mas_top).offset(top_gap);
                        make.left.equalTo(self.publicContainerView.mas_left);
                    } else {
                        if (index % colum == 0) {
                            make.top.equalTo(lastItemView.mas_bottom);
                            make.left.equalTo(self.publicContainerView.mas_left);
                        } else {
                            make.top.equalTo(lastItemView.mas_top);
                            make.left.equalTo(lastItemView.mas_right);
                        }
                    }
                }];
                itemContainerView.mas_key = [NSString stringWithFormat:@"itemContainerView%d",index];
                
                // 标题
                UILabel *titleLabel = ({
                    UILabel *label = [UILabel new];
                    [itemContainerView addSubview:label];
                    [label setTextColor:textColor];
                    [label setText:filterModel.title];
                    [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(itemContainerView.mas_centerX);
                        make.centerY.equalTo(itemContainerView.mas_centerY);
                    }];
                    
                    label;
                });
                titleLabel.mas_key = [NSString stringWithFormat:@"titleLabel%d",index];
                
                itemContainerView;
            });
            
            lastItemView = itemView;
        }
        
        // 约束的完整性
        [self.publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastItemView.mas_bottom).offset(bottom_gap).priority(749);
        }];
        
    } else {

        // 分割线
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
            [self.publicContainerView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.publicContainerView.mas_top);
                make.left.right.equalTo(self.publicContainerView);
                make.height.mas_equalTo(0.0f);
            }];
            
            view;
        });
        self.separatorLineView = separatorLineView;
        self.separatorLineView.mas_key = @"separatorLineView";
        
        // 约束的完整性
        [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
        }];
    }
    
}

#pragma mark - 触发操作事件
- (void)pressItemView:(UITapGestureRecognizer *)gesture
{
    UIView *itemView = (UIView*)gesture.view;
    
    NSUInteger index = itemView.tag - 8000;
    
    FYBillingSearchFilterModel *realModel = (FYBillingSearchFilterModel *)self.menuModel;
    if (index >= realModel.items.count) {
        FYLog(NSLocalizedString(@"数组越界，请检测代码。", nil));
        return;
    }

    FYBillingFilterModel *filterModel = [realModel.items objectAtIndex:index];
    if (filterModel.didSelectedBlock) {
        filterModel.didSelectedBlock(filterModel);
    }
}


@end

