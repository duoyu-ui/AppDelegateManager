//
//  FYBestWinsLossesModel.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBestWinsLossesModel.h"

@implementation FYBestWinsLossesModel

@end

@implementation FYBestWinsLossesRed

@end
@implementation FYBestWinsLossesPokers
- (UIImage *)pokersImg{
    switch ([self.type intValue]) {
        case 1:
            return [UIImage imageNamed:@"plum_blossom_icon"];
            break;
        case 2:
            return [UIImage imageNamed:@"square_icon"];
            break;
        case 3:
            return [UIImage imageNamed:@"red_peach_icon"];
            break;
        case 4:
            return [UIImage imageNamed:@"spades_icon"];
            break;
        default:
            return [UIImage new];
            break;
    }
}
@end
@implementation FYBestWinsLossesBlue

@end
@implementation FYBestWinsLossesFlopResult

@end

