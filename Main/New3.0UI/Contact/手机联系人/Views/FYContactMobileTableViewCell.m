//
//  FYContactMobileTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactMobileTableViewCell.h"
#import "FYContactMobileSearchModel.h"
#import "FYMobilePerson.h"

#define COLOR_CONTACT_MOBILE_SEARCH_REST    COLOR_HEXSTRING(@"#FDAA00")

@interface FYContactMobileTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *telephoneLabel;

@property (nonatomic, strong) UILabel *buttonLabel;

@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYContactMobileTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)height
{
    return CFC_AUTOSIZING_WIDTH(70.0f);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);

    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    // 头像
    CGFloat imageSize = [FYContactMobileTableViewCell height] * 0.68f;
    UIImageView *avatarImageView = ({
        CGSize size = CGSizeMake(imageSize, imageSize);
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:@"icon_mobile_contact_empty"] imageByScalingProportionallyToSize:size]];
        [imageView addCornerRadius:imageSize*0.2f];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(margin*1.5f);
            make.size.mas_equalTo(size);
        }];
        
        imageView;
    });
    self.avatarImageView = avatarImageView;
    self.avatarImageView.mas_key = @"avatarImageView";
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setNumberOfLines:1];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(avatarImageView.mas_centerY);
            make.left.equalTo(avatarImageView.mas_right).offset(margin*1.0f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    // 手机
    UILabel *telephoneLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setNumberOfLines:1];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setFont:FONT_PINGFANG_REGULAR(14)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.25f);
            make.left.equalTo(avatarImageView.mas_right).offset(margin*1.0f);
        }];
        
        label;
    });
    self.telephoneLabel = telephoneLabel;
    self.telephoneLabel.mas_key = @"telephoneLabel";
    
    // 邀请
    UILabel *buttonLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:NSLocalizedString(@"邀请", nil)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:FONT_PINGFANG_REGULAR(15)];
        [label setBackgroundColor:COLOR_HEXSTRING(@"#72BA72")];
    
        CGFloat height = imageSize * 0.6f;
        [label addCornerRadius:height*0.1f];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarImageView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-margin*3.0f);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(height*2.0f);
        }];
        
        label;
    });
    self.buttonLabel = buttonLabel;
    self.buttonLabel.mas_key = @"buttonLabel";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        CGFloat height = SEPARATOR_LINE_HEIGHT;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.titleLabel.mas_left).offset(-margin*0.1f);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(height);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
}

- (void)setModel:(FYMobilePerson *)model searchResModel:(FYContactMobileSearchModel *)searchResModel isSearch:(BOOL)isSearch
{
    if (![model isKindOfClass:[FYMobilePerson class]]) {
        return;
    }
    
    _model = model;
    _searchResModel = searchResModel;
    
    // 头像
    if (model.image) {
        [self.avatarImageView setImage:model.image];
    } else {
        [self.avatarImageView setImage:[UIImage imageNamed:@"icon_mobile_contact_empty"]];
    }
    
    // 名称 + 手机
    if (!isSearch) {
        // 名称
        [self.titleLabel setText:model.fullName];
        
        // 手机
        FYPhone *phone = model.phones.firstObject;
        NSString *telephone = [NSString stringWithFormat:NSLocalizedString(@"手机号：%@", nil), phone.phone];
        [self.telephoneLabel setText:telephone];
    } else {
        // 名称
        NSMutableAttributedString *attstrOfTitle = [self setSearchResLabel:model.fullName keyword:self.searchResModel.searchKey color:COLOR_CONTACT_MOBILE_SEARCH_REST];
        [self.titleLabel setAttributedText:attstrOfTitle];
        
        // 手机
        FYPhone *phone = model.phones.firstObject;
        NSString *telephone = [NSString stringWithFormat:NSLocalizedString(@"手机号：%@", nil), phone.phone];
        NSMutableAttributedString *attstrOfPhone = [self setSearchResLabel:telephone keyword:self.searchResModel.searchKey color:COLOR_CONTACT_MOBILE_SEARCH_REST];
        [self.telephoneLabel setAttributedText:attstrOfPhone];
    }
}

/**
 * 改变UILabel部分字符颜色
 */
- (NSMutableAttributedString *)setSearchResLabel:(NSString *)message keyword:(NSString *)keyword color:(UIColor *)color
{
    NSArray<NSValue *> *allLocations = [CFCSysUtil getAllRangesOfString:message matchingSubstring:keyword];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:message];
    for (int i = 0; i < allLocations.count; i++) {
        NSValue *value = [allLocations objectWithIndex:i];
        NSRange match;
        [value getValue:&match];
        [attstr addAttribute:NSForegroundColorAttributeName value:color range:match];
    }
    return attstr;
}


@end

