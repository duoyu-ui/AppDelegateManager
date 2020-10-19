//
//  FYContactDataHelper.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactDataHelper.h"
#import "NSString+EnPinYin.h"
#import "FYContactSectionModel.h"
#import "FYContactsModel.h"

@implementation FYContactDataHelper


+ (NSMutableArray<NSString *> *)getSectionTitles:(NSMutableArray<NSMutableArray<FYContactsModel *> *> *)array
{
    NSMutableArray *section = [[NSMutableArray alloc] init];

    for (NSArray *item in array) {
        FYContactsModel *contact = [item objectAtIndex:0];
        NSString *nick = VALIDATE_STRING_EMPTY(contact.friendNick) ? STR_TRI_WHITE_SPACE(contact.nick) : STR_TRI_WHITE_SPACE(contact.friendNick);
        char c = [nick.toPinyin characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    
    return section;
}


+ (NSMutableArray<NSMutableArray<FYContactsModel *> *> *) getSectionData:(NSMutableArray<FYContactsModel *> *)array
{
    NSMutableArray *contactSections = [[NSMutableArray alloc] init];
    
    // 拼音排序
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(FYContactsModel * obj1, FYContactsModel * obj2) {
        NSString *nick1 = VALIDATE_STRING_EMPTY(obj1.friendNick) ? STR_TRI_WHITE_SPACE(obj1.nick) : STR_TRI_WHITE_SPACE(obj1.friendNick);
        NSString *nick2 = VALIDATE_STRING_EMPTY(obj2.friendNick) ? STR_TRI_WHITE_SPACE(obj2.nick) : STR_TRI_WHITE_SPACE(obj2.friendNick);
        
        int i;
        NSString *strA = nick1.toPinyin;
        NSString *strB = nick2.toPinyin;
        
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;  // 上升
            } else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;  // 下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if (strA.length < strB.length) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    //
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *other = [[NSMutableArray alloc] init];
    for (FYContactsModel *contact in serializeArray) {
        NSString *nick = VALIDATE_STRING_EMPTY(contact.friendNick) ? STR_TRI_WHITE_SPACE(contact.nick) : STR_TRI_WHITE_SPACE(contact.friendNick);
        char c = [nick.toPinyin characterAtIndex:0];
        if (!isalpha(c)) {
            [other addObject:contact];
        } else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [contactSections addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:contact];
        } else {
            [data addObject:contact];
        }
    }
    
    if (data && data.count > 0) {
        [contactSections addObject:data];
    }
    if (other.count > 0) {
        [contactSections addObject:other];
    }
    
    return contactSections;
}

+ (NSMutableArray<FYContactSectionModel *> *) getContactSecionModelsBySectionData:(NSMutableArray<NSMutableArray<FYContactsModel *> *> *)sectionData sectionTitles:(NSMutableArray<NSString *> *)sectionTitles
{
    __block NSMutableArray<FYContactSectionModel *> *sectionModels = [NSMutableArray arrayWithCapacity:sectionTitles.count];
    
    [sectionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < sectionData.count) {
            NSMutableArray<FYContactsModel *> *contacts = [sectionData objectAtIndex:idx];
            FYContactSectionModel *sectionModel = [[FYContactSectionModel alloc] init];
            [sectionModel setTitle:title];
            [sectionModel setContacts:contacts];
            [sectionModels addObj:sectionModel];
        }
    }];
    
    return sectionModels;
}

+ (NSMutableArray<FYContactSectionModel *> *) getContactDataSource
{
    NSMutableArray<FYContactSectionModel *> *dataSource = [NSMutableArray array];
    
    // 本地功能
    {
        FYContactSectionModel *sectionModel = [FYContactSectionModel buildingDataModleForFunction];
        [dataSource addObj:sectionModel];
    }
    
    // 客服数据
    {
        FYContactSectionModel *sectionModel = [FYContactSectionModel buildingDataModleForCustomerService];
        [dataSource addObj:sectionModel];
    }
    
    // 朋友数据
    {
        // 朋友数据
        NSArray<IMUserEntity *> *allFriendEntities = [[IMContactsModule sharedInstance] getAllFreinds];
        NSArray<NSDictionary *> *arrayOfDicts = [IMUserEntity mj_keyValuesArrayWithObjectArray:allFriendEntities];
        NSMutableArray<FYContactsModel *> *allFriendModels = [FYContactsModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
        
        // 朋友分组
        NSMutableArray *sectionFriendData = [FYContactDataHelper getSectionData:allFriendModels];
        NSMutableArray *sectionFriendTitles = [FYContactDataHelper getSectionTitles:sectionFriendData];
        NSMutableArray<FYContactSectionModel *> *allSectionFriendModels = [FYContactDataHelper getContactSecionModelsBySectionData:sectionFriendData sectionTitles:sectionFriendTitles];
        
        // 朋友模型
        [dataSource addObjectsFromArray:allSectionFriendModels];
    }
    
    return dataSource;
}

+ (NSMutableArray<NSString *> *)getContactSectionTitles:(NSMutableArray<FYContactSectionModel *> *)sectionModels
{
    __block NSMutableArray<NSString *> *sectionTitles = [NSMutableArray array];
    
    [sectionTitles addString:UITableViewIndexSearch];

    [sectionModels enumerateObjectsUsingBlock:^(FYContactSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) {

        } else if (1 == idx) {
            [sectionTitles addString:NSLocalizedString(@"客", nil)];
        } else {
            [sectionTitles addString:obj.title];
        }
    }];
    
    return sectionTitles;
}


@end

