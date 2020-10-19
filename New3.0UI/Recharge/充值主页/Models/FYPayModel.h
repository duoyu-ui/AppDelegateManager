//
//  FYPayModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYPayModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *sort;

@property (nonatomic, copy) NSString *normalImages;
@property (nonatomic, copy) NSString *selectedImages;

+ (NSMutableArray<FYPayModel *> *) buildingDataModles:(NSArray<FYPayModel *> *)items;

@end

NS_ASSUME_NONNULL_END
