
#import <Foundation/Foundation.h>
#ifdef _PROJECT_WITH_OPENINSTALL_
#import "OpenInstallSDK.h"
#endif

NS_ASSUME_NONNULL_BEGIN

#ifndef _PROJECT_WITH_OPENINSTALL_
@interface OpenInstallApiManager : NSObject
#else
@interface OpenInstallApiManager : NSObject <OpenInstallDelegate>
#endif

/**
 *  严格单例
 *  @return 实例对象.
 */
+ (instancetype)sharedOpenInstallApiManager;

@end

NS_ASSUME_NONNULL_END
