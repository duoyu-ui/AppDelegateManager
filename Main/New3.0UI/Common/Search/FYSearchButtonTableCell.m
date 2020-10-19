//
//  FYSearchButtonTableCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYSearchButtonTableCell.h"
#import "FYSearchButtonModel.h"


@interface FYSearchButtonTableCell ()

@property (nonatomic, strong) UIImageView *searchImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation FYSearchButtonTableCell

+ (CGFloat)heightOfSearchButton
{
    return 50.0f;
}

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
    UIImageView *searchImageView = ({
        CGFloat size = [FYSearchButtonTableCell heightOfSearchButton] * 0.68f;
        CGSize imageSize = CGSizeMake(size, size);
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView addCornerRadius:size*0.2f];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:@"AddGroupSearch_icon"] imageByScalingProportionallyToSize:imageSize]];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(margin*1.5f);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.searchImageView = searchImageView;
    self.searchImageView.mas_key = @"searchImageView";
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setNumberOfLines:1];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(searchImageView.mas_centerY);
            make.left.equalTo(searchImageView.mas_right).offset(margin*1.0f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
}

- (void)setModel:(FYSearchButtonModel *)model
{
    if (![model isKindOfClass:[FYSearchButtonModel class]]) {
        return;
    }
    
    _model = model;
    
    // 搜索图标
    if ([UIImage imageNamed:self.model.imageUrl]) {
        [self.searchImageView setImage:[UIImage imageNamed:self.model.imageUrl]];
    }
    
    // 搜索内容
    NSDictionary *attrText = @{ NSFontAttributeName:FONT_PINGFANG_SEMI_BOLD(16),
                                NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
    NSDictionary *attrSearch = @{ NSFontAttributeName:FONT_PINGFANG_SEMI_BOLD(16),
                                  NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
    NSString *content = VALIDATE_STRING_EMPTY(self.model.content) ? @"" : self.model.content;
    NSArray *stringArray = @[ NSLocalizedString(@"搜索：", nil), content ];
    NSArray *attributeArray = @[attrText, attrSearch];
    NSAttributedString *attrString = [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    [self.titleLabel setAttributedText:attrString];
}

@end

