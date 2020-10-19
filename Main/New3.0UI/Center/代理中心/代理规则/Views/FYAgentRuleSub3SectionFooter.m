//
//  FYAgentRuleSub3SectionFooter.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleSub3SectionFooter.h"

@interface FYAgentRuleSub3SectionFooter ()
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *title;
@end

@implementation FYAgentRuleSub3SectionFooter

+ (CGFloat)headerViewHeight
{
    return TAB_BAR_DANGER_HEIGHT + 50.0f;
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
    [self.titleLabel setFont:FONT_PINGFANG_REGULAR(14)];
}

- (void)setViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-TAB_BAR_DANGER_HEIGHT);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
    }];
}

@end

