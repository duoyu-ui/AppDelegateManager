//
//  FYBagBagCowRecordModel.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRecordObject.h"

@implementation FYBagBagCowRecordObject

@end
@implementation FYBagBagCowRecordData
@end
@implementation FYBagBagCowTool
+ (NSMutableAttributedString *)setWinner:(NSInteger)winner{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (winner) {
        case 0://庄赢
        {
            dict[NSForegroundColorAttributeName] = HexColor(@"#CB332D");
            NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"庄赢", nil)];
            [abs addAttributes:dict range:NSMakeRange(0, 1)];
            return abs;
            
        }
            break;
        case 1://闲赢
        {
            dict[NSForegroundColorAttributeName] = HexColor(@"#3875F6");
            NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"闲赢", nil)];
            [abs addAttributes:dict range:NSMakeRange(0, 1)];
            return abs;
        }
            break;
        case 2://和赢
        {
            dict[NSForegroundColorAttributeName] = HexColor(@"#00C52E");
            NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"和赢", nil)];
            [abs addAttributes:dict range:NSMakeRange(0, 1)];
            return abs;
        }
            break;
        default:
            return [[NSMutableAttributedString alloc]init];;
            break;
    }
}
+ (NSString *)setCowNumber:(NSInteger)number{
    switch (number) {
        case 1:
            return NSLocalizedString(@"牛一", nil);
            break;
        case 2:
            return NSLocalizedString(@"牛二", nil);
            break;
        case 3:
            return NSLocalizedString(@"牛三", nil);
            break;
        case 4:
            return NSLocalizedString(@"牛四", nil);
            break;
        case 5:
            return NSLocalizedString(@"牛五", nil);
            break;
        case 6:
            return NSLocalizedString(@"牛六", nil);
            break;
        case 7:
            return NSLocalizedString(@"牛七", nil);
            break;
        case 8:
            return NSLocalizedString(@"牛八", nil);
            break;
        case 9:
            return NSLocalizedString(@"牛九", nil);
            break;
        case 10:
            return NSLocalizedString(@"牛牛", nil);
            break;
        case 11:
            return NSLocalizedString(@"金牛", nil);
            break;
        case 12:
            return NSLocalizedString(@"对子", nil);
            break;
        case 13:
            return NSLocalizedString(@"正顺", nil);
            break;
        case 14:
            return NSLocalizedString(@"倒顺", nil);
            break;
        case 15:
            return NSLocalizedString(@"豹子", nil);
            break;
        default:
            return @"";
            break;
    }
}
@end
