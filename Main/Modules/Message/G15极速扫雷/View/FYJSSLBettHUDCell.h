//
//  FYJSSLBettHUDCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FYJSSLDataSource;
@interface FYJSSLBettHUDCell : UITableViewCell
+ (NSString *)reuseIdentifier;
@property (nonatomic , strong) FYJSSLDataSource *list;
@end

NS_ASSUME_NONNULL_END
