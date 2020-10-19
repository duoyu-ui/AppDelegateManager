//
//  SSChatGameAwardCell.m
//  ProjectCSHB
//
//  Created by Tom on 2019/10/31.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "SSChatGameAwardCell.h"
#import "NSString+Size.h"

@interface SSChatGameAwardCell()
/** 背景view*/
@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation SSChatGameAwardCell
-(void)initChatCellUI {
    [super initChatCellUI];
    [self initSubviews];
    
    
}
- (void)initSubviews{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(0);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
    }];
}
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    if (model.message.nnMessageModel.type == RobNiuNiuTypeSaoLeiResult) {
        [self superSaoleiResult:model];
        return;
    }
    NSArray *tempArray=model.message.nnMessageModel.msg;
    if (tempArray.count > 6) {
        if (model.message.nnMessageModel.type == SolitaireGameAward) {
            tempArray = [tempArray subarrayWithRange:NSMakeRange(0, 6)];
        }
    }
    NSString *msg = [tempArray componentsJoinedByString:@" "];//为分隔符
    CGFloat w = [msg getWidthWithFont:[UIFont systemFontOfSize:14] height:20];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w / 2 + 80);
    }];
   
    //第一个
    NSMutableArray <NSString *>*firstArr = [NSMutableArray arrayWithCapacity:0];
    //后一个
    NSMutableArray <NSString *>*lastArr = [NSMutableArray arrayWithCapacity:0];
    
    [tempArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 3) {
            [firstArr addObject:obj];
        }else{
            [lastArr addObject:obj];
        }
    }];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.attributedText = [self setImageTextAttr:[self imageAndText:firstArr textColor:HexColor(@"#ff3c54") imgName:nil] lastAttr:[self imageAndText:lastArr textColor:HexColor(@"#008000") imgName:@"ic_jielong_xia"]];
}

-(void)superSaoleiResult:(FYMessagelLayoutModel *)model{
    NSString *message = [model.message.nnMessageModel.msg componentsJoinedByString:@" "];
    CGFloat widthSize = [message getWidthWithFont:[UIFont systemFontOfSize:14] height:20];
//    CGSize textSize=[message sizeWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:SCREEN_WIDTH - 100];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(widthSize / 2 + 40);
//        make.width.mas_equalTo(textSize.width + 20);
    }];;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.bgView.mas_width).mas_offset(-20);
    }];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.attributedText = [self assembeString:message color:HexColor(@"#FE4C56")];
}
-(NSAttributedString *)assembeString:(NSString *)message color:(UIColor *)color{
    return [[NSAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 3;
        _bgView.backgroundColor = COLOR_X(206, 206, 206);
    }
    return _bgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

//图文混排
- (NSMutableAttributedString *)imageAndText:(NSArray<NSString*>*)texts textColor:(UIColor*)textColor imgName:(NSString *)imagName{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
    if (texts.count > 0){
        [texts enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx % 2 == 0){
                NSAttributedString *blankAtt = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@ ",text] attributes:@{NSForegroundColorAttributeName:textColor}];
                [att appendAttributedString:blankAtt];
            }else{
                if ([text containsString:@"（"]) {
                    NSAttributedString *titleAtt = [[NSAttributedString alloc]initWithString:text attributes:@{
                        NSForegroundColorAttributeName:textColor,
                        NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                    [att appendAttributedString:titleAtt];
                }else{
                    NSAttributedString *titleAtt = [[NSAttributedString alloc]initWithString:text attributes:@{
                        NSForegroundColorAttributeName:UIColor.whiteColor,
                        NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                    [att appendAttributedString:titleAtt];
                }
            }
           
        }];
        NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
           imageAtta.bounds = CGRectMake(0, -4, 13, 17);
           imageAtta.image = [UIImage imageNamed:@"robNNRedIcon"];
           NSAttributedString *attach = [NSAttributedString attributedStringWithAttachment:imageAtta];
           [att insertAttributedString:attach atIndex:0];
        if (imagName.length > 0) {
            NSTextAttachment *jielongImageAtta = [[NSTextAttachment alloc] init];
            jielongImageAtta.bounds = CGRectMake(0, -4, 16, 18);
            jielongImageAtta.image = [UIImage imageNamed:imagName];
            NSAttributedString *jielongAttach = [NSAttributedString attributedStringWithAttachment:jielongImageAtta];
            [att appendAttributedString:jielongAttach];
        }
    }
    return att;
}
- (NSMutableAttributedString *)setImageTextAttr:(NSAttributedString *)firstAttr lastAttr:(NSAttributedString*)lastAttr{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
    [att appendAttributedString:firstAttr];
    NSAttributedString *titleAtt = [[NSAttributedString alloc]initWithString:@"\n\n" attributes:@{
        NSForegroundColorAttributeName:UIColor.whiteColor,
        NSFontAttributeName:[UIFont systemFontOfSize:3]}];
    [att appendAttributedString:titleAtt];

    [att appendAttributedString:lastAttr];
    return att;
}
@end
