//
//  FYContactMobileSectionModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactMobileSectionModel.h"
#import "FYMobilePerson.h"
#import "NSString+EnPinYin.h"

@implementation FYContactMobileSectionModel

+ (NSMutableArray<NSString *> *)getSectionTitles:(NSMutableArray<NSMutableArray<FYMobilePerson *> *> *)array
{
    NSMutableArray *section = [[NSMutableArray alloc] init];

    for (NSArray *item in array) {
        FYMobilePerson *contact = [item objectAtIndex:0];
        NSString *nick = VALIDATE_STRING_EMPTY(contact.fullName) ? @"" : STR_TRI_WHITE_SPACE(contact.fullName);
        char c = [nick.toPinyin characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    
    return section;
}


+ (NSMutableArray<NSMutableArray<FYMobilePerson *> *> *) getSectionData:(NSArray<FYMobilePerson *> *)array
{
    NSMutableArray *contactSections = [[NSMutableArray alloc] init];
    
    // 拼音排序
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(FYMobilePerson * obj1, FYMobilePerson * obj2) {
        NSString *nick1 = VALIDATE_STRING_EMPTY(obj1.fullName) ? @"" : STR_TRI_WHITE_SPACE(obj1.fullName);
        NSString *nick2 = VALIDATE_STRING_EMPTY(obj2.fullName) ? @"" : STR_TRI_WHITE_SPACE(obj2.fullName);
        
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
    for (FYMobilePerson *contact in serializeArray) {
        NSString *nick = VALIDATE_STRING_EMPTY(contact.fullName) ? @"" : STR_TRI_WHITE_SPACE(contact.fullName);
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

+ (NSMutableArray<FYContactMobileSectionModel *> *) getContactMobileSecionModelsBySectionData:(NSMutableArray<NSMutableArray<FYMobilePerson *> *> *)sectionData sectionTitles:(NSMutableArray<NSString *> *)sectionTitles
{
    __block NSMutableArray<FYContactMobileSectionModel *> *sectionModels = [NSMutableArray arrayWithCapacity:sectionTitles.count];
    
    [sectionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < sectionData.count) {
            NSMutableArray<FYMobilePerson *> *contacts = [sectionData objectAtIndex:idx];
            FYContactMobileSectionModel *sectionModel = [[FYContactMobileSectionModel alloc] init];
            [sectionModel setTitle:title];
            [sectionModel setPersons:contacts];
            [sectionModels addObj:sectionModel];
        }
    }];
    
    return sectionModels;
}

+ (NSMutableArray<FYContactMobileSectionModel *> *) getContactMobileDataSource:(NSArray<FYMobilePerson *> *)itemPersonModels
{
    NSMutableArray<FYContactMobileSectionModel *> *dataSource = [NSMutableArray array];
    
    NSMutableArray *sectionData = [[self class] getSectionData:itemPersonModels];
    NSMutableArray *sectionTitles = [[self class] getSectionTitles:sectionData];
    NSMutableArray<FYContactMobileSectionModel *> *allSectionFriendModels = [[self class] getContactMobileSecionModelsBySectionData:sectionData sectionTitles:sectionTitles];
    [dataSource addObjectsFromArray:allSectionFriendModels];
    
    return dataSource;
}

+ (NSMutableArray<NSString *> *)getContactMobileSectionTitles:(NSMutableArray<FYContactMobileSectionModel *> *)sectionModels
{
    __block NSMutableArray<NSString *> *sectionTitles = [NSMutableArray array];
    
    [sectionTitles addString:UITableViewIndexSearch];

    [sectionModels enumerateObjectsUsingBlock:^(FYContactMobileSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionTitles addString:obj.title];
    }];
    
    return sectionTitles;
}


@end

