//
//  FYLaunchristPageCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLaunchristPageCell.h"
@interface FYLaunchristPageCell()
@property (nonatomic ,strong)UIImageView *imageView;
@end
@implementation FYLaunchristPageCell

- (void)setList:(FYLaunchSkAdvDetailList *)list {
    _list = list;
    if (list.advPicUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:list.advPicUrl] placeholderImage:[UIImage imageNamed:@"icon_loading_1010_260"]];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
@end
