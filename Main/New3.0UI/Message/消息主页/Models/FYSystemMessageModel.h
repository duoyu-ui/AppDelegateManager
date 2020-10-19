//
//  FYSystemMessageModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FYSystemMessageRecords :NSObject
@property (nonatomic , copy) NSString              * releaseTime;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) BOOL              delFlag;
//@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * lastUpdateTime;
@property (nonatomic , copy) NSString              * title;
///0:系统 1:平台
@property (nonatomic , assign) NSInteger              noticeType;
@property (nonatomic , assign) BOOL              releaseFlag;
@property (nonatomic , assign) NSInteger              stickFlag;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) CGSize size;
@end

@interface FYSystemMessageData :NSObject
@property (nonatomic , copy) NSArray<FYSystemMessageRecords *>              * records;
@property (nonatomic , assign) NSInteger              pages;
@property (nonatomic , assign) NSInteger              current;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , assign) NSInteger              total;

@end

@interface FYSystemMessageModel :NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) FYSystemMessageData              * data;
@property (nonatomic , assign) NSInteger              code;

@end

NS_ASSUME_NONNULL_END
