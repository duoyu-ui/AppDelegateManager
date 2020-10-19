//
//  FYHTTPResponseModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYHTTPResponseModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *alterMsg;
@property (nonatomic, copy) NSString *errorcode;
@property (nonatomic, strong) NSDictionary *data;
@end

NS_ASSUME_NONNULL_END
