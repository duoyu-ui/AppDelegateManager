//
//  YEBTransferDetailHeaderView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferDetailHeaderView.h"

@implementation YEBTransferDetailHeaderView

+ (instancetype)headerView {
    return [[NSBundle mainBundle] loadNibNamed:@"YEBTransferDetailHeaderView" owner:nil options:nil].firstObject;
}

@end
