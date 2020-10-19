//
//  FYGameTrendSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameTrendSectionHeader.h"

CGFloat const FYGameTrendSectionHeaderColumnTitleAreaHeight = 35.0f; // 列标题区域
CGFloat const FYGameTrendSectionHeaderSplitLineAreaHeight = 0.6f; // 间隔

@interface FYGameTrendSectionHeader ()
//
@property (nonatomic, strong) UIView *columnTitleContainer;
@property (nonatomic, strong) UIView *splitLineContainer;

@end

@implementation FYGameTrendSectionHeader

#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return FYGameTrendSectionHeaderColumnTitleAreaHeight + FYGameTrendSectionHeaderSplitLineAreaHeight;
}

- (NSArray<NSString *> *)getColumnTitles
{
    return @[ STR_APP_TEXT_PLACEHOLDER, STR_APP_TEXT_PLACEHOLDER, STR_APP_TEXT_PLACEHOLDER, STR_APP_TEXT_PLACEHOLDER ];
}

- (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.25f), @(0.50f), @(0.75f), @(1.0f) ];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    // 容器 - 标题区域
    [self addSubview:self.columnTitleContainer];
    [self.columnTitleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(FYGameTrendSectionHeaderColumnTitleAreaHeight);
    }];
    
    // 容器 - 分割区域
    [self addSubview:self.splitLineContainer];
    [self.splitLineContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.columnTitleContainer.mas_bottom);
        make.height.mas_equalTo(FYGameTrendSectionHeaderSplitLineAreaHeight);
    }];
    
    //
    [self createViewColumnTitleAtuoLayout];
}

- (void)createViewColumnTitleAtuoLayout
{
    NSArray<NSString *> *titles = [self getColumnTitles];
    NSArray<NSNumber *> *percents = [self getColumnPercents];
    UIFont *titleFont = FONT_PINGFANG_REGULAR(15);
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    CGFloat itemHeight = FYGameTrendSectionHeaderColumnTitleAreaHeight;
    
    UILabel *lastItemLabel = nil;
    for (NSInteger index = 0; index < titles.count; index ++) {
        CGFloat percent = [percents objectAtIndex:index].floatValue;
        
        lastItemLabel = ({
            UILabel *label = [UILabel new];
            [self.columnTitleContainer addSubview:label];
            [label setText:titles[index]];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.columnTitleContainer.mas_right).multipliedBy(percent);
                make.height.equalTo(@(itemHeight));
                
                if (!lastItemLabel) {
                    make.top.equalTo(self.columnTitleContainer.mas_top);
                    make.left.equalTo(self.columnTitleContainer.mas_left);
                } else {
                    make.top.equalTo(lastItemLabel.mas_top);
                    make.left.equalTo(lastItemLabel.mas_right);
                }
            }];
            
            label;
        });
        lastItemLabel.mas_key = [NSString stringWithFormat:@"titleLabel%ld", index];
        
        if (index < titles.count-1) {
            UIView *splitLineView = ({
                UIView *view = [[UIView alloc] init];
                [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                [self.columnTitleContainer addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.columnTitleContainer);
                    make.centerX.equalTo(self.columnTitleContainer.mas_right).multipliedBy(percent);
                    make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                }];
                
                view;
            });
            splitLineView.mas_key = @"splitLineView";
        }
    }
}


#pragma mark - Getter & Setter

- (UIView *)columnTitleContainer
{
    if (!_columnTitleContainer) {
        _columnTitleContainer = [[UIView alloc] init];
        [_columnTitleContainer setBackgroundColor:COLOR_HEXSTRING(@"#F6F6F6")];
        [_columnTitleContainer addBorderWithColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT cornerRadius:0.0f andWidth:SEPARATOR_LINE_HEIGHT];
    }
    return _columnTitleContainer;
}

- (UIView *)splitLineContainer
{
    if (!_splitLineContainer) {
        _splitLineContainer = [[UIView alloc] init];
        [_splitLineContainer setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    }
    return _splitLineContainer;
}


@end
