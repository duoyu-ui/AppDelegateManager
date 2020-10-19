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

UIKIT_EXTERN NSString * const kPersonalSignatureHeadCellId;

@interface PersonalSignatureHeadCell : UITableViewCell

+ (CGFloat)cellHeightOfTableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 显示账号
@property (nonatomic, assign) BOOL isShowID;

/// 设置数据
@property (nonatomic, strong) FYContacts *contacts;

/// 设置数据
@property (nonatomic, strong) PersonalSignatureModel *personalModel;


- (void)setContacts:(FYContacts *)contacts personalModel:(PersonalSignatureModel *)personalModel;


@end

NS_ASSUME_NONNULL_END
