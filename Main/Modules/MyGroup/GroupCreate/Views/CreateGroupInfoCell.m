//
//  CreateGroupInfoCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "CreateGroupInfoCell.h"
#import "FYCreateGroupModel.h"

#define kTEXT_MAX_LENGTH    20

@implementation CreateGroupInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self initializes];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self makeSubview];
    }
    return self;
}

- (void)initializes
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.arrowView.hidden = YES;
    self.switchView.hidden = YES;
    self.textField.hidden = YES;
    self.titleLabel.hidden = NO;
}

- (void)makeSubview
{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowView];
    [self.contentView addSubview:self.switchView];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.subtitleLab];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(CFC_AUTOSIZING_WIDTH(20.0f));
        make.height.mas_equalTo(CFC_AUTOSIZING_WIDTH(20.0f));
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.equalTo(@41);
        make.height.equalTo(@21);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right).offset(15.0f);
        make.height.equalTo(@36);
    }];
    
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@220);
        make.height.equalTo(@21);
    }];
}

#pragma mark - Public Setter

- (void)setModel:(FYCreateGroupModel *)model
{
    _model = model;
    
    if (model.style == CreateNoticeInfoOrArrow) {
        self.textField.hidden = YES;
        self.switchView.hidden = YES;
        self.arrowView.hidden = NO;
        self.subtitleLab.hidden = NO;
        self.subtitleLab.text = model.subtitle;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(12);
        }];
        
        self.subtitleLab.numberOfLines = 2;
        self.subtitleLab.textAlignment = NSTextAlignmentNatural;
        [self.subtitleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.arrowView.mas_left).offset(-12);
        }];
        
    } else if (model.style == CreateTitleOrTextField) {
        self.arrowView.hidden = NO;
        self.switchView.hidden = YES;
        self.subtitleLab.hidden = YES;
        self.textField.hidden = NO;
    
        NSDictionary *attr = @{NSForegroundColorAttributeName:COLOR_HEXSTRING(@"#808080")};
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:model.subtitle attributes:attr];
        [self.textField setAttributedPlaceholder:attributeString];
        
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowView.mas_left).offset(-12);
        }];
        
    } else if (model.style == CreateAllTitleAndArrow) {
        self.switchView.hidden = YES;
        self.textField.hidden = YES;
        self.arrowView.hidden = NO;
        self.subtitleLab.hidden = NO;
        
        self.subtitleLab.text = model.subtitle;
        [self.subtitleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrowView.mas_left).offset(-11);
            make.width.equalTo(@220);
            make.height.equalTo(@21);
            make.centerY.equalTo(self.contentView);
        }];
        
    } else if (model.style == CreateAllTitleAndSwitch) {
        self.textField.hidden = YES;
        self.arrowView.hidden = YES;
        self.subtitleLab.hidden = NO;
        self.switchView.hidden = NO;
        self.subtitleLab.text = model.subtitle;
        [self.subtitleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.switchView.mas_left).offset(-11);
            make.centerY.equalTo(self.contentView);
        }];
        
    } else {
        self.textField.hidden = YES;
        self.arrowView.hidden = YES;
        self.switchView.hidden = YES;
        self.titleLabel.hidden = NO;
        self.subtitleLab.hidden = NO;
        self.subtitleLab.text = model.subtitle;
    }
    
    
    if ([model.title isEqualToString:STR_CELL_TITLE_GROUP_TYPE] ||
        [model.title isEqualToString:STR_CELL_TITLE_GROUP_NAME] ||
        [model.title isEqualToString:STR_CELL_TITLE_GROUP_REDPACT]) {
        [self setupAttrText:model.title];
    } else {
        self.titleLabel.text = model.title;
    }
}

- (void)setupAttrText:(NSString *)str {
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:str];
    [attrText addAttribute:NSForegroundColorAttributeName
                     value:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT
                     range:NSMakeRange(0, 1)];
    self.titleLabel.attributedText = attrText;
}


- (void)setIsRate:(BOOL)isRate
{
    _isRate = isRate;
    if (isRate) {
        [self.arrowView transformWithRotation:0.38];
    }else {
        self.arrowView.transform = CGAffineTransformIdentity;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action

- (void)switchDidChanged:(UISwitch *)sender {
    if (self.switchChangedBlock) {
        self.switchChangedBlock();
    }
    
    if (self.switchChangedIsOnBlock) {
        self.switchChangedIsOnBlock(sender.isOn);
    }
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textEditEndBlock) {
        self.textEditEndBlock(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.textField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0)
        {
            return YES;
        }
        else if (self.textField.text.length >= kTEXT_MAX_LENGTH)
        {
            self.textField.text = [textField.text substringToIndex:kTEXT_MAX_LENGTH];
            ALTER_INFO_MESSAGE(NSLocalizedString(@"群名称输入长度超出20个字符", nil))
            return NO;
        }
    }
    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.textEditEndBlock) {
        self.textEditEndBlock(textString);
    }
    
    return YES;
}


#pragma mark - Private Getter

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLab {
    
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.numberOfLines = 1;
        _subtitleLab.textAlignment = NSTextAlignmentRight;
        _subtitleLab.font = [UIFont systemFontOfSize:15];
        _subtitleLab.textColor = [UIColor colorWithHexString:@"#808080"];
    }
    return _subtitleLab;
}

- (UIImageView *)arrowView {
    
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:ICON_TABLEVIEW_CELL_ARROW];
    }
    return _arrowView;
}

- (UISwitch *)switchView {
    
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
        [_switchView addTarget:self action:@selector(switchDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor colorWithHexString:@"#808080"];
        _textField.delegate = self;
    }
    return _textField;
}


@end
