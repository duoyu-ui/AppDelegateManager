//
//  FYLanguageModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYLanguageModel : NSObject
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *code;
+ (NSString *)palyLanguageConfigType:(GroupTemplateType)type;
@end

NS_ASSUME_NONNULL_END
