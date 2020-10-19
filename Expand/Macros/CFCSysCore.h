
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFCSysCore : NSObject

#pragma mark MJRefresh下拉加载提示信息
UIKIT_EXTERN CGFloat const CFCRefreshAutoHeaderFontSize;
UIKIT_EXTERN NSString *const CFCRefreshAutoHeaderColor;
//UIKIT_EXTERN NSString *const CFCRefreshAutoHeaderIdleText;
//UIKIT_EXTERN NSString *const CFCRefreshAutoHeaderPullingText;
//UIKIT_EXTERN NSString *const CFCRefreshAutoHeaderRefreshingText;

#pragma mark 上拉刷新提示信息
UIKIT_EXTERN CGFloat const CFCRefreshAutoFooterFontSize;
UIKIT_EXTERN NSString *const CFCRefreshAutoFooterColor;
//UIKIT_EXTERN NSString *const CFCRefreshAutoFooterIdleText;
//UIKIT_EXTERN NSString *const CFCRefreshAutoFooterRefreshingText;
//UIKIT_EXTERN NSString *const CFCRefreshAutoFooterNoMoreDataText;

#pragma mark 加载提示信息
//UIKIT_EXTERN NSString *const CFCLoadingProgessHUDText;

#define  CFCRefreshAutoHeaderIdleText NSLocalizedString(@"下拉可以刷新", nil)
#define  CFCRefreshAutoHeaderPullingText NSLocalizedString(@"松开立即刷新", nil)
#define  CFCRefreshAutoHeaderRefreshingText  NSLocalizedString(@"正在刷新数据中", nil)
#define  CFCRefreshAutoFooterIdleText NSLocalizedString(@"点击或上拉加载更多", nil)
#define  CFCRefreshAutoFooterRefreshingText NSLocalizedString(@"正在加载更多的数据", nil)
#define  CFCRefreshAutoFooterNoMoreDataText NSLocalizedString(@"已经全部加载完毕", nil)
#define  CFCLoadingProgessHUDText NSLocalizedString(@"加载中", nil)

#pragma mark 消息模块 - 置顶消息分割符号与本地存储KEY
UIKIT_EXTERN NSString *const FYMSG_CHAT_STICK_ARRAY_SPLIIT;
UIKIT_EXTERN NSString *const FYMSG_CHAT_STICK_ARRAY_DEF_KEY;


@end

NS_ASSUME_NONNULL_END
