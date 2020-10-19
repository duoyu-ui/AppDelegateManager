//
//  FYContactTableSectionFooter.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactTableSectionFooter.h"


@interface FYContactTableSectionFooter ()
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 高度
@property (nonatomic, assign) CGFloat footerHeight;

@end


@implementation FYContactTableSectionFooter

- (instancetype)initWithFrame:(CGRect)frame footerHeight:(CGFloat)footerHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        _footerHeight = footerHeight;
        [self createView];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)createView
{
    NSInteger count = [[IMContactsModule sharedInstance] getAllFreinds].count;
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%ld位朋友及联系人", nil), count];
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    [self.titleLabel setText:title];
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

@end

