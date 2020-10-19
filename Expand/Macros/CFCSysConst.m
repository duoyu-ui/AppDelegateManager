
#import "CFCSysConst.h"

@implementation CFCSysConst

#pragma mark 控件间隔常量
CGFloat const MARGIN = 10.0f;

#pragma mark 最小浮点常量
CGFloat const FLOAT_MIN = CGFLOAT_MIN;

#pragma mark 标签栏高度(系统默认高度为49)
CGFloat const TAB_BAR_HEIGHT = 49.0f;

#pragma mark 导航条高度(系统默认高度为44)
CGFloat const NAVIGATION_BAR_HEIGHT = 44.0f;

#pragma mark 导航条底部发丝线(系统默认高度为1.0)
CGFloat const NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO = 0.0f;
CGFloat const NAVIGATION_BAR_HAIR_LINE_HEIGHT_DEFAULT = 0.6f;

#pragma mark 导航条按钮与屏幕边距
CGFloat const NAVIGATION_BAR_SCREEN_MARGIN = 10.0f;

#pragma mark 导航条左右按钮最大宽度
CGFloat const NAVIGATION_BAR_BUTTON_MAX_WIDTH = 50.0f;

#pragma mark 导航条左右按钮图标宽度
CGFloat const NAVIGATION_BAR_BUTTON_IMAGE_SIZE = 25.0f;

#pragma mark 导航条标题字数限制
CGFloat const NAVIGATION_BAR_TITLE_MAX_NUM = 12.0f;

#pragma mark 系统分割线默认高度
CGFloat const SEPARATOR_LINE_HEIGHT = 0.6f;

#pragma mark 系统全局按钮高度
CGFloat const SYSTEM_GLOBAL_BUTTON_HEIGHT = 45.0;

#pragma mark 全屏右滑返回左边手势允许的最大距离
CGFloat const FULLSCREEN_POP_GESTURE_MAX_DISTANCE_TO_LEFT_EDGE = 50.0;


#pragma mark 通用间隔高度
CGFloat const SEPARTOR_MARGIN_HEIGHT = 3.3f;

#pragma mark 游戏大厅-菜单CELL固定高度
CGFloat const GAMES_MALL_MENU_CELL_HEIGHT = 55.0;

#pragma mark 游戏大厅-内容CELL固定高度
CGFloat const GAMES_MALL_CONTENT_CELL_HEIGHT = 75.0;


#pragma mark 悬浮按钮宽度
CGFloat const CHAT_MESSAGE_FLOAT_BUTTON_WIDTH = 70.0f;
CGFloat const CHAT_MESSAGE_FLOAT_BUTTON_HEIGHT = 32.0f;

#pragma mark 悬浮按钮尺寸
CGFloat const FULL_SUSPEND_BALL_SIZE = 60.0f;

#pragma mark 请求超时
CGFloat const NET_REQUEST_TIMEOUTINTERVAL = 16.0f;

#pragma mark 空白图片尺寸
CGFloat const SCROLL_EMPTY_DATASET_SCALE = 0.2f;


#pragma mark TabBar 主页对应下标
NSInteger const TABBAR_INDEX_MESSAGE = 0;
NSInteger const TABBAR_INDEX_RECHARGE = 1;
NSInteger const TABBAR_INDEX_GAMEHALL = 2;
NSInteger const TABBAR_INDEX_CONTACTS = 3;
NSInteger const TABBAR_INDEX_MYCENTER = 4;


#pragma mark 键盘功能按钮标识
/**
tag = 2000  <===>  福利
tag = 2001  <===>  加盟
tag = 2002  <===>  红包
tag = 2003  <===> 充值
tag = 2004  <===>  玩法
tag = 2005  <===>  群规

tag = 2006  <===>  帮助
tag = 2007  <===>  客服
tag = 2008  <===>  照片
tag = 2009  <===>  拍照
tag = 2010  <===>  赚钱

tag = 2011  <===>  转账
tag = 2012  <===>  期数记录
tag = 2013  <===>  投注记录
tag = 2014  <===>  提款
tag = 2015  <===>  余额宝

tag = 2016  <===>  二维码
 
tag = 2017  <===>  视频
*/
CGFloat const KEYBOARD_FUNCTION_UUID_FULI = 2000;
CGFloat const KEYBOARD_FUNCTION_UUID_JIAMENG = 2001;
CGFloat const KEYBOARD_FUNCTION_UUID_REDPACKET = 2002;
CGFloat const KEYBOARD_FUNCTION_UUID_RECHARGE = 2003;
CGFloat const KEYBOARD_FUNCTION_UUID_PALY_RULE = 2004;
//
CGFloat const KEYBOARD_FUNCTION_UUID_GROUP_RULE = 2005;
CGFloat const KEYBOARD_FUNCTION_UUID_HELPER = 2006;
CGFloat const KEYBOARD_FUNCTION_UUID_CUSTOMER = 2007;
CGFloat const KEYBOARD_FUNCTION_UUID_PHOTO = 2008;
CGFloat const KEYBOARD_FUNCTION_UUID_CARAMER = 2009;
//
CGFloat const KEYBOARD_FUNCTION_UUID_ERANMONEY = 2010;
CGFloat const KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY = 2011;
CGFloat const KEYBOARD_FUNCTION_UUID_ISSUE_RECORDS = 2012;
CGFloat const KEYBOARD_FUNCTION_UUID_BETTING_RECORDS = 2013;
CGFloat const KEYBOARD_FUNCTION_UUID_DRAW_MONEY = 2014;
//
CGFloat const KEYBOARD_FUNCTION_UUID_YUEBAO = 2015;
CGFloat const KEYBOARD_FUNCTION_UUID_QRCODE = 2016;

CGFloat const KEYBOARD_FUNCTION_UUID_VIDEO = 2017;


@end

