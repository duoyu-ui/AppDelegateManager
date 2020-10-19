//
//  FYNearlySelectUserCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYNearlySelectUserCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageSelect;
@property (nonatomic, strong) UIImageView *imageAvatar;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelDetail;
-(void)updateUseSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
