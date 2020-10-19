//
//  FYBestWinsLossesModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface FYBestWinsLossesPokers :NSObject
@property (nonatomic , assign) NSInteger              number;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , assign) NSInteger              num;
@property (nonatomic , copy) NSString              * bigSmall;
@property (nonatomic , copy) NSString              * singleDouble;
@property (nonatomic , copy) NSString              * text;
/// 1: 梅花 2:方块 3:红桃 4:黑桃
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , strong) UIImage *pokersImg;
@end

@interface FYBestWinsLossesRed :NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * niuShuName;
@property (nonatomic , copy) NSArray<FYBestWinsLossesPokers *>              * pokers;
@property (nonatomic , assign) NSInteger              niuShuNum;

@end

@interface FYBestWinsLossesBlue :NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * niuShuName;
@property (nonatomic , copy) NSArray<FYBestWinsLossesPokers *>              * pokers;
@property (nonatomic , assign) NSInteger              niuShuNum;

@end

@interface FYBestWinsLossesFlopResult :NSObject
@property (nonatomic , assign) NSInteger              groupId;
@property (nonatomic , strong) FYBestWinsLossesRed              * red;
///1:蓝方胜 2:红方胜
@property (nonatomic , assign) NSInteger              winSide;
@property (nonatomic , strong) FYBestWinsLossesBlue              * blue;
@property (nonatomic , assign) NSInteger              gameNumber;

@end

@interface FYBestWinsLossesModel :NSObject
@property (nonatomic , strong) FYBestWinsLossesFlopResult              * flopResult;
@property (nonatomic , assign) NSInteger              flopType;

@end
NS_ASSUME_NONNULL_END
