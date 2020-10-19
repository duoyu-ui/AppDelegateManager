//
//  SendRedEnvelopeScrollView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SendRedEnvelopeScrollView.h"
///按钮间隔
const CGFloat interval = 5;
///左边间隔
const CGFloat leftInterval = 60;

#define SendLeiBtnW  ((SCREEN_WIDTH - leftInterval * 2 - interval * 4) / 5)
@interface SendRedEnvelopeScrollView()<UITextFieldDelegate>
///顶部输入的view
@property (nonatomic , strong) UIView *topEdiView;
@property (nonatomic , strong)UITextField *topTf;
@property (nonatomic , strong)UILabel *topLeftLab;
///底部输入的view
@property (nonatomic , strong)UIView *bottomEdiView;
@property (nonatomic , strong)UITextField *bottomTf;
@property (nonatomic , strong)UILabel *bottomLeftLab;
@property (nonatomic , strong) UILabel *bottomRightLab;
///雷号的view
@property (nonatomic , strong) UIView *leiNumView;
///选择埋雷数字
@property (nonatomic , strong) UILabel *leiNumLab;
///虚线
@property (nonatomic , strong) UIImageView *leftLineImgView;
@property (nonatomic , strong) UIImageView *rightLineImgView;
// 按钮数组
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic , strong) NSArray *nums;
// 选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;

///禁抢的view
@property (nonatomic , strong) UIView *jqView;
///底部的view
@property (nonatomic , strong) UIView *bottomView;
///塞钱进红包 按钮
@property (nonatomic , strong) UIButton *completeBtn;
///未领取的红包，将于5分钟后发起退款
@property (nonatomic , strong)UILabel *bottomLab;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , copy) NSString *minMoney;
@property (nonatomic , copy) NSString *maxMoney;
///红包最小个数
@property (nonatomic , copy) NSString *minCount;
@property (nonatomic , copy) NSString *maxCount;
///雷号
@property (nonatomic , copy) NSString *leiNum;

@end
@implementation SendRedEnvelopeScrollView
- (void)setIsFu:(BOOL)isFu{
    _isFu = isFu;
}
- (void)setItem:(MessageItem *)item{
    _item = item;
    if (_isFu) {
        self.minMoney = item.simpMinMoney;
        self.maxMoney = item.simpMaxMoney;
        self.minCount = item.simpMinCount;
        self.maxCount = item.simpMaxCount;
    }
    switch (item.type) {
        case 0:
            break;
        case 1://扫雷
        case 2://牛牛
        case 8://二人牛牛
        case 10:
            self.minMoney = item.minMoney;
            self.maxMoney = item.maxMoney;
            self.minCount = item.minCount;
            self.maxCount = item.maxCount;
            break;
        
            
        default:
            break;
    }
    if (item.type == 1 || item.type == 8) {
        if ([self.maxCount isEqualToString:self.minCount]) {
            self.bottomTf.userInteractionEnabled = NO;
            self.bottomTf.placeholder = [NSString stringWithFormat:@"%@",self.minCount];
            self.bottomLeftLab.textColor = HexColor(@"#C5C5C5");
            self.bottomRightLab.textColor = HexColor(@"#C5C5C5");
        }else{
            self.bottomTf.userInteractionEnabled = YES;
            self.bottomTf.placeholder = [NSString stringWithFormat:@"%@ ~ %@ ",self.minCount,self.maxCount];
            self.bottomLeftLab.textColor = HexColor(@"#333333");
            self.bottomRightLab.textColor = HexColor(@"#333333");
        }
        self.leiNumLab.hidden = NO;
        self.leftLineImgView.hidden = NO;
        self.rightLineImgView.hidden = NO;
        if(item.type == 1 ){
            [self.leiNumView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SendLeiBtnW * 2 + 20 * 4);
            }];
        }else{
            [self setLeiNumView];
        }
    }else{
        [self setLeiNumView];
        self.bottomTf.placeholder = [NSString stringWithFormat:@"%@ ~ %@ ",self.minCount,self.maxCount];
    }
    self.topTf.placeholder = [NSString stringWithFormat:@"%@ ~ %@ ",self.minMoney,self.maxMoney];
    

}
- (void)setLeiNumView{
    [self.leiNumView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
    }];
    [self.leiNumView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor colorFromHex:@"#EDEDED"];
        [self setSubviews];
    }
    return self;
}
- (void)setSubviews{
    [self addSubview:self.topEdiView];
    [self addSubview:self.bottomEdiView];
    [self.topEdiView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self);
         make.top.mas_equalTo(self.mas_top).offset(40);
         make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 60, 55));
     }];
     [self.bottomEdiView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self);
         make.top.mas_equalTo(self.topEdiView.mas_bottom).offset(20);
         make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 60, 55));
     }];
    [self addSubview:self.jqView];
    [self addSubview:self.leiNumView];
    [self addSubview:self.bottomView];
    [self addSubview:self.bottomLab];
    [self.topEdiView addSubview:self.topLeftLab];
    [self.topEdiView addSubview:self.topTf];
    UILabel *topRightLab = [self setLabText:NSLocalizedString(@"元", nil) textColor:HexColor(@"#333333")];
    [self.topEdiView addSubview: topRightLab];
    
    UILabel *bottomRightLab = [self setLabText:NSLocalizedString(@"个", nil) textColor:HexColor(@"#333333")];
    self.bottomRightLab = bottomRightLab;
    [self.bottomEdiView addSubview:self.bottomLeftLab];
    [self.bottomEdiView addSubview:bottomRightLab];
    [self.bottomEdiView addSubview:self.bottomTf];
    [self.bottomView addSubview:self.completeBtn];
    [self.bottomView addSubview:self.moneyLab];
    
    [self.leiNumView addSubview:self.leiNumLab];
    [self.leiNumView addSubview:self.leftLineImgView];
    [self.leiNumView addSubview:self.rightLineImgView];
    [self.topLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topEdiView);
        make.left.equalTo(self.topEdiView.mas_left).offset(15);
        make.width.mas_equalTo(70);
    }];
    [topRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topEdiView);
        make.right.equalTo(self.topEdiView.mas_right).offset(-5);
        make.width.mas_equalTo(20);
    }];
    [bottomRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomEdiView);
        make.right.equalTo(self.bottomEdiView.mas_right).offset(-5);
        make.width.mas_equalTo(20);
    }];
    [self.topTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topEdiView);
        make.left.equalTo(self.topLeftLab.mas_right);
        make.height.equalTo(self.topEdiView);
        make.right.equalTo(topRightLab.mas_left).offset(-15);
    }];
    
    [self.bottomLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomEdiView);
        make.left.equalTo(self.bottomEdiView.mas_left).offset(15);
        make.width.mas_equalTo(70);
    }];
    [self.bottomTf mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.bottomEdiView);
           make.left.equalTo(self.bottomLeftLab.mas_right);
           make.height.equalTo(self.bottomEdiView);
           make.right.equalTo(topRightLab.mas_left).offset(-15);
       }];
    
 
    [self.jqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self);
        make.top.mas_equalTo(self.bottomEdiView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.leiNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self);
        make.top.mas_equalTo(self.jqView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.width.centerX.equalTo(self);
              make.top.mas_equalTo(self.leiNumView.mas_bottom);
              make.height.mas_equalTo(150);
          }];
          [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.bottom.centerX.equalTo(self.bottomView);
              make.height.mas_equalTo(68);
              make.width.mas_equalTo(240);
          }];
          [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerX.equalTo(self.bottomView);
              make.bottom.equalTo(self.completeBtn.mas_top).offset(-30);
          }];
   });
  
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(SCREEN_HEIGHT -(kiPhoneX_Bottom_Height + Height_NavBar + 40));
    }];
    [self.leiNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leiNumView);
        make.top.mas_equalTo(20);
    }];
    [self.leftLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leiNumLab);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(self.leiNumLab.mas_left).offset(-30);
        make.height.mas_equalTo(2);
    }];
    [self.rightLineImgView  mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(self.leiNumLab);
           make.right.mas_equalTo(-30);
           make.left.mas_equalTo(self.leiNumLab.mas_right).offset(30);
           make.height.mas_equalTo(2);
       }];
    [self.nums enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = idx;
        btn.backgroundColor = HexColor(@"#FFFFFF");
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = SendLeiBtnW / 2;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(@"#6B6B6B") forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(@"#FFFFFF") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(leiNumSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.leiNumView addSubview:btn];
        [self.btnArray addObj:btn];
        CGFloat btnTop = idx < 5 ? 0 : 60;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(SendLeiBtnW);
            make.left.mas_equalTo(leftInterval + idx % 5 * (SendLeiBtnW + interval));
            make.top.mas_equalTo(self.leiNumLab.mas_bottom).offset(20 + btnTop);
        }];
    }];
}
- (void)leiNumSelected:(UIButton *)sender{
    if (self.item.type == 1) {//扫雷,单选
        self.selectedBtn = sender;
        sender.selected = !sender.selected;
        for (NSInteger j = 0; j < [self.btnArray count]; j++) {
            UIButton *btn = self.btnArray[j] ;
            if (sender.tag == j) {
                btn.selected = sender.selected;
            } else {
                btn.selected = NO;
            }
            btn.backgroundColor = HexColor(@"#FFFFFF");
        }
        
        UIButton *btn = self.btnArray[sender.tag];
        if (btn.selected) {
            self.leiNum = btn.titleLabel.text;
            btn.backgroundColor = HexColor(@"#E16754");
        } else {
            btn.backgroundColor = HexColor(@"#FFFFFF");
        }
    }

}
- (void)completeRed:(UIButton *)btn{
    [self endEditing:YES];
    NSString *count;
    if (self.item.type == 1 || self.item.type == 8){
        count = self.minCount;
    }else{
        count = self.bottomTf.text;
    }
    if ([self.srDelegate respondsToSelector:@selector(sendRedMoney:count:leiNums:)]) {
        [self.srDelegate sendRedMoney:self.topTf.text count:count leiNums:self.leiNum];
    }
}
- (void)topMoney:(UITextField *)tf{
    NSString *money;
    if (tf.text == nil || [tf.text isEmpty]) {
        money = @"0";
    }else{
        money = tf.text;
    }
    self.moneyLab.text = [NSString stringWithFormat:@"%@.0",money];
}
///富文本拼接颜色
- (NSMutableAttributedString *)setAttrString:(NSString *)str rangString:(NSString *)rangString{
  
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    //拼接颜色
    [attr addAttribute:NSForegroundColorAttributeName value:HexColor(@"#C5C5C5") range:[str rangeOfString:rangString]];
    return attr;
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    //得到输入框内容
//    NSString *toBeSting = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (range.length == 1 && string.length == 0) {
//        return YES;
//    }
//    if (textField == self.topTf && textField.tag == 10) {
//        if([textField.text length] == 1 && [textField.text isEqualToString:@"0"]){
//            textField.text = self.minMoney;
//            self.moneyLab.text = [NSString stringWithFormat:@"%@.0",textField.text];
//            return NO;
//
//        }
//        if ([toBeSting intValue] >= [self.maxMoney intValue]){
//            textField.text = self.maxMoney;
//            self.moneyLab.text = [NSString stringWithFormat:@"%@.0",textField.text];
//            return NO;
//        }
//    }else if (textField == self.bottomTf && textField.tag == 11){
//        if ([textField.text intValue] != [self.maxCount intValue] || [textField.text intValue] != [self.minCount intValue]){
//            textField.text = self.maxCount;
//            return NO;
//        }
//    }
//    return YES;
//}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.leftLineImgView.image = [self drawLineOfDashByImageView:self.leftLineImgView];
    self.rightLineImgView.image = [self drawLineOfDashByImageView:self.rightLineImgView];
}
#pragma mark - 懒加载子view
- (UIView *)topEdiView{
    if (!_topEdiView) {
        _topEdiView = [[UIView alloc]init];
        _topEdiView.layer.masksToBounds = YES;
        _topEdiView.layer.cornerRadius = 4;
        _topEdiView.backgroundColor = [UIColor whiteColor];
    }
    return _topEdiView;
}
- (UILabel *)topLeftLab{
    if (!_topLeftLab) {
        _topLeftLab = [[UILabel alloc]init];
        _topLeftLab.textColor = HexColor(@"#333333");
        _topLeftLab.text = NSLocalizedString(@"红包金额", nil);
        _topLeftLab.font = [UIFont systemFontOfSize:15];
    }
    return _topLeftLab;
}
- (UILabel *)bottomLeftLab{
    if (!_bottomLeftLab) {
        _bottomLeftLab = [[UILabel alloc]init];
        _bottomLeftLab.textColor = HexColor(@"#333333");
        _bottomLeftLab.text = NSLocalizedString(@"红包个数", nil);
        _bottomLeftLab.font = [UIFont systemFontOfSize:15];
    }
    return _bottomLeftLab;
}
- (UIView *)bottomEdiView{
    if (!_bottomEdiView) {
          _bottomEdiView = [[UIView alloc]init];
          _bottomEdiView.layer.masksToBounds = YES;
          _bottomEdiView.layer.cornerRadius = 4;
          _bottomEdiView.backgroundColor = [UIColor whiteColor];
      }
      return _bottomEdiView;;
}
- (UITextField *)topTf{
    if (!_topTf) {
        _topTf = [[UITextField alloc]init];
        _topTf.keyboardType = UIKeyboardTypeNumberPad;
        _topTf.textColor = HexColor(@"#333333");
        _topTf.textAlignment = NSTextAlignmentRight;
//        _topTf.delegate = self;
        _topTf.tag = 10;
        [_topTf addTarget:self action:@selector(topMoney:) forControlEvents:UIControlEventEditingChanged];
    }
    return _topTf;
}
- (UITextField *)bottomTf{
    if (!_bottomTf) {
        _bottomTf = [[UITextField alloc]init];
        _bottomTf.keyboardType = UIKeyboardTypeNumberPad;
        _bottomTf.tag = 11;
        _bottomTf.textColor = HexColor(@"#333333");
        _bottomTf.textAlignment = NSTextAlignmentRight;
//        _bottomTf.delegate = self;
    }
    return _bottomTf;
}
- (UIView *)leiNumView{
    if (!_leiNumView) {
        _leiNumView = [[UIView alloc]init];
    }
    return _leiNumView;
}
- (UIView *)jqView{
    if (!_jqView) {
        _jqView = [[UIView alloc]init];
    }
    return _jqView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
          _bottomView = [[UIView alloc]init];
      }
      return _bottomView;
}
- (UIButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = [[UIButton alloc]init];
        _completeBtn.backgroundColor = HexColor(@"#E16754");
        _completeBtn.layer.masksToBounds = YES;
        _completeBtn.layer.cornerRadius = 6;
        [_completeBtn setTitle:NSLocalizedString(@"塞钱进红包", nil) forState:UIControlStateNormal];
        [_completeBtn setTitleColor:HexColor(@"#FFFFFF") forState:UIControlStateNormal];
        [_completeBtn addTarget:self action:@selector(completeRed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.font = [UIFont systemFontOfSize:48];
        _moneyLab.textColor = HexColor(@"#181818");
        _moneyLab.text = @"0.0";
        _moneyLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _moneyLab;
}
- (UILabel *)bottomLab{
       if (!_bottomLab) {
        _bottomLab = [[UILabel alloc]init];
        _bottomLab.textColor = HexColor(@"#C5C5C5");
        _bottomLab.text = NSLocalizedString(@"未领取的红包，将于5分钟后发起退款", nil);
        _bottomLab.font = [UIFont systemFontOfSize:15];
    }
    return _bottomLab;
}
- (UILabel *)leiNumLab{
    if (!_leiNumLab) {
         _leiNumLab = [[UILabel alloc]init];
         _leiNumLab.textColor = HexColor(@"#333333");
         _leiNumLab.text = NSLocalizedString(@"选择埋雷数字", nil);
         _leiNumLab.font = [UIFont systemFontOfSize:15];
        _leiNumLab.hidden = YES;
     }
     return _leiNumLab;
}
- (UIImageView *)leftLineImgView{
    if (!_leftLineImgView) {
        _leftLineImgView = [[UIImageView alloc]init];
        _leftLineImgView.hidden = YES;
    }
    return _leftLineImgView;
}
- (UIImageView *)rightLineImgView{
    if (!_rightLineImgView) {
        _rightLineImgView = [[UIImageView alloc]init];
        _rightLineImgView.hidden = YES;
    }
    return _rightLineImgView;
}
- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
- (NSArray *)nums{
    if (!_nums) {
        _nums = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    }
    return _nums;
}
- (UILabel *)setLabText:(NSString *)text textColor:(UIColor *)textColor{
    UILabel *lab = [[UILabel alloc]init];
    lab.text = text;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = textColor;
    return lab;
}
/**
 *  通过 Quartz 2D 在 UIImageView 绘制虚线
 *
 *  param imageView 传入要绘制成虚线的imageView
 *  return
 */

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);

    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];

    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();

    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {4,4};

    CGContextSetStrokeColorWithColor(line, HexColor(@"#C2C2C2").CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);

    CGContextMoveToPoint(line, 0.0, 2.0);

    CGContextAddLineToPoint(line, 300, 2.0);

    CGContextStrokePath(line);

    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
@end
