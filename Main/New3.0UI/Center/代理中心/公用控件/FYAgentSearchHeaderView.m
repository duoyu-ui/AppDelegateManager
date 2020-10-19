//
//  FYAgentSearchHeaderView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentSearchHeaderView.h"

CGFloat const kFyAgentReferralsHeaderSearchAreaHeight = 55.0; // 搜索区域

@interface FYAgentSearchHeaderView () <UITextFieldDelegate>
//
@property (nonatomic, strong) UIView *searchContainer;
@property (nonatomic, strong) UIView *searchTextContainer;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIView *searchButton;
//
@property (nonatomic, strong) UILabel *searchUserName;
@property (nonatomic, strong) UILabel *searchUserType;
@property (nonatomic, strong) UIImageView *searchUserPhoto;

@end


@implementation FYAgentSearchHeaderView

#pragma mark - Actions

/// 搜索
- (void)pressActionOfButtonSearch:(UITapGestureRecognizer *)gesture
{
    NSString *keyword = self.searchTextField.text;
    if (VALIDATE_STRING_EMPTY(keyword)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"搜索内容不能为空", nil))
        return;
    }
    
    // 键盘
    [self endEditing];
    
    // 搜索
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAgentHeaderSearchByKeyword:isSearch:)]) {
        [self.delegate didAgentHeaderSearchByKeyword:STR_TRI_WHITE_SPACE(keyword) isSearch:YES];
    }
}


#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return kFyAgentReferralsHeaderSearchAreaHeight;
}

- (instancetype)initWithFrame:(CGRect)frame searchMemberKey:(NSString *)searchMemberKey delegate:(id<FYAgentSearchHeaderViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        //
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    // 搜索区域
    [self addSubview:self.searchContainer];
    [self.searchContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kFyAgentReferralsHeaderSearchAreaHeight);
    }];
    
    [self createViewSearchAtuoLayout];
}

- (void)createViewSearchAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat imageSizeH = 34.0f;
    CGFloat imageSizeW = imageSizeH * 0.792452f;
    CGFloat searchTextHeight = 30.0f;
    CGFloat buttonSearchImageSize = searchTextHeight*0.5f;
    CGFloat buttonSearchWidth = searchTextHeight*0.5f + buttonSearchImageSize + margin*0.5f;
    
    // 图标
    UIImageView *searchUserPhoto = ({
        UIImageView *imageView = [UIImageView new];
        [self.searchContainer addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView setImage:[UIImage imageNamed:@"icon_agent_agent"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSearchUserPhotoView:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchContainer.mas_left).offset(margin);
            make.centerY.equalTo(self.searchContainer.mas_centerY);
            make.height.equalTo(@(imageSizeH));
            make.width.equalTo(@(imageSizeW));
        }];
        
        imageView;
    });
    self.searchUserPhoto = searchUserPhoto;
    self.searchUserPhoto.mas_key = @"searchUserPhoto";
    
    // 请输入会员ID
    UILabel *searchUserName = ({
        UILabel *label = [UILabel new];
        [self.searchContainer addSubview:label];
        [label setText:NSLocalizedString(@"请输入会员ID", nil)];
        [label setFont:FONT_PINGFANG_SEMI_BOLD(14)];
        [label setTextColor:COLOR_HEXSTRING(@"#FFFFFF")];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(searchUserPhoto.mas_centerY);
            make.left.equalTo(searchUserPhoto.mas_right).offset(margin);
        }];
        
        label;
    });
    self.searchUserName = searchUserName;
    self.searchUserName.mas_key = @"searchUserName";
    
    // 代理/会员
    UILabel *searchUserType = ({
        UILabel *label = [UILabel new];
        [self.searchContainer addSubview:label];
        [label setText:NSLocalizedString(@"代理/会员", nil)];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextColor:COLOR_HEXSTRING(@"#FAA9A9")];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(searchUserPhoto.mas_centerY);
            make.left.equalTo(searchUserPhoto.mas_right).offset(margin);
        }];
        
        label;
    });
    self.searchUserType = searchUserType;
    self.searchUserType.mas_key = @"searchUserType";
    
    // 搜索框
    [self.searchTextContainer addCornerRadius:searchTextHeight*0.5f];
    [self.searchContainer addSubview:self.searchTextContainer];
    [self.searchTextContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchContainer.mas_right).offset(-margin);
        make.left.equalTo(searchUserName.mas_right).offset(margin*2.0f);
        make.centerY.equalTo(searchUserPhoto.mas_centerY);
        make.height.mas_equalTo(searchTextHeight);
    }];
    
    // 搜索按钮
    {
        [self.searchTextContainer addSubview:self.searchButton];
        [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.searchTextContainer);
            make.width.mas_equalTo(buttonSearchWidth);
        }];
        
        UIImageView *buttonSearchImageView = ({
            UIImageView *imageView = [UIImageView new];
            [self.searchButton addSubview:imageView];
            [imageView setUserInteractionEnabled:YES];
            [imageView setImage:[UIImage imageNamed:@"icon_agent_seach"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.searchButton.mas_right).offset(-searchTextHeight*0.5f);
                make.centerY.equalTo(self.searchButton.mas_centerY);
                make.height.equalTo(@(buttonSearchImageSize));
                make.width.equalTo(@(buttonSearchImageSize));
            }];
            
            imageView;
        });
        buttonSearchImageView.mas_key = @"buttonSearchImageView";
    }
    
    // 搜索输入框
    [self.searchTextContainer addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTextContainer.mas_left).offset(searchTextHeight*0.5f);
        make.right.equalTo(self.searchButton.mas_left);
        make.top.bottom.equalTo(self.searchTextContainer);
    }];
}

- (void)endEditing
{
    [self endEditing:YES];
    [self.searchTextField resignFirstResponder];
}

- (void)doRefreshSearchKey:(NSString *)userId userName:(NSString *)username usertype:(NSNumber *)usertype headIcon:(NSString *)headIcon searchText:(NSString *)searchText
{
    // 搜索关键字
    [self.searchTextField setText:searchText];
    // 用户名称
    if (VALIDATE_STRING_EMPTY(username)) {
        [self.searchUserName setText:NSLocalizedString(@"请输入会员ID", nil)];
    } else {
        [self.searchUserName setText:username];
    }
    // 代理/会员
    if (54088 == usertype.integerValue) {
        [self.searchUserType setText:NSLocalizedString(@"代理/会员", nil)];
    } else {
        [self.searchUserType setText:(usertype.boolValue?NSLocalizedString(@"代理", nil):NSLocalizedString(@"会员", nil))];
    }
    
    // 用户头像
    CGFloat imageSize = 34.0f;
    if ([CFCSysUtil validateStringUrl:headIcon]) {
        [self.searchUserPhoto mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(imageSize));
        }];
        //
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:@"icon_agent_agent"];
        [self.searchUserPhoto sd_setImageWithURL:[NSURL URLWithString:headIcon] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!activityIndicator) {
                    [self.searchUserPhoto addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                    [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                    [activityIndicator setCenter:self.searchUserPhoto.center];
                    [activityIndicator startAnimating];
                    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.searchUserPhoto.mas_centerX);
                        make.centerY.equalTo(self.searchUserPhoto.mas_centerY);
                    }];
                }
            }];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    } else if (!VALIDATE_STRING_EMPTY(headIcon) && [UIImage imageNamed:headIcon]) {
        [self.searchUserPhoto mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(imageSize));
        }];
        [self.searchUserPhoto setImage:[UIImage imageNamed:headIcon]];
    } else {
        [self.searchUserPhoto mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(imageSize));
            make.width.equalTo(@(imageSize * 0.792452f));
        }];
        [self.searchUserPhoto setImage:[UIImage imageNamed:@"icon_agent_agent"]];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAgentHeaderSearchByKeyword:isSearch:)]) {
        [self.delegate didAgentHeaderSearchByKeyword:STR_TRI_WHITE_SPACE(textString) isSearch:NO];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAgentHeaderSearchByKeyword:isSearch:)]) {
        [self.delegate didAgentHeaderSearchByKeyword:@"" isSearch:NO];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self pressActionOfButtonSearch:nil];
    
    return YES;
}


#pragma mark - Getter & Setter

- (UIView *)searchContainer
{
    if (!_searchContainer) {
        _searchContainer = [[UIView alloc] init];
        [_searchContainer setBackgroundColor:COLOR_AGENT_HEADER_NAVBAR_BACKGROUND];
    }
    return _searchContainer;
}

- (UIView *)searchTextContainer
{
    if(!_searchTextContainer) {
        _searchTextContainer = [UIView new];
        [_searchTextContainer setBackgroundColor:[UIColor whiteColor]];
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
        [_searchTextField setFont:FONT_PINGFANG_SEMI_BOLD(14)];
        [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_searchTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        //
        UIColor *textFieldPlaceholderColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
        [_searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"搜索ID", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
    }
    return _searchTextField;
}

- (UIView *)searchButton
{
    if(!_searchButton) {
        _searchButton = [UIView new];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressActionOfButtonSearch:)];
        [_searchButton addGestureRecognizer:tapGesture];
    }
    return _searchButton;
}


#pragma mark - Private

- (void)pressSearchUserPhotoView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAgentHeaderSearchUserHeaderPicture)]) {
        [self.delegate didAgentHeaderSearchUserHeaderPicture];
    }
}


@end

