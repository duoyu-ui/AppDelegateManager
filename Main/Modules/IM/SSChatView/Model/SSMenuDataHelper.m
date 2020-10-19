//
//  SSMenuDataHelper.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/12/9.
//  Copyright © 2019 Fangyuan. All rights reserved.
//  配置菜单栏

#import "SSMenuDataHelper.h"


@implementation SSMenuDataHelper

static SSMenuDataHelper *_instance = nil;

+ (instancetype)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         _instance = [[SSMenuDataHelper alloc] init];
    });
    return _instance;
}

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
 tag = 2015  <===>  提款
 tag = 2016  <===>  余额宝
 
 tag = 2017  <===>  二维码
 */

/// 游戏类（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷）
- (NSArray <SSChatMenuConfig *>*)loadMenusWithChatType:(NSInteger)chatType officeFlag:(BOOL)officeFlag gameType:(NSInteger)gameType {
    NSArray *configMenus = nil;
    
    if (chatType == 1) { // 群聊
        if (officeFlag) { // 官方群
            if (GroupTemplate_N04_RobNiuNiu == gameType
                || GroupTemplate_N05_ErBaGang == gameType) {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"期数记录", nil) image:@"icon_bottom_record_periods" tag:KEYBOARD_FUNCTION_UUID_ISSUE_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"投注记录", nil) image:@"icon_bottom_record_bet" tag:KEYBOARD_FUNCTION_UUID_BETTING_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            } else if (GroupTemplate_N06_LongHuDou == gameType) {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"期数记录", nil) image:@"icon_bottom_record_periods" tag:KEYBOARD_FUNCTION_UUID_ISSUE_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"投注记录", nil) image:@"icon_bottom_record_bet" tag:KEYBOARD_FUNCTION_UUID_BETTING_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"福利", nil) image:@"icon_bottom_welfare" tag:KEYBOARD_FUNCTION_UUID_FULI],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            } else if (GroupTemplate_N07_JieLong == gameType) {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"游戏记录", nil) image:@"icon_bottom_record_bet" tag:KEYBOARD_FUNCTION_UUID_BETTING_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"福利", nil) image:@"icon_bottom_welfare" tag:KEYBOARD_FUNCTION_UUID_FULI],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            } else if (GroupTemplate_N10_BagLottery == gameType
                       || GroupTemplate_N11_BagBagCow == gameType
                       || GroupTemplate_N14_BestNiuNiu == gameType) {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            } else {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"福利", nil) image:@"icon_bottom_welfare" tag:KEYBOARD_FUNCTION_UUID_FULI],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"照片", nil) image:@"icon_bottom_photo" tag:KEYBOARD_FUNCTION_UUID_PHOTO],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"拍照", nil) image:@"icon_bottom_takep" tag:KEYBOARD_FUNCTION_UUID_CARAMER],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            }
        } else {
            // 自建群
            if (GroupTemplate_N00_FuLi == gameType) {
                if ([AppModel shareInstance].isGroupOwner) { // 如果是群主
                    configMenus = @[
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"福利", nil) image:@"icon_bottom_welfare" tag:KEYBOARD_FUNCTION_UUID_FULI],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                        //
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"照片", nil) image:@"icon_bottom_photo" tag:KEYBOARD_FUNCTION_UUID_PHOTO],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"拍照", nil) image:@"icon_bottom_takep" tag:KEYBOARD_FUNCTION_UUID_CARAMER],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                        //
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                    ];
                } else {
                    configMenus = @[
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                        //
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"照片", nil) image:@"icon_bottom_photo" tag:KEYBOARD_FUNCTION_UUID_PHOTO],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"拍照", nil) image:@"icon_bottom_takep" tag:KEYBOARD_FUNCTION_UUID_CARAMER],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                        //
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                    ];
                }
            } else if (GroupTemplate_N04_RobNiuNiu == gameType
                || GroupTemplate_N05_ErBaGang == gameType) {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"期数记录", nil) image:@"icon_bottom_record_periods" tag:KEYBOARD_FUNCTION_UUID_ISSUE_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"投注记录", nil) image:@"icon_bottom_record_bet" tag:KEYBOARD_FUNCTION_UUID_BETTING_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            } else if (GroupTemplate_N06_LongHuDou == gameType) {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"期数记录", nil) image:@"icon_bottom_record_periods" tag:KEYBOARD_FUNCTION_UUID_ISSUE_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"投注记录", nil) image:@"icon_bottom_record_bet" tag:KEYBOARD_FUNCTION_UUID_BETTING_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"福利", nil) image:@"icon_bottom_welfare" tag:KEYBOARD_FUNCTION_UUID_FULI],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            } else if (GroupTemplate_N07_JieLong == gameType) {
                configMenus = @[
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"游戏记录", nil) image:@"icon_bottom_record_bet" tag:KEYBOARD_FUNCTION_UUID_BETTING_RECORDS],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"福利", nil) image:@"icon_bottom_welfare" tag:KEYBOARD_FUNCTION_UUID_FULI],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                    //
                    [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                ];
            } else {
                if ([AppModel shareInstance].isGroupOwner) { // 如果是群主
                    configMenus = @[
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"福利", nil) image:@"icon_bottom_welfare" tag:KEYBOARD_FUNCTION_UUID_FULI],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                        //
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"照片", nil) image:@"icon_bottom_photo" tag:KEYBOARD_FUNCTION_UUID_PHOTO],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"拍照", nil) image:@"icon_bottom_takep" tag:KEYBOARD_FUNCTION_UUID_CARAMER],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                    ];
                } else {
                    configMenus = @[
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"转账", nil) image:@"icon_bottom_transfer" tag:KEYBOARD_FUNCTION_UUID_TRANSFER_MONEY],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
                        //
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"照片", nil) image:@"icon_bottom_photo" tag:KEYBOARD_FUNCTION_UUID_PHOTO],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"拍照", nil) image:@"icon_bottom_takep" tag:KEYBOARD_FUNCTION_UUID_CARAMER],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"提款", nil) image:@"icon_bottom_draw" tag:KEYBOARD_FUNCTION_UUID_DRAW_MONEY],
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"余额宝", nil) image:@"icon_bottom_yeb" tag:KEYBOARD_FUNCTION_UUID_YUEBAO],
                        //
                        [SSChatMenuConfig initWithTitle:NSLocalizedString(@"二维码", nil) image:@"icon_bottom_qr" tag:KEYBOARD_FUNCTION_UUID_QRCODE]
                    ];
                }
            }
        }
    } else {
        // 单聊
        configMenus = @[
            [SSChatMenuConfig initWithTitle:NSLocalizedString(@"帮助", nil) image:@"icon_bottom_help" tag:KEYBOARD_FUNCTION_UUID_HELPER],
            [SSChatMenuConfig initWithTitle:NSLocalizedString(@"加盟", nil) image:@"icon_bottom_join" tag:KEYBOARD_FUNCTION_UUID_JIAMENG],
            [SSChatMenuConfig initWithTitle:NSLocalizedString(@"客服", nil) image:@"icon_bottom_service" tag:KEYBOARD_FUNCTION_UUID_CUSTOMER],
            [SSChatMenuConfig initWithTitle:NSLocalizedString(@"充值", nil) image:@"icon_bottom_recharge" tag:KEYBOARD_FUNCTION_UUID_RECHARGE],
            //
            [SSChatMenuConfig initWithTitle:NSLocalizedString(@"赚钱", nil) image:@"icon_bottom_makem" tag:KEYBOARD_FUNCTION_UUID_ERANMONEY],
            [SSChatMenuConfig initWithTitle:NSLocalizedString(@"照片", nil) image:@"icon_bottom_photo" tag:KEYBOARD_FUNCTION_UUID_PHOTO],
            [SSChatMenuConfig initWithTitle:NSLocalizedString(@"拍照", nil) image:@"icon_bottom_takep" tag:KEYBOARD_FUNCTION_UUID_CARAMER],
        ];
    }
        
    return configMenus;
}


@end
