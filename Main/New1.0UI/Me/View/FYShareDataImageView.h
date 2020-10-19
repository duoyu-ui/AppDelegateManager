//
//  FYShareDataImageView.h
//  ProjectCSHB
//
//  Created by Tom on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYShareDetailModel.h"


@interface FYShareDataImageView : UIScrollView
@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, strong) FYShareDetailModel *model;
@property (nonatomic, strong) UIButton *copyBtn;
@end


