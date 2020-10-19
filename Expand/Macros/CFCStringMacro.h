
#ifndef _CFC_STRING_MACRO_H_
#define _CFC_STRING_MACRO_H_

#pragma mark - 导航栏按钮标题 - 返回/默认
#define STR_NAVIGATION_BAR_BUTTON_TITLE_EMPTY                                        @""
#define STR_NAVIGATION_BAR_BUTTON_TITLE_RETURN_BACK                                  @""

#pragma mark -
#pragma mark 字符串常量 - 占位符
#define STR_APP_TEXT_PLACEHOLDER                                                     @"-----"
#define STR_SCROLL_EMPTY_DATASET_TITLE                                               NSLocalizedString(@"没有找到相关记录", nil)
#define STR_SCROLL_EMPTY_DATASET_TIPINFO                                             NSLocalizedString(@"前不见古人，后不见来者", nil)

#define STR_GAME_TREND_CHART_TIP_TITLE_DEFAULF                                       NSLocalizedString(@"近30期开奖结果", nil)
#define STR_GAME_TREND_CHART_TIP_TITLE_VALUE                                         NSLocalizedString(@"近%ld期开奖结果", nil)


#pragma mark - 标签栏标题
#define STR_TAB_BAR_ITEM_NAME_MESSAGE                                                NSLocalizedString(@"消息", nil)
#define STR_TAB_BAR_ITEM_NAME_CONTACT                                                NSLocalizedString(@"通讯录", nil)
#define STR_TAB_BAR_ITEM_NAME_GAMES                                                  NSLocalizedString(@"游戏大厅", nil)
#define STR_TAB_BAR_ITEM_NAME_RECHARGE                                               NSLocalizedString(@"充值", nil)
#define STR_TAB_BAR_ITEM_NAME_CENTER                                                 NSLocalizedString(@"我的", nil)

#pragma mark - 导航栏标题
#define STR_NAVIGATION_BAR_TITLE_MESSAGE                                             NSLocalizedString(@"消息", nil)
#define STR_NAVIGATION_BAR_TITLE_CONTACT                                             NSLocalizedString(@"通讯录", nil)
#define STR_NAVIGATION_BAR_TITLE_GAMES                                               NSLocalizedString(@"游戏大厅", nil)
#define STR_NAVIGATION_BAR_TITLE_RECHARGE                                            NSLocalizedString(@"支付方式", nil)
#define STR_NAVIGATION_BAR_TITLE_CENTER                                              NSLocalizedString(@"个人中心", nil)
//
#define STR_NAVIGATION_BAR_TITLE_TRANSFER_MONEY                                      NSLocalizedString(@"转账", nil)
#define STR_NAVIGATION_BAR_TITLE_YOUHUI_ACTIVITY                                     NSLocalizedString(@"优惠活动", nil)
#define STR_NAVIGATION_BAR_TITLE_MONEY_DETAIL_RECORD                                 NSLocalizedString(@"资金明细", nil)
#define STR_NAVIGATION_BAR_TITLE_PERSON_STATIC                                       NSLocalizedString(@"个人汇总", nil)
#define STR_NAVIGATION_BAR_TITLE_BILLING_RECORD                                      NSLocalizedString(@"账单明细", nil)
#define STR_NAVIGATION_BAR_TITLE_BILLING_DETAILS                                     NSLocalizedString(@"账单详情", nil)
#define STR_NAVIGATION_BAR_TITLE_YUEBAO                                              NSLocalizedString(@"余额宝", nil)
#define STR_NAVIGATION_BAR_TITLE_CENTER_MY_QRCODE                                    NSLocalizedString(@"我的二维码", nil)
#define STR_NAVIGATION_BAR_TITLE_AGENT_CENTER                                        NSLocalizedString(@"代理中心", nil)
#define STR_NAVIGATION_BAR_TITLE_AGENT_OPEN_ACCOUNT                                  NSLocalizedString(@"代理开户", nil)
#define STR_NAVIGATION_BAR_TITLE_ADD_FRIEND                                          NSLocalizedString(@"添加朋友", nil)
#define STR_NAVIGATION_BAR_TITLE_CONTACT_GROUP                                       NSLocalizedString(@"我的群组", nil)
#define STR_NAVIGATION_BAR_TITLE_MSG_GROUP_BUILD                                     NSLocalizedString(@"创建群组", nil)
#define STR_NAVIGATION_BAR_TITLE_GROUP_TYPE_CHOICE                                   NSLocalizedString(@"选择游戏类型", nil)
#define STR_NAVIGATION_BAR_TITLE_RECHARGE_PAY_MODE_MORE                              NSLocalizedString(@"充值渠道", nil)
#define STR_NAVIGATION_BAR_TITLE_RECHARGE_PAY_VERIFY                                 NSLocalizedString(@"身份验证", nil)
#define STR_NAVIGATION_BAR_TITLE_RECHARGE_PAY_MONEY_CONTENT                          NSLocalizedString(@"充值金额", nil)
#define STR_NAVIGATION_BAR_TITLE_WITHDRAW_CENTER                                     NSLocalizedString(@"提现", nil)
#define STR_NAVIGATION_BAR_TITLE_ADD_BINDBANKCARD                                    NSLocalizedString(@"添加银行卡", nil)
#define STR_NAVIGATION_BAR_TITLE_WITHDRAW_BANKCARD_SELECT                            NSLocalizedString(@"选择银行卡", nil)
#define STR_NAVIGATION_BAR_TITLE_WITHDRAW_BANKCARD_UNBIND                            NSLocalizedString(@"解绑银行卡", nil)
#define STR_NAVIGATION_BAR_TITLE_WITHDRAW_BINDBANKCARD                               NSLocalizedString(@"绑定银行卡", nil)
#define STR_NAVIGATION_BAR_TITLE_BAGBAGCOW_RECORDS                                   NSLocalizedString(@"游戏记录", nil)
#define STR_NAVIGATION_BAR_TITLE_BAGBAGCOW_TRENDS                                    NSLocalizedString(@"基本走势", nil)
#define STR_NAVIGATION_BAR_TITLE_BAGBAGLOTTERY_TRENDS                                NSLocalizedString(@"基本走势", nil)

#pragma mark - 按钮的标题
#define STR_MSG_MENU_TITLE_GROUP_BUILD                                               NSLocalizedString(@"创建群组", nil)
#define STR_MSG_MENU_TITLE_ADD_FRIEND                                                NSLocalizedString(@"添加朋友", nil)
#define STR_MSG_MENU_TITLE_SCAN_QRCODE                                               NSLocalizedString(@"扫一扫", nil)

#pragma mark - 按钮的标题
#define STR_NAV_BUTTON_TITLE_RECHARGE_RECORD                                         NSLocalizedString(@"充值记录", nil)
#define STR_NAV_BUTTON_TITLE_WITHDRAW_RECORD                                         NSLocalizedString(@"提款记录", nil)

#pragma mark - 充值渠道 - 渠道类型
#define STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL                                        1
#define STR_RECHARGE_CHANNELPAY_TYPE_VIP                                             2
#define STR_RECHARGE_CHANNELPAY_TYPE_THIRD                                           3
#pragma mark - 充值渠道 - 支付类型
#define STR_RECHARGE_CHANNELPAY_MODE_KEY_WECHAT                                      1
#define STR_RECHARGE_CHANNELPAY_MODE_KEY_ALIPAY                                      2
#define STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD                                    3
#define STR_RECHARGE_CHANNELPAY_MODE_KEY_QQPAY                                       4
#define STR_RECHARGE_CHANNELPAY_MODE_KEY_JDPAY                                       5

#pragma mark - 游戏大厅
#define STR_GAMES_CENTER_CLASS_MENU_TITLE                                            NSLocalizedString(@"热门游戏", nil)
//
#define STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET                                       1  // 红包
#define STR_GAMES_CENTER_CLASS_TYPE_QIPAI                                            2  // 棋牌
#define STR_GAMES_CENTER_CLASS_TYPE_DIANZI                                           3  // 电子
#define STR_GAMES_CENTER_CLASS_TYPE_CAIPIAO                                          4  // 彩票
//
#define STR_GAMES_CENTER_CLASS_TYPE_DIANZI_SHUIGUOYXJ                                8  // 电子 - 水果游戏机
#define STR_GAMES_CENTER_CLASS_TYPE_DIANZI_XINGYUNDZP                                9  // 电子 - 幸运大转盘
#define STR_GAMES_CENTER_CLASS_TYPE_DIANZI_BENCHIBAOMA                               10 // 电子 - 奔驰宝马


#pragma mark - 个人中心
// 我的服务
#define STR_CENTER_MENU_ITEM_TIKUANZHONGXIN                                          NSLocalizedString(@"提款中心", nil)
#define STR_CENTER_MENU_ITEM_ZHUANZHANGJIAOYI                                        NSLocalizedString(@"转账交易", nil)
#define STR_CENTER_MENU_ITEM_HUODONGJIANGLI                                          NSLocalizedString(@"活动奖励", nil)
#define STR_CENTER_MENU_ITEM_ZHANGDANMINGXI                                          NSLocalizedString(@"账单明细", nil)
#define STR_CENTER_MENU_ITEM_YUEBAO                                                  NSLocalizedString(@"余额宝", nil)
#define STR_CENTER_MENU_ITEM_ERWEIMA                                                 NSLocalizedString(@"二维码", nil)
#define STR_CENTER_MENU_ITEM_PERSON_STATIC                                           NSLocalizedString(@"个人汇总", nil)
#define STR_CENTER_MENU_ITEM_FENXIANGZHUANQINA                                       NSLocalizedString(@"分享赚钱", nil)
#define STR_CENTER_MENU_ITEM_XINSHOUJIAOCHENG                                        NSLocalizedString(@"新手教程", nil)
// 代理中心
#define STR_CENTER_MENU_ITEM_DAILIZHONGXING                                          NSLocalizedString(@"代理中心", nil)
//
#define STR_CENTER_MENU_ITEM_SHENQINGDAILI_YES                                       NSLocalizedString(@"您已是代理", nil)
#define STR_CENTER_MENU_ITEM_SHENQINGDAILI                                           NSLocalizedString(@"申请代理", nil)
#define STR_CENTER_MENU_ITEM_DALIKAIHU                                               NSLocalizedString(@"代理开户", nil)
#define STR_CENTER_MENU_ITEM_WODEXIAXIAN                                             NSLocalizedString(@"我的下线", nil)
#define STR_CENTER_MENU_ITEM_DAILIBAOBIAO                                            NSLocalizedString(@"代理报表", nil)
//
#define STR_CENTER_MENU_ITEM_DAILIGUIZE                                              NSLocalizedString(@"代理规则", nil)
#define STR_CENTER_MENU_ITEM_TUIGUANWENAN                                            NSLocalizedString(@"推广文案", nil)
#define STR_CENTER_MENU_ITEM_FUZHITUIGLINKURL                                        NSLocalizedString(@"推广链接", nil)
#define STR_CENTER_MENU_ITEM_FUZHIYAOQINGMA                                          NSLocalizedString(@"邀请码", nil)
// 游戏报表
#define STR_CENTER_MENU_ITEM_FULIHONGBAO                                             NSLocalizedString(@"福利红包", nil)
#define STR_CENTER_MENU_ITEM_SHAOLEIHONGBAO                                          NSLocalizedString(@"扫雷红包", nil)
#define STR_CENTER_MENU_ITEM_NIUNIUHONGBO                                            NSLocalizedString(@"牛牛红包", nil)
#define STR_CENTER_MENU_ITEM_JINQIANGHONGBAO                                         NSLocalizedString(@"禁抢红包", nil)
#define STR_CENTER_MENU_ITEM_ERRENNIUNIU                                             NSLocalizedString(@"二人牛牛", nil)
//
#define STR_AGENT_CENTER_MENU_ITEM_SHENQINGDAILI                                     NSLocalizedString(@"申请代理", nil)
#define STR_AGENT_CENTER_MENU_ITEM_FENXIANGZHUANQINA                                 NSLocalizedString(@"分享赚钱", nil)
#define STR_AGENT_CENTER_MENU_ITEM_XIAJIWANJIA                                       NSLocalizedString(@"下级玩家", nil)
#define STR_AGENT_CENTER_MENU_ITEM_TUIGUANGWENAN                                     NSLocalizedString(@"推广文案", nil)
#define STR_AGENT_CENTER_MENU_ITEM_DAILIGUIZE                                        NSLocalizedString(@"代理规则", nil)
#define STR_AGENT_CENTER_MENU_ITEM_WODEBAOBIAO                                       NSLocalizedString(@"我的报表", nil)




#endif /* _CFC_STRING_MACRO_H_ */

