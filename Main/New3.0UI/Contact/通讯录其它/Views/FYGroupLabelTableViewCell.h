//
//  FYGroupLabelTableViewCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAvatarNameContactCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYGroupLabelTableViewCell : FYAvatarNameContactCell

- (void)updateLabel:(NSString *)title;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
