//
//  FYJSSLGameTrendTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYJSSLGameTrendModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameTrendTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYJSSLGameTrendModel *model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)headerViewHeight;

@end

NS_ASSUME_NONNULL_END
