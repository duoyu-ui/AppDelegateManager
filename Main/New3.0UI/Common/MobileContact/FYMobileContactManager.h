//
//  FYMobileContactManager.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYMobilePerson, FYSectionMobilePerson;

/**
 通讯录变更回调
 */
typedef void (^FYMobileContactChangeHandler) (void);

@interface FYMobileContactManager : NSObject

+ (instancetype)sharedInstance;

/**
 * 通讯录变更回调
 */
@property (nonatomic, copy) FYMobileContactChangeHandler contactChangeHandler;

/**
 * 请求授权
 * @param completion 回调
 */
- (void)requestAddressBookAuthorization:(void (^) (BOOL authorization))completion;

/**
 * 获取联系人列表（未分组的通讯录）
 * @param completcion 回调
 */
- (void)accessContactsComplection:(void (^)(BOOL succeed, NSArray <FYMobilePerson *> *contacts))completcion;

/**
 * 获取联系人列表（已分组的通讯录）
 * @param completcion 回调
 */
- (void)accessSectionContactsComplection:(void (^)(BOOL succeed, NSArray <FYSectionMobilePerson *> *contacts, NSArray <NSString *> *keys))completcion;


@end

