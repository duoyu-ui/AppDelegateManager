//
//  FYBegLotteryHistoryModel.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBegLotteryHistoryModel.h"

@implementation FYBegLotteryHistoryModel

@end
@implementation FYBegLotteryHistoryData
@end
@implementation FYBegLotteryTool
+ (UIColor *)setLabBackgroundColor:(NSString *)num{
    switch ([num integerValue]) {
        case 0:
            return HexColor(@"#3CBE6A");
            break;
        case 1:
            return HexColor(@"#FCC901");
            break;
        case 2:
            return HexColor(@"#4EA0E6");
            break;
        case 3:
            return HexColor(@"#606060");
            break;
        case 4:
            return HexColor(@"#F77F44");
            break;
        case 5:
            return HexColor(@"#4EA0E8");
            break;
        case 6:
            return HexColor(@"#3819D4");
            break;
        case 7:
            return HexColor(@"#CECBCB");
            break;
        case 8:
            return HexColor(@"#FE5050");
            break;
        case 9:
            return HexColor(@"#AD2929");
            break;
        default:
            return UIColor.clearColor;
            break;
    }
}
@end
