//
//  VVAlertViewController.h
//  ProjectXZHB
//
//  Created by Mike on 2019/3/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SystemAlertViewController : FYBaseCoreViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSTextAlignment messageAlignment;
@property (nonatomic, copy) void(^closeCallBack)(NSInteger);

+ (instancetype)alertControllerWithTitle:(NSString *)title dataArray:(NSArray *)dataArray;

@end

