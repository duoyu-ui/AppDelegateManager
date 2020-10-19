//
//  FYDropDownMenuBasedModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 定义一个菜单的block
typedef void(^FYMenuBlock)(void);

/**
 * 下拉菜单的基本模型，所有自定义模型必须继承这个模型
 * 注意:若自定义一个继承于这个类的菜单模型，必须要自定义一个继承于 FYDropDownMenuBasedCell 的菜单cell
 */
@interface FYDropDownMenuBasedModel : NSObject

/** 点击回调的block */
@property (nonatomic, copy) FYMenuBlock menuBlock;

/** 展示Cell名称 */
@property (nonatomic, copy) NSString *cellClassName;

@end

NS_ASSUME_NONNULL_END
