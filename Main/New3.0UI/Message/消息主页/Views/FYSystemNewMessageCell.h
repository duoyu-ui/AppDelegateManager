//
//  FYSystemNewMessageCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYSystemMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYSystemNewMessageCell : UITableViewCell
@property (nonatomic , strong) FYSystemMessageRecords *list;
@property (nonatomic , copy) NSString *imgName;
@end

NS_ASSUME_NONNULL_END
