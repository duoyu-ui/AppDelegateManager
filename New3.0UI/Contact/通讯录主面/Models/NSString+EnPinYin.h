//
//  NSString+EnPinYin.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (EnPinYin)

/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)toPinyin;


@end

NS_ASSUME_NONNULL_END
