//
//  FYDropDownMenuBasedCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 下拉菜单的基本cell,  自定义cell继承这个cell即可
 */
@interface FYDropDownMenuBasedCell : UITableViewCell
{
    @public
    id _menuModel;
}

/** 菜单模型 */
@property (nonatomic, strong) id menuModel;

@end

NS_ASSUME_NONNULL_END
