//
//  SSChatBottomMenuCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/1/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatBottomMenuCell.h"
#import "SSChatMenuConfig.h"

@interface SSChatBottomMenuCell()

@property (nonatomic, strong) UIImageView *itemImageView;

@property (nonatomic, strong) UILabel *itemLabel;

@end

@implementation SSChatBottomMenuCell

#pragma mark - getter

- (UILabel *)itemLabel {
    
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = [UIFont systemFontOfSize:14];
        _itemLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _itemLabel;
}

- (UIImageView *)itemImageView {
    
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
    }
    return _itemImageView;
}

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self makeSubview];
    }
    
    return self;
}

- (void)makeSubview {
    
    [self.contentView addSubview:self.itemImageView];
    [self.contentView addSubview:self.itemLabel];
    
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@45);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.itemImageView.mas_bottom).offset(10);
    }];
}


#pragma mark - setter

- (void)setModel:(SSChatMenuConfig *)model {
    _model = model;
    
    self.itemLabel.text = model.title;
    self.itemImageView.image = [UIImage imageNamed:model.image];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}


@end
