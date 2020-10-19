//
//  FYSolitaireInfoModel.h
//  ProjectCSHB
//
//  Created by Tom on 2019/10/31.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYSolitaireInfoModel : NSObject

///实际发包金额
@property (nonatomic , copy) NSString              * sendMoney;
///游戏状态 0 未开始 1 中断 2 等待群主发包 3 等待用户发包 4 以发包
@property (nonatomic , assign) NSInteger              gameStatus;
///是否初始包 0否 1,是
@property (nonatomic , assign) NSInteger              isInit;
///群主ID
@property (nonatomic , copy) NSString              * groupOwnerId;
//@property (nonatomic , copy) NSString              * init;
@property (nonatomic , copy) NSString              * remindGrabTime;
///发包人昵称
@property (nonatomic , copy) NSString              * sendUserNick;
///等待发包时间
@property (nonatomic , copy) NSString              * waitSendTime;
///游戏期数
@property (nonatomic , copy) NSString              * gameNumber;

/// 群ID
@property (nonatomic , copy) NSString              * chatGroupId;
///钱包前冻结金额
@property (nonatomic , copy) NSString              * frozenMoney;
/// 发包人ID
@property (nonatomic , copy) NSString              * sendUserId;
/// 抽水金额
@property (nonatomic , copy) NSString              * waterMoney;
/// 每局发包金额抽水比列
@property (nonatomic , copy) NSString              * waterRate;
///只有list里的成员更新余额
@property (nonatomic , strong) NSArray              *gameList;
@end

NS_ASSUME_NONNULL_END
