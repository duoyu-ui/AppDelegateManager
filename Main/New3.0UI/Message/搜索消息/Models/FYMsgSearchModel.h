//
//  FYMsgSearchModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/11.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYMsgSearchModel : NSObject

@property (nonatomic, strong) NSString *searchKey;

@property (nonatomic, strong) NSArray<NSString *> *messages;

@end

NS_ASSUME_NONNULL_END
