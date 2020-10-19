//
//  FYMyBankCardModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMyBankCardModel.h"

@implementation FYMyBankModel
@end

@implementation FYMyBankCardModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

- (UIImage *)bankCardImage
{
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", self.bankName];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:@"BankIcons.bundle"];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];;
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    return image;
}

+ (NSMutableArray<FYMyBankCardModel *> *) buildingDataModles:(NSArray<FYMyBankCardModel *> *)itemModels
                                               selectedModel:(FYMyBankCardModel *)selectedModel
                                                        then:(void (^)(FYMyBankCardModel * selectedModel))then
{
    if (!itemModels || itemModels.count <= 0) {
        FYMyBankCardModel *modelOfNull = [[FYMyBankCardModel alloc] init];
        [modelOfNull setCellType:FYMyBankCardCellTypeNull];
        !then ?: then(nil);
        return @[modelOfNull].mutableCopy;
    }

    __block NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
    [itemModels enumerateObjectsWithIndex:^(FYMyBankCardModel *object, NSUInteger index) {
        [object setCellType:FYMyBankCardCellTypeCard];
        if (selectedModel) {
            if (selectedModel.uuid.integerValue != object.uuid.integerValue) {
                [object setIsSelected:NO];
            } else {
                [object setIsSelected:YES];
            }
        } else {
            // selectedModel 为空，说明没有银行卡，第一次添加的银行卡，默认选中
            [object setIsSelected:YES];
            !then ?: then(object);
        }
        [bankCardModels addObj:object];
    }];
    //
    FYMyBankCardModel *modelOfAddCard = [[FYMyBankCardModel alloc] init];
    [modelOfAddCard setCellType:FYMyBankCardCellTypeAddCard];
    [bankCardModels addObj:modelOfAddCard];
    
    return [NSMutableArray<FYMyBankCardModel *> arrayWithArray:bankCardModels];
}


/// 选择银行卡
+ (NSMutableArray *) buildingDataModlesForSelect:(NSArray<FYMyBankCardModel *> *)itemModels
                                   selectedModel:(FYMyBankCardModel *)selectedModel
                             isFromPersonSetting:(BOOL)isFromPersonSetting
                                            then:(void (^)(FYMyBankCardModel * selectedModel))then
{
    // 未绑定银行卡
    if (!itemModels || itemModels.count <= 0) {
        FYMyBankCardModel *modelOfNull = [[FYMyBankCardModel alloc] init];
        [modelOfNull setCellType:FYMyBankCardCellTypeNull];
        !then ?: then(nil);
        return @[ @[modelOfNull] ].mutableCopy;
    }
    
    // 绑定的银行卡
    NSMutableArray *sectionOfBankCard = [NSMutableArray array];
    {
        __block NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
        [itemModels enumerateObjectsWithIndex:^(FYMyBankCardModel *object, NSUInteger index) {
            [object setCellType:FYMyBankCardCellTypeCard];
            if (selectedModel) {
                if (selectedModel.uuid.integerValue != object.uuid.integerValue) {
                    [object setIsSelected:NO];
                } else {
                    [object setIsSelected:YES];
                }
            } else {
                // selectedModel 为空，说明没有银行卡，第一次添加的银行卡，默认选中
                [object setIsSelected:YES];
                !then ?: then(object);
            }
            if (isFromPersonSetting) {
                [object setIsSelected:NO];
            }
            [bankCardModels addObj:object];
        }];
        [sectionOfBankCard addObjectsFromArray:bankCardModels];
    }
    
    // 功能按钮（解绑银行卡）
    NSMutableArray *sectionOfFunction = [NSMutableArray array];
    {
        NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
        FYMyBankCardModel *modelOfAddCard = [[FYMyBankCardModel alloc] init];
        [modelOfAddCard setCellType:FYMyBankCardCellTypeUnBind];
        [modelOfAddCard setBankName:NSLocalizedString(@"解除绑定", nil)];
        [bankCardModels addObj:modelOfAddCard];
        //
        [sectionOfFunction addObjectsFromArray:bankCardModels];
    }
    
    return @[ sectionOfBankCard, sectionOfFunction ].mutableCopy;
}

/// 解绑银行卡
+ (NSMutableArray *) buildingDataModlesForUnBind:(NSArray<FYMyBankCardModel *> *)itemModels
                                   selectedModel:(FYMyBankCardModel *)selectedModel
                                            then:(void (^)(FYMyBankCardModel * selectedModel))then
{
    // 绑定的银行卡
    NSMutableArray *sectionOfBankCard = [NSMutableArray array];
    {
        __block FYMyBankCardModel *currentSelectedModel = selectedModel;
        __block NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
        [itemModels enumerateObjectsWithIndex:^(FYMyBankCardModel *object, NSUInteger index) {
            [object setCellType:FYMyBankCardCellTypeCard];
            if (selectedModel) {
                if (selectedModel.uuid.integerValue != object.uuid.integerValue) {
                    [object setIsSelected:NO];
                } else {
                    [object setIsSelected:YES];
                }
            } else {
                // selectedModel 为空，说明没有银行卡，第一次添加的银行卡，默认选中
                [object setIsSelected:YES];
                currentSelectedModel = object;
            }
            [bankCardModels addObj:object];
        }];
        [sectionOfBankCard addObjectsFromArray:bankCardModels];
        
        !then ?: then(currentSelectedModel);
    }
    
    return @[ sectionOfBankCard ].mutableCopy;
}


@end

