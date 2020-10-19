//
//  FYBagBagCowBetHubView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^bagBagCowGoBet)(NSInteger betAttr,NSString *money,BOOL isPay);
@interface FYBagBagCowBetHubView : UIView
+ (void)showHubViewWithList:(NSString *)list block:(bagBagCowGoBet)block;
@end

NS_ASSUME_NONNULL_END
