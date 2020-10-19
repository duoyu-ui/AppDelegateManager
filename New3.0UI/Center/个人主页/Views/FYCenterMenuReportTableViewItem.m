//
//  FYCenterMenuReportTableViewItem.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMenuReportTableViewItem.h"
#import "FYCenterMenuSectionModel.h"

@interface FYCenterMenuReportTableViewItem ()
//
@property (nonatomic, strong) FYCenterMenuReportModel *menuReportModel;
@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabelArray;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pictureImageArray;

@end

@implementation FYCenterMenuReportTableViewItem

#pragma mark - Life Cycle

- (instancetype)initWithTabMenuReportModel:(FYCenterMenuReportModel *)menuReportModel
{
    self = [super init];
    if (self) {
        self.hasTableViewRefresh = NO;
        _menuReportModel = menuReportModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.menuReportModel.childList.count > 0) {
        
        int colum = 4;
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat left_right_gap = margin * 0.0f;
        CGFloat itemWidth = (SCREEN_WIDTH - left_right_gap*2.0f -margin*2.0f) /colum;
        CGFloat itemHeight = itemWidth * 0.85f;
        CGFloat imageSize = itemWidth * 0.25;
        
        _titleLabelArray = [NSMutableArray array];
        _pictureImageArray = [NSMutableArray array];
        
        UIView *lastItemView = nil;
        for (int i = 0; i < self.menuReportModel.childList.count; i ++) {
            
            // 容器
            UIView *itemView = ({
                UIView *itemContainerView = [[UIView alloc] init];
                [itemContainerView setTag:8000+i];
                [self.view addSubview:itemContainerView];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressItemView:)];
                [itemContainerView addGestureRecognizer:tapGesture];
                [itemContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(itemWidth));
                    make.height.equalTo(@(itemHeight));
                    
                    if (!lastItemView) {
                        make.top.equalTo(self.view.mas_top);
                        make.left.equalTo(self.view.mas_left).offset(left_right_gap);
                    } else {
                        if (i % colum == 0) {
                            make.top.equalTo(lastItemView.mas_bottom);
                            make.left.equalTo(self.view.mas_left).offset(left_right_gap);
                        } else {
                            make.top.equalTo(lastItemView.mas_top);
                            make.left.equalTo(lastItemView.mas_right);
                        }
                    }
                }];
                itemContainerView.mas_key = [NSString stringWithFormat:@"itemContainerView%d",i];
                
                // 图片
                UIImageView *iconImageView = ({
                    UIImageView *imageView = [UIImageView new];
                    [itemContainerView addSubview:imageView];
                    [imageView setUserInteractionEnabled:YES];
                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(itemContainerView.mas_centerX);
                        make.centerY.equalTo(itemContainerView.mas_bottom).multipliedBy(0.4f);
                        make.height.equalTo(@(imageSize));
                        make.width.equalTo(@(imageSize));
                    }];
                    
                    imageView;
                });
                iconImageView.mas_key = [NSString stringWithFormat:@"iconImageView%d",i];
                
                // 标题
                UILabel *titleLabel = ({
                    UILabel *label = [UILabel new];
                    [itemContainerView addSubview:label];
                    [label setText:STR_APP_TEXT_PLACEHOLDER];
                    [label setFont:FONT_PINGFANG_REGULAR(14)];
                    [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(itemContainerView.mas_left).offset(margin*0.5f);
                        make.right.equalTo(itemContainerView.mas_right).offset(-margin*0.5f);
                        make.top.equalTo(iconImageView.mas_bottom).offset(margin*0.5f);
                    }];
                    
                    label;
                });
                titleLabel.mas_key = [NSString stringWithFormat:@"titleLabel%d",i];
                
                //
                [_titleLabelArray addObject:titleLabel];
                [_pictureImageArray addObject:iconImageView];
                
                itemContainerView;
            });
            
            lastItemView = itemView;
        }
        
        for (int idx = 0; idx < self.pictureImageArray.count; idx ++) {
            
            UILabel *titleLable = self.titleLabelArray[idx];
            UIImageView *imageView = self.pictureImageArray[idx];
            
            if (idx < self.menuReportModel.childList.count) {
                [imageView setHidden:NO];
                [titleLable setHidden:NO];
                // 数据
                FYCenterMenuItemModel *classModel = self.menuReportModel.childList[idx];
                // 标题
                [titleLable setText:[CFCSysUtil stringByTrimmingWhitespaceAndNewline:classModel.title]];
                // 图片
                if ([CFCSysUtil validateStringUrl:classModel.imageUrl]) {
                    UIImage *placeholderImage = [UIImage imageNamed:ICON_PUBLIC_PLACEHOLDER];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:classModel.imageUrl] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                    }];
                } else if (!VALIDATE_STRING_EMPTY(classModel.imageUrl)) {
                    [imageView setImage:[UIImage imageNamed:classModel.imageUrl]];
                } else {
                    [imageView setImage:[UIImage imageNamed:ICON_PUBLIC_PLACEHOLDER]];
                }
            } else {
                [imageView setHidden:YES];
                [titleLable setHidden:YES];
            }
        }
    }
}

- (void)pressItemView:(UITapGestureRecognizer *)gesture
{
    UIView *itemView = (UIView*)gesture.view;
    
    NSUInteger index = itemView.tag - 8000;
    
    if (index >= self.menuReportModel.childList.count) {
        FYLog(NSLocalizedString(@"数组越界，请检测代码。", nil));
        return;
    }
    
    if (self.delegateOfReportCell && [self.delegateOfReportCell respondsToSelector:@selector(didSelectRowAtReportModel:itemModel:)]) {
        [self.delegateOfReportCell didSelectRowAtReportModel:self.menuReportModel itemModel:self.menuReportModel.childList[index]];
    }
}


@end

