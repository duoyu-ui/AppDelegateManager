//
//  FYJSSLGameRecordDetailHudCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYJSSLGameRecordHudModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameRecordDetailHudCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYJSSLGameRecordHudModel *model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)headerViewHeight;

@end

NS_ASSUME_NONNULL_END
