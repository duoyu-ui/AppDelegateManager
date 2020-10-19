//
//  FYSuperBombPacketTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class FYSuperBombPacketTableViewCell;

@protocol FYSuperBombPacketCellDelegate <NSObject>
@optional
- (void)cell:(FYSuperBombPacketTableViewCell *)cell didSelectedAtPacket:(NSString *)packet;

@end

@interface FYSuperBombPacketTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *packets;

@property (nonatomic, strong) NSString *selectedPacket;

@property (nonatomic, weak) id<FYSuperBombPacketCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
