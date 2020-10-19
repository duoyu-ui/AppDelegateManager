//
//  SSChatRobNiuNiuCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatRobNiuNiuCell.h"
#import "FYChatRobNiuNiuCell.h"
#import "FYChatNiuNiuModel.h"
static NSString *const FYChatRobNiuNiuCellID = @"FYChatRobNiuNiuCellID";
@interface SSChatRobNiuNiuCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UIView *lineView2;
@property (nonatomic , strong) UIView *lineView3;
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *dateLab;
@property (nonatomic , strong) NSMutableArray<UILabel *> *labs;
@property (nonatomic , strong) NSMutableArray<UILabel *> *bankLabs;

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray <FYChatNiuNiuData*>*dataSource;
@end
@implementation SSChatRobNiuNiuCell
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    FYChatNiuNiuModel *winModel = [FYChatNiuNiuModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.msg.firstObject,winModel.msg[1]];
    self.dateLab.text = winModel.msg.lastObject;
    [self.dataSource removeAllObjects];
    __block FYChatNiuNiuData *bankData = [[FYChatNiuNiuData alloc]init];
    NSArray <FYChatNiuNiuData*>*listData = [FYChatNiuNiuData mj_objectArrayWithKeyValuesArray:winModel.data];
    [listData enumerateObjectsUsingBlock:^(FYChatNiuNiuData *data, NSUInteger idx, BOOL * _Nonnull stop) {
        if (data.bank == 1) {
            bankData = data;
        }else{
            [self.dataSource addObj:data];
        }
    }];
    [self.tableView reloadData];
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                lab.text = bankData.name;
                break;
            case 1:
                lab.textAlignment = NSTextAlignmentCenter;
                lab.text = bankData.str;
                break;
            case 2:
                lab.textAlignment = NSTextAlignmentCenter;
                
                lab.text = (bankData.handicap.length > 0) ? [NSString stringWithFormat:NSLocalizedString(@"%@倍", nil),bankData.handicap] : @"";
                break;
            case 3:
                lab.textAlignment = NSTextAlignmentRight;
                lab.text = [NSString stringWithFormat:@"%@",bankData.money];
                lab.textColor = [bankData.money integerValue] > 0 ? HexColor(@"#CB332D"):HexColor(@"#1A1A1A");
                break;
            default:
                break;
        }
    }];
    [self.bankLabs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            NSString *nick = [NSString stringWithFormat:@"%@",winModel.msg[idx + 2]];
            NSString *stop = [NSString stringWithFormat:@"  %@",winModel.msg[idx + 3]];
            NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",nick,stop]];
            [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#4BBC5A") range:NSMakeRange(0, nick.length)];
            lab.attributedText = abs;
        }else{
            lab.text = winModel.msg[idx + 3];
            lab.textColor = HexColor(@"#1A1A1A");
        }
    }];
}
- (void)initChatCellUI{
    [super initChatCellUI];
    [self setSubViews];
}
- (void)setSubViews{
    self.mMessageTimeLab.hidden = YES;
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.lineView1];
    [self.bubbleBackView addSubview:self.lineView2];
    [self.bubbleBackView addSubview:self.lineView3];
    [self.bubbleBackView addSubview:self.dateLab];
    [self.bubbleBackView addSubview:self.tableView];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.left.mas_equalTo(10);
    }];
    NSString *text = NSLocalizedString(@"官方", nil);
    CGSize textSize = [text textSizeWithFont:[UIFont systemFontOfSize:10] limitWidth:kScreenWidth * 0.5];
    [self.officialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nicknameLabel);
        make.width.mas_equalTo(textSize.width + 10);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.top.equalTo(self.headerImgView);
        make.height.mas_equalTo(12);
    }];
    [self.bubbleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.75);
        make.bottom.mas_equalTo(-10);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kLineSpacing);
        make.left.mas_equalTo(15);
    }];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kLineSpacing);
        make.left.mas_equalTo(15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.titleLab);
          make.height.mas_equalTo(kLineHeight);
          make.right.mas_equalTo(-10);
          make.top.equalTo(self.titleLab.mas_bottom).offset(kLineSpacing);
      }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.dateLab.mas_top).offset(-kLineSpacing);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.top.equalTo(self.lineView.mas_bottom).offset(70);
    }];
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.lineView1.mas_top).offset(-30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.top.equalTo(self.lineView2.mas_bottom).offset(kLineSpacing);
        make.bottom.equalTo(self.lineView3.mas_top).offset(-kLineSpacing);
    }];
    CGFloat labw = ((SCREEN_WIDTH * 0.75 - 25) / 5);
    for (int i = 0; i < 4; i ++) {
        UILabel *lab = [self setLabCent];
        [self.bubbleBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView3.mas_bottom).offset(kLineSpacing);
            make.left.equalTo(self.lineView3.mas_left).offset(i * labw);
            make.width.mas_equalTo( i == 3 ?(labw * 2) : labw);
        }];
        [self.labs addObj:lab];
    }
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [self setLabCent];
        [self.bubbleBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView.mas_left);
            make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing + i * 20);
            make.right.equalTo(self.lineView);
        }];
        [self.bankLabs addObj:lab];
    }
}
- (UILabel *)setLabCent{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:kCellFont];
    lab.textColor = HexColor(@"#1A1A1A");
    return lab;
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FYChatRobNiuNiuCell *cell = [tableView dequeueReusableCellWithIdentifier:FYChatRobNiuNiuCellID];
    if (self.dataSource.count > indexPath.row) {
        cell.list = self.dataSource[indexPath.row];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
#pragma mark -- setter
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qgSystemIcon"]];
        _headerImgView.backgroundColor =  [UIColor brownColor];
        _headerImgView.layer.cornerRadius = 5;
        _headerImgView.clipsToBounds = YES;
    }
    return _headerImgView;
}
- (UILabel *)officialLab{
    if (!_officialLab) {
        _officialLab = [[UILabel alloc]init];
        _officialLab.text = NSLocalizedString(@"官方", nil);
        _officialLab.textColor = HexColor(@"#FFFFFF");
        _officialLab.backgroundColor = HexColor(@"#E75E58");
        _officialLab.layer.masksToBounds = YES;
        _officialLab.textAlignment = NSTextAlignmentCenter;
        _officialLab.layer.cornerRadius = 7;
        _officialLab.font = [UIFont systemFontOfSize:10];
    }
    return _officialLab;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HexColor(@"#1A1A1A");
        _titleLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _titleLab;
}
- (UILabel *)dateLab{
    if (!_dateLab) {
        _dateLab = [[UILabel alloc]init];
        _dateLab.textColor = HexColor(@"#1A1A1A");
        _dateLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _dateLab;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView1;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView;
}
- (UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView2;
}
- (UIView *)lineView3{
    if (!_lineView3) {
        _lineView3 = [[UIView alloc]init];
        _lineView3.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView3;
}
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
}
- (NSMutableArray<UILabel *> *)bankLabs{
    if (!_bankLabs) {
        _bankLabs = [NSMutableArray arrayWithCapacity:0];
    }
    return _bankLabs;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYChatRobNiuNiuCell class] forCellReuseIdentifier:FYChatRobNiuNiuCellID];
    }
    return _tableView;
}
- (NSMutableArray<FYChatNiuNiuData *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0 ];
    }
    return _dataSource;
}
@end

