//
//  PersonalSignatureVC.h
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYBaseCoreViewController.h"

@class FYContacts;
NS_ASSUME_NONNULL_BEGIN

@interface PersonalSignatureVC : FYBaseCoreViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
