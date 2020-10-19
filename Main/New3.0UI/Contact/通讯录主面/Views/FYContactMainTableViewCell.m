//
//  FYContactMainTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactMainTableViewCell.h"
#import "UIImage+GIFImage.h"
#import "FYContactsModel.h"

#define COLOR_CONTACT_CELL_TITLE             COLOR_HEXSTRING(@"#333333")
#define COLOR_CONTACT_CELL_ONLINE            COLOR_HEXSTRING(@"#15CD79")
#define COLOR_CONTACT_CELL_OFFLINE           COLOR_HEXSTRING(@"#8D8D8D")

CGFloat const TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_MAIN = 60.0f;

CGFloat const IMAGE_SIZE_FOR_CONTACT_MAIN = TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_MAIN * 0.68f;


@interface FYContactMainTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *badgeLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYContactMainTableViewCell

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
        CGFloat size = IMAGE_SIZE_FOR_CONTACT_MAIN;
        CGSize imageSize = CGSizeMake(size, size);
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
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
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_CONTACT_CELL_TITLE];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(avatarImageView.mas_centerY);
            make.left.equalTo(avatarImageView.mas_right).offset(margin*1.0f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
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

- (void)setModel:(FYContactsModel *)model
{
    if (![model isKindOfClass:[FYContactsModel class]]) {
        return;
    }
    
    _model = model;
    
    // 功能区
    if (FYContactsLocalTypeMyNewFriends == model.localType
        || FYContactsLocalTypeMyJoinGroups == model.localType) {
        [self.arrowImageView setHidden:NO];
        [self.avatarImageView addCornerRadius:0];
    } else {
        CGFloat size = IMAGE_SIZE_FOR_CONTACT_MAIN;
        [self.arrowImageView setHidden:YES];
        [self.avatarImageView addCornerRadius:size*0.2f];
    }
    
    if (self.model.isLocal) { // 本地
        [self.badgeLabel setHidden:YES];
        [self.titleLabel setText:self.model.nick];
        [self.avatarImageView setImage:[UIImage imageWithGIFNamed:self.model.avatar]];
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
        
        // 昵称
        {
            NSString *onLineStr = NSLocalizedString(@"(离线)", nil);
            NSString *title = VALIDATE_STRING_EMPTY(self.model.friendNick) ? self.model.nick : self.model.friendNick;
            UIFont *textFont = FONT_PINGFANG_REGULAR(16);
            UIFont *isOnLineFont = FONT_PINGFANG_REGULAR(15);
            NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                        NSForegroundColorAttributeName:COLOR_CONTACT_CELL_TITLE};
            NSDictionary *attrIsOnLine = @{ NSFontAttributeName:isOnLineFont,
                                            NSForegroundColorAttributeName:COLOR_CONTACT_CELL_OFFLINE};
            if (1 == self.model.status) {
                onLineStr = NSLocalizedString(@"(在线)", nil);
                attrIsOnLine = @{NSFontAttributeName:isOnLineFont,NSForegroundColorAttributeName:COLOR_CONTACT_CELL_ONLINE};
            }
            NSString *content = [NSString stringWithFormat:@"%@ ", title];
            NSArray<NSString *> *strArray = @[content, onLineStr];
            NSArray *attrArray = @[attrText, attrIsOnLine];
            NSAttributedString *attrString = [CFCSysUtil attributedString:strArray attributeArray:attrArray];
            [self.titleLabel setAttributedText:attrString];
        }
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


@end

