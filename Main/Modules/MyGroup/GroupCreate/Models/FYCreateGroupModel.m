//
//  FYCreateGroupModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYCreateGroupModel.h"

@implementation FYCreateGroupModel

- (instancetype)createModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(CreateCellStyle)style
{
    if (self == [super init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.style = style;
    }
    return self;
}

+ (instancetype)createModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(CreateCellStyle)style {
    FYCreateGroupModel *model = [[FYCreateGroupModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    model.style = style;
    return model;
}

- (instancetype)initGroupTypeWithTitle:(NSString *)title isSelected:(BOOL)isSelected {
    if (self == [super init]) {
        self.title = title;
        self.isSelected = isSelected;
    }
    return self;
}

+ (instancetype)initGroupTypeWithTitle:(NSString *)title isSelected:(BOOL)isSelected {
    FYCreateGroupModel *model = [[FYCreateGroupModel alloc] init];
    model.title = title;
    model.isSelected = isSelected;
    return model;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    if (self == [super init]) {
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

+ (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    FYCreateGroupModel *model = [[FYCreateGroupModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    return model;
}

@end
