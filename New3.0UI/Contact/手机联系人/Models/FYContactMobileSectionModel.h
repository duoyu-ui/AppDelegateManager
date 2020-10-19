//
//  FYContactMobileSectionModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYMobilePerson;

NS_ASSUME_NONNULL_BEGIN

@interface FYContactMobileSectionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<FYMobilePerson *> *persons;


+ (NSMutableArray<NSString *> *)getSectionTitles:(NSMutableArray<NSMutableArray<FYMobilePerson *> *> *)array;
+ (NSMutableArray<NSMutableArray<FYMobilePerson *> *> *) getSectionData:(NSArray<FYMobilePerson *> *)array;

+ (NSMutableArray<FYContactMobileSectionModel *> *) getContactMobileDataSource:(NSArray<FYMobilePerson *> *)itemPersonModels;
+ (NSMutableArray<NSString *> *)getContactMobileSectionTitles:(NSMutableArray<FYContactMobileSectionModel *> *)sectionModels;


@end

NS_ASSUME_NONNULL_END

