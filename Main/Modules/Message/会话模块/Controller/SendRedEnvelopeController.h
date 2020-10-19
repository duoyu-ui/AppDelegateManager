//
//  EnvelopeViewController.h
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "FYBaseCoreViewController.h"
#import "FYCreateRequest.h"

@interface SendRedEnvelopeController : FYBaseCoreViewController

/// 是否是福利红包
@property (nonatomic, assign) BOOL isFu;

/// 群基本设置
@property (nonatomic, strong) FYCreateRequest *groupConfig;

@end
