//
//  FYGroupTypeAlertCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYGroupTypeAlertCell.h"

@implementation FYGroupTypeAlertCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [self makeSubview];
    }
    
    return self;
}

- (void)initialize {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
    self.layer.masksToBounds = YES;
}

- (void)makeSubview {
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    self.selectedBackgroundView = selectedView;
}

- (void)setModel:(FYRedPacketListModel *)model {
    _model = model;

    self.typeLabel.text = model.showName.length ? model.showName : @"";
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.typeLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;
    }else {
        self.typeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
        self.layer.borderWidth = 1;
    }
}


@end
