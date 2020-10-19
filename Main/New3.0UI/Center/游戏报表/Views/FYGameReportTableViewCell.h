//
//  FYGameReportTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGameReportModel;

NS_ASSUME_NONNULL_BEGIN


@protocol FYGameReportTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtGameReportModel:(FYGameReportModel *)model indexPath:(NSIndexPath *)indexPath;
@end


@interface FYGameReportTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYGameReportModel *model;

@property (nonatomic, weak) id<FYGameReportTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end


NS_ASSUME_NONNULL_END

