//
//  DYMacro.h
//  ID贷
//
//  Created by apple on 2019/6/22.
//  Copyright © 2019 hansen. All rights reserved.
//

#ifndef DYMacro_h
#define DYMacro_h

#define kWeakly(self) typeof(self) __weak weakself = self;
#define kDefaultAvatarImage [UIImage imageNamed:@"addGroupContactAvatar_icon"]

#ifdef __OBJC__

#import "UIView+dy_extension.h"
#import "NSString+dy_extension.h"
#import "UIColor+dy_extension.h"

#endif

#endif /* DYMacro_h */
