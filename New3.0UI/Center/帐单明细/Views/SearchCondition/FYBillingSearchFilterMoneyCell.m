//
//  FYBillingSearchFilterMoneyCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBillingSearchFilterMoneyCell.h"
#import "FYBillingSearchFilterModel.h"

@interface FYBillingSearchFilterMoneyCell () <UITextFieldDelegate>
/**
 * 根容器组件
 */
@property (nonnull, nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器组件
 */
@property (nonnull, nonatomic, strong) UIView *publicContainerView;
/**
 * 标题控件
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 输入金额
 */
@property (nonatomic, strong) UITextField *minMoneyTextField;
@property (nonatomic, strong) UITextField *maxMoneyTextField;

@end


@implementation FYBillingSearchFilterMoneyCell

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
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat rootPublicViewHeight = 50.0f;
    CGFloat left_right_gap = margin * 1.5f;
    //
    CGFloat textFieldCornerRadius = 3.0f;
    CGFloat textFieldContainerHeight = 35.0f;
    UIColor *textFieldBorderColor = COLOR_HEXSTRING(@"#F5F5F5");
    UIColor *textFieldContainerColor = COLOR_HEXSTRING(@"#FFFFFF");
    //
    UIFont *textTitleFont = FONT_PINGFANG_REGULAR(15);
    UIColor *textTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    //
    UIFont *textFieldFont = FONT_PINGFANG_REGULAR(15);
    UIColor *textFieldColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIColor *textFieldPlaceholderColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressRootContainerView:)];
        [view addGestureRecognizer:tapGesture];
        
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
    
    // 标题
    UIView *titleContainer = ({
        // 容器
        UIView *view = [UIView new];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.rootContainerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rootContainerView.mas_top);
            make.left.right.equalTo(self.rootContainerView);
            make.height.mas_equalTo(CFC_AUTOSIZING_WIDTH(45.0f) );
        }];

        // 标题
        UILabel *titleLabel = ({
            UILabel *label = [UILabel new];
            [view addSubview:label];
            [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).offset(left_right_gap);
                make.right.equalTo(view.mas_right).offset(-margin*2.5f);
                make.centerY.equalTo(view.mas_centerY);
            }];
            
            label;
        });
        self.titleLabel = titleLabel;
        self.titleLabel.mas_key = @"titleLabel";
        
        view;
    });
    titleContainer.mas_key = @"titleContainer";
    
    // 公共容器
    UIView *publicContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [rootContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left);
            make.top.equalTo(titleContainer.mas_bottom);
            make.right.equalTo(rootContainerView.mas_right);
            make.bottom.equalTo(rootContainerView.mas_bottom);
            make.height.mas_equalTo(rootPublicViewHeight);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 最低金额
    UIView *minMoneyTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [publicContainerView addSubview:view];
        [view setBackgroundColor:textFieldContainerColor];
        [view addBorderWithColor:textFieldBorderColor cornerRadius:textFieldCornerRadius andWidth:1.0f];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.left.equalTo(publicContainerView.mas_left).offset(left_right_gap);
            make.right.equalTo(publicContainerView.mas_centerX).offset(-margin*1.5f);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        // 人民币¥
        UILabel *textTitleLabel = [UILabel new];
        [view addSubview:textTitleLabel];
        [textTitleLabel setText:@"¥"];
        [textTitleLabel setFont:textTitleFont];
        [textTitleLabel setTextColor:textTitleColor];
        [textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(margin*1.0f);
            make.width.equalTo(@(15));
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        textTitleLabel.mas_key = @"textTitleLabel";
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setTag:80001];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setTextColor:textFieldColor];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"最低金额", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(textTitleLabel.mas_right);
            make.right.equalTo(view.mas_right).offset(-margin);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.minMoneyTextField = textField;
        self.minMoneyTextField.mas_key = @"minMoneyTextField";
        
        view;
    });
    minMoneyTextFieldView.mas_key = @"minMoneyTextFieldView";
    
    // 最高金额
    UIView *maxMoneyTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [publicContainerView addSubview:view];
        [view setBackgroundColor:textFieldContainerColor];
        [view addBorderWithColor:textFieldBorderColor cornerRadius:textFieldCornerRadius andWidth:1.0f];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.left.equalTo(publicContainerView.mas_centerX).offset(margin*1.5f);
            make.right.equalTo(publicContainerView.mas_right).offset(-left_right_gap);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        // 人民币¥
        UILabel *textTitleLabel = [UILabel new];
        [view addSubview:textTitleLabel];
        [textTitleLabel setText:@"¥"];
        [textTitleLabel setFont:textTitleFont];
        [textTitleLabel setTextColor:textTitleColor];
        [textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(margin*1.0f);
            make.width.equalTo(@(15));
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        textTitleLabel.mas_key = @"textTitleLabel";
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setTag:80002];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setTextColor:textFieldColor];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"最高金额", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(textTitleLabel.mas_right);
            make.right.equalTo(view.mas_right).offset(-margin);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.maxMoneyTextField = textField;
        self.maxMoneyTextField.mas_key = @"maxMoneyTextField";
        
        view;
    });
    maxMoneyTextFieldView.mas_key = @"maxMoneyTextFieldView";
    
    // 中间分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_HEXSTRING(@"#F5F5F5")];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.left.equalTo(minMoneyTextFieldView.mas_right).offset(margin*0.7f);
            make.right.equalTo(maxMoneyTextFieldView.mas_left).offset(-margin*0.7f);
            make.height.mas_equalTo(2.0f);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *characterSet;
    NSUInteger indexDotLocation = [textField.text rangeOfString:@"."].location;
    NSUInteger indexMinusLocation = [textField.text rangeOfString:@"-"].location;
    if (NSNotFound == indexMinusLocation && 0 == range.location) {
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"-0123456789\n"] invertedSet];
    } else {
        if (NSNotFound == indexDotLocation && 1 != range.location) {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
        } else {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
        }
    }
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请输入正确的金额！", nil))
        return NO;
    }
    if (NSNotFound != indexDotLocation && range.location > indexDotLocation + 2) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"金额最多2位小数点！", nil))
        return NO;
    }

    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self doChangeTextField:textField money:textString];

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self doChangeTextField:textField money:@""];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doChangeTextField:textField money:textField.text];
    [self doKeyBoardEndEditing];
    return YES;
}

- (void)doChangeTextField:(UITextField *)textField money:(NSString *)textString
{
     FYBillingSearchFilterModel *realModel = (FYBillingSearchFilterModel *)self.menuModel;
    
    if (80001 == textField.tag) { // 最低金额
        [realModel.items enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull filterModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([STR_BILLING_FILTER_TITLE_MONEY_MIN isEqualToString:filterModel.title]) {
                [filterModel setMinMoney:textString];
            }
        }];
    } else if (80002 == textField.tag) { // 最低金额
        [realModel.items enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull filterModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([STR_BILLING_FILTER_TITLE_MONEY_MAX isEqualToString:filterModel.title]) {
                [filterModel setMaxMoney:textString];
            }
        }];
    }
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
    
    // 标题
    [self.titleLabel setText:realModel.title];
    
    // 金额
    [realModel.items enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull filterModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *textFieldPlaceholderColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
        NSAttributedString *attrStrPlaceholder = [[NSAttributedString alloc] initWithString:filterModel.title attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }];
        if ([STR_BILLING_FILTER_TITLE_MONEY_MIN isEqualToString:filterModel.title]) {
            [self.minMoneyTextField setText:filterModel.minMoney];
            [self.minMoneyTextField setAttributedPlaceholder:attrStrPlaceholder];
        } else if ([STR_BILLING_FILTER_TITLE_MONEY_MAX isEqualToString:filterModel.title]) {
            [self.maxMoneyTextField setText:filterModel.maxMoney];
            [self.maxMoneyTextField setAttributedPlaceholder:attrStrPlaceholder];
        }
    }];
}


#pragma mark - 触发操作事件
- (void)pressRootContainerView:(UITapGestureRecognizer *)gesture
{
    [self doKeyBoardEndEditing];
}

- (void)doKeyBoardEndEditing
{
    [self endEditing:YES];
}


@end

    
