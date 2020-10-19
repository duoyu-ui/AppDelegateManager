//
//  SendRedPackedTextCell.m
//  Project
//
//  Created by Mike on 2019/2/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SendRedPackedTextCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRedEnvelopeController.h"

#define kTableViewMarginWidth 30

@interface SendRedPackedTextCell ()



@end

@implementation SendRedPackedTextCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRedPackedTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRedPackedTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = HexColor(@"#EDEDED");
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = HexColor(@"#FFFFFF");
    backView.layer.cornerRadius = 7;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.left.mas_equalTo(self.mas_left).offset(kTableViewMarginWidth);
        make.center.mas_equalTo(self);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"-";
    _titleLabel.font = [UIFont systemFontOfSize2:16];
    _titleLabel.textColor = HexColor(@"#333333");
    [backView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    _unitLabel = [UILabel new];
    _unitLabel.text = @"-";
    _unitLabel.textAlignment = NSTextAlignmentRight;
    _unitLabel.font = [UIFont systemFontOfSize2:16];
    _unitLabel.textColor = HexColor(@"#333333");
    [backView addSubview:_unitLabel];
    
    _deTextField = [UITextField new];
    _deTextField.font = [UIFont systemFontOfSize2:16];
    _deTextField.keyboardType = UIKeyboardTypeNumberPad;
    _deTextField.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_deTextField];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(@40);
    }];
    
    [_deTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_unitLabel.mas_left).offset(-5);
        make.centerY.equalTo(backView.mas_centerY);
        make.left.mas_equalTo(backView.mas_left).offset(90);
        make.height.mas_equalTo(35);
    }];

}

@end



