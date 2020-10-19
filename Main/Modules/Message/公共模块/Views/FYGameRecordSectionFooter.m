//
//  FYGameRecordSectionFooter.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameRecordSectionFooter.h"

CGFloat const kFyGameRecordSectionFooterAreaHeight = 50.0f; // 列标题区域

@interface FYGameRecordSectionFooter ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *title;
@end

@implementation FYGameRecordSectionFooter

+ (CGFloat)headerViewHeight
{
    return kFyGameRecordSectionFooterAreaHeight;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        [self createView];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)createView
{
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    [self.titleLabel setText:self.title];
    [self.titleLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:FONT_PINGFANG_REGULAR(15)];
}

- (void)setViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
    }];
}

@end

