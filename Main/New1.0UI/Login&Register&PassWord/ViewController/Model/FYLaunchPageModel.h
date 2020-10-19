//
//  FYLaunchPageModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FYLaunchPageModel : NSObject
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,strong)UIColor *titleColor;
@property (nonatomic ,strong)UIColor *backgroundColor;
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor;
@end


@interface FYLaunchSkAdvDetailList :NSObject
@property (nonatomic , copy) NSString              * advLinkUrl;
@property (nonatomic , copy) NSString              * advSpaceId;
@property (nonatomic , copy) NSString              * advPicUrl;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * linkType;

@end

@interface FYLaunchData :NSObject

@property (nonatomic , strong) NSArray *skAdvDetailList;

@property (nonatomic , copy) NSString              * displayWay;
@property (nonatomic , copy) NSString              * carouselTime;
@property (nonatomic , copy) NSString              * carouselSecTime;

@end

@interface FYLaunchModels :NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) FYLaunchData        * data;
@property (nonatomic , copy) NSString              * code;

@end
