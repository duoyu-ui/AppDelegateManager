//
//  FYJSSLMachineSelecteView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FYJSSLMachineSelecteView;
@protocol JSSLMachineSelecteDelegate <NSObject>

- (void)gameJSSLMachineSelecteWithView:(FYJSSLMachineSelecteView*)selecteView row:(NSInteger)row;

@end

///机选view
@class FYJSSLSelecteModel;
@interface FYJSSLMachineSelecteView : UIView
@property (nonatomic , weak) id<JSSLMachineSelecteDelegate> delegate;
@property (nonatomic , strong) FYJSSLSelecteModel *model;
+ (CGFloat)headerViewHeight;
@end
@interface FYJSSLSelecteModel: NSObject
@property (nonatomic , strong) NSArray <NSString*> *titles;
@property (nonatomic , strong) NSArray <NSString*> *images;
///机选
+ (FYJSSLSelecteModel*)setMachineSelecte;
///活动,走势,记录模型
+ (FYJSSLSelecteModel*)setGamedataModel;
@end
NS_ASSUME_NONNULL_END
