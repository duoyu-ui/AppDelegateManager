//
//  SSChatJieLongCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatJieLongCell : FYChatBaseCell

@end
@interface SSChatJieLongGrabList :NSObject
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * money;
@property (nonatomic , assign) BOOL              isBest;
@property (nonatomic , assign) BOOL isWorst;

@end

@interface SSChatJieLongModel :NSObject
@property (nonatomic , copy) NSString              * worstNick;
@property (nonatomic , copy) NSArray<SSChatJieLongGrabList *>              * grabList;
@property (nonatomic , copy) NSString              * worstDesc;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSArray<NSString *>              * title;
@property (nonatomic , copy) NSString              * bestDesc;
@property (nonatomic , copy) NSString              * bestNick;
@property (nonatomic , assign) NSInteger              type;

@end

NS_ASSUME_NONNULL_END
