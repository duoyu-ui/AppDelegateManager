//
//  FYSuperBombFooterSectionView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSuperBombFooterSectionView.h"
#import "FYSuperBombAttrModel.h"

@interface FYSuperBombFooterSectionView()

//@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *oddsLabel;

@end

@implementation FYSuperBombFooterSectionView

#pragma mark - life cycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = HexColor(@"#EDEDED");
//        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    
//    [self.contentView addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(12);
//        make.centerY.equalTo(self.contentView);
//        make.width.equalTo(@80);
//    }];
//
    [self addSubview:self.oddsLabel];
    [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - setter

- (void)setModel:(FYSuperBombAttrModel *)model {
    _model = model;
    if (model.setedHandicap.length > 0){
        self.oddsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"赔率: %@倍", nil),model.setedHandicap];
    }
}

#pragma mark - getter

//- (UILabel *)titleLabel {
//
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = NSLocalizedString(@"赔率", nil);
//        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//        _titleLabel.font = [UIFont systemFontOfSize:14];
//    }
//    return _titleLabel;
//}

- (UILabel *)oddsLabel {
    
    if (!_oddsLabel) {
        _oddsLabel = [[UILabel alloc] init];
        _oddsLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _oddsLabel.font = [UIFont systemFontOfSize:16];
    }
    return _oddsLabel;
}

@end
