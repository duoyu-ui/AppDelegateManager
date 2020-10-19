
#import <UIKit/UIKit.h>
#import "RobNiuNiuQunModel.h"
#import "FYSolitaireInfoModel.h"
@class FYIMGroupChatHeaderView;

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlockRobNiuNiuType)(NSInteger status);

@protocol FYIMGroupChatHeaderViewDelegate <NSObject>
// 余额
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfCheckBalance:(UILabel *)balanceLabel;
// 充值
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfRecharge:(UIButton *)button;
// 玩法
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfPlayRule:(UIButton *)button;
// 分享
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfShare:(UIButton *)button;

@end

@interface FYIMGroupChatHeaderView : UIView

/* 模型 - 模型 */
//@property (nonatomic, strong) RobNiuNiuQunModel *modelOfNiuNiu;
//
///* 模型 - 接龙 */
//@property (nonatomic, strong) FYSolitaireInfoModel *modelOfSolitaire;


/* 余额 */
@property (nonatomic, copy) NSString *balance;

/* 头部操作代理 */
@property (nonatomic, weak) id<FYIMGroupChatHeaderViewDelegate> delegate;

/* 群类型（0：福利群；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷）*/
@property (nonatomic, assign) NSInteger groupTemplateType;

- (instancetype)initWithGroupTemplateType:(NSInteger)groupTemplateType;

@end

NS_ASSUME_NONNULL_END

