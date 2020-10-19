//
//  SSChatNoticeCell.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/9/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SSChatNoticeCell.h"
#import "NSString+Size.h"

@interface SSChatNoticeCell ()

@property (nonatomic, strong) UIView *dropBackView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic , strong) UIImageView *redImgView;
@end

@implementation SSChatNoticeCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.dropBackView];
        [self.dropBackView addSubview:self.titleLabel];
        [self.dropBackView addSubview:self.redImgView];
        [self.dropBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(0);
        }];
    }
    
    return self;
}

#pragma mark - setter

- (void)setModel:(FYMessagelLayoutModel *)model {
    [super setModel:model];
    switch (model.message.nnMessageModel.type) {
        case RobNiuNiuTypeHaveGrab://xxxx 领取了红包
        case SolitaireUserGrabTip:
        case RobNiuNiuTypeSaoLeiReceiveOther://"msg":["xxxxx","领取了您的红包"]
        case RobNiuNiuTypeSaoLeiReceive://"msg":["您","领取了","鬼怪","的红包"]
        case RobNiuNiuTypeSaoLeiReceiveLib:
        case BagBagGamesReceive:
            [self setReceiveRedEnvelopeWithModel:model];
            break;
        default:
            self.redImgView.hidden = YES;
            [self niuNiuGameResult:model];
            break;
    }
}
//xxx 领取了红包
- (void)setReceiveRedEnvelopeWithModel:(FYMessagelLayoutModel *)model{
    self.redImgView.hidden = NO;
    NSDictionary *dict = [model.message.text mj_JSONObject];
    NSArray <NSString*>*msgArr = [NSString mj_objectArrayWithKeyValuesArray:dict[@"msg"]];
    NSString *msg = [msgArr componentsJoinedByString:@" "];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    CGFloat w = [msg widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:20];
    if (w > SCREEN_WIDTH) {
        w = SCREEN_WIDTH * 0.9;
    }
    [self.dropBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w + 35 + 3);
    }];
    [self.redImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dropBackView);
        make.width.height.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dropBackView);
        make.left.equalTo(self.redImgView.mas_right).offset(3);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(self.dropBackView.mas_right).offset(-10);
    }];
    self.titleLabel.text = msg;
//    NSLog(@"text:%@",model.message.text);
//    if (model.message.nnMessageModel.type == RobNiuNiuTypeSaoLeiReceiveLib) {
//        self.redImgView.image = [UIImage imageNamed:@"mess_bomb"];
//    }else{
//    }
    self.redImgView.image = [UIImage imageNamed:@"robNNRedIcon"];
}

/// 普通的信息提示
- (void)niuNiuGameResult:(FYMessagelLayoutModel *)model{

    self.titleLabel.font = [UIFont systemFontOfSize:11];
    NSString *msg = [model.message.nnMessageModel.msg componentsJoinedByString:@" "];//为分隔符
    CGFloat w = [msg widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:20];
    
    [self.dropBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w + 20);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.dropBackView);
    }];
    
    self.titleLabel.text = msg;
}

///// 领取红包带富文本的信息提示
//- (void)niuNiuHaveGrab:(FYMessagelLayoutModel *)model {
//
//    NSString *msg = [model.message.nnMessageModel.msg componentsJoinedByString:@" "];//为分隔符
//    self.dropBackView.backgroundColor = COLOR_X(206, 206, 206);
//    CGFloat w = [msg widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:20];
//    [self.dropBackView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(w + 40);
//    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.dropBackView);
//        make.centerY.mas_equalTo(self.dropBackView);
//        make.height.mas_equalTo(14);
//
//    }];
//    self.titleLabel.attributedText = [self imageAndText:model.message.nnMessageModel.msg textColor:HexColor(@"#FE4C56") iconName:@""];
//}


///手气最佳,手气最差
//- (void)solitaireGameAwardSixLength:(FYMessagelLayoutModel *)model {
//    NSArray *tempArray=model.message.nnMessageModel.msg;
//    if (tempArray.count > 6) {
//        tempArray = [tempArray subarrayWithRange:NSMakeRange(0, 6)];
//    }
//    NSString *msg = [tempArray componentsJoinedByString:@" "];//为分隔符
//    self.dropBackView.backgroundColor = COLOR_X(206, 206, 206);
//    CGFloat w = [msg widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:20];
//    [self.dropBackView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(w + 40);
//    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.dropBackView);
//        make.centerY.mas_equalTo(self.dropBackView);
//        make.height.mas_equalTo(14);
//
//    }];
//    self.titleLabel.attributedText = [self imageAndText:tempArray textColor:HexColor(@"#FE4C56") iconName:@""];
//}

#pragma mark - getter

- (UIView *)dropBackView {
    
    if (!_dropBackView) {
        _dropBackView = [[UIView alloc]init];
        _dropBackView.layer.cornerRadius = 3;
        _dropBackView.backgroundColor = COLOR_X(206, 206, 206);
    }
    return _dropBackView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)redImgView{
    if (!_redImgView) {
        _redImgView = [[UIImageView alloc]init];
    }
    return _redImgView;
}
//图文混排,.....领取了红包
//- (NSMutableAttributedString *)imageAndText:(NSArray<NSString*>*)texts textColor:(UIColor*)textColor iconName:(NSString *)imageName{
//    if (texts.count <= 0) {
//        return [[NSMutableAttributedString alloc]initWithString:@""];
//    }
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
//    [texts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//         NSAttributedString *blankAtt = [[NSAttributedString alloc]initWithString:@" " attributes:@{NSForegroundColorAttributeName:UIColor.clearColor}];
//        if (idx % 2 != 0) {
//            NSAttributedString *titleAtt = [[NSAttributedString alloc]initWithString:obj attributes:@{
//            NSForegroundColorAttributeName:UIColor.whiteColor,
//            NSFontAttributeName:[UIFont systemFontOfSize:11]}];
//            [att appendAttributedString:blankAtt];
//            [att appendAttributedString:titleAtt];
//        }else{
//            NSAttributedString *nameAtt = [[NSAttributedString alloc]initWithString:obj attributes:@{
//                                                                                                                      NSForegroundColorAttributeName:textColor,
//                                                                                                                      NSFontAttributeName:[UIFont systemFontOfSize:11]}];
//            [att appendAttributedString:blankAtt];
//            [att appendAttributedString:nameAtt];
//        }
//
//    }];
//
//    // 插入图片附件
//    NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
//    imageAtta.bounds = CGRectMake(0, 0, 11, 11);
//    if (imageName.length > 0) {
//        imageAtta.image = [UIImage imageNamed:imageName];
//    }else{
//        imageAtta.image = [UIImage imageNamed:@"robNNRedIcon"];
//    }
//    NSAttributedString *attach = [NSAttributedString attributedStringWithAttachment:imageAtta];
//    [att insertAttributedString:attach atIndex:0];
//
//    return att;
//}
//
//-(NSAttributedString *)fetchImage:(NSString *)image bounds:(CGRect)bounds{
//    NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
//    imageAtta.bounds = bounds;
//    imageAtta.image = [UIImage imageNamed:image];
//    return [NSAttributedString attributedStringWithAttachment:imageAtta];
//}
//
//-(NSAttributedString *)assembeString:(NSString *)message color:(UIColor *)color{
//    return [[NSAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:11]}];
//}

@end
