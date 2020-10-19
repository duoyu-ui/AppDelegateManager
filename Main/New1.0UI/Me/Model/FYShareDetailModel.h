//
//  FYShareDetailModel.h
//  ProjectCSHB
//
//  Created by Tom on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYShareDetailModel : NSObject
@property (nonatomic , assign) NSInteger              shareType;
@property (nonatomic , assign) BOOL              delFlag;
@property (nonatomic , copy) NSString              * endAvatar;
@property (nonatomic , assign) NSInteger              clickNum;
//@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * lastUpdateTime;
@property (nonatomic , copy) NSString              * firstAvatar;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * secondAvatar;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * url;
/**图片大小*/
//@property (nonatomic ,assign)CGSize imageSize;

@end

NS_ASSUME_NONNULL_END
