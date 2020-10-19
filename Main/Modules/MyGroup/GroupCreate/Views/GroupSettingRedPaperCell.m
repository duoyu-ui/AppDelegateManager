//
//  GroupSettingRedPaperCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "GroupSettingRedPaperCell.h"

@interface GroupSettingRedPaperCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GroupSettingRedPaperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialize];
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
        [self setupSunview];
    }
    return self;
}

- (void)initialize {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
}

- (void)setupSunview {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = NSLocalizedString(@"50元", nil);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
    self.selectedBackgroundView = selectedView;
}

#pragma mark - Private setter

- (void)setModel:(FYCreateRequest *)model {
    _model = model;
    
    if (model.min && model.max) {
        self.titleLabel.text = [NSString stringWithFormat:@"%ld-%ld", model.min, model.max];;
    }else if (model.amount) {
        self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld元", nil), model.amount];
    }else if (model.payRatio) {
        self.titleLabel.text = [NSString stringWithFormat:@"%ld%%", model.payRatio];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }else {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
    }
}

@end
 
