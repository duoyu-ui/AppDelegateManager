//
//  ReportCell.h
//  Project
//
//  Created by fy on 2019/1/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ReportFormsItem;
NS_ASSUME_NONNULL_BEGIN

@interface ReportCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIImageView *iconImageView;
//+(CGFloat)cellHeightWithModel:(NSDictionary*)model;
+(instancetype)cellWith:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath;
- (void)richElementsInCellWithModel:(ReportFormsItem*)model indexPath:(NSIndexPath*)indexPath;
@end

NS_ASSUME_NONNULL_END
