//
//  FYGameRecordSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameRecordSectionHeader.h"

CGFloat const kFyGameRecordSectionHeaderColumnTitleAreaHeight = 50.0f; // 列标题区域
CGFloat const kFyGameRecordSectionHeaderSplitLineAreaHeight = 3.3f; // 间隔

@interface FYGameRecordSectionHeader ()
@property (nonatomic, strong) UIView *columnTitleContainer;
@property (nonatomic, strong) UIView *splitLineContainer;
@end

@implementation FYGameRecordSectionHeader

#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return kFyGameRecordSectionHeaderColumnTitleAreaHeight + kFyGameRecordSectionHeaderSplitLineAreaHeight;
}

- (NSArray<NSString *> *)getColumnTitles
{
    return @[ NSLocalizedString(@"期号", nil),
              NSLocalizedString(@"开奖", nil),
              NSLocalizedString(@"盈亏", nil),
              NSLocalizedString(@"时间", nil),
              @"" ];
}

- (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.20f), @(0.40f), @(0.60f), @(0.97f), @(1.0f) ];
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
        make.height.mas_equalTo(kFyGameRecordSectionHeaderColumnTitleAreaHeight);
    }];
    
    // 容器 - 分割区域
    [self addSubview:self.splitLineContainer];
    [self.splitLineContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.columnTitleContainer.mas_bottom);
        make.height.mas_equalTo(kFyGameRecordSectionHeaderSplitLineAreaHeight);
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
    CGFloat itemHeight = kFyGameRecordSectionHeaderColumnTitleAreaHeight;
    
    UILabel *lastItemLabel = nil;
    for (NSInteger index = 0; index < titles.count; index ++) {
        lastItemLabel = ({
            UILabel *label = [UILabel new];
            [self.columnTitleContainer addSubview:label];
            [label setText:titles[index]];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            CGFloat percent = [percents objectAtIndex:index].floatValue;
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

