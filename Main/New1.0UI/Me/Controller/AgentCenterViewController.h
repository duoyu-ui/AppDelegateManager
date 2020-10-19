//
//  AgentCenterViewController.h
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface AgentTypeView : UIView
@property(nonatomic,copy)DataBlock selectBlock;
- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray;
@end

@interface AgentLinkView : UIView
@property(nonatomic,copy)DataBlock selectBlock;
- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray;
@end

@interface CellItemView : UIView
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,assign)NSDictionary *infoDic;
@end

@interface AgentCenterViewController : SuperViewController
@property(nonatomic,strong)UIImageView* iv;
@end

NS_ASSUME_NONNULL_END
