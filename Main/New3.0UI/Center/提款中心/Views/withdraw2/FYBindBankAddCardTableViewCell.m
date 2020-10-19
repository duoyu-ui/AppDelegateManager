//
//  FYBindBankAddCardTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBindBankAddCardTableViewCell.h"
#import "FYMyBankCardModel.h"


// Cell Identifier
NSString * const CELL_IDENTIFIER_BIND_BANKADDCARD_TABLEVIEW_CELL = @"FYBindBankAddCardTableViewCelldentifier";

@interface FYBindBankAddCardTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;

@end


@implementation FYBindBankAddCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat bankLogoSize = CFC_AUTOSIZING_WIDTH(30.0);
    CGFloat bankUserHeight = CFC_AUTOSIZING_WIDTH(40.0);

    [self.contentView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView insertSubview:view atIndex:0];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(margin*1.5f);
            make.top.equalTo(@0.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-margin*1.5f);
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
        [rootContainerView addSubview:view];
        [view addBorderWithColor:COLOR_BANK_CARD_NORMAL cornerRadius:margin*0.7f andWidth:1.5f];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPublicItemView:)];
        [view addGestureRecognizer:tapGesture];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left).offset(margin*2.0f);
            make.top.equalTo(rootContainerView.mas_top).offset(margin*1.5f);
            make.right.equalTo(rootContainerView.mas_right).offset(-margin*2.0f);
            make.bottom.equalTo(rootContainerView.mas_bottom).offset(-margin*1.5f);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // +
    UIView *addBankCardView = ({
        UIView *view = [[UIView alloc] init];
        [publicContainerView addSubview:view];
        [view addBorderWithColor:COLOR_BANK_CARD_NORMAL cornerRadius:3.0f andWidth:1.5f];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin*3.0f);
            make.centerX.equalTo(publicContainerView);
            make.size.mas_equalTo(CGSizeMake(bankLogoSize, bankLogoSize));
        }];
        
        view;
    });
    addBankCardView.mas_key = @"addBankCardView";
    
    // +
    UILabel *addBankCardLabel = ({
        UILabel *label = [UILabel new];
        [addBankCardView addSubview:label];
        [label setText:@"+"];
        [label setTextColor:COLOR_BANK_CARD_NORMAL];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16)]];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(addBankCardView);
        }];
        
        label;
    });
    addBankCardLabel.mas_key = @"addBankCardLabel";
    
    // 添加银行卡
    UILabel *addBankButtonLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"添加银行卡", nil)];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addBankCardView.mas_bottom);
            make.centerX.equalTo(publicContainerView);
            make.height.mas_equalTo(bankUserHeight);
        }];
        
        label;
    });
    addBankButtonLabel.mas_key = @"addBankButtonLabel";

    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addBankButtonLabel.mas_bottom).offset(margin*1.5f).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYMyBankCardModel *)model
{
    if (![model isKindOfClass:[FYMyBankCardModel class]]) {
        return;
    }
    
    _model = model;

}

#pragma mark - 触发操作事件

// 点击银行卡
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBindAddCardAtBankCardModel:indexPath:)]) {
        [self.delegate didBindAddCardAtBankCardModel:self.model indexPath:self.indexPath];
    }
}


@end

