//
//  FYMyBankCardModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define COLOR_BANK_CARD_NORMAL COLOR_HEXSTRING(@"#999999")
#define COLOR_BANK_CARD_SELECT COLOR_HEXSTRING(@"#F68B00")

// 网页类游戏类型
typedef NS_ENUM(NSInteger, FYMyBankCardCellType){
    FYMyBankCardCellTypeNull = 1,  // 空
    FYMyBankCardCellTypeCard = 2, // 银行卡
    FYMyBankCardCellTypeUnBind = 3, // 银行卡解绑
    FYMyBankCardCellTypeAddCard = 4, // 添加银行卡
};

@interface FYMyBankModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@end


@interface FYMyBankCardModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankRegion;

@property (nonatomic, strong) NSNumber *upayNo;
@property (nonatomic, strong) NSString *upayNoHideStr;
@property (nonatomic, strong) NSNumber *upaytId;

@property (nonatomic, strong) NSNumber *createBy;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *targetId;

@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) FYMyBankModel *code;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) FYMyBankCardCellType cellType;

- (UIImage *)bankCardImage;

+ (NSMutableArray<FYMyBankCardModel *> *) buildingDataModles:(NSArray<FYMyBankCardModel *> *)itemModels
                                               selectedModel:(FYMyBankCardModel *)selectedModel
                                                        then:(void (^)(FYMyBankCardModel*selectedModel))then;

/// 选择银行卡
+ (NSMutableArray *) buildingDataModlesForSelect:(NSArray<FYMyBankCardModel *> *)itemModels
                                   selectedModel:(FYMyBankCardModel *)selectedModel
                             isFromPersonSetting:(BOOL)isFromPersonSetting
                                            then:(void (^)(FYMyBankCardModel * selectedModel))then;

/// 解绑银行卡
+ (NSMutableArray *) buildingDataModlesForUnBind:(NSArray<FYMyBankCardModel *> *)itemModels
                                   selectedModel:(FYMyBankCardModel *)selectedModel
                                            then:(void (^)(FYMyBankCardModel * selectedModel))then;

@end

NS_ASSUME_NONNULL_END
