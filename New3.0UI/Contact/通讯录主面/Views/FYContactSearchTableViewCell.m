//
//  FYContactSearchTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactSearchTableViewCell.h"
#import "UIImage+GIFImage.h"
#import "FYContactsModel.h"
#import "FYContactSearchModel.h"

#define COLOR_CONTACT_SEARCH_REST_TITLE             COLOR_HEXSTRING(@"#FDAA00")
#define COLOR_CONTACT_SEARCH_CELL_TITLE             COLOR_HEXSTRING(@"#333333")
#define COLOR_CONTACT_SEARCH_CELL_ONLINE            COLOR_HEXSTRING(@"#15CD79")
#define COLOR_CONTACT_SEARCH_CELL_OFFLINE           COLOR_HEXSTRING(@"#8D8D8D")

CGFloat const TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_SEARCH = 60.0f;

CGFloat const IMAGE_SIZE_FOR_CONTACT_SEARCH = TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_SEARCH * 0.68f;


@interface FYContactSearchTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *badgeLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYContactSearchTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
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
    UIImageView *avatarImageView = ({
        CGFloat size = IMAGE_SIZE_FOR_CONTACT_SEARCH;
        CGSize imageSize = CGSizeMake(size, size);
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView addCornerRadius:size*0.2f];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:@"msg3"] imageByScalingProportionallyToSize:imageSize]];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(margin*1.5f);
            make.size.mas_equalTo(imageSize);
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
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_CONTACT_SEARCH_CELL_TITLE];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(avatarImageView.mas_centerY);
            make.left.equalTo(avatarImageView.mas_right).offset(margin*1.0f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    // 内容
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setNumberOfLines:1];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setFont:FONT_PINGFANG_LIGHT(14)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.20f);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-margin);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    // 角标
    UILabel *badgeLabel = ({
        UIFont *font = FONT_PINGFANG_LIGHT(12);
        CGFloat width = [@"99" widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.3f;
        CGFloat height = 18.0f;
        CGFloat size = (width > height ? width : height);
        
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setFont:font];
        [label setHidden:YES];
        [label addCornerRadius:height*0.5f];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(avatarImageView.mas_right).offset(-margin*0.2);
            make.centerY.equalTo(avatarImageView.mas_top).offset(margin*0.2);
            make.size.mas_equalTo(CGSizeMake(size, height));
        }];
        
        label;
    });
    self.badgeLabel = badgeLabel;
    self.badgeLabel.mas_key = @"badgeLabel";
    
    // 箭头控件
    UIImageView *arrowImageView = ({
        CGSize imageSize = CGSizeMake(CFC_AUTOSIZING_WIDTH(25.0f), CFC_AUTOSIZING_WIDTH(25.0f));
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView.layer setMasksToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:ICON_TABLEVIEW_CELL_ARROW] imageByScalingProportionallyToSize:imageSize]];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-margin*1.5f);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.arrowImageView = arrowImageView;
    self.arrowImageView.mas_key = @"arrowImageView";
    
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

- (void)setContactsModel:(FYContactsModel *)model searchResModel:(FYContactSearchModel *)searchResModel
{
    if (![model isKindOfClass:[FYContactsModel class]]) {
        return;
    }
    
    _model = model;
    _searchResModel = searchResModel;
    
    // 功能区
    if (FYContactsLocalTypeMyNewFriends == model.localType
        || FYContactsLocalTypeMyJoinGroups == model.localType) {
        [self.arrowImageView setHidden:NO];
        [self.avatarImageView addCornerRadius:0];
    } else {
        CGFloat size = IMAGE_SIZE_FOR_CONTACT_SEARCH;
        [self.arrowImageView setHidden:YES];
        [self.avatarImageView addCornerRadius:size*0.2f];
    }
    
    if (self.model.isLocal) { // 本地
        [self.badgeLabel setHidden:YES];
        [self.avatarImageView setImage:[UIImage imageWithGIFNamed:self.model.avatar]];
        {
            NSMutableAttributedString *attstr = [self setSearchResLabel:model.nick keyword:self.searchResModel.searchKey color:COLOR_CONTACT_SEARCH_REST_TITLE];
            [self.titleLabel setAttributedText:attstr];
        }
    } else { // 远程
        // 隐藏
        [self.badgeLabel setHidden:YES];
        
        // 头像
        if (VALIDATE_STRING_HTTP_URL(self.model.avatar)) {
            __block UIActivityIndicatorView *activityIndicator = nil;
            UIImage *placeholderImage = [UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (!activityIndicator) {
                        [self.contentView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                        [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                        [activityIndicator setCenter:self.avatarImageView.center];
                        [activityIndicator startAnimating];
                        [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(self.avatarImageView.mas_centerX);
                            make.centerY.equalTo(self.avatarImageView.mas_centerY);
                        }];
                    }
                }];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
            }];
        } else {
            [self.avatarImageView setImage:[UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER]];
        }
        
        // 备注 或 昵称
        {
            NSString *onLineStr = NSLocalizedString(@"(离线)", nil);
            NSString *title = VALIDATE_STRING_EMPTY(self.model.friendNick) ? self.model.nick : self.model.friendNick;
            UIFont *textFont = FONT_PINGFANG_REGULAR(16);
            UIFont *isOnLineFont = FONT_PINGFANG_REGULAR(15);
            NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                        NSForegroundColorAttributeName:COLOR_CONTACT_SEARCH_CELL_TITLE};
            NSDictionary *attrIsOnLine = @{ NSFontAttributeName:isOnLineFont,
                                            NSForegroundColorAttributeName:COLOR_CONTACT_SEARCH_CELL_OFFLINE};
            if (1 == self.model.status) {
                onLineStr = NSLocalizedString(@"(在线)", nil);
                attrIsOnLine = @{NSFontAttributeName:isOnLineFont,NSForegroundColorAttributeName:COLOR_CONTACT_SEARCH_CELL_ONLINE};
            }
            // 查找内容
            {
                NSString *titleSearch = [NSString stringWithFormat:@"%@ %@", title, onLineStr];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleSearch];
                [attrString addAttributes:attrText range:NSMakeRange(0, titleSearch.length)];
                //
                NSArray<NSValue *> *allResLocations = [CFCSysUtil getAllRangesOfString:titleSearch matchingSubstring:self.searchResModel.searchKey];
                for (int i = 0; i < allResLocations.count; i++) {
                    NSValue *value = [allResLocations objectWithIndex:i];
                    NSRange match;
                    [value getValue:&match];
                    [attrString addAttribute:NSForegroundColorAttributeName
                                       value:COLOR_CONTACT_SEARCH_REST_TITLE
                                       range:match];
                }
                //
                NSArray<NSValue *> *allLineLocations = [CFCSysUtil getAllRangesOfString:titleSearch matchingSubstring:onLineStr];
                for (int i = 0; i < allLineLocations.count; i++) {
                    NSValue *value = [allLineLocations objectWithIndex:i];
                    NSRange match;
                    [value getValue:&match];
                    [attrString addAttributes:attrIsOnLine range:match];
                }
                [self.titleLabel setAttributedText:attrString];
            }
        }
    }
    
    // 昵称
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    [self.contentLabel setHidden:!self.searchResModel.isShowNick];
    if (self.searchResModel.isShowNick) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.avatarImageView.mas_centerY);
            make.left.equalTo(self.avatarImageView.mas_right).offset(margin*1.0f);
        }];
        {
            NSDictionary *attrText = @{ NSFontAttributeName:FONT_PINGFANG_LIGHT(14),
                                        NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT};
            NSString *titlePrefix = NSLocalizedString(@"昵称:", nil);
            NSString *titleSearch = [NSString stringWithFormat:@"%@%@", titlePrefix, STR_TRI_WHITE_SPACE(self.model.nick)];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleSearch];
            [attrString addAttributes:attrText range:NSMakeRange(0, titleSearch.length)];
            //
            NSArray<NSValue *> *allResLocations = [CFCSysUtil getAllRangesOfString:titleSearch matchingSubstring:self.searchResModel.searchKey];
            for (int i = 0; i < allResLocations.count; i++) {
                NSValue *value = [allResLocations objectWithIndex:i];
                NSRange match;
                [value getValue:&match];
                [attrString addAttribute:NSForegroundColorAttributeName
                                   value:COLOR_CONTACT_SEARCH_REST_TITLE
                                   range:match];
            }
            //
            NSArray<NSValue *> *allLineLocations = [CFCSysUtil getAllRangesOfString:titleSearch matchingSubstring:titlePrefix];
            for (int i = 0; i < allLineLocations.count; i++) {
                NSValue *value = [allLineLocations objectWithIndex:i];
                NSRange match;
                [value getValue:&match];
                [attrString addAttributes:attrText range:match];
            }
            [self.contentLabel setAttributedText:attrString];
        }
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarImageView.mas_centerY);
            make.left.equalTo(self.avatarImageView.mas_right).offset(margin*1.0f);
        }];
        [self.contentLabel setText:@""];
    }
}

- (void)setBadge:(NSInteger)badge
{
    if (badge > 0) {
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        UIFont *font = FONT_PINGFANG_LIGHT(12);
        CGFloat width = [@"99" widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.3f;
        CGFloat height = 18.0f;
        CGFloat size = (width > height ? width : height);
        if (badge > 99) {
            CGFloat width = [@"99+" widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.5f;
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            [self.badgeLabel setText:@"99+"];
        } else {
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size, height));
            }];
            [self.badgeLabel setText:[NSString stringWithFormat:@"%ld", badge]];
        }
        [self.badgeLabel setHidden:NO];
    } else {
        [self.badgeLabel setHidden:YES];
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

