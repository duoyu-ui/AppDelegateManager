//
//  FYContactDataHelper.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYContactSectionModel, FYContactsModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYContactDataHelper : NSObject


+ (NSMutableArray<NSString *> *)getSectionTitles:(NSMutableArray<NSMutableArray<FYContactsModel *> *> *)array;
+ (NSMutableArray<NSMutableArray<FYContactsModel *> *> *) getSectionData:(NSMutableArray<FYContactsModel *> *)array;


// 所有联系人分组（本地+客服+朋友）
+ (NSMutableArray<FYContactSectionModel *> *) getContactDataSource;
+ (NSMutableArray<NSString *> *)getContactSectionTitles:(NSMutableArray<FYContactSectionModel *> *)sectionModels;


@end


NS_ASSUME_NONNULL_END
