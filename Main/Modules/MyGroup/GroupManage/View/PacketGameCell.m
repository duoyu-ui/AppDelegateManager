//
//  TableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "PacketGameCell.h"
#import "GroupInfoUserModel.h"
#import "gamepacketmodel.h"
@interface PacketGameCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *enterGameLab;

//@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *toGameBtn;
@end
@implementation PacketGameCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.iconView];
        [self addSubview:self.enterGameLab];
//        [self addSubview:self.nameLabel];
        [self addSubview:self.toGameBtn];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(60);
        }];
        [self.enterGameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-10);
            make.width.height.mas_equalTo(60);
        }];
//        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.iconView.mas_right).offset(10);
//            make.top.equalTo(self.iconView.mas_top).offset(3);
//
//        }];
        [self.toGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(45);

        }];
    }
    return self;
}


- (void)setModel:(GamePacketModel *)model {
    
    [super setModel:model];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",model.name] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSAttributedString *gz = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"查看游戏规则>>", nil) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    [title appendAttributedString:gz];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:10];
    paraStyle.alignment = NSTextAlignmentLeft;
    [title addAttributes:@{NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, title.length)];

    [self.toGameBtn setAttributedTitle:title forState:UIControlStateNormal];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"msg3"]];
    
}
- (void)checkRuleBtnClick:(id)sender {
    
    if (self.OtherClickFlag) {
        //查看游戏规则
        self.OtherClickFlag(self.model, 1001);
    }
    
}
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}
- (UILabel *)enterGameLab{
    if (!_enterGameLab) {
        _enterGameLab = [[UILabel alloc]init];
        _enterGameLab.backgroundColor = [UIColor colorWithHexString:@"#f02835" alpha:1.0];
        _enterGameLab.text = NSLocalizedString(@"进入\n游戏", nil);

        _enterGameLab.textAlignment = NSTextAlignmentCenter;
        _enterGameLab.textColor = UIColor.whiteColor;
        _enterGameLab.numberOfLines = 0;
        _enterGameLab.font = [UIFont systemFontOfSize:14];
        _enterGameLab.layer.cornerRadius = 8;
        _enterGameLab.layer.masksToBounds = YES;
        
    }
    return _enterGameLab;
}
- (UIButton *)toGameBtn{
    if (!_toGameBtn) {
        _toGameBtn = [[UIButton alloc]init];
        _toGameBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [_toGameBtn setTitle:NSLocalizedString(@"查看游戏规则>>", nil) forState:UIControlStateNormal];
        [_toGameBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _toGameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_toGameBtn addTarget:self action:@selector(checkRuleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _toGameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _toGameBtn;
}

@end
