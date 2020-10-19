//
//  FYContactMobileTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMobilePerson, FYContactMobileSearchModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYContactMobileTableViewCell : UITableViewCell

@property (nonatomic, strong) FYMobilePerson *model;

@property (nonatomic, strong) FYContactMobileSearchModel *searchResModel;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

- (void)setModel:(FYMobilePerson *)model searchResModel:(FYContactMobileSearchModel *)searchResModel isSearch:(BOOL)isSearch;

@end

NS_ASSUME_NONNULL_END
