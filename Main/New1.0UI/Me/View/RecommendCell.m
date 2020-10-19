//
//  RecommendCell.m
//  Project
//
//  Created by mini on 2018/8/2.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "RecommendCell.h"
#import "RecommmendObj.h"
//#import "UIView+AZGradient.h"

@interface RecommendCell(){
    
    UIImageView *_sexIcon;
    UILabel *_name;
    UILabel *_account;
}
@property(nonatomic,strong)UIImageView *headIcon;
@property(nonatomic,strong)UIImageView* midLine;
@end

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

#pragma mark ----- Data
- (void)initData{
    
}

#pragma mark ----- Layout
- (void)initLayout{
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(12));
        make.height.width.equalTo(@(44));
    }];
    
    [_midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.conView);
        make.height.equalTo(@(1));
        make.top.mas_equalTo(self.headIcon.mas_bottom).offset(6);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(10.9);
        make.top.equalTo(self.conView.mas_top).offset(13);
    }];
    
    [_account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(11.9);
        make.top.equalTo(self->_name.mas_bottom).offset(6);
    }];
}

#pragma mark ----- subView
- (void)initSubviews{
    self.backgroundColor = BaseColor;
    UIView *conView = [[UIView alloc] init];
    conView.backgroundColor = [UIColor whiteColor];
    conView.layer.masksToBounds = YES;
    conView.layer.cornerRadius = 8.0;
    self.conView = conView;
    [self.contentView addSubview:conView];
    [conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    _headIcon = [UIImageView new];
    [conView addSubview:_headIcon];
    _headIcon.layer.cornerRadius = 8.0f;
    _headIcon.layer.masksToBounds = YES;
//    _headIcon.backgroundColor = [UIColor randColor];
    
    _midLine = [UIImageView new];
    [conView addSubview:_midLine];
    _midLine.backgroundColor = BaseColor;
    
    _name = [UILabel new];
    [conView addSubview:_name];
    _name.font = [UIFont systemFontOfSize2:15];
    _name.textColor = COLOR_X(60, 60, 60);
    
    UIView *sexBack = [UIView new];
    [conView addSubview:sexBack];
    sexBack.backgroundColor = SexBack;
    sexBack.layer.cornerRadius = 7.5;
    sexBack.layer.masksToBounds = YES;
    [sexBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_name.mas_right).offset(3);
        make.centerY.equalTo(self->_name);
        make.height.width.equalTo(@(15));
    }];
    
    _sexIcon = [UIImageView new];
    [sexBack addSubview:_sexIcon];
    [_sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sexBack);
    }];
    
    _account = [UILabel new];
    [conView addSubview:_account];
    _account.font = [UIFont systemFontOfSize2:13];
    _account.textColor = Color_6;
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = COLOR_X(245, 245, 245);
//    [conView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@0.5);
//        make.left.right.equalTo(conView);
//        make.bottom.equalTo(conView.mas_bottom).offset(-36);
//    }];
    
    _detailButton = [UIButton new];
    [conView addSubview:_detailButton];
    _detailButton.titleLabel.font = [UIFont systemFontOfSize2:13];
    [_detailButton setTitle:NSLocalizedString(@"查看详情", nil) forState:UIControlStateNormal];
    [_detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.cornerRadius = 13;
    _detailButton.backgroundColor = HEXCOLOR(0xfd4c56);
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(conView).offset(-10);
        make.centerY.equalTo(self->_headIcon.mas_centerY);
        make.height.equalTo(@26);
        make.width.equalTo(@80);
    }];
    
    UIView *view1 = [self viewForNum:@""  numColor:COLOR_X(246, 139, 0) title:NSLocalizedString(@"代理数", nil)];
    [conView addSubview:view1];
    view1.tag = 10;
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(conView.mas_left);
        make.width.equalTo(conView.mas_width).multipliedBy(0.33);
        make.height.equalTo(@50);
        make.centerY.equalTo(@30);
    }];
    
    UIView *view2 = [self viewForNum:@"" numColor:COLOR_X(0, 137, 30) title:NSLocalizedString(@"玩家数", nil) ];
    [conView addSubview:view2];
    view2.tag = 11;
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right);
        make.width.equalTo(conView.mas_width).multipliedBy(0.33);
        make.height.equalTo(@50);
        make.centerY.equalTo(@30);
    }];
    
    UIView *view3 = [self viewForNum:@"" numColor:COLOR_X(190, 0, 54) title:NSLocalizedString(@"流水佣金", nil)];
    [conView addSubview:view3];
    view3.tag = 12;
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_right);
        make.width.equalTo(conView.mas_width).multipliedBy(0.33);
        make.height.equalTo(@50);
        make.centerY.equalTo(@30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setObj:(id)obj{
    RecommmendObj *model = [RecommmendObj mj_objectWithKeyValues:obj];
    NSString *url = [NSString cdImageLink:model.avatar];
    [_headIcon cd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"user-default"]];
    _name.text = model.nick;
    _sexIcon.image = (model.gender == 0)?[UIImage imageNamed:@"male"]:[UIImage imageNamed:@"female"];
    _account.text = [NSString stringWithFormat:@"ID：%@",model.userId];
    
    UIView *view1 = [self.conView viewWithTag:10];
    UILabel *label1 = [view1 viewWithTag:2];
    UIView *view2 = [self.conView viewWithTag:11];
    UILabel *label2 = [view2 viewWithTag:2];
    UIView *view3 = [self.conView viewWithTag:12];
    UILabel *label3 = [view3 viewWithTag:2];
    UIImageView *iv3 = [view3 viewWithTag:4];
    iv3.hidden = true;
    label1.text = model.childAgentCount;
    label2.text = model.childPlayerCount;
    label3.text = [NSString stringWithFormat:@"￥%@",model.profitCommission];
}

-(UIView *)viewForNum:(NSString *)num numColor:(UIColor*)numColor title:(NSString *)title{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize2:16];
    titleLabel.textColor = numColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    titleLabel.tag = 2;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@20);
        make.centerY.equalTo(view.mas_centerY).offset(-10);
    }];
    titleLabel.text = num;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize2:14];
    titleLabel.textColor = COLOR_X(120, 120, 120);
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    titleLabel.tag = 3;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@20);
        make.centerY.equalTo(view.mas_centerY).offset(10);
    }];
    titleLabel.text = title;
    
    
    UIImageView* iv = [[UIImageView alloc]init];
    [view addSubview:iv];
    iv.backgroundColor = BaseColor;
    iv.tag = 4;
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(3);
        make.bottom.equalTo(view).offset(-3);
        make.width.equalTo(@1); make.centerY.equalTo(view.mas_centerY).offset(0);
        make.right.equalTo(view).offset(-1);
    }];
    return view;
}

@end
