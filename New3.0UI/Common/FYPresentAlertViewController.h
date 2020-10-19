//
//  FYPresentAlertViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FYPresentAlertTextAlignment) {
    FYPresentAlertTextAlignmentLeft     = 0,
    FYPresentAlertTextAlignmentCenter    = 1,
    FYPresentAlertTextAlignmentRight     = 2,
};

@interface FYPresentAlertViewController : CFCBaseCoreViewController

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) void(^cancleActionBlock)(void);
@property (nonatomic, copy) void(^confirmActionBlock)(void);

@property (nonatomic, assign) FYPresentAlertTextAlignment alertTextAlignment;

+ (instancetype)alertController;

+ (instancetype)alertControllerWithContent:(NSString *)content;

+ (instancetype)alertControllerWithContent:(NSString *)content imageUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
