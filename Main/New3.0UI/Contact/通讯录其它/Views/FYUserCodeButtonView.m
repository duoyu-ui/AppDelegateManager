//
//  FYUserCodeButtonView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYUserCodeButtonView.h"

@interface FYUserCodeButtonView ()
@property (nonatomic, strong) UIButton *userQRCodeButton;
@end

@implementation FYUserCodeButtonView

#pragma mark - Actions

- (void)pressButtonActionOfUserCode:(id)sender
{
    if (self.doUserCodeActionBlock) {
        self.doUserCodeActionBlock();
    }
}


#pragma mark - Height

+ (CGFloat)heightOfUserCodeView
{
    return [[self class] heightOfUserCodeViewButton] + [[self class] heightOfUserCodeViewSpline];
}

+ (CGFloat)heightOfUserCodeViewButton
{
    return 60.0;
}

+ (CGFloat)heightOfUserCodeViewSpline
{
    return 0.6f; // 间隔
}


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame username:APPINFORMATION.userInfo.nick];
    if (self) {
        [self createViewAtuoLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame username:(NSString *)username
{
    self = [super initWithFrame:frame];
    if (self) {
        _username = username;
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    [self viewDidAddTitleView];
    [self viewDidAddBottomLineView];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAddTitleView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    UIFont *titleFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)];
    CGFloat containerHeight = [[self class] heightOfUserCodeViewButton];
    CGFloat imageSize = 20;
    CGFloat imageTitleMargin = margin*0.5f;
    CGFloat titleStringWidth = [self.username widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX];
    CGFloat totalWidth = imageSize + imageTitleMargin + titleStringWidth;
    
    // 容器
    [self addSubview:self.userQRCodeButton];
    [self.userQRCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(containerHeight);
    }];
    
    // 图片
    UIImageView *iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.userQRCodeButton addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_myqr"]];
        
        CGFloat offset = totalWidth*0.5f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.userQRCodeButton.mas_centerX).offset(offset);
            make.centerY.equalTo(self.userQRCodeButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    iconImageView.mas_key = @"iconImageView";
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *titleLabel = [UILabel new];
        [self.userQRCodeButton addSubview:titleLabel];
        [titleLabel setText:self.username];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(iconImageView.mas_left).offset(-imageTitleMargin);
            make.centerY.equalTo(self.userQRCodeButton.mas_centerY);
        }];
        
        titleLabel;
    });
    titleLabel.mas_key = @"titleLabel";
}

- (void)viewDidAddBottomLineView
{
    CGFloat lineHeight = [[self class] heightOfUserCodeViewSpline];
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(lineHeight);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
}


#pragma mark - Getter/Setter

- (UIButton *)userQRCodeButton
{
    if(!_userQRCodeButton)
    {
        _userQRCodeButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_userQRCodeButton setBackgroundColor:[UIColor whiteColor]];
        [_userQRCodeButton addTarget:self action:@selector(pressButtonActionOfUserCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userQRCodeButton;
}


@end

