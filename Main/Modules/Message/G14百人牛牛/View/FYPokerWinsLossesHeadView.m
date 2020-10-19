//
//  FYPokerWinsLossesHeadView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPokerWinsLossesHeadView.h"
#import "FYBestWinsLossesModel.h"
#import "FYPockerView.h"
#import "FYPokerHistoryHubView.h"
#import "FYBestNiuNiuHistoryModel.h"
#import "FYBaiRenNNPockerDataHelper.h"

@interface FYPokerWinsLossesHeadView()
@property (nonatomic , strong) UIImageView *bgLeftImgView;
@property (nonatomic , strong) UIImageView *bgVSImgView;
@property (nonatomic , strong) UIImageView *vsImgView;
@property (nonatomic , strong) UIImageView *bgRightImgView;
@property (nonatomic , strong) UIImageView *btnBgRightView;
@property (nonatomic , strong) UIButton *rightBtn;
@property (nonatomic , strong) NSMutableArray <FYPockerView*>*bluePockerView;
@property (nonatomic , strong) NSMutableArray <FYPockerView*>*redPockerView;

@property (nonatomic , strong) UILabel *blueTitleLab;
@property (nonatomic , strong) UILabel *blueNiuLab;
@property (nonatomic , strong) UIImageView *blueVictoryImgView; ///胜利的图标

@property (nonatomic , strong) UILabel *redTitleLab;
@property (nonatomic , strong) UILabel *redNiuLab;
@property (nonatomic , strong) UIImageView *redVictoryImgView; ///胜利的图标

@property (nonatomic, assign) CGFloat duration; // 动画时间
@property (nonatomic, assign) BOOL isFlipCardsAnimation;
@property (nonatomic, assign) NSInteger flipCardsIndex; // 记录翻第几张牌
@property (nonatomic, assign) NSInteger flipCardsCount; // 牌的总数量5
@property (nonatomic, strong) NSMutableArray *flipCardsResultArray; // 去重复存储通知内容

///历史数据
@property (nonatomic , strong) NSArray<FYBestNiuNiuHistoryData*> *dataSource;

@end

@implementation FYPokerWinsLossesHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _duration = 0.4;
        _flipCardsIndex = 0;
        _flipCardsCount = 5;
        self.isFlipCardsAnimation = NO;
        [self initSubView];
        [self getBestNiuNiuNotification];
    }
    return self;
}
- (void)getBestNiuNiuNotification{
    [NOTIF_CENTER addObserver:self
           selector:@selector(didNotificationBestNiuNiuContent:)
               name:kNotificationGroupOfRobNiuNiuContent
             object:nil];
}
///第一次加载的数据
- (void)setResult:(FYBestWinsLossesFlopResult *)result{
    _result = result;
    if (!POCKER_DATA_HELPER.flopResult) {
        POCKER_DATA_HELPER.flopResult = result;
    }
    [self didFlipPokersWithResult:POCKER_DATA_HELPER.flopResult flopType:1 animation:NO];
}
///IM获取的数据
- (void)didNotificationBestNiuNiuContent:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSDictionary *dataDict = [dict[@"data"][@"content"] mj_JSONObject];
    if ([dataDict[@"type"] integerValue] == 63) {
        FYBestWinsLossesModel *model = [FYBestWinsLossesModel mj_objectWithKeyValues:dataDict[@"data"]];
        [self didFlipPokersWithResult:model.flopResult flopType:model.flopType animation:YES];
    }
}

#pragma mark - 动画效果

// 执行翻转动画后，减少一条数据
- (NSDictionary *)didFlipCardsResultArrayFirstObj
{
    NSDictionary *firstCardsObject;
    NSMutableArray *filterFlipCardsResultArray = [NSMutableArray array];
    for (NSInteger idx = 0; idx < self.flipCardsResultArray.count; idx ++) {
        NSDictionary *cardsObject = [self.flipCardsResultArray objectAtIndex:idx];
        if (0 == idx) {
            firstCardsObject = cardsObject;
        } else {
            [filterFlipCardsResultArray addObj:cardsObject];
        }
    }
    self.flipCardsResultArray = filterFlipCardsResultArray;
    return firstCardsObject;
}
// 翻转动画列表，处理新接收到的数据
- (NSMutableArray *)didFlipCardsResultArray:(FYBestWinsLossesFlopResult *)result flopType:(NSInteger)flopType
{
    NSMutableArray *filterFlipCardsResultArray = [NSMutableArray arrayWithArray:self.flipCardsResultArray];
    if (self.flipCardsResultArray.count <= 0) {
        if (0 == flopType || !result) { // 反面
            NSDictionary *lastCardsDict = @{ @"flopType" : @(0) };
            [filterFlipCardsResultArray addObj:lastCardsDict];
        } else {
            NSDictionary *lastCardsDict = @{
                @"flopType" : @(1),
                @"flopResult" : result,
                @"redPokers" : [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.red.pokers],
                @"bluePokers" : [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.blue.pokers]
            };
            [filterFlipCardsResultArray addObj:lastCardsDict];
        }
    } else {
        if (0 == flopType || !result) { // 反面
            NSDictionary *cardsObject = self.flipCardsResultArray.lastObject;
            NSUInteger lastFlopType = [cardsObject integerForKey:@"flopType"];
            if (1 == lastFlopType) {
                NSDictionary *lastCardsDict = @{ @"flopType" : @(0) };
                [filterFlipCardsResultArray addObj:lastCardsDict];
            }
        } else {
            NSDictionary *cardsObject = self.flipCardsResultArray.lastObject;
            NSUInteger lastFlopType = [cardsObject integerForKey:@"flopType"];
            NSDictionary *lastCardsDict = @{
                @"flopType" : @(1),
                @"flopResult" : result,
                @"redPokers" : [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.red.pokers],
                @"bluePokers" : [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.blue.pokers]
            };
            if (0 == lastFlopType) {
                [filterFlipCardsResultArray addObj:lastCardsDict];
            } else {
                if (![self didFlipCardsObject:cardsObject isEqualToResult:result]) {
                    [filterFlipCardsResultArray replaceObjectAtIndex:filterFlipCardsResultArray.count-1 withObject:lastCardsDict];
                } else {
                    [filterFlipCardsResultArray replaceObjectAtIndex:filterFlipCardsResultArray.count-1 withObject:lastCardsDict];
                }
            }
        }
    }
    return filterFlipCardsResultArray;
}

// 新牌与旧牌是否相等
- (BOOL)didFlipCardsObject:(NSDictionary *)cardsObject isEqualToResult:(FYBestWinsLossesFlopResult *)result
{
    NSArray<FYBestWinsLossesPokers*> *redPokers = [cardsObject arrayForKey:@"redPokers"];
    NSArray<FYBestWinsLossesPokers*> *bluePokers = [cardsObject arrayForKey:@"bluePokers"];
    NSArray<FYBestWinsLossesPokers*> *redNewPokers = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.red.pokers];
    NSArray<FYBestWinsLossesPokers*> *blueNewPokers = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.blue.pokers];
    if (bluePokers.count != blueNewPokers.count || redPokers.count != redNewPokers.count) {
        return NO;
    }
    for (NSInteger idx = 0; idx < bluePokers.count && idx < redPokers.count; idx ++) {
        FYBestWinsLossesPokers *bluePoker = [bluePokers objectAtIndex:idx];
        FYBestWinsLossesPokers *redPoker = [redPokers objectAtIndex:idx];
        FYBestWinsLossesPokers *blueNewPoker = [blueNewPokers objectAtIndex:idx];
        FYBestWinsLossesPokers *redNewPoker = [redNewPokers objectAtIndex:idx];
        if (![bluePoker.text isEqualToString:blueNewPoker.text]
            || ![redPoker.text isEqualToString:redNewPoker.text]) {
            return NO;
        }
    }
    return YES;
}

- (void)didFlipPokersWithResult:(FYBestWinsLossesFlopResult *)result flopType:(NSInteger)flopType animation:(BOOL)animation
{
#if DEBUG
    NSMutableArray *bluePokers = [NSMutableArray array];
    NSArray <FYBestWinsLossesPokers*> *blueArr = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.blue.pokers];
    for (NSInteger index = 0; index < blueArr.count; index ++) {
        FYBestWinsLossesPokers *bluePoker = index < blueArr.count ? blueArr[index] : nil;
        [bluePokers addObj:bluePoker.text];
    }
    NSMutableArray *redPokers = [NSMutableArray array];
    NSArray <FYBestWinsLossesPokers*> *redArr = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.red.pokers];
    for (NSInteger index = 0; index < redArr.count; index ++) {
        FYBestWinsLossesPokers *redPoker = index < redArr.count ? redArr[index] : nil;
        [redPokers addObj:redPoker.text];
    }
    FYLog(@"[蓝方][红方] => 显示[%ld]", flopType);
    if (bluePokers.count > 0 || redPokers.count > 0) {
        FYLog(@"蓝方 => %@", [bluePokers componentsJoinedByString:@"|"]);
        FYLog(@"红方 => %@", [redPokers componentsJoinedByString:@"|"]);
    }
#endif
    
    POCKER_DATA_HELPER.flopResult = result;
    self.flipCardsResultArray = [self didFlipCardsResultArray:result flopType:flopType];
    if (animation) {
        if (!self.isFlipCardsAnimation) {
            [self flipPokerAnimationWithflipCardsResultArray];
        }
    } else { // 第一次加载，无需动画，直接显示
        if (self.flipCardsResultArray.count > 0) {
            NSDictionary *flipCardsResultArrayFirstObject = [self didFlipCardsResultArrayFirstObj];
            NSUInteger flopType = [flipCardsResultArrayFirstObject integerForKey:@"flopType"];
            FYBestWinsLossesFlopResult *flopResult = [flipCardsResultArrayFirstObject objectForKey:@"flopResult"];
            [self flipPokerAnimationNoWithFlopResult:flopResult flopType:flopType];
        }
    }
}

- (void)flipPokerAnimationWithflipCardsResultArray
{
    if (self.flipCardsResultArray.count > 0) {
        self.flipCardsIndex = 0;
        self.isFlipCardsAnimation = YES;
        NSDictionary *flipCardsResultArrayFirstObject = [self didFlipCardsResultArrayFirstObj];
        NSUInteger flopType = [flipCardsResultArrayFirstObject integerForKey:@"flopType"];
        FYBestWinsLossesFlopResult *flopResult = [flipCardsResultArrayFirstObject objectForKey:@"flopResult"];
        [self flipPokerAnimationYesWithFlopResult:flopResult flopType:flopType];
    }
}

- (void)flipPokerAnimationNoWithFlopResult:(FYBestWinsLossesFlopResult *)result flopType:(NSInteger)flopType
{
    self.isFlipCardsAnimation = YES;
    if (flopType == 1) {//正面
        NSArray <FYBestWinsLossesPokers*> *blueArr = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.blue.pokers];
        NSArray <FYBestWinsLossesPokers*> *redArr = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.red.pokers];
        dispatch_main_async_safe(^{
            [self flipCardsAnimationNoBluePokers:blueArr redPokers:redArr flopType:flopType];
            self.blueNiuLab.text = result.blue.niuShuName;
            self.redNiuLab.text = result.red.niuShuName;
            if (result.winSide == 1) {//蓝方胜
                self.blueVictoryImgView.hidden = NO;
                self.redVictoryImgView.hidden = YES;
            } else {
                self.blueVictoryImgView.hidden = YES;
                self.redVictoryImgView.hidden = NO;
            }
            self.isFlipCardsAnimation = NO;
            //
            [self flipPokerAnimationWithflipCardsResultArray];
        });
    } else {
        dispatch_main_async_safe(^{
            [self flipCardsAnimationNoBluePokers:nil redPokers:nil flopType:flopType];
            self.blueNiuLab.text = @"--";
            self.redNiuLab.text = @"--";
            self.blueVictoryImgView.hidden = YES;
            self.redVictoryImgView.hidden = YES;
            self.isFlipCardsAnimation = NO;
            //
            [self flipPokerAnimationWithflipCardsResultArray];
        });
    }
}

- (void)flipPokerAnimationYesWithFlopResult:(FYBestWinsLossesFlopResult *)result flopType:(NSInteger)flopType
{
    if (flopType == 1) {//正面
        NSArray <FYBestWinsLossesPokers*> *blueArr = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.blue.pokers];
        NSArray <FYBestWinsLossesPokers*> *redArr = [FYBestWinsLossesPokers mj_objectArrayWithKeyValuesArray:result.red.pokers];
        dispatch_main_async_safe(^{
            [self flipCardsAnimationYesBluePokers:blueArr redPokers:redArr flopType:flopType];
            self.blueNiuLab.text = result.blue.niuShuName;
            self.redNiuLab.text = result.red.niuShuName;
            if (result.winSide == 1) {//蓝方胜
                self.blueVictoryImgView.hidden = NO;
                self.redVictoryImgView.hidden = YES;
            } else {
                self.blueVictoryImgView.hidden = YES;
                self.redVictoryImgView.hidden = NO;
            }
        });
    } else {
        dispatch_main_async_safe(^{
            [self flipCardsAnimationYesBluePokers:nil redPokers:nil flopType:flopType];
            self.blueNiuLab.text = @"--";
            self.redNiuLab.text = @"--";
            self.blueVictoryImgView.hidden = YES;
            self.redVictoryImgView.hidden = YES;
        });
    }
}

// 翻转牌 - 无动画
- (void)flipCardsAnimationNoBluePokers:(NSArray<FYBestWinsLossesPokers *> *)bluePokers redPokers:(NSArray<FYBestWinsLossesPokers *> *)redPokers flopType:(NSInteger)flopType
{
    for (NSInteger idx = 0; idx < self.flipCardsCount; idx ++) {
        FYPockerView *blueCardsView = idx < self.bluePockerView.count ? self.bluePockerView[idx] : nil;
        FYPockerView *redCardsView = idx < self.redPockerView.count ? self.redPockerView[idx] : nil;
        FYBestWinsLossesPokers *bluePoker = idx < bluePokers.count ? bluePokers[idx] : nil;
        FYBestWinsLossesPokers *redPoker = idx < redPokers.count ? redPokers[idx] : nil;
        [blueCardsView setImgViewImgWithPokers:bluePoker flopType:flopType];
        [redCardsView setImgViewImgWithPokers:redPoker flopType:flopType];
    }
}

// 翻转牌 - 有动画
- (void)flipCardsAnimationYesBluePokers:(NSArray<FYBestWinsLossesPokers *> *)bluePokers redPokers:(NSArray<FYBestWinsLossesPokers *> *)redPokers flopType:(NSInteger)flopType
{
    FYPockerView *blueCardsView = self.flipCardsIndex < self.bluePockerView.count ? self.bluePockerView[self.flipCardsIndex] : nil;
    FYPockerView *redCardsView = self.flipCardsIndex < self.redPockerView.count ? self.redPockerView[self.flipCardsIndex] : nil;
    [self flipCardsAnimationYesBlueCardsView:blueCardsView BluePokers:bluePokers redCardsView:redCardsView redPokers:redPokers flopType:flopType];
}

- (void)flipCardsAnimationYesBlueCardsView:(FYPockerView *)blueCardsView
                             BluePokers:(NSArray<FYBestWinsLossesPokers *> *)bluePokers
                           redCardsView:(FYPockerView *)redCardsView
                              redPokers:(NSArray<FYBestWinsLossesPokers *> *)redPokers
                               flopType:(NSInteger)flopType
{
    FYBestWinsLossesPokers *bluePoker = self.flipCardsIndex < bluePokers.count ? bluePokers[self.flipCardsIndex] : nil;
    FYBestWinsLossesPokers *redPoker = self.flipCardsIndex < redPokers.count ? redPokers[self.flipCardsIndex] : nil;
    
    UIViewAnimationOptions option = UIViewAnimationOptionTransitionFlipFromLeft;
    
    if (flopType == blueCardsView.flopType) {
        [blueCardsView setImgViewImgWithPokers:bluePoker flopType:flopType];
    } else {
        [UIView transitionWithView:blueCardsView duration:self.duration options:option animations:^{
            [blueCardsView setImgViewImgWithPokers:bluePoker flopType:flopType];
        } completion:^(BOOL finished) {

        }];
    }
    
    if (flopType == redCardsView.flopType) {
        [redCardsView setImgViewImgWithPokers:redPoker flopType:flopType];
        {
            self.flipCardsIndex ++;
            if (self.flipCardsIndex < self.flipCardsCount) {
                self.isFlipCardsAnimation = YES;
                [self flipCardsAnimationYesBluePokers:bluePokers redPokers:redPokers flopType:flopType];
            } else if (self.flipCardsResultArray.count > 0) {
                [self flipPokerAnimationWithflipCardsResultArray];
            } else {
                self.flipCardsIndex = 0;
                self.isFlipCardsAnimation = NO;
            }
        }
    } else {
        [UIView transitionWithView:redCardsView duration:self.duration options:option animations:^{
            [redCardsView setImgViewImgWithPokers:redPoker flopType:flopType];
        } completion:^(BOOL finished) {
            self.flipCardsIndex ++;
            if (self.flipCardsIndex < self.flipCardsCount) {
                self.isFlipCardsAnimation = YES;
                [self flipCardsAnimationYesBluePokers:bluePokers redPokers:redPokers flopType:flopType];
            } else if (self.flipCardsResultArray.count > 0) {
                [self flipPokerAnimationWithflipCardsResultArray];
            } else {
                self.flipCardsIndex = 0;
                self.isFlipCardsAnimation = NO;
            }
        }];
    }
}

#pragma mark - 历史记录
///历史数据
- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuHistory parameters:dict success:^(id object) {
        if ([[object mj_JSONObject][@"code"] intValue] == 0) {
            FYBestNiuNiuHistoryModel *model = [FYBestNiuNiuHistoryModel mj_objectWithKeyValues:[object mj_JSONObject]];
            self.dataSource = [FYBestNiuNiuHistoryData mj_objectArrayWithKeyValuesArray:model.data];
        }
    } failure:^(id object) {
        
    }];
}

#pragma mark - 点击->历史记录
- (void)downloadUnder{
    [self clickFlipExpand:self.rightBtn];
}
///点击箭头翻转,记录展开
- (void)clickFlipExpand:(UIButton*)btn{
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeRotation(-M_PI - 0.00001);
    }];
    [FYPokerHistoryHubView showWithDataSource:self.dataSource Block:^{
        [UIView animateWithDuration:0.25 animations:^{
            btn.transform = CGAffineTransformIdentity;
        }];
    }];
}
- (void)initSubView{
    [self addSubview:self.bgRightImgView];
    [self addSubview:self.bgVSImgView];
    [self addSubview:self.bgLeftImgView];
    [self addSubview:self.btnBgRightView];
    [self.btnBgRightView addSubview:self.rightBtn];
    [self addSubview:self.vsImgView];
    [self.bgLeftImgView addSubview:self.blueTitleLab];
    [self.bgLeftImgView addSubview:self.blueNiuLab];
    [self.bgLeftImgView addSubview:self.blueVictoryImgView];
    
    [self.bgRightImgView addSubview:self.redTitleLab];
    [self.bgRightImgView addSubview:self.redNiuLab];
    [self.bgRightImgView addSubview:self.redVictoryImgView];
    ///图片像素总宽度 左-vs-右-按钮
    CGFloat imgPsW = 476 + 82 + 461 + 61;
    //左边图片占总图片比例
    CGFloat leftImgAbs = 476.0 / imgPsW;
    //vs图片占总图片比例
    CGFloat vsImgAbs = 82.0 / imgPsW;
    //右边图片占总图片比例
    CGFloat rightImgAbs = 461.0 / imgPsW;
    //右边按钮占总图片比例
    CGFloat btnAbs = 61.0 / imgPsW;
    [self.bgLeftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(kScreenWidth * leftImgAbs);
    }];
    [self.bgVSImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(self.bgLeftImgView.mas_right);
        make.width.mas_equalTo(kScreenWidth * vsImgAbs);
    }];
    [self.vsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgVSImgView);
        make.height.equalTo(self.bgVSImgView.mas_height);
        make.width.mas_equalTo(pokerWinsLossesHeadViewHigh);
    }];
    [self.bgRightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(self.bgVSImgView.mas_right);
        make.width.mas_equalTo(kScreenWidth * rightImgAbs);
    }];
    [self.btnBgRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.right.equalTo(self);
        make.width.mas_equalTo(kScreenWidth * btnAbs);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.btnBgRightView.mas_width);
        make.center.equalTo(self.btnBgRightView);
    }];
    [self.blueTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgLeftImgView);
        make.top.mas_equalTo(5);
    }];
    [self.blueNiuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgLeftImgView);
        make.bottom.equalTo(self.bgLeftImgView.mas_bottom).offset(-5);
    }];
    [self.redTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.bgRightImgView);
         make.top.mas_equalTo(5);
     }];
     [self.redNiuLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.bgRightImgView);
         make.bottom.equalTo(self.bgRightImgView.mas_bottom).offset(-5);
     }];
    [self.blueVictoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(pokerWinsLossesHeadViewHigh / 2);
        make.top.right.equalTo(self.bgLeftImgView);
    }];
    [self.redVictoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.height.mas_equalTo(pokerWinsLossesHeadViewHigh / 2);
          make.top.right.equalTo(self.bgRightImgView);
      }];
    CGFloat spacing = 3;
    CGFloat bluePockW = (kScreenWidth * leftImgAbs - spacing * 9) / 5;
    CGFloat pockH = pokerWinsLossesHeadViewHigh / 3;
    CGFloat redPockW = (kScreenWidth * rightImgAbs - spacing * 8) / 5;
    for (int i = 0; i< 5; i++) {
        FYPockerView *blueView = [[FYPockerView alloc]init];
        blueView.tag = 100+i;
        [self.bgLeftImgView addSubview:blueView];
        [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(pockH);
            make.left.mas_equalTo(spacing * 3 + i * (spacing + bluePockW));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(bluePockW);
        }];
        [self.bluePockerView addObj:blueView];
        FYPockerView *redView = [[FYPockerView alloc]init];
        redView.tag = 1000+i;
        [self.bgRightImgView addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(pockH);
            make.left.mas_equalTo(spacing * 2 + i * (spacing + redPockW));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(redPockW);
        }];
        [self.redPockerView addObj:redView];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadUnder)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - 懒加载
- (UIImageView *)bgLeftImgView{
    if (!_bgLeftImgView) {
        _bgLeftImgView = [[UIImageView alloc]init];
        _bgLeftImgView.image = [UIImage imageNamed:@"bgLeftBest_icon"];
    }
    return _bgLeftImgView;
}
- (UIImageView *)bgVSImgView{
    if (!_bgVSImgView) {
        _bgVSImgView = [[UIImageView alloc]init];
        _bgVSImgView.image = [UIImage imageNamed:@"bgVSBest_icon"];
    }
    return _bgVSImgView;
}
- (UIImageView *)bgRightImgView{
    if (!_bgRightImgView) {
        _bgRightImgView = [[UIImageView alloc]init];
        _bgRightImgView.image = [UIImage imageNamed:@"bgRightBest_icon"];
    }
    return _bgRightImgView;
}
- (UIImageView *)vsImgView{
    if (!_vsImgView) {
        _vsImgView = [[UIImageView alloc]init];
        _vsImgView.image = [UIImage imageNamed:@"vsBest_icon"];
    }
    return _vsImgView;
}
- (UIImageView *)btnBgRightView{
    if (!_btnBgRightView) {
        _btnBgRightView = [[UIImageView alloc]init];
        _btnBgRightView.image = [UIImage imageNamed:@"bgBtnBest_icon"];
        _btnBgRightView.userInteractionEnabled = YES;
    }
    return _btnBgRightView;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setImage:[UIImage imageNamed:@"btnBest_down_icon"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickFlipExpand:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (NSMutableArray<FYPockerView *> *)bluePockerView{
    if (!_bluePockerView) {
        _bluePockerView = [NSMutableArray<FYPockerView*> array];
    }
    return _bluePockerView;
}
- (NSMutableArray<FYPockerView *> *)redPockerView{
    if (!_redPockerView) {
        _redPockerView = [NSMutableArray<FYPockerView*> array];
    }
    return _redPockerView;
}
- (UILabel *)blueTitleLab{
    if (!_blueTitleLab) {
        _blueTitleLab = [[UILabel alloc]init];
        _blueTitleLab.textColor = UIColor.whiteColor;
        _blueTitleLab.font = [UIFont systemFontOfSize:12];
        _blueTitleLab.text = NSLocalizedString(@"蓝方", nil);
    }
    return _blueTitleLab;
}
- (UILabel *)blueNiuLab{
    if (!_blueNiuLab) {
        _blueNiuLab = [[UILabel alloc]init];
        _blueNiuLab.textColor = HexColor(@"#FEEE37");
        _blueNiuLab.font = [UIFont systemFontOfSize:12];
        _blueNiuLab.text = @"--";
    }
    return _blueNiuLab;
}

- (UIImageView *)blueVictoryImgView{
    if (!_blueVictoryImgView) {
        _blueVictoryImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bastNiuNiu_victory_icon"]];
        _blueVictoryImgView.hidden = YES;
    }
    return _blueVictoryImgView;
}
- (UILabel *)redTitleLab{
    if (!_redTitleLab) {
        _redTitleLab = [[UILabel alloc]init];
        _redTitleLab.textColor = UIColor.whiteColor;
        _redTitleLab.font = [UIFont systemFontOfSize:12];
        _redTitleLab.text = NSLocalizedString(@"红方", nil);
    }
    return _redTitleLab;
}
- (UILabel *)redNiuLab{
    if (!_redNiuLab) {
        _redNiuLab = [[UILabel alloc]init];
        _redNiuLab.textColor = HexColor(@"#FEEE37");
        _redNiuLab.font = [UIFont systemFontOfSize:12];
        _redNiuLab.text = @"--";
    }
    return _redNiuLab;
}
- (UIImageView *)redVictoryImgView{
    if (!_redVictoryImgView) {
        _redVictoryImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bastNiuNiu_victory_icon"]];
        _redVictoryImgView.hidden = YES;
    }
    return _redVictoryImgView;
}
- (NSMutableArray *)flipCardsResultArray{
    if (!_flipCardsResultArray) {
        _flipCardsResultArray = [NSMutableArray array];
    }
    return _flipCardsResultArray;
}
- (void)dealloc{
    NSLog(@"%@销毁",self);
    [NOTIF_CENTER removeObserver:self];
}
@end
