//
//  FYNewRobChatKeyBord.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYNewRobChatKeyBord.h"
#import "FYRobChatKeyBordCell.h"
static NSString * const FYRobChatKeyBordCellID = @"FYRobChatKeyBordCellID";

#define backViewH (360.0 + ([UIApplication sharedApplication].statusBarFrame.size.height == 20 ? 0 : 34))
#define  keyW (SCREEN_WIDTH / 5)
#define cellW (SCREEN_WIDTH - keyW) / 3
///龙虎斗view的高
#define lhdHeight 60

@interface FYNewRobChatKeyBord()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
///背景
@property (nonatomic, strong) UIView *backdropView;
/**
 键盘容器
 */
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/** 数据源*/
@property (nonatomic, strong) NSArray<NSString*> *dataSource;

@property (nonatomic , strong) UIView *keyView;
@property (nonatomic , strong) NSMutableArray<UIButton*> *btnArrs;
@property (nonatomic , strong) NSMutableArray<UIButton*> *numBtnArrs;
@property (nonatomic , strong) UIView *tfBgView;
//@property (nonatomic , strong) UITextField *tfView;
@property (nonatomic, weak) id<FYNewRobChatKeyboardDelegate> delegate;
@property (nonatomic , strong) UILabel *numLab;
@property (nonatomic , strong) UIView *labBgView;
@property (nonatomic , strong) NSMutableArray <NSString*>*nums;
@property (nonatomic , strong) UIButton *qzbtn;
/// 2: 抢庄 ,3: 投注
@property (nonatomic , assign) NSInteger status;
@property (nonatomic , assign) NSInteger gameType;
@property (nonatomic , strong) UIView *lhdView;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
// 选中按钮 ,龙虎和
@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic , assign) NSInteger lhh;
@property (nonatomic, strong) NSArray <NSString*>*moneyArr;
@end
@implementation FYNewRobChatKeyBord

+ (void)showPayKeyboardViewAnimate:(id<FYNewRobChatKeyboardDelegate>)delegate moneyArr:(NSArray <NSString*>*)moneyArr money:(NSString *)money status:(NSInteger)status gameType:(NSInteger)gameType{
    FYNewRobChatKeyBord *keyBord = [[FYNewRobChatKeyBord alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    [window addSubview:keyBord];
    keyBord.frame = window.bounds;
    [keyBord showPayKeyboardViewAnimate:delegate moneyArr:moneyArr money:money status:status gameType:gameType];
}
- (void)showPayKeyboardViewAnimate:(id<FYNewRobChatKeyboardDelegate>)delegate moneyArr:(NSArray <NSString*>*)moneyArr money:(NSString *)money status:(NSInteger)status gameType:(NSInteger)gameType{
    self.delegate = delegate;
    self.status = status;
    self.gameType = gameType;
    self.moneyArr = moneyArr;
    self.lhdView.hidden = (gameType == 6 && status != 2) ? NO : YES;
    self.dataSource = @[@"1",@"2",@"3",@"numDeleteIcon",@"4",@"5",@"6",NSLocalizedString(@"充值", nil),@"7",@"8",@"9",NSLocalizedString(@"抢庄", nil),@"switchKeyboardIcon",@"0",money];
    [self showNumKeyboardViewAnimate];
}

- (void)setStatus:(NSInteger)status{
    _status = status;
    [self.qzbtn setTitle:status == 2 ? NSLocalizedString(@"抢庄", nil):NSLocalizedString(@"投注", nil) forState:UIControlStateNormal];
//    self.lhdView.hidden = status == 2 ? YES:NO;
}

- (void)setGameType:(NSInteger)gameType{
    _gameType = gameType;
   
 
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}
- (void)setMoneyArr:(NSArray<NSString *> *)moneyArr{
    _moneyArr = moneyArr;
    [moneyArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx <= self.numBtnArrs.count) {
            [self.numBtnArrs[idx] setTitle:obj forState:UIControlStateNormal];
            self.numBtnArrs[idx].enabled = YES;
        }else{
            self.numBtnArrs[idx].enabled = NO;
        }
    }];
  
}
- (void)setSubViews{
    [self addSubview:self.backdropView];
    [self addSubview:self.containerView];
    self.backdropView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);;
    //内容视图高
    self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, backViewH);
    
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.qzbtn];
    [self.containerView addSubview:self.keyView];
    [self.containerView addSubview:self.tfBgView];
    [self.tfBgView addSubview:self.labBgView];
    [self.labBgView addSubview:self.numLab];
    [self.containerView addSubview:self.lineView];
    [self.containerView addSubview:self.lineView1];
    [self.containerView addSubview:self.lhdView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-(Height_Bar));
        make.height.mas_equalTo(220);
    }];

    [self.qzbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(keyW);
        make.right.mas_equalTo(self.containerView.mas_right).offset(-4);
        make.bottom.equalTo(self.collectionView.mas_bottom).offset(-2);
        make.height.mas_equalTo(105);
    }];
    [self.keyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectionView.mas_top).offset(-15);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(55);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.keyView.mas_bottom).offset(9);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.keyView.mas_top).offset(-9);
    }];
    [self.lhdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.tfBgView.mas_bottom).offset(0.5);
        make.bottom.equalTo(self.lineView1.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    NSArray <NSString*>*nums = @[@"",@"",@"",@""];
    
    CGFloat btnw = (SCREEN_WIDTH - 22) / 4 ;
    [nums enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]init];
        [self.keyView addSubview:btn];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(@"#202020") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerY.equalTo(self.keyView);
            make.width.mas_equalTo(btnw);
            make.left.mas_equalTo(5 + idx * (btnw + 4));
        }];
        [self.numBtnArrs addObj:btn];
        [btn addTarget:self action:@selector(numAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
    NSArray <NSString*>*lhhArr = @[NSLocalizedString(@"龙", nil),NSLocalizedString(@"虎", nil),NSLocalizedString(@"和", nil)];
    CGFloat lhhW = (SCREEN_WIDTH - 18) / 3;
    [lhhArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]init];
        [self.lhdView addSubview:btn];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(@"#202020") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"robChatKeySeletIcon"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"robChatKeySeletIcon"] forState:UIControlStateHighlighted];
        btn.tag = 1000 + idx;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lhdView);
            make.top.mas_equalTo(5);
            make.width.mas_equalTo(lhhW);
            make.left.mas_equalTo(5 + idx * (lhhW + 4));
        }];
        [btn addTarget:self action:@selector(lhhAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [self.tfBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.height.mas_equalTo(55);
    }];
    [self.labBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tfBgView);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.labBgView);
        make.left.mas_equalTo(15);
    }];
}
///抢庄
- (void)btnAction:(UIButton *)btn{
    if (![self.numLab.text isEqualToString:NSLocalizedString(@"请输入金额", nil)]) {
        if ([self.delegate respondsToSelector:@selector(chatRobKeyboardaAmount:status:lhh:)]) {
            [self.delegate chatRobKeyboardaAmount:self.numLab.text status:self.status lhh:self.lhh];
        }
    }
    [self KeyboardDismiss];
}
- (void)lhhAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1000:
            self.lhh = 0;
            break;
        case 1001:
            self.lhh = 1;
            break;
        case 1002:
            self.lhh = 2;
            break;
        default:
            break;
    }
    if ((btn != self.selectedBtn)) {
        self.selectedBtn.selected = NO;
        btn.selected = YES;
        self.selectedBtn = btn;
    }else{
        self.selectedBtn.selected = YES;
    }
}

- (void)numAction:(UIButton *)btn{
    self.numLab.text = btn.titleLabel.text;
    self.numLab.textColor = UIColor.blackColor;
    NSString *text = btn.titleLabel.text;
    unsigned char arrStr[text.length];
    memcpy(arrStr, [text cStringUsingEncoding:NSUTF8StringEncoding], text.length);
    if (self.nums.count > 0) {
        [self.nums removeAllObjects];
    }
    for (int i = 0; i < sizeof(arrStr); i++) {
        [self.nums addObj:[NSString stringWithFormat:@"%c",arrStr[i]]];
    }
    
    if (![self.numLab.text isEqualToString:NSLocalizedString(@"请输入金额", nil)]) {
        if ([self.delegate respondsToSelector:@selector(chatRobKeyboardaAmount:status:lhh:)]) {
            [self.delegate chatRobKeyboardaAmount:self.numLab.text status:self.status lhh:self.lhh];
        }
    }
    [self KeyboardDismiss];
}

- (void)showNumKeyboardViewAnimate {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
     [UIView animateWithDuration:0.35 animations:^{
         self.containerView.frame = CGRectMake(0,(self.gameType == 6 && self.status != 2) ? (SCREEN_HEIGHT - backViewH - lhdHeight) : (SCREEN_HEIGHT - backViewH), SCREEN_WIDTH, (self.gameType == 6 && self.status != 2)? backViewH + lhdHeight: backViewH);
      }];
}
- (void)KeyboardDismiss {
    [UIView animateWithDuration:0.35 animations:^{
        self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, backViewH );
    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYRobChatKeyBordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FYRobChatKeyBordCellID forIndexPath:indexPath];
    if (indexPath.row == 3 || indexPath.row == 12) {
        cell.imgView.hidden = NO;
        [cell.imgView setImage:[UIImage imageNamed:self.dataSource[indexPath.row]]];
    }else {
        cell.numLab.text = self.dataSource[indexPath.row];
        cell.numLab.hidden = NO;
        if (indexPath.row == 7 || indexPath.row == 11) {
            cell.numLab.font = [UIFont systemFontOfSize:18];
        }
        if (indexPath.row == 11) {
            cell.hidden = YES;
        }
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.row + 1) % 4 == 0) {
        return CGSizeMake(keyW , 54);
    }else{
        return CGSizeMake(cellW - 4, 54);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 5, 3, 5);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.row ) {
        case 3://删除
        {
            if (self.nums.count > 0) {
                [self.nums removeLastObject];
                self.numLab.textColor = UIColor.blackColor;
                self.numLab.text = [self.nums componentsJoinedByString:@""];
                if (self.numLab.text.length == 0) {
                    self.numLab.text = NSLocalizedString(@"请输入金额", nil);
                    self.numLab.textColor = HexColor(@"#C5C5C5");
                }
            }else{
                self.numLab.text = NSLocalizedString(@"请输入金额", nil);
                self.numLab.textColor = HexColor(@"#C5C5C5");
            }
        }
            break;
        case 7://充值
            NSLog(NSLocalizedString(@"充值", nil));
            if ([self.delegate respondsToSelector:@selector(goToPay)]) {
                [self KeyboardDismiss];
                [self.delegate goToPay];
            }
            break;
        case 12://切换键盘
            [self KeyboardDismiss];
            break;
        case 0://1
        case 1://2
        case 2://3
        case 4://4
        case 5://5
        case 6://6
        case 8://7
        case 9://8
        case 10://9
        case 13://0
        {
            [self.nums addObj:self.dataSource[indexPath.row]];
            self.numLab.textColor = UIColor.blackColor;
            self.numLab.text = [self.nums componentsJoinedByString:@""];
        }
            break;
        case 14://+200
        {
            int num = [self.numLab.text intValue] + [self.dataSource[indexPath.row] intValue];
            self.numLab.text = [NSString stringWithFormat:@"%d",num];
            self.numLab.textColor = UIColor.blackColor;
            NSString *text = self.numLab.text;
            unsigned char arrStr[text.length];
            memcpy(arrStr, [text cStringUsingEncoding:NSUTF8StringEncoding], text.length);
            if (self.nums.count > 0) {
                [self.nums removeAllObjects];
            }
            for (int i = 0; i < sizeof(arrStr); i++) {
                [self.nums addObj:[NSString stringWithFormat:@"%c",arrStr[i]]];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 懒加载
- (UIView *)backdropView{
    if (!_backdropView) {
        _backdropView = [[UIView alloc]init];
        _backdropView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(KeyboardDismiss)];
        [_backdropView addGestureRecognizer:tap];
    }
    return _backdropView;
}

- (UIView *)containerView{
    if (!_containerView) {//内容视图,
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = HexColor(@"#EEEEEE");
    }
    return _containerView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexColor(@"#EEEEEE");
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[FYRobChatKeyBordCell class] forCellWithReuseIdentifier:FYRobChatKeyBordCellID];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}
- (NSMutableArray<UIButton *> *)btnArrs{
    if (!_btnArrs) {
        _btnArrs = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArrs;
}
- (NSMutableArray<UIButton *> *)numBtnArrs{
    if (!_numBtnArrs) {
        _numBtnArrs = [NSMutableArray arrayWithCapacity:0];
    }
    return _numBtnArrs;
}
- (UIView *)keyView{
    if (!_keyView) {
        _keyView = [[UIView alloc]init];
    }
    return _keyView;
}
- (UIView *)tfBgView{
    if (!_tfBgView) {
        _tfBgView = [[UIView alloc]init];
        _tfBgView.backgroundColor = HexColor(@"#F6F6F6");
    }
    return _tfBgView;
}
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc]init];
        _numLab.font = [UIFont systemFontOfSize:16];
        _numLab.layer.masksToBounds = YES;
        _numLab.layer.cornerRadius = 4;
        _numLab.text = NSLocalizedString(@"请输入金额", nil);
        _numLab.textColor = HexColor(@"#C5C5C5");
        _numLab.backgroundColor = UIColor.whiteColor;
    }
    return _numLab;
}
- (UIView *)labBgView{
    if (!_labBgView) {
        _labBgView = [[UIView alloc]init];
        _labBgView.backgroundColor = UIColor.whiteColor;
        _labBgView.layer.masksToBounds = YES;
        _labBgView.layer.cornerRadius = 4;
    }
    return _labBgView;
}
- (NSMutableArray<NSString *> *)nums{
    if (!_nums) {
        _nums = [NSMutableArray arrayWithCapacity:0];
    }
    return _nums;
}

- (UIButton *)qzbtn{
    if (!_qzbtn) {
        _qzbtn = [[UIButton alloc]init];
        _qzbtn.layer.masksToBounds = YES;
        _qzbtn.layer.cornerRadius = 8;
        _qzbtn.backgroundColor = HexColor(@"#CB332D");
        [_qzbtn setTitle:NSLocalizedString(@"抢庄", nil) forState:UIControlStateNormal];
        [_qzbtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_qzbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qzbtn;
}
- (UIView *)lhdView{
    if (!_lhdView) {
        _lhdView = [[UIView alloc]init];
        _lhdView.backgroundColor = HexColor(@"#F6F6F6");
    }
    return _lhdView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#D9D9D9");
    }
    return _lineView;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#D9D9D9");
    }
    return _lineView1;
}
@end
