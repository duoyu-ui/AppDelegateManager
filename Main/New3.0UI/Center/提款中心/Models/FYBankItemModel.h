//
//  FYBankItemModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBankItemModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;

- (UIImage *)bankCardImage;

@end

NS_ASSUME_NONNULL_END
