//
//  FYAvatarNameContactCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYUserAddCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageAvatar;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelDetail;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *lineGray;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, copy) void(^buttonClickAction)(UIButton *btn);
- (void)buttonTitleWith:(NSString *)title;
- (void)isSectionLastRow:(BOOL)isLastRow;
+ (NSString *)reuseIdentifier;
@end

@interface FYAvatarNameContactCell : UITableViewCell
@property (nonatomic, strong) FLAnimatedImageView *imageAvatar;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelRedNumber;
@property (nonatomic, strong) UIView *greenTag;
@property (nonatomic, strong) UIView *lineGray;
@property (nonatomic, copy) void(^clickAction)(NSInteger clickType);
-(void)updateRedNumber:(NSInteger)count;
-(void)updateOnline:(NSInteger)online;
-(void)isSectionLastRow:(BOOL)isLastRow;
+ (NSString *)reuseIdentifier;
+ (CGFloat)height;
@end

@interface FYContactSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *labelName;
@end

NS_ASSUME_NONNULL_END
