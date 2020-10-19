//
//  EnvelopAnimationView.h
//  Project
//
//  Created by mini on 2018/8/13.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AnimationBlock)(void);
typedef void (^DetailBlock)(void);
typedef void (^OpenBtnBlock)(void);
typedef void (^AnimationEndBlock)(void);
typedef void (^DisMissRedBlock)(void);

@interface RedEnvelopeAnimationView : UIView

- (void)updateView:(id)obj response:(id)response rpOverdueTime:(NSString *)rpOverdueTime;
- (void)showInView:(UIView *)view;
@property (nonatomic ,copy) AnimationBlock animationBlock;
@property (nonatomic ,copy) DetailBlock detailBlock;
@property (nonatomic ,copy) OpenBtnBlock openBtnBlock;
@property (nonatomic ,copy) AnimationEndBlock animationEndBlock;
@property (nonatomic ,copy) DisMissRedBlock disMissRedBlock;

//@property (nonatomic,assign) BOOL isClickedDisappear;

-(void)disMissRedView;

@end

@interface RedEnvelopeModel:NSObject
@property (nonatomic , copy) NSString              * ip;
@property (nonatomic , assign) NSInteger              billId;
@property (nonatomic , assign) NSInteger              freerId;
@property (nonatomic , assign) NSInteger              money;
///是否已结算
@property (nonatomic , assign) BOOL overFlag;
///红包状态 0:冻结 1:正常,2:过期,完成结算
@property (nonatomic , assign) NSInteger              status;
///剩余未抢的红包
@property (nonatomic , assign) NSInteger              left;
///预计退包时间,还有多少时间退包
@property (nonatomic , assign) NSInteger              exceptOverdueTimes;
@property (nonatomic , assign) NSInteger              total;
@property (nonatomic , copy) NSString              * actualOverdueTime;
@property (nonatomic , copy) NSString              * splitList;
@property (nonatomic , copy) NSString              * otherWin;
@property (nonatomic , assign) NSInteger              version;
@property (nonatomic , copy) NSString              * bombNum;
@property (nonatomic , copy) NSString              * lastUpdateTime;
@property (nonatomic , assign) CGFloat              handicap;
///群类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；
///5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷）
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * attr;
@property (nonatomic , copy) NSString              * exceptOverdueTime;
@property (nonatomic , assign) BOOL              commisionFlag;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , assign) NSInteger              chatgId;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              *userId;
@end
