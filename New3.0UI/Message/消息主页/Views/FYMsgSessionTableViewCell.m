//
//  FYMsgSessionTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMsgSessionTableViewCell.h"
#import "UIImage+GIFImage.h"
#import "FYContactsModel.h"
#import "FYContacts.h"
#import "FYIMKitUtil.h"

#define COLOR_MSG_CELL_TITLE             COLOR_HEXSTRING(@"#333333")
#define COLOR_MSG_CELL_ONLINE            COLOR_HEXSTRING(@"#15CD79")
#define COLOR_MSG_CELL_OFFLINE           COLOR_HEXSTRING(@"#8D8D8D")

@interface FYMsgSessionTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *datetimeLabel;

@property (nonatomic, strong) UILabel *badgeLabel;

@property (nonatomic, strong) UILabel *classLabel;

@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYMsgSessionTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)height
{
    return 70.0f;
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
        CGFloat size = [[self class] height] * 0.68f;
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
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_MSG_CELL_TITLE];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(avatarImageView.mas_centerY);
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
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setFont:FONT_PINGFANG_LIGHT(14)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.25f);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-margin);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    // 日期
    UILabel *datetimeLabel = ({
        UIFont *font = FONT_PINGFANG_LIGHT(13);
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setFont:font];
        [label setNumberOfLines:1];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        
        CGFloat width = [@"8888-88-88" widthWithFont:font constrainedToHeight:CGFLOAT_MAX];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-margin*1.5f);
            make.width.mas_equalTo(width+margin);
        }];
        
        label;
    });
    self.datetimeLabel = datetimeLabel;
    self.datetimeLabel.mas_key = @"datetimeLabel";
    
    // 类别[官方]
    UILabel *classLabel = ({
        UIFont *font = FONT_PINGFANG_SEMI_BOLD(12);
        CGFloat width = [NSLocalizedString(@"官方", nil) widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*1.0f;
        CGFloat height = [NSLocalizedString(@"官方", nil) heightWithFont:font constrainedToWidth:CGFLOAT_MAX]+margin*0.3f;
        
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setFont:font];
        [label setHidden:YES];
        [label addCornerRadius:height*0.2f];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:COLOR_MSG_CELL_ONLINE];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(margin*0.5f);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        label;
    });
    self.classLabel = classLabel;
    self.classLabel.mas_key = @"classLabel";
    
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

- (void)setModel:(id)model
{
    if (!model) {
        return;
    }
    
    _model = model;
    
    if ([model isKindOfClass:[FYContacts class]]) { // 消息对话
        [self setFYContacts:model];
    } else if ([model isKindOfClass:[FYContactsModel class]]) { // 在线客服
        [self setFYContactsModel:model];
    } else {
        FYLog(NSLocalizedString(@"消息数据错误！", nil));
    }
}

- (void)setFYContacts:(FYContacts *)model
{
    FYContacts *realModel = (FYContacts *)model;
        
    // 头像
    if (VALIDATE_STRING_HTTP_URL(realModel.avatar)) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:realModel.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
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
    } else if ([UIImage imageNamed:realModel.avatar]) {
        [self.avatarImageView setImage:[UIImage imageNamed:realModel.avatar]];
    } else {
        [self.avatarImageView setImage:[UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER]];
    }
    
    // 昵称
    if (FYConversationType_PRIVATE == realModel.sessionType) {
        NSString *onLineStr = NSLocalizedString(@"(离线)", nil);
        NSString *title = realModel.friendNick;
        UIFont *textFont = FONT_PINGFANG_REGULAR(16);
        UIFont *isOnLineFont = FONT_PINGFANG_REGULAR(15);
        NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                    NSForegroundColorAttributeName:COLOR_MSG_CELL_TITLE};
        NSDictionary *attrIsOnLine = @{NSFontAttributeName:isOnLineFont,
                                       NSForegroundColorAttributeName:COLOR_MSG_CELL_OFFLINE};
        if (1 == realModel.status) {
            onLineStr = NSLocalizedString(@"(在线)", nil);
            attrIsOnLine = @{NSFontAttributeName:isOnLineFont,
                             NSForegroundColorAttributeName:COLOR_MSG_CELL_ONLINE};
        }
        NSString *content = [NSString stringWithFormat:@"%@ ", title];
        NSArray<NSString *> *strArray = @[content, onLineStr];
        NSArray *attrArray = @[attrText, attrIsOnLine];
        NSAttributedString *attrString = [CFCSysUtil attributedString:strArray attributeArray:attrArray];
        [self.titleLabel setAttributedText:attrString];
    } else {
        if (VALIDATE_STRING_EMPTY(realModel.friendNick)) {
            [self.titleLabel setText:@"-"];
        } else {
            [self.titleLabel setText:STR_TRI_WHITE_SPACE(realModel.friendNick)];
        }
    }
    
    // 消息
    NSString *messageId = VALIDATE_STRING_EMPTY(realModel.lastMessageId) ? @"" : realModel.lastMessageId;
    FYMessage *message = [[IMMessageModule sharedInstance] getMessageWithMessageId:messageId];
    if (message.isDeleted | message.isRecallMessage) {
        [self.contentLabel setText:NSLocalizedString(@"暂未收到消息", nil)];
        [realModel setLastTimestamp:0];
    } else {
        NSString *lastMessage = VALIDATE_STRING_EMPTY(realModel.lastMessage) ? NSLocalizedString(@"还没收到消息", nil) : STR_TRI_WHITE_SPACE(realModel.lastMessage);
        if ([lastMessage containsString:@"null"]) {
            lastMessage = [lastMessage stringByReplacingOccurrencesOfString:@"(null)：" withString:@""];
        }
        [self.contentLabel setText:lastMessage];
    }
    
    // 时间
    if (0 == realModel.lastTimestamp) {
        [self.datetimeLabel setText:@""];
    } else {
        NSString *datetime = [FYIMKitUtil showTime:realModel.lastTimestamp/1000 showDetail:NO];
        [self.datetimeLabel setText:datetime];
    }
    
    // 标角
    if (realModel.unReadMsgCount > 0) {
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        UIFont *font = FONT_PINGFANG_LIGHT(12);
        CGFloat width = [@"99" widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.3f;
        CGFloat height = 18.0f;
        CGFloat size = (width > height ? width : height);
        if (realModel.unReadMsgCount > 99) {
            CGFloat width = [@"99+" widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.5f;
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            [self.badgeLabel setText:@"99+"];
        } else {
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size, height));
            }];
            [self.badgeLabel setText:[NSString stringWithFormat:@"%ld", realModel.unReadMsgCount]];
        }
        [self.badgeLabel setHidden:NO];
    } else {
        [self.badgeLabel setHidden:YES];
    }
    
    // 官方
    if (1 == realModel.messageType) {
        [self.classLabel setHidden:NO];
        [self.classLabel setText:NSLocalizedString(@"官方", nil)];
    } else if (2 == realModel.messageType) {
        [self.classLabel setHidden:NO];
        [self.classLabel setText:NSLocalizedString(@"自建", nil)];
    } else {
        [self.classLabel setHidden:YES];
    }
}

- (void)setFYContactsModel:(FYContactsModel *)model
{
    FYContactsModel *realModel = (FYContactsModel *)model;
    //
    [self.badgeLabel setHidden:YES];
    [self.classLabel setHidden:YES];
    //
    if (realModel.isLocal) { // 本地
        if (FYContactsLocalTypeServices == realModel.localType) { // 在线客服
            [self.titleLabel setText:realModel.nick];
            [self.contentLabel setText:realModel.personalSignature];
            [self.avatarImageView setImage:[UIImage imageWithGIFNamed:realModel.avatar]];
        } else if (FYContactsLocalTypeSystemMessage == realModel.localType) { // 系统消息
            // 昵称
            {
                UIFont *textFont = FONT_PINGFANG_REGULAR(16);
                NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                            NSForegroundColorAttributeName:COLOR_MSG_CELL_TITLE};
                NSString *content = [NSString stringWithFormat:@"%@ ", realModel.nick];
                NSArray<NSString *> *strArray = @[content];
                NSArray *attrArray = @[attrText];
                NSAttributedString *attrString = [CFCSysUtil attributedString:strArray attributeArray:attrArray];
                [self.titleLabel setAttributedText:attrString];
            }
            
            // 时间
            NSTimeInterval lastTimestamp = [self getSessionLastTimestamp:realModel];
            if (0 == lastTimestamp) {
                [self.datetimeLabel setText:@""];
            } else {
                NSString *datetime = [FYIMKitUtil showTime:lastTimestamp showDetail:NO];
                [self.datetimeLabel setText:datetime];
            }
            
            // 消息 - 角标 - 头像
            [self setFYContactsModelOfSession:model];
        }
    } else { // 远程
        // 昵称
        {
            NSString *onLineStr = NSLocalizedString(@"(离线)", nil);
            UIFont *textFont = FONT_PINGFANG_REGULAR(16);
            UIFont *isOnLineFont = FONT_PINGFANG_REGULAR(15);
            NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                        NSForegroundColorAttributeName:COLOR_MSG_CELL_TITLE};
            NSDictionary *attrIsOnLine = @{ NSFontAttributeName:isOnLineFont,
                                            NSForegroundColorAttributeName:COLOR_MSG_CELL_OFFLINE};
            if (1 == realModel.status) {
                onLineStr = NSLocalizedString(@"(在线)", nil);
                attrIsOnLine = @{NSFontAttributeName:isOnLineFont,NSForegroundColorAttributeName:COLOR_MSG_CELL_ONLINE};
            }
            NSString *content = [NSString stringWithFormat:@"%@ ", realModel.nick];
            NSArray<NSString *> *strArray = @[content, onLineStr];
            NSArray *attrArray = @[attrText, attrIsOnLine];
            NSAttributedString *attrString = [CFCSysUtil attributedString:strArray attributeArray:attrArray];
            [self.titleLabel setAttributedText:attrString];
        }
        
        // 时间
        NSTimeInterval lastTimestamp = [self getSessionLastTimestamp:realModel];
        if (0 == lastTimestamp) {
            [self.datetimeLabel setText:@""];
        } else {
            NSString *datetime = [FYIMKitUtil showTime:lastTimestamp/1000 showDetail:NO];
            [self.datetimeLabel setText:datetime];
        }
        
        // 消息 - 角标 - 头像
        [self setFYContactsModelOfSession:model];
    }
}

- (void)setFYContactsModelOfSession:(FYContactsModel *)model
{
    FYContactsModel *realModel = (FYContactsModel *)self.model;
    
    // 消息
    [self.contentLabel setText:[self getSessionLastMessage:realModel]];
    
    // 标角
    NSInteger unReadMsgCount = [self getSessionUnReadCount:model];
    if (unReadMsgCount > 0) {
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        UIFont *font = FONT_PINGFANG_LIGHT(12);
        CGFloat width = [@"99" widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.3f;
        CGFloat height = 18.0f;
        CGFloat size = (width > height ? width : height);
        if (unReadMsgCount > 99) {
            CGFloat width = [@"99+" widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.5f;
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            [self.badgeLabel setText:@"99+"];
        } else {
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size, height));
            }];
            [self.badgeLabel setText:[NSString stringWithFormat:@"%ld", unReadMsgCount]];
        }
        [self.badgeLabel setHidden:NO];
    } else {
        [self.badgeLabel setHidden:YES];
    }
    
    // 头像
    if (VALIDATE_STRING_HTTP_URL(realModel.avatar)) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:realModel.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
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
    } else if ([UIImage imageNamed:realModel.avatar]) {
        [self.avatarImageView setImage:[UIImage imageNamed:realModel.avatar]];
    } else {
        [self.avatarImageView setImage:[UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER]];
    }
}

- (NSInteger)getSessionUnReadCount:(FYContactsModel *)realModel
{
    FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:realModel.chatId];
    return session.unReadMsgCount;
}

- (NSString *)getSessionLastMessage:(FYContactsModel *)realModel
{
    FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:realModel.chatId];
    if (!VALIDATE_STRING_EMPTY(session.lastMessage)) {
        return session.lastMessage;
    }
    return VALIDATE_STRING_EMPTY(realModel.personalSignature) ? NSLocalizedString(@"暂未收到消息", nil) : realModel.personalSignature;
}

- (NSTimeInterval)getSessionLastTimestamp:(FYContactsModel *)realModel
{
    FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:realModel.chatId];
    return session.lastTimestamp;
}


@end

