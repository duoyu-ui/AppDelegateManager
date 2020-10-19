//
//  SSChatBagBagCowBetCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatBagBagCowBetCell.h"
#import <GMenuController/GMenuController.h>
@interface SSChatBagBagCowBetCell ()
@property (nonatomic, strong) UIImageView *dateImgView;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic , strong) NSArray <GMenuItem*>*arr;
@end
@implementation SSChatBagBagCowBetCell


- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    SSChatBagBagCowBetModel *winModel = [SSChatBagBagCowBetModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    NSString *betAttr = [NSString string];
    switch (winModel.betAttr) {//0：庄  1：闲  2：和
        case 0:
            betAttr = NSLocalizedString(@"庄", nil);
            break;
        case 1:
            betAttr = NSLocalizedString(@"闲", nil);
            break;
        case 2:
            betAttr = NSLocalizedString(@"和", nil);
            break;
        default:
            break;
    }
    NSString *betText = [NSString stringWithFormat:NSLocalizedString(@"投注 : %zd  压 : %@", nil),winModel.money,betAttr];
    
    CGSize moneySize = [NSString sizeWithText:betText font:[UIFont systemFontOfSize:kCellFont] maxW:SCREEN_WIDTH * 0.8];
    CGFloat dateW = 30.0;
    CGFloat spacing = 25 + 5;//左右2边间距 + 文字和图片间距
    self.moneyLab.text = betText;
    if (model.message.messageFrom == FYMessageDirection_SEND) {
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
-(void)initChatCellUI {
    [super initChatCellUI];
    [self initSubviews];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
     [self.bubbleBackView addGestureRecognizer:tap];
    GMenuItem *item1 = [[GMenuItem alloc] initWithTitle:NSLocalizedString(@"跟投", nil) target:self action:@selector(toVoteForItem)];
    GMenuItem *item2 = [[GMenuItem alloc] initWithTitle:NSLocalizedString(@"复制", nil) target:self action:@selector(copyItem)];
    self.arr = @[item1,item2];

}
///长按删除
- (void)longPress:(UIGestureRecognizer *) gestureRecognizer {
        [self becomeFirstResponder];
        CGRect rect = [gestureRecognizer view].frame;
        [[GMenuController sharedMenuController] setMenuItems:self.arr];
        [[GMenuController sharedMenuController] setTargetRect:rect inView:self.contentView];
        [[GMenuController sharedMenuController] setMenuVisible:YES];
}
- (void)copyItem{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChatBagBagCowBetCell:row:)]){
           [self.delegate didChatBagBagCowBetCell:self.model.message row:2];
       }
       [[GMenuController sharedMenuController] setMenuVisible:NO];
}
- (void)toVoteForItem{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChatBagBagCowBetCell:row:)]){
        [self.delegate didChatBagBagCowBetCell:self.model.message row:1];
    }
    [[GMenuController sharedMenuController] setMenuVisible:NO];
}
- (void)initSubviews{
    [self.bubbleBackView addSubview:self.dateImgView];
    [self.bubbleBackView addSubview:self.moneyLab];
    
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
        _moneyLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _moneyLab;
}

@end
@implementation SSChatBagBagCowBetModel

@end
