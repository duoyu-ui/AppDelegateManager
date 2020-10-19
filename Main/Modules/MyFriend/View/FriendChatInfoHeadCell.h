//
//  FriendChatInfoHeadCell.h
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalSignatureModel, FYContacts;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const kFriendChatInfoHeaderCellId;

@interface FriendChatInfoHeadCell : UITableViewCell

/// 设置数据
@property (nonatomic, strong) FYContacts *contacts;

/// 设置数据
@property (nonatomic, strong) PersonalSignatureModel *personalModel;


+ (CGFloat)cellHeightOfTableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setContacts:(FYContacts *)contacts personalModel:(PersonalSignatureModel *)personalModel;

@end

NS_ASSUME_NONNULL_END
