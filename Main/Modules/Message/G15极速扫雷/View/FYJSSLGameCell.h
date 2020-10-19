//
//  FYJSSLGameCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYJSSLDataSource.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameCell : UICollectionViewCell
@property (nonatomic , strong) FYJSSLDataSource *list;
@end

NS_ASSUME_NONNULL_END
