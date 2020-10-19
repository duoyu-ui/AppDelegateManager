//
//  SSChatMenuConfig.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/12/9.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSChatMenuConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger tag;

#pragma mark - 构造方法

+ (instancetype)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;

- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
