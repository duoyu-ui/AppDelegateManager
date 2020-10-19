//
//  FYJSSLGameRecordTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYJSSLGameRecordModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYJSSLGameRecordTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtJSSLGameRecordModel:(FYJSSLGameRecordModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYJSSLGameRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYJSSLGameRecordModel *model;

@property (nonatomic, weak) id<FYJSSLGameRecordTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

