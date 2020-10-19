//
//  FYRedEnvelopePublickResponse.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYRedEnvelopePubickDetailModel : NSObject
@property (nonatomic, copy) NSString              *ip;
@property (nonatomic, assign) NSInteger           billId;
@property (nonatomic, copy) NSString              *money;
@property (nonatomic, assign) NSInteger           status;
@property (nonatomic, assign) NSInteger           total;
@property (nonatomic, copy) NSString              *splitList;
@property (nonatomic, assign) NSInteger           exceptOverdueTimes;
@property (nonatomic, assign) NSInteger           version;
@property (nonatomic, assign) NSInteger           type;
@property (nonatomic, assign) NSInteger           handicap;
@property (nonatomic, copy) NSString              *attr;
@property (nonatomic, copy) NSString              *exceptOverdueTime;
@property (nonatomic, assign) BOOL                commisionFlag;
@property (nonatomic, assign) NSInteger           left;
@property (nonatomic, copy) NSString              *nick;
@property (nonatomic, copy) NSString              *avatar;
@property (nonatomic, assign) NSInteger           chatgId;
@property (nonatomic, copy) NSString              *createTime;
@property (nonatomic, assign) NSInteger           userId;
@property (nonatomic, assign) NSInteger           gameType;
///龙虎和
@property (nonatomic, copy) NSString *bankScoreStr;
@end

@interface FYRedEnvelopePubickGrabModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) NSInteger redbId;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *money;
///龙虎
@property (nonatomic, copy) NSString *scoreStr;
///手气最差 true
@property (nonatomic, assign) BOOL worst;
///手气最佳 true
@property (nonatomic, assign) BOOL best;
///中雷 true
@property (nonatomic, assign) BOOL bombFlag;
///庄家 true
@property (nonatomic, assign) BOOL banker;
@end

@interface FYRedEnvelopePubickData : NSObject
@property (nonatomic, strong) FYRedEnvelopePubickDetailModel *detail;
@property (nonatomic, copy) NSArray<FYRedEnvelopePubickGrabModel *> *items;
@end

@interface FYRedEnvelopePublickResponse : NSObject
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) FYRedEnvelopePubickData *data;
@end

NS_ASSUME_NONNULL_END
