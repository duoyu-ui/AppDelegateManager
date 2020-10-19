//
//  FYRedEnvelopeCoreTableHeader.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYRedEnvelopeCoreTableHeader : UIView
///
@property (nonatomic , strong) UIImageView *avatarImgView;
@property (nonatomic , strong) UILabel *nickLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UIView *lineView2;
@property (nonatomic , strong) UILabel *moneyNumLab;
@property (nonatomic , strong) UILabel *centerLab;
@property (nonatomic , strong) UIView *timeBgView;
@property (nonatomic , strong) UIImageView *timeImgView;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , assign) NSInteger overdueTimes;
@property (nonatomic , strong) UILabel *moneyLab;

/// 龙虎和
@property (nonatomic , strong) UILabel *lhhLab;
@property (nonatomic , strong) UIImageView *testimonialsImgView;
@property (nonatomic , strong) UILabel *leiLab;

/// 倒计时间
@property (nonatomic, strong) NSTimer *timer;

/// 游戏类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷；10:包包彩；11:包包牛）
@property(nonatomic, assign) GroupTemplateType type;

+ (CGFloat)headerHeight:(GroupTemplateType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(GroupTemplateType)type;

/// 刷新红包信息
/// @param detailModel 红包模型
/// @param sumMoney 抢红包总金额
/// @param money 自己抢的总金额
- (void)refreshWithDetailModel:(id)detailModel sumMoney:(CGFloat)sumMoney money:(NSString *)money;

/// 倒计时间
- (void)scheduledTimerCountDown;

@end


///雷号模型
@interface FYRedEnvelopeLeiNumModel: NSObject
///1:单雷,2:多雷,3:混合扫雷
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSNumber *bombNum;
@property (nonatomic, copy) NSArray<NSNumber *> *bombList;
@end

NS_ASSUME_NONNULL_END

