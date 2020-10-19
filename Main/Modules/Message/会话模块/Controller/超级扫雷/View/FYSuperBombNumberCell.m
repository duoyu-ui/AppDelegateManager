//
//  FYSuperBombNumberCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSuperBombNumberCell.h"

@implementation FYSuperBombNumberCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
//    [self initialize];
//}

- (void)initialize {
    self.layer.cornerRadius = 33 * 0.5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
        [self setupSubview];
    }
    return self;
}
- (void)setCornerRadius:(CGFloat)cornerRadius{
    if(cornerRadius > 0){
        self.layer.cornerRadius = cornerRadius;
    }
}
- (void)setupSubview {
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor colorWithHexString:@"#E16754"];
    self.selectedBackgroundView = selectedView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.numberLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
//        self.layer.borderColor = [UIColor clearColor].CGColor;
//        self.layer.borderWidth = 0;
    }else {
        self.numberLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        
//        self.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
//        self.layer.borderWidth = 1;
    }
}

@end
