//
//  FYRedPacketListModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYRedPacketListModel : NSObject

@property (nonatomic, assign) NSInteger Id; ///< 游戏id
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, copy) NSString *accessIcon;
@property (nonatomic, copy) NSString *maxIcon;
@property (nonatomic, copy) NSString *minIcon;
@property (nonatomic, copy) NSString *showName; ///< 红包名称
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger type; ///< 类型
@property (nonatomic, assign) NSInteger maintainLimitTime; ///< 维护时间
@property (nonatomic, assign) BOOL maintainFlag; ///<是否维护
@property (nonatomic, assign) BOOL powerFlag; ///<是否维护
@property (nonatomic, assign) BOOL openFlag;
@property (nonatomic, assign) BOOL accessWay;

@end

NS_ASSUME_NONNULL_END
