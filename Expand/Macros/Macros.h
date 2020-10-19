//
//  Macros.h
//  Project
//
//  Created by Mike on 2019/1/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#import "DYMacro.h"

// 1:新增微信登录 2:新增游客登录 3:新登录界面 4:第3期
#define APP_ENUM_VERSION  4

#define kColorWithHex(hex) [UIColor colorWithRed:((float)((hex & 0xff0000) >> 16))/255.0 green:((float)((hex & 0x00ff00) >> 8))/255.0 blue:((float)(hex & 0x0000ff))/255.0 alpha:1.0]

#define kThemeTextColor kColorWithHex(0xe41c27)

#endif /* Macros_h */
