//
//  FYActivityTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYActivityTableViewCell.h"
#import "FYActivityModel.h"

// Cell Identifier
NSString * const CELL_IDENTIFIER_ACTIVITY_TABLEVIEW_CELL = @"FYActivityTableViewCellIdentifier";

@interface FYActivityTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 标题控件
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 内容控件
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 * 图片控件
 */
@property (nonatomic, strong) UIImageView *contentImageView;

@end


@implementation FYActivityTableViewCell

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
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [self.contentView insertSubview:view atIndex:0];
        
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPublicItemView:)];
        [view addGestureRecognizer:tapGesture];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left).offset(margin);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right).offset(-margin);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 标题控件
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setNumberOfLines:1];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(13)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin);
            make.left.equalTo(publicContainerView.mas_left).offset(margin);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";

    // 图标控件
    UIImageView *contentImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin);
            make.left.equalTo(publicContainerView.mas_left).offset(margin);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin);
            make.height.mas_equalTo(CFC_AUTOSIZING_WIDTH(120.0f));
        }];
        
        imageView;
    });
    self.contentImageView = contentImageView;
    self.contentImageView.mas_key = @"contentImageView";
        
    // 内容控件
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setNumberOfLines:1];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(12)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentImageView.mas_bottom).offset(margin);
            make.left.equalTo(publicContainerView.mas_left).offset(margin);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(margin);
            make.left.right.equalTo(publicContainerView);
            make.height.mas_equalTo(margin);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYActivityModel *)model
{
    if (![model isKindOfClass:[FYActivityModel class]]) {
        return;
    }
    
    _model = model;

    // 标题
    [self.titleLabel setText:model.mainTitle];
    
    // 时间
    {
        NSString *dateString = [NSString stringWithFormat:NSLocalizedString(@"活动时间：%@ ~ %@", nil), model.beginDate, model.endDate];
        [self.contentLabel setText:dateString];
    }
        
    // 图片
    if ([CFCSysUtil validateStringUrl:model.img]) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:@"icon_loading_1010_260"];
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!activityIndicator) {
                    [self.contentView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                    [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                    [activityIndicator startAnimating];
                    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.contentView.mas_centerX);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                }
            }];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    } else {
        UIImage *placeholderImage = [UIImage imageNamed:@"icon_loading_1010_260"];
        [self.contentImageView setImage:placeholderImage];
    }
}

#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtActivityModel:)]) {
        [self.delegate didSelectRowAtActivityModel:self.model];
    }
}


@end

