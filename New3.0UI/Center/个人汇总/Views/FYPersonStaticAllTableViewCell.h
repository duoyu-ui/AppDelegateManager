//
//  FYPersonStaticAllTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYPersonStaticAllModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYPersonStaticAllTableViewCell : UITableViewCell

@property (nonatomic, strong) FYPersonStaticAllModel *model;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
