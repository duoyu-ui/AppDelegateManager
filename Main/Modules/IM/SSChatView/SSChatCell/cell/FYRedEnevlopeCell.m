//
//  EnvelopeCollectionViewCell.m
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "FYRedEnevlopeCell.h"
#import "EnvelopeMessage.h"
@interface FYRedEnevlopeCell()
///禁抢💣图片
@property (nonatomic , strong) UIImageView *bombImgView;
///🧧普通状态和打开状态
@property (nonatomic , strong) UIImageView *envelopeImgView;
/// 领取红包
@property (nonatomic , strong) UILabel *receiveLab;

@property (nonatomic , strong) UILabel *contentLabel;
@property (nonatomic , strong) UILabel *dateLabel;
@end
@implementation FYRedEnevlopeCell

- (void)initChatCellUI{
    [super initChatCellUI];
    [self initSubviews];
}
#pragma mark ----- subView
- (void)initSubviews{
    [self.bubbleBackView addSubview:self.bombImgView];
    [self.bubbleBackView addSubview:self.receiveLab];
    [self.bubbleBackView addSubview:self.dateLabel];
    [self.bubbleBackView addSubview:self.envelopeImgView];
    [self.bubbleBackView addSubview:self.contentLabel];
    [self.envelopeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(50);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.envelopeImgView.mas_centerY);
        
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(-7);
          make.left.equalTo(self.bubbleBackView.mas_left).offset(15);
      }];
    [self.receiveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-7);
//        make.width.mas_equalTo(70);
        make.right.equalTo(self.bubbleBackView.mas_right).offset(-10);
    }];
    [self.envelopeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleBackView.mas_left).offset(15);
        make.top.equalTo(@(10));
        make.width.height.mas_equalTo(40);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.envelopeImgView.mas_right).offset(5);
        make.centerY.equalTo(self.envelopeImgView.mas_centerY);
        make.right.equalTo(self.bubbleBackView.mas_right).offset(-15);
    }];
//    [self.receiveLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.lessThanOrEqualTo(@(-10));
//    }];
    [self.bombImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}


#pragma mark - 更新数据
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    EnvelopeMessage *emsg = [[EnvelopeMessage alloc]init];
    if (model.message.redEnvelopeMessage == nil) {
       emsg = [EnvelopeMessage mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    }else {
        emsg = model.message.redEnvelopeMessage;
    }
    NSInteger cellStatus = [emsg.cellStatus integerValue];
    // ****** 设置背景图片 ******
    UIImage *bubbleImage = [self backImage:emsg.type cellStatus:cellStatus dirFrom:model.message.messageFrom];
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = bubbleImage;
    self.dateLabel.text = emsg.date;
    switch (emsg.type) {
        case FYRedEnvelopeType_Fu://福利
        case FYRedEnvelopeType_RobNN://抢庄牛牛
        case FYRedEnvelopeType_ebg://二八杠
        case FYRedEnvelopeType_lhd://龙虎斗
        case FYRedEnvelopeType_jl://接龙
        case FYRedEnvelopeType_BagBagCow://包包牛
        case FYRedEnvelopeType_BagLottery://包包彩
            self.contentLabel.text = cellStatus == 2 ? NSLocalizedString(@"红包已抢完", nil):NSLocalizedString(@"恭喜发财 大吉大利", nil);
            break;
        case FYRedEnvelopeType_Mine://扫雷
            self.contentLabel.text = cellStatus == 2 ? NSLocalizedString(@"红包已抢完", nil):[NSString stringWithFormat:@"%@%@/%@%zd",emsg.money,NSLocalizedString(@"元", nil),NSLocalizedString(@"雷", nil),emsg.num];
            break;
        case FYRedEnvelopeType_Cow://牛牛
        case FYRedEnvelopeType_ErRenNN://二人牛牛
            self.contentLabel.text = cellStatus == 2 ? NSLocalizedString(@"红包已抢完", nil):[NSString stringWithFormat:@"%@%@/%zd%@",emsg.money,NSLocalizedString(@"元", nil),emsg.count,NSLocalizedString(@"包", nil)];
            break;
            case FYRedEnvelopeType_NoRob://禁抢
        {
            NSDictionary *nograDict = emsg.nograbContent;
            NSString *leiNum = [NSString stringWithFormat:@"%@",emsg.nograbContent[@"bombList"]];
            if ([leiNum hasPrefix:@"["]) {//去掉[
                leiNum = [leiNum stringByReplacingOccurrencesOfString:@"[" withString:@""];
            }
            if ([leiNum hasSuffix:@"]"]){
                leiNum = [leiNum stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }
            NSInteger handicap = [nograDict[@"handicap"] integerValue];
            NSInteger type = [nograDict[@"type"] integerValue];
            //是否是雷
            BOOL isLei = (handicap > 0 && type != 2) ? NO :YES;
            self.bombImgView.hidden = isLei;
            NSString *text = [NSString stringWithFormat:@"%@%@/%@%@",emsg.money,NSLocalizedString(@"元", nil),(isLei ? NSLocalizedString(@"不", nil) : NSLocalizedString(@"雷", nil)),leiNum];
            self.contentLabel.text = cellStatus == 2 ? NSLocalizedString(@"红包已抢完", nil) : text;
        }
            break;
        case FYRedEnvelopeType_SuperBomb://超级扫雷
        {
            NSString *bombList = emsg.bombList;
            if (bombList.length == 0) {
                return;
            }
            if ([bombList hasPrefix:@"["]) {//前
                bombList = [bombList stringByReplacingOccurrencesOfString:@"[" withString:@""];
            }
            if([bombList hasSuffix:@"]"]){//后
                bombList = [bombList stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }
            unsigned char arrStr[bombList.length];
            memcpy(arrStr, [bombList cStringUsingEncoding:NSUTF8StringEncoding], bombList.length);
            NSMutableArray *nums = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < sizeof(arrStr); i++) {
                [nums addObj:[NSString stringWithFormat:@"%c",arrStr[i]]];
            }
            self.contentLabel.text = cellStatus == 2 ? NSLocalizedString(@"红包已抢完", nil):[NSString stringWithFormat:@"%@%@/%@%@",emsg.money,NSLocalizedString(@"元", nil),NSLocalizedString(@"雷", nil),[nums componentsJoinedByString:@","]];
        }
            break;
        default:
            break;
    }
    if (emsg.type != FYRedEnvelopeType_NoRob) {
        self.bombImgView.hidden = YES;
    }
    if (model.message.messageFrom == FYMessageDirection_SEND) {//自己发的
        [self.envelopeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleBackView.mas_left).offset(10);
        }];
    }else{
        [self.envelopeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleBackView.mas_left).offset(15);
        }];
    }
    [self.envelopeImgView setImage:[UIImage imageNamed:[self envelopeImgWithType:cellStatus]]];
    self.receiveLab.text = [self envelopeTextWithType:cellStatus];

}
- (NSString *)envelopeTextWithType:(NSInteger)type{
    if (type == 0) {
        return NSLocalizedString(@"领取红包", nil);
    }else{
        return NSLocalizedString(@"查看红包", nil);
    }
}
- (NSString *)envelopeImgWithType:(NSInteger)type{
    if (type == 0) {
        return @"envelope_icon_nor";
    }else{
        return @"envelope_icon_sel";
    }
}

// 设置背景图片
- (UIImage *)backImage:(FYRedEnvelopeType)redEnveType cellStatus:(NSInteger)cellStatus dirFrom:(FYChatMessageFrom)dirFrom
{
    NSString *from;
    NSString *status;
    NSString *type;
    if (dirFrom == FYMessageDirection_SEND) {//发送 ,图片箭头在右边
        from = @"send";
    }else{
        from = @"receive";
    }
    status = (cellStatus == 0) ? @"nor":@"sel";
    switch (redEnveType) {
        case FYRedEnvelopeType_Fu:
            type = @"fuLi";
            break;
        case FYRedEnvelopeType_SuperBomb:
        case FYRedEnvelopeType_Mine:
            type = @"saolei";
            break;
        case FYRedEnvelopeType_ErRenNN:
        case FYRedEnvelopeType_RobNN:
        case FYRedEnvelopeType_Cow:
        case FYRedEnvelopeType_BagBagCow:
            type = @"niuniu";
            break;
        case FYRedEnvelopeType_NoRob:
            type = @"jinQiang";
            break;
       
        case FYRedEnvelopeType_ebg:
            type = @"erBa";
            break;
        case FYRedEnvelopeType_lhd:
            type = @"lhd";
            break;
        case FYRedEnvelopeType_jl:
            type = @"jieLong";
            break;
        case FYRedEnvelopeType_BagLottery:
             type = @"bagLottery";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon_%@_%@",type,from,status]];
}

- (UIImageView *)bombImgView{
    if (!_bombImgView) {
        _bombImgView = [[UIImageView alloc]init];
        [_bombImgView setImage:[UIImage imageNamed:@"bomb_icon_sel"]];
    }
    return _bombImgView;
}
- (UIImageView *)envelopeImgView{
    if (!_envelopeImgView) {
        _envelopeImgView = [[UIImageView alloc]init];
    }
    return _envelopeImgView;
}
- (UILabel *)receiveLab{
    if (!_receiveLab) {
        _receiveLab = [[UILabel alloc]init];
        _receiveLab.text = NSLocalizedString(@"领取红包", nil);
        _receiveLab.textColor = HexColor(@"#FFFFFF");
        _receiveLab.font = [UIFont systemFontOfSize:10];
        _receiveLab.textAlignment = NSTextAlignmentRight;
    }
    return _receiveLab;
}
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textColor = HexColor(@"#FFFFFF");
        _dateLabel.font = [UIFont systemFontOfSize:10];
    }
    return _dateLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = HexColor(@"#FFFFFF");
        _contentLabel.font = [UIFont systemFontOfSize:16];
    }
    return _contentLabel;
}
@end

