//
//  FYRedPaperNumberCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYRedPaperNumberCell.h"

@implementation FYRedPaperNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialize];
}

- (void)initialize {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 14;
    self.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
        [self setupSunview];
    }
    return self;
}

- (void)setupSunview {
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.text = @"-";
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
    self.selectedBackgroundView = selectedView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.numberLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;
    }else {
        self.numberLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
        self.layer.borderWidth = 1;
    }
}

@end
