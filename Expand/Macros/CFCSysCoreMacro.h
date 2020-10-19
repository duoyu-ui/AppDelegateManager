
#ifndef _CFC_SYS_CORE_MACRO_H_
#define _CFC_SYS_CORE_MACRO_H_

#pragma mark -
#define APPINFORMATION  [AppModel shareInstance]
#define APPUSERDEFAULTS  [FYSysUserDefaults standardUserDefaults]
#define APP_USER_REMARK_NAME(userId) [[IMContactsModule sharedInstance] getContactRemarkName:userId]
#define FUNCTION_MANAGER [FunctionManager sharedInstance]
//
#define NET_REQUEST_MANAGER [NetRequestManager sharedInstance]
#define NET_REQUEST_SUCCESS(response) [CFCSysUtil validateNetRequestResult:response]
#define NET_REQUEST_SUCCESS_KEYVALUE(response,KEY,VALUE) [CFCSysUtil validateNetRequestResult:response key:KEY value:VALUE]
//
#define NET_REQUEST_DATA(response) [CFCSysUtil objectOfNetRequestResultData:response]
//
#define ALTER_INFO_MESSAGE(STR) [CFCSysUtil alterSringMessage:STR];
#define ALTER_HTTP_MESSAGE(response) [CFCSysUtil alterSuccMessage:response];
#define ALTER_HTTP_ERROR_MESSAGE(error) [CFCSysUtil alterErrorMessage:error];
//
#define VALIDATE_AUTH_TOKEN(response) [CFCSysUtil validateAuthToken:response];
//
#define VALIDATE_STRING_EMPTY(STRING) [CFCSysUtil validateStringEmpty:STRING]
#define VALIDATE_STRING_HTTP_URL(STR) [CFCSysUtil validateStringUrl:STR]
#define STR_TRI_WHITE_SPACE(S) [CFCSysUtil stringByTrimmingWhitespaceAndNewline:S]

//
#define MESSAGE_SINGLE_KEY(A,B) [NSString stringWithFormat:@"%@-%@",(A),(B)]
// 消息免打扰
#define MESSAGE_NOTICE_SWITCH_KEY(A,B) [NSString stringWithFormat:@"%@-%@",(A),(B)]
// 置顶消息
#define CHAT_STICK_SWITCH_KEY(A,B) [NSString stringWithFormat:@"%@-%@",(A),(B)]

#pragma mark -
#pragma mark 本地数据储存
#define NSUSERDEFAULTS_OBJ_KEY(KEY)          [[NSUserDefaults standardUserDefaults] objectForKey:(KEY)]
#define NSUSERDEFAULTS_OBJ_SET(KEY,VALUE)    [[NSUserDefaults standardUserDefaults] setObject:(VALUE) forKey:(KEY)];[[NSUserDefaults standardUserDefaults] synchronize]

#pragma mark -
#pragma mark 避免循环引用
#define WEAKTYPE(type) __weak __typeof(&*type)weak##type = type;
#define WEAKSELF(weakSelf) __weak __typeof(&*self)weakSelf = self;

#pragma mark -
#pragma mark 屏幕尺寸大小
#define SCREEN_SIZE              ([UIScreen mainScreen].bounds.size)
#define SCREEN_BOUNDS            ([UIScreen mainScreen].bounds)
#define SCREEN_MAX_LENGTH        (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH        (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#pragma mark -
#pragma mark 机型判断
#define CFC_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CFC_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define CFC_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define CFC_IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define CFC_IS_IPHONE_5 (CFC_IS_IPHONE && SCREEN_MAX_LENGTH == 568.0 && SCREEN_MIN_LENGTH == 320.0)
#define CFC_IS_IPHONE_6 (CFC_IS_IPHONE && SCREEN_MAX_LENGTH == 667.0 && SCREEN_MIN_LENGTH == 375.0)
#define CFC_IS_IPHONE_6P (CFC_IS_IPHONE && SCREEN_MAX_LENGTH == 736.0 && SCREEN_MIN_LENGTH == 414.0)
#define CFC_IS_IPHONE_X (CFC_IS_IPHONE && SCREEN_MAX_LENGTH == 812.0 && SCREEN_MIN_LENGTH == 375.0)
#define CFC_IS_IPHONE_XR (CFC_IS_IPHONE && SCREEN_MAX_LENGTH == 896.0 && SCREEN_MIN_LENGTH == 414.0)
#define CFC_IS_IPHONE_XS (CFC_IS_IPHONE && SCREEN_MAX_LENGTH == 812.0 && SCREEN_MIN_LENGTH == 375.0)
#define CFC_IS_IPHONE_XSMAX (CFC_IS_IPHONE && SCREEN_MAX_LENGTH == 896.0 && SCREEN_MIN_LENGTH == 414.0)
#define CFC_IS_IPHONE_X_OR_GREATER (CFC_IS_IPHONE_X || CFC_IS_IPHONE_XR || CFC_IS_IPHONE_XS || CFC_IS_IPHONE_XSMAX)

#pragma mark -
#pragma mark 应用程序尺寸
// APP_FRAME_WIDTH = SCREEN_WIDTH
#define APP_FRAME_WIDTH ([UIScreen mainScreen].applicationFrame.size.width)
// APP_FRAME_HEIGHT = SCREEN_HEIGHT-STATUSBAR_HEIGHT
// 注意：横屏（UIDeviceOrientationLandscape）时，iOS8默认隐藏状态栏，此时 APP_FRAME_HEIGHT = SCREEN_HEIGHT
#define APP_FRAME_HEIGHT ([UIScreen mainScreen].applicationFrame.size.height)

#pragma mark -
#pragma mark 不同机型宽度、高度、字体适配
// 字体进行适配
#define CFC_AUTOSIZING_FONT(fontSize)                             [CFCAutosizingUtil getAutosizeFontSize:(fontSize)]
#define CFC_AUTOSIZING_FONT_SCALE(fontSize)                       [CFCAutosizingUtil getAutosizeFontSizeScale:(fontSize)]
// 宽度进行适配
#define CFC_AUTOSIZING_WIDTH(width)                               [CFCAutosizingUtil getAutosizeViewWidth:(width)]
#define CFC_AUTOSIZING_WIDTH_SCALE(width)                         [CFCAutosizingUtil getAutosizeViewWidthScale:(width)]
// 高度进行适配
#define CFC_AUTOSIZING_HEIGTH(height)                             [CFCAutosizingUtil getAutosizeViewHeight:(height)]
#define CFC_AUTOSIZING_HEIGTH_SCALE(height)                       [CFCAutosizingUtil getAutosizeViewHeightScale:(height)]
// 间隔进行适配
#define CFC_AUTOSIZING_MARGIN(MARGIN)                             [CFCAutosizingUtil getAutosizeViewMargin:(MARGIN)]
#define CFC_AUTOSIZING_MARGIN_SCALE(MARGIN)                       [CFCAutosizingUtil getAutosizeViewMarginScale:(MARGIN)]

#pragma mark -
#pragma mark 颜色工具宏
#define COLOR_HEXSTRING(A) HexColor(A)
#define COLOR_RANDOM                                              COLOR_RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0f)
#define COLOR_RANDOM_ALPHA(X)                                     COLOR_RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), (X))
#define COLOR_RGB(R, G, B)                                        [UIColor colorWithRed:((R)/255.f) green:((G)/255.f) blue:((B)/255.f) alpha:1.0f]
#define COLOR_RGBA(R, G, B, A)                                    [UIColor colorWithRed:((R)/255.f) green:((G)/255.f) blue:((B)/255.f) alpha:(A)]

#pragma mark - 三方字体 - 萍方
#define FONT_PINGFANG_THEN(A)             [UIFont fontWithName:@"PingFangSC-Thin" size:CFC_AUTOSIZING_FONT(A)]
#define FONT_PINGFANG_REGULAR(A)          [UIFont fontWithName:@"PingFangSC-Regular" size:CFC_AUTOSIZING_FONT(A)]
#define FONT_PINGFANG_BOLD(A)             [UIFont fontWithName:@"PingFang-SC-Bold" size:CFC_AUTOSIZING_FONT(A)]
#define FONT_PINGFANG_SEMI_BOLD(A)        [UIFont fontWithName:@"PingFangSC-Semibold" size:CFC_AUTOSIZING_FONT(A)]
#define FONT_PINGFANG_MEDIUM(A)           [UIFont fontWithName:@"PingFangSC-Medium" size:CFC_AUTOSIZING_FONT(A)]
#define FONT_PINGFANG_LIGHT(A)            [UIFont fontWithName:@"PingFangSC-Light" size:CFC_AUTOSIZING_FONT(A)]
#define FONT_PINGFANG_ULTRAL_LIGHT(A)     [UIFont fontWithName:@"PingFangSC-Ultralight" size:CFC_AUTOSIZING_FONT(A)]

#pragma mark -
#pragma mark 系统主题色 - 界面主色
#define COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT                        COLOR_HEXSTRING(@"#CB332D")
#pragma mark 系统主题色 - 界面底色 - 默认
#define COLOR_SYSTEM_MAIN_UI_BACKGROUND_DEFAULT                   COLOR_HEXSTRING(@"#FFFFFF")
#pragma mark 系统主题色 - 主字体色 - 默认
#define COLOR_SYSTEM_MAIN_FONT_DEFAULT                            COLOR_HEXSTRING(@"#333333")
#pragma mark 系统主题色 - 辅助字体色 - 默认
#define COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT                     COLOR_HEXSTRING(@"#8A8A8D")
#pragma mark 系统主题色 - 按钮的颜色 - 正常 - 默认
#define COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_NORMAL_DEFAULT        COLOR_HEXSTRING(@"#FFFFFF")
#pragma mark 系统主题色 - 按钮的颜色 - 选中 - 默认
#define COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT        COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT

#pragma mark -
#pragma mark 导航栏配置 - 背景颜色
#define COLOR_NAVIGATION_BAR_BACKGROUND_DEFAULT                   COLOR_HEXSTRING(@"#FFFFFF")
#pragma mark 导航栏配置 - 标题字体颜色
#define FONT_NAVIGATION_BAR_TITLE_DEFAULT                         [UIFont fontWithName:@"PingFangSC-Semibold" size:CFC_AUTOSIZING_FONT(18.0f)]
#define COLOR_NAVIGATION_BAR_TITLE_DEFAULT                        COLOR_HEXSTRING(@"#333333")
#pragma mark 导航栏配置 - 按钮字体颜色
#define FONT_NAVIGATION_BAR_BUTTON_TITLE_DEFAULT                  [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)]
#define COLOR_NAVIGATION_BAR_BUTTON_TITLE_NORMAL_DEFAULT          COLOR_NAVIGATION_BAR_TITLE_DEFAULT
#define COLOR_NAVIGATION_BAR_BUTTON_TITLE_SELECT_DEFAULT          COLOR_NAVIGATION_BAR_TITLE_DEFAULT
#pragma mark 导航栏配置 - 底部横线颜色
#define COLOR_NAVIGATION_BAR_HAIR_LINE_DEFAULT                    COLOR_HEXSTRING(@"#D9D9D9")

#pragma mark -
#pragma mark 标签栏配置 - 背景颜色
#define COLOR_TAB_BAR_BACKGROUND_DEFAULT                          COLOR_HEXSTRING(@"#FBFBFB")
#pragma mark 标签栏配置 - 标题字体颜色
#define FONT_TAB_BAR_TITLE_DEFAULT                                [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(12.0f)]
#define COLOR_TAB_BAR_TITLE_NORMAL_DEFAULT                        COLOR_HEXSTRING(@"#676767")
#define COLOR_TAB_BAR_TITLE_SELECT_DEFAULT                        COLOR_HEXSTRING(@"#CB332D")

#pragma mark -
#pragma mark UITableView表格背景色
#define COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT                    COLOR_HEXSTRING(@"#F4F4F4")
#define COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT              COLOR_HEXSTRING(@"#F4F4F4")
#define COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT            COLOR_HEXSTRING(@"#F4F4F4")
#define COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT            COLOR_HEXSTRING(@"#F4F4F4")

#pragma mark -
#pragma mark 系统主题色 - 系统按钮
#define COLOR_SYSTEM_MAIN_UI_BUTTON_DEFAULT                       COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT

#pragma mark -
#pragma mark 刷新控件 - 背景颜色
#define COLOR_REFRESH_CONTROL_FRONT_DEFAULT                       COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT
#define COLOR_REFRESH_CONTROL_BACKGROUND_DEFAULT                  COLOR_HEXSTRING(@"#D6D6D6")

#pragma mark -
#pragma mark UIWebView - 进度条颜色
#define COLOR_ACTIVITY_INDICATOR_BACKGROUND                       COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT
#define COLOR_UIWEBVIEW_PROGRESSVIEW_BACKGROUND                   COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT
#define COLOR_UIWEBVIEW_ACTIVITY_INDICATOR_BACKGROUND             COLOR_HEXSTRING(@"#F13031")


#pragma mark 字体颜色
#define FONT_COMMON_BUTTON_TITLE            [UIFont fontWithName:@"PingFangSC-Semibold" size:CFC_AUTOSIZING_FONT(14)]
#define FONT_COMMON_TABLE_SECTION_TITLE     [UIFont fontWithName:@"PingFangSC-Semibold" size:CFC_AUTOSIZING_FONT(16)]


#pragma mark - 游戏大厅
#define HEIGHT_GAME_MENU_SEPARATOR_LINE                          0.6f
#define HEIGHT_GAME_CONTENT_SEPARATOR_LINE                       0.0f
#define COLOR_GAME_MENU_SEPARATOR_LINE                           COLOR_HEXSTRING(@"#E6E6E6")
#define COLOR_GAME_CONTENT_SEPARATOR_LINE                        COLOR_HEXSTRING(@"#D9D9D9")

#pragma mark - 代理中心
#define COLOR_AGENT_HEADER_NAVBAR_TITLE                          COLOR_HEXSTRING(@"#FFFFFF")
#define COLOR_AGENT_HEADER_NAVBAR_BUTTON_TITLE                   COLOR_HEXSTRING(@"#FFFFFF")
#define COLOR_AGENT_HEADER_NAVBAR_BACKGROUND                     COLOR_HEXSTRING(@"#E05846")


#endif /* _CFC_SYS_CORE_MACRO_H_ */

