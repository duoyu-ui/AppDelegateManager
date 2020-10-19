//
//  FYGroupTableSectionFooter.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGroupTableSectionFooter.h"

@interface FYGroupTableSectionFooter ()
// 标题
@property (nonatomic, copy) NSString *title;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation FYGroupTableSectionFooter

+ (CGFloat)height
{
    return CFC_AUTOSIZING_WIDTH(60.0f);
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
    [self.titleLabel setTextColor:COLOR_HEXSTRING(@"#7F7F7F")];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:FONT_PINGFANG_REGULAR(16)];
}

- (void)setViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(margin);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
    }];
}

- (void)setTitleString:(NSString *)titleString
{
    _title = titleString;
    [self.titleLabel setText:titleString];
}

@end

