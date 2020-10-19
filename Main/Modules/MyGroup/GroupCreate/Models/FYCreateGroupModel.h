//
//  FYCreateGroupModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STR_CELL_TITLE_GROUP_TYPE         NSLocalizedString(@"*群类型", nil)
#define STR_CELL_TITLE_GROUP_NAME         NSLocalizedString(@"*群名称", nil)
#define STR_CELL_TITLE_GROUP_NOTICE       NSLocalizedString(@"群公告(选填)", nil)
#define STR_CELL_TITLE_GROUP_REDPACT      NSLocalizedString(@"*红包设置", nil)

typedef enum : NSUInteger {
    CreateTitleAndSubtitle = 0,
    CreateNoticeInfoOrArrow,
    CreateTitleOrTextField,
    CreateAllTitleAndArrow,
    CreateAllTitleAndSwitch,
} CreateCellStyle;

NS_ASSUME_NONNULL_BEGIN

@interface FYCreateGroupModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CreateCellStyle style;
@property (nonatomic, assign) BOOL isSelected;

#pragma mark - 构造方法

- (instancetype)createModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(CreateCellStyle)style;
+ (instancetype)createModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(CreateCellStyle)style;

- (instancetype)initGroupTypeWithTitle:(NSString *)title isSelected:(BOOL)isSelected;
+ (instancetype)initGroupTypeWithTitle:(NSString *)title isSelected:(BOOL)isSelected;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
+ (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
