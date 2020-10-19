//
//  FY2020LoginCell.h
//  FY_OC
//
//  Created by FangYuan on 2020/1/31.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYFieldModel : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, assign) BOOL isRequire;
+(FYFieldModel *)key:(NSString *)key value:(NSString *)value place:(NSString *)place require:(BOOL)reuire;
+(NSArray<FYFieldModel *> *)assembelArray:(NSArray *)source;
@end

@interface FY2020LoginCell : UITableViewCell

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIStackView *stackView;

@end

@interface FY2020LoginInputCell : UITableViewCell<UITextFieldDelegate,ActionSheetDelegate>

@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) UIButton *buttonCode;
@property (nonatomic, strong) UIButton *buttonRegisterCode;
@property (nonatomic, strong) FLAnimatedImageView *buttonImageAnimator;
@property (nonatomic, strong) FYFieldModel *model;
@property (nonatomic, copy) void(^actionCallBack)(NSInteger actionType);

@end

@interface FY2020LoginActionCell : UITableViewCell
@property (nonatomic, strong) UIButton *buttonLogin;
//@property (nonatomic, strong) UIButton *buttonOther;

@end

@interface FY2020LoginRedActionCell : UITableViewCell
@property (nonatomic, strong) UIButton *button;
@end

@interface FY2020LoginRightButtonCell : UITableViewCell
@property (nonatomic, strong) UIButton *button;
@end


NS_ASSUME_NONNULL_END
