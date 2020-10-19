//
//  NiuNiuReportModel.h
//  Project
//
//  Created by 汤姆 on 2019/9/5.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NiuNiuReportModel : NSObject<NSCoding>

//@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , assign) NSInteger              profitLoss;
@property (nonatomic , copy) NSString              * niuStr;
@property (nonatomic , assign) NSInteger              mainId;
/**期数*/
@property (nonatomic , assign) NSInteger              period;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , copy) NSString              * userName;

/**
 投注
 */
@property (nonatomic , assign) NSInteger              betting;
@property (nonatomic , assign) NSInteger              score;
@property (nonatomic , assign) NSInteger              updateTime;
@end


