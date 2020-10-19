//
//  FYAvatarNameContactCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAvatarNameContactCell.h"

CGFloat const IMAGE_HEIGHT = 40.0;

#define COLOR_CONTACT_CELL_TITLE             COLOR_HEXSTRING(@"#333333")


@implementation FYUserAddCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self imageAvatar];
        [self labelName];
        [self labelDetail];
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)isSectionLastRow:(BOOL)isLastRow{
    self.lineGray.hidden=isLastRow;
}

-(void)buttonAction:(UIButton *)sender{
    if (self.buttonClickAction) {
        self.buttonClickAction(sender);
    }
}

- (void)buttonTitleWith:(NSString *)title{
    [self.button setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:NSLocalizedString(@"同意", nil)]) {
        [self.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.button.layer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    }else if ([title isEqualToString:NSLocalizedString(@"邀请", nil)]){
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.layer.backgroundColor = [UIColor colorWithRed:131/255.0 green:183/255.0 blue:121/255.0 alpha:1].CGColor;
    }else{
        [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.button.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
}

- (UIView *)lineGray{
    if (!_lineGray) {
        _lineGray=[UIView new];
        _lineGray.backgroundColor = COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT;
        [self.contentView addSubview:_lineGray];
        [_lineGray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60);
            make.bottom.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
    }
    return _lineGray;
}

- (UIImageView *)imageAvatar{
    if (!_imageAvatar) {
        _imageAvatar=[UIImageView new];
        _imageAvatar.layer.cornerRadius = 2;
        [self.contentView addSubview:_imageAvatar];
        [_imageAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(IMAGE_HEIGHT, IMAGE_HEIGHT));
        }];
    }
    return _imageAvatar;
}

- (UILabel *)labelDetail{
    if (!_labelDetail) {
        _labelDetail=[UILabel new];
        _labelDetail.textColor = [UIColor lightGrayColor];
        _labelDetail.font=[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
        [self.contentView addSubview:_labelDetail];
        [_labelDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageAvatar.mas_right).mas_offset(15);
            make.bottom.equalTo(self.imageAvatar.mas_bottom);
        }];
    }
    return _labelDetail;
}

- (UILabel *)labelName{
    if (!_labelName) {
        _labelName=[UILabel new];
        _labelName.font=[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
        _labelName.textColor = COLOR_CONTACT_CELL_TITLE;
        [self.contentView addSubview:_labelName];
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageAvatar.mas_right).mas_offset(15);
            make.top.mas_equalTo(self.imageAvatar.mas_top);
        }];
    }
    return _labelName;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        CGSize imageSize = CGSizeMake(CFC_AUTOSIZING_WIDTH(25.0f), CFC_AUTOSIZING_WIDTH(25.0f));
        _arrowImageView=[UIImageView new];
        _arrowImageView.hidden = YES;
        _arrowImageView.layer.cornerRadius = 2;
        _arrowImageView.layer.masksToBounds = YES;
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.image = [[UIImage imageNamed:ICON_TABLEVIEW_CELL_ARROW] imageByScalingProportionallyToSize:imageSize];
        [self.contentView addSubview:_arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(imageSize);
        }];
    }
    return _arrowImageView;
}

-(UIButton *)button{
    if (!_button) {
        _button=[UIButton new];
        _button.layer.cornerRadius = 2;
        _button.titleLabel.font = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13)];
        [_button setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(22);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-20);
        }];
    }
    return _button;
}

@end



@implementation FYAvatarNameContactCell

+ (CGFloat)height
{
    return 60.0f;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self imageAvatar];
        [self labelName];
        [self labelRedNumber];
        [self.imageAvatar addTarget:self selector:@selector(tapAction:)];
    }
    return self;
}

-(void)isSectionLastRow:(BOOL)isLastRow{
    self.lineGray.hidden=isLastRow;
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.clickAction) {
        self.clickAction(2);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateRedNumber:(NSInteger)count{
    if (count>0) {
        self.labelRedNumber.hidden = NO;
        if (count<10) {
            self.labelRedNumber.text=[NSString stringWithFormat:@"%ld",count];
        }else{
            self.labelRedNumber.text=@"";
        }
    }else{
        self.labelRedNumber.hidden = YES;
        self.labelRedNumber.text=@"";
    }
}

-(void)updateOnline:(NSInteger)online{
    self.greenTag.hidden = online == 1 ? NO : YES;
}

- (UIView *)lineGray{
    if (!_lineGray) {
        _lineGray=[UIView new];
        _lineGray.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.contentView addSubview:_lineGray];
        [_lineGray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60);
            make.bottom.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.6);
        }];
    }
    return _lineGray;
}

-(UIView *)greenTag{
    if (!_greenTag) {
        _greenTag=[UIView new];
        _greenTag.layer.backgroundColor = [UIColor greenColor].CGColor;
        _greenTag.layer.cornerRadius = 3;
        [self.contentView addSubview:_greenTag];
        [_greenTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.imageAvatar.mas_right);
            make.centerY.mas_equalTo(self.imageAvatar.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
    }
    return _greenTag;
}

- (FLAnimatedImageView *)imageAvatar{
    if (!_imageAvatar) {
        _imageAvatar=[FLAnimatedImageView new];
        _imageAvatar.layer.cornerRadius = 2;
        [self.contentView addSubview:_imageAvatar];
        [_imageAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(IMAGE_HEIGHT, IMAGE_HEIGHT));
        }];
    }
    return _imageAvatar;
}

- (UILabel *)labelRedNumber{
    if (!_labelRedNumber) {
        _labelRedNumber=[UILabel new];
        _labelRedNumber.layer.cornerRadius = 8;
        _labelRedNumber.font = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(11)];
        _labelRedNumber.textColor = [UIColor whiteColor];
        _labelRedNumber.textAlignment = NSTextAlignmentCenter;
        _labelRedNumber.layer.backgroundColor = COLOR_TAB_BAR_TITLE_SELECT_DEFAULT.CGColor;
        [self.contentView addSubview:_labelRedNumber];
        [_labelRedNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.imageAvatar.mas_right);
            make.centerY.mas_equalTo(self.imageAvatar.mas_top).offset(2.0f);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return _labelRedNumber;
}

- (UILabel *)labelName{
    if (!_labelName) {
        _labelName=[UILabel new];
        _labelName.font=FONT_PINGFANG_REGULAR(16);
        _labelName.textColor = COLOR_CONTACT_CELL_TITLE;
        [self.contentView addSubview:_labelName];
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageAvatar.mas_right).mas_offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
    }
    return _labelName;
}

@end




@implementation FYContactSectionHeaderView

- (UILabel *)labelName{
    if (!_labelName) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _labelName=[UILabel new];
        _labelName.font=[UIFont systemFontOfSize:12];
        _labelName.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_labelName];
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _labelName;
}

@end

