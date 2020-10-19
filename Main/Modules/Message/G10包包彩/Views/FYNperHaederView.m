//
//  FYNperHaederView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYNperHaederView.h"
#import "FYBegLotteryHistoryModel.h"
#import "FYBagLotteryHistoryView.h"
#import "FYBagBagCowRecordObject.h"
@interface FYNperHaederView ()
@property (nonatomic , strong) NSArray <FYBegLotteryHistoryData*>*dataArr;
//期数
@property (nonatomic , strong) UILabel *nperLab;
@property (nonatomic , strong) NSMutableArray <UILabel*>*labArr;
@property (nonatomic , strong) UIButton *hubBtn;
@property (nonatomic , strong) NSArray <FYBagBagCowRecordData*>*recordDataArr;
@property (nonatomic , strong) NSMutableArray <UILabel*>*labCowArr;
@end
@implementation FYNperHaederView
- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    if (self.itemType == GroupTemplate_N11_BagBagCow) {//包包牛
        [self.labArr enumerateObjectsUsingBlock:^(UILabel * lab, NSUInteger idx, BOOL * _Nonnull stop) {
            lab.hidden = YES;
        }];
        [NET_REQUEST_MANAGER getBegBagCowRecordDict:dict success:^(id object) {
            if ([object[@"code"] integerValue] == 0) {
                self.recordDataArr = [FYBagBagCowRecordData mj_objectArrayWithKeyValuesArray:object[@"data"]];
            }
        } fail:nil];
        
    }else {//包包彩
        [self.labCowArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
            lab.hidden = YES;
        }];
        NSMutableArray *arr = [NSMutableArray array];
        [NET_REQUEST_MANAGER getBegLotteryHistoryDict:dict success:^(id object) {
            if ([object[@"code"] integerValue] == 0) {
                NSArray <FYBegLotteryHistoryData*> *datas = [FYBegLotteryHistoryData mj_objectArrayWithKeyValuesArray:object[@"data"]];
                [datas enumerateObjectsUsingBlock:^(FYBegLotteryHistoryData * _Nonnull data, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![data.typeName isEqualToString:NSLocalizedString(@"未开奖", nil)]) {
                        [arr addObj:data];
                    }
                }];
                self.dataArr = arr;
            }
        } fail:nil];
    }
}
- (void)setRecordDataArr:(NSArray<FYBagBagCowRecordData *> *)recordDataArr{
    _recordDataArr = recordDataArr;
    if (recordDataArr.count == 0) {
        self.nperLab.text = NSLocalizedString(@"正在开奖,请稍后..", nil);
    }
    [recordDataArr enumerateObjectsUsingBlock:^(FYBagBagCowRecordData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            self.nperLab.text = [NSString stringWithFormat:NSLocalizedString(@"%zd期", nil),obj.gameNumber];
            [self.labCowArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
                switch (idx) {
                    case 0:
                        lab.text = [NSString stringWithFormat:NSLocalizedString(@"庄|%@", nil),[FYBagBagCowTool setCowNumber:obj.bankerNumber]];
                        break;
                    case 1:
                        lab.text = [NSString stringWithFormat:NSLocalizedString(@"闲|%@", nil),[FYBagBagCowTool setCowNumber:obj.playerNumber]];
                        break;
                    case 2:
                        lab.attributedText = [FYBagBagCowTool setWinner:obj.winner];
                        break;
                    default:
                        break;
                }
            }];
        }
    }];
}
- (void)setDataArr:(NSArray<FYBegLotteryHistoryData *> *)dataArr{
    _dataArr = dataArr;
    if (dataArr.count == 0) {
        self.nperLab.text = NSLocalizedString(@"正在开奖,请稍后..", nil);
        [self.labArr enumerateObjectsUsingBlock:^(UILabel * lab, NSUInteger idx, BOOL * _Nonnull stop) {
            lab.hidden = YES;
        }];
        return;
    }
  
    [dataArr enumerateObjectsUsingBlock:^(FYBegLotteryHistoryData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            self.nperLab.text = [NSString stringWithFormat:NSLocalizedString(@"%@期", nil),obj.gameNumber];
            NSArray <NSString*>*winNumbers = [obj.winNumbers componentsSeparatedByString:@","];
            [self.labArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 6) {
                    self.labArr[6].text = obj.typeName;
                }else{
                    if (winNumbers.count > idx) {
                        lab.hidden = NO;
                        lab.backgroundColor = [FYBegLotteryTool setLabBackgroundColor:winNumbers[idx]];
                        lab.text = winNumbers[idx];
                    }else{
                        lab.hidden = YES;
                    }
                }
            }];
        }
    }];
}
- (void)downloadUnder{
    if (self.itemType == GroupTemplate_N11_BagBagCow) {
        if (self.recordDataArr.count > 0) {
            [FYBagLotteryHistoryView showBagBagCowHistoryViewWith:self.recordDataArr type:GroupTemplate_N11_BagBagCow];
        }
    }else{
        
        if (self.dataArr.count > 0) {
            [FYBagLotteryHistoryView showHistoryViewWithList:self.dataArr];
        }
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubview];
    }
    return self;
}
- (void)initSubview{
    [self addSubview:self.nperLab];
    [self addSubview:self.hubBtn];
    [self.nperLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self);
    }];
    [self.hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.mas_height);
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right);
    }];
    for (int i = 0; i < 7; i++) {
        UILabel *lab = [[UILabel alloc]init];
        if (i < 6) {
            lab.layer.masksToBounds = YES;
            lab.layer.cornerRadius = 5;
            lab.layer.borderColor = HexColor(@"#202020").CGColor;
            lab.layer.borderWidth = 1.5;
            lab.textColor = UIColor.whiteColor;
        }else{
            lab.textColor = HexColor(@"#333333");
        }
        lab.font = [UIFont boldSystemFontOfSize:16];
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
            if (i < 6) {
                make.width.mas_equalTo(25);
                make.left.equalTo(self.nperLab.mas_right).offset(10 + i * 29);
            }else{
                make.left.equalTo(self.nperLab.mas_right).offset(10 + i * 31);
            }
            make.centerY.equalTo(self);
        }];
        [self.labArr addObj:lab];
    }
    
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = HexColor(@"#333333");
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        [self.labCowArr addObj:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.nperLab.mas_right).offset(20 + i * 75);
            make.width.mas_equalTo(70);
        }];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadUnder)];
    [self addGestureRecognizer:tapGesture];
}

- (UILabel *)nperLab{
    if (!_nperLab) {
        _nperLab = [[UILabel alloc]init];
        _nperLab.textColor = HexColor(@"#333333");
        _nperLab.font = [UIFont systemFontOfSize:15];
    }
    return _nperLab;
}
- (NSMutableArray<UILabel *> *)labArr{
    if (!_labArr) {
        _labArr = [NSMutableArray array];
    }
    return _labArr;
}
- (NSMutableArray<UILabel *> *)labCowArr{
    if (!_labCowArr) {
         _labCowArr = [NSMutableArray array];
     }
     return _labCowArr;
}
- (UIButton *)hubBtn{
    if (!_hubBtn) {
        _hubBtn = [[UIButton alloc]init];
        [_hubBtn setImage:[UIImage imageNamed:@"download_under_icon"] forState:UIControlStateNormal];
        [_hubBtn addTarget:self action:@selector(downloadUnder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hubBtn;
}

@end
