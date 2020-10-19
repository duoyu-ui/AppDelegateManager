//
//  FYRedEnvelopeCoreTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYRedEnvelopeCoreTableViewCell : UITableViewCell
///
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nickLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *moneyLab;

/// 手气最佳
@property (nonatomic, strong) UILabel *bestLuckLab;
@property (nonatomic, strong) UIImageView *luckImgView;

/// 雷的图片
@property (nonatomic, strong) UIImageView *leiImgView;
@property (nonatomic, strong) UILabel *bankerLab;
@property (nonatomic, strong) UILabel *cowLab;
@property (nonatomic, strong) UIImageView *cowImgView;


+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

/// 游戏类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷；10:包包彩；11:包包牛）
- (void)setCellModel:(id)cellModel type:(GroupTemplateType)type;

@end

NS_ASSUME_NONNULL_END
