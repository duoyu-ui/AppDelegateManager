//
//  SSChatRobBettingCell.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/9/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SSChatRobBettingCell.h"
//#import "FYTextView.h"
@interface SSChatRobBettingCell()
/**筹码*/
@property (nonatomic, strong) UIImageView *dateImgView;
@property (nonatomic, strong) UILabel *moneyLab;
@end
@implementation SSChatRobBettingCell


-(void)initChatCellUI {
    [super initChatCellUI];
    [self initSubviews];
 
}
- (void)initSubviews{
    [self.bubbleBackView addSubview:self.dateImgView];
    [self.bubbleBackView addSubview:self.moneyLab];
    
}
-(void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
//    NSDictionary *dict = [model.message.text mj_JSONObject];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    
    FYChatRobBettingModel *winModel = [FYChatRobBettingModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    NSString *lhh = [[NSString alloc]init];
    if (winModel.betAttr.length > 0) {
        lhh = [NSString stringWithFormat:NSLocalizedString(@"  压: %@", nil),[self lhhWithBetAttr:[winModel.betAttr integerValue]]];
        
    }
  
    if (model.message.messageType == FYMessageTypeBett || model.message.messageType == FYMessageTypeRob) {//投注,竞庄
        NSString *type = model.message.messageType == FYMessageTypeBett ? NSLocalizedString(@"投注", nil):NSLocalizedString(@"竞庄", nil);
        NSString *money = [NSString stringWithFormat:@"%@ : %zd%@",type,winModel.money,lhh];
        CGSize moneySize = [NSString sizeWithText:money font:[UIFont systemFontOfSize:14] maxW:SCREEN_WIDTH * 0.8];
        CGFloat dateW = 30.0;
        CGFloat spacing = 25 + 5;//左右2边间距 + 文字和图片间距
        self.moneyLab.text = money;
        if (model.message.messageFrom == FYMessageDirection_SEND) {
//            self.moneyLab.text = [NSString stringWithFormat:@"%zd : %@",winModel.money,type];
            [self.bubbleBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mHeaderImgView.mas_left).offset(-10);
                make.centerY.equalTo(self.mHeaderImgView);
                make.height.mas_equalTo(40);
                make.width.mas_equalTo(dateW + spacing + moneySize.width);
            }];
            [self.dateImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.bubbleBackView);
                make.width.height.mas_equalTo(25);
                make.right.equalTo(self.bubbleBackView.mas_right).offset(-15);
            }];
            [self.moneyLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.bubbleBackView);
                make.right.equalTo(self.dateImgView.mas_left).offset(-5);
            }];
        }else{
            
            [self.bubbleBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mHeaderImgView.mas_right).offset(10);
                make.top.equalTo(self.nicknameLabel.mas_bottom).offset(4);
                make.height.mas_equalTo(40);
                make.width.mas_equalTo(dateW + spacing + moneySize.width);
            }];
            [self.dateImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.bubbleBackView);
                make.width.height.mas_equalTo(25);
                make.left.mas_equalTo(15);
            }];
            [self.moneyLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.bubbleBackView);
                make.left.equalTo(self.dateImgView.mas_right).offset(5);
            }];
        }
        
    }

}
- (NSString *)lhhWithBetAttr:(NSInteger)betAttr{
    switch (betAttr) {
        case 0:
            return NSLocalizedString(@"龙", nil);
            break;
        case 1:
            return NSLocalizedString(@"虎", nil);
            break;
        case 2:
            return NSLocalizedString(@"和", nil);
            break;
        default:
            return @"";
            break;
    }
}
- (UIImageView *)dateImgView{
    if (!_dateImgView) {
        _dateImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date_betting_icon"]];
    }
    return _dateImgView;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.textColor = HexColor(@"#1A1A1A");
        _moneyLab.font = [UIFont systemFontOfSize:14];
    }
    return _moneyLab;
}

@end
@implementation FYChatRobBettingModel

@end
