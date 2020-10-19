//
//  FYJJSLRecordHudCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYJSSLRecordData;
NS_ASSUME_NONNULL_BEGIN

@interface FYJJSLRecordHudCell : UITableViewCell
+ (NSString *)reuseIdentifier;
@property (nonatomic , strong) FYJSSLRecordData *list;
@property (nonatomic , strong) UIButton *hubBtn;
@end

NS_ASSUME_NONNULL_END
