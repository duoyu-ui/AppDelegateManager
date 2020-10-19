//
//  FYCenterMenuSectionModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMenuSectionModel.h"

@implementation FYCenterMenuItemCategoryModel
@end


@implementation FYCenterMenuItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"name",
             @"imageUrl" : @"icon"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"category" : @"FYCenterMenuItemCategoryModel" };
}

+ (NSMutableArray<FYCenterMenuItemModel *> *) buildingDataModlesForMyService
{
    NSArray<NSDictionary<NSString *, NSString *> *> *arrayOfDict = @[
        @{
            @"name": STR_CENTER_MENU_ITEM_TIKUANZHONGXIN,
            @"icon": @"icon_center_deposit",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_ZHUANZHANGJIAOYI,
            @"icon": @"icon_center_transfer",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_HUODONGJIANGLI,
            @"icon": @"icon_center_award",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_YUEBAO,
            @"icon": @"icon_center_yeb",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_FENXIANGZHUANQINA,
            @"icon": @"icon_center_share",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_XINSHOUJIAOCHENG,
            @"icon": @"icon_center_tutorial",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_PERSON_STATIC,
            @"icon": @"icon_center_person_static",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_ZHANGDANMINGXI,
            @"icon": @"icon_center_detail",
        }
    ];
    return [FYCenterMenuItemModel mj_objectArrayWithKeyValuesArray:arrayOfDict];
}

+ (NSMutableArray<FYCenterMenuItemModel *> *) buildingDataModlesForAgentCenter
{
    NSString *agentTitle = 1==APPINFORMATION.userInfo.agentFlag ? STR_CENTER_MENU_ITEM_SHENQINGDAILI_YES : STR_CENTER_MENU_ITEM_SHENQINGDAILI;
    NSArray<NSDictionary<NSString *, NSString *> *> *arrayOfDict = @[
        @{
            @"name": agentTitle,
            @"icon": @"icon_center_proxy_sqdl",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_DALIKAIHU,
            @"icon": @"icon_center_proxy_dlkh",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_TUIGUANWENAN,
            @"icon": @"icon_center_proxy_tgwa",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_FUZHITUIGLINKURL,
            @"icon": @"icon_center_proxy_gztglj",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_DAILIBAOBIAO,
            @"icon": @"icon_center_proxy_dlbb",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_DAILIGUIZE,
            @"icon": @"icon_center_proxy_dlgz",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_WODEXIAXIAN,
            @"icon": @"icon_center_proxy_wdxx",
        },
        @{
            @"name": STR_CENTER_MENU_ITEM_FUZHIYAOQINGMA,
            @"icon": @"icon_center_proxy_fzyqm",
        }
    ];
    return [FYCenterMenuItemModel mj_objectArrayWithKeyValuesArray:arrayOfDict];
}

@end


@implementation FYCenterMenuReportModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"name"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"childList" : @"FYCenterMenuItemModel" };
}

@end


@implementation FYCenterMenuSectionModel

+ (FYCenterMenuSectionModel *) buildingDataModlesForMyService
{
    FYCenterMenuSectionModel *model = [[FYCenterMenuSectionModel alloc] init];
    [model setTitle:NSLocalizedString(@"我的服务", nil)];
    [model setList:[FYCenterMenuItemModel buildingDataModlesForMyService]];
    return model;
}

+ (FYCenterMenuSectionModel *) buildingDataModlesForAgentCenter
{
    FYCenterMenuSectionModel *model = [[FYCenterMenuSectionModel alloc] init];
    [model setTitle:NSLocalizedString(@"代理中心", nil)];
    [model setList:[FYCenterMenuItemModel buildingDataModlesForAgentCenter]];
    return model;
}

+ (NSMutableArray<FYCenterMenuSectionModel *> *) buildingDataModles
{
    NSMutableArray<FYCenterMenuSectionModel *> *models = [NSMutableArray array];
    [models addObject:[[self class] buildingDataModlesForMyService]];
    [models addObject:[[self class] buildingDataModlesForAgentCenter]];
    return models;
}


@end
