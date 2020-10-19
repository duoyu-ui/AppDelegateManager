//
//  FYMoneyRecordCollectionCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMoneyRecordCollectionCell.h"
#import "FYMoneyRecordModel.h"


@interface FYMoneyRecordCollectionCell ()
@property (nonnull, nonatomic, strong) UIView *rootContainerView;
@property (nonnull, nonatomic, strong) UIView *publicContainerView;
@property (nonnull, nonatomic, strong) UIImageView *iconImageView;
@property (nonnull, nonatomic, strong) UILabel *titleLabel;
@end


@implementation FYMoneyRecordCollectionCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma mark 创建子控件
- (void) createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
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
        [rootContainerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPublicItemView:)];
        [view addGestureRecognizer:tapGesture];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 图片控件
    UIImageView *iconImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.publicContainerView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        CGFloat imageSize = SCREEN_MIN_LENGTH * 0.5f * 0.35f * 0.62f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView);
            make.size.mas_equalTo(CGSizeMake(imageSize,imageSize));
            make.centerX.equalTo(publicContainerView.mas_right).multipliedBy(0.25f);
        }];
        
        imageView;
    });
    self.iconImageView = iconImageView;
    self.iconImageView.mas_key = [NSString stringWithFormat:@"iconImageView"];
    
    // 标题控件
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setNumberOfLines:1];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView);
            make.left.equalTo(iconImageView.mas_right).offset(margin*0.5f);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
}


#pragma mark - 设置数据模型
- (void)setModel:(FYMoneyRecordModel *)model
{
    if (![model isKindOfClass:[FYMoneyRecordModel class]]) {
        return;
    }
    
    _model = (FYMoneyRecordModel *)model;
    
    [self.titleLabel setText:model.title];
    [self.iconImageView setImage:[UIImage imageNamed:model.imageUrl]];
}


#pragma mark - 操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtMoneyRecordModel:indexPath:)]) {
        [self.delegate didSelectRowAtMoneyRecordModel:self.model indexPath:self.indexPath];
    }
}


@end





