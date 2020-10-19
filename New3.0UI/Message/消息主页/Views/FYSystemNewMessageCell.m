//
//  FYSystemNewMessageCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYSystemNewMessageCell.h"
@interface FYSystemNewMessageCell()
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UIImageView *headerImgView;
@property (nonatomic , strong) UIImageView *bubbleBackView;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;
@end
@implementation FYSystemNewMessageCell
- (void)setList:(FYSystemMessageRecords *)list{
    _list = list;
    self.timeLab.text = list.lastUpdateTime;
    if (list.noticeType == 0) {
        self.headerImgView.image = [UIImage imageNamed:@"systemMessage_icon"];
    }else{
        self.headerImgView.image = [UIImage imageNamed:@"pingtaiMessage_icon"];
        
    }
    CGSize textSize = [list.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:SCREEN_WIDTH * 0.7];
    [self.bubbleBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_top);
        make.left.equalTo(self.headerImgView.mas_right).offset(5);
        make.height.mas_equalTo(textSize.height + 50);
        make.width.mas_equalTo(textSize.width + 30);
    }];
    self.titleLab.text = list.title;
    self.contentLab.text = list.content;
}
- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    self.headerImgView.image = [UIImage imageNamed:imgName];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexColor(@"#EDEDED");
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self addSubview:self.timeLab];
    [self addSubview:self.headerImgView];
    [self addSubview:self.bubbleBackView];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.contentLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(5);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.mas_equalTo(10);
        make.top.equalTo(self.timeLab.mas_bottom).offset(15);
    }];
    
    UIImage *image = [UIImage imageNamed:@"icon_qipao2"];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.bubbleBackView.mas_right).offset(-2);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.equalTo(self.bubbleBackView.mas_right).offset(-10);
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-5);
    }];
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc]init];
    }
    return _headerImgView;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.textColor = HexColor(@"#A6A6A6");
        _timeLab.font = [UIFont systemFontOfSize:14];
    }
    return _timeLab;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HexColor(@"#333333");
        _titleLab.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.textColor = HexColor(@"#555555");
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}
- (UIImageView *)bubbleBackView{
    if (!_bubbleBackView) {
        _bubbleBackView = [[UIImageView alloc]init];
    }
    return _bubbleBackView;
}
@end
