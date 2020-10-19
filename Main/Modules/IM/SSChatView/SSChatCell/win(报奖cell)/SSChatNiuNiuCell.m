//
//  SSChatNiuNiuCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatNiuNiuCell.h"
#import "FYChatNiuNiuWinCell.h"
#import "FYNiuNiuWinModel.h"
static NSString *const FYChatNiuNiuWinCellID = @"FYChatNiuNiuWinCellID";
@interface SSChatNiuNiuCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UIView *lineView2;
@property (nonatomic , strong) UIView *lineView3;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *dateLab;
@property (nonatomic , strong) NSMutableArray<UILabel *> *labs;
@property (nonatomic , strong) UILabel *nickLab;
@property (nonatomic , strong) UILabel *minLab;

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray<FYNiuNiuWinGrabList*> *dataSoure;
@end
@implementation SSChatNiuNiuCell

- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    FYNiuNiuWinModel *winModel = [FYNiuNiuWinModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    self.dataSoure = [FYNiuNiuWinGrabList mj_objectArrayWithKeyValuesArray:winModel.grabList];
    [self.tableView reloadData];
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.title.firstObject,winModel.title.lastObject];
    self.dateLab.text = winModel.date;
    NSString *nickStr = [NSString stringWithFormat:@"@%@ %@",winModel.gameOver.firstObject,winModel.gameOver.lastObject];
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:nickStr];
    [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#4BBC5A") range:NSMakeRange(0, winModel.gameOver.firstObject.length + 1)];
    self.nickLab.attributedText = abs;
    self.minLab.text = winModel.result;
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                lab.text = winModel.bankerGrab.nick;
                break;
            case 1:
                lab.text = winModel.bankerGrab.score;
                break;
            case 2:
                lab.text = winModel.bankerGrab.handicap;
                break;
            case 3:
                lab.text = [NSString stringWithFormat:@"%.2lf",winModel.bankerGrab.winMoney];
                lab.textColor = winModel.bankerGrab.winMoney >= 0 ? HexColor(@"#CB332D") :HexColor(@"#1A1A1A");
                break;
            default:
                break;
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
    [self.bubbleBackView addSubview:self.dateLab];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.lineView1];
    [self.bubbleBackView addSubview:self.lineView2];
    [self.bubbleBackView addSubview:self.lineView3];
    [self.bubbleBackView addSubview:self.nickLab];
    [self.bubbleBackView addSubview:self.minLab];
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
        make.width.mas_equalTo(SCREEN_WIDTH * 0.65);
        make.bottom.mas_equalTo(-10);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kLineSpacing);
        make.left.mas_equalTo(15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.height.mas_equalTo(kLineHeight);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.titleLab.mas_bottom).offset(kLineSpacing);
    }];
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.top.equalTo(self.lineView.mas_bottom).offset(50);
    }];
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing);
        make.left.right.equalTo(self.lineView);
    }];
    [self.minLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_left);
        make.top.equalTo(self.nickLab.mas_bottom).offset(2);
    }];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kLineSpacing);
        make.left.mas_equalTo(15);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.dateLab.mas_top).offset(-kLineSpacing);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
          make.height.mas_equalTo(kLineHeight);
//          make.right.mas_equalTo(-10);
          make.bottom.equalTo(self.lineView1.mas_top).offset(-35);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.lineView);
//        make.right.mas_equalTo(-10);
        make.top.equalTo(self.lineView3.mas_bottom).offset(kLineSpacing);
        make.bottom.equalTo(self.lineView2.mas_top).offset(-kLineSpacing);
    }];
    CGFloat labW = (SCREEN_WIDTH * 0.65 - 25) / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *lab = [self setLabCent];
        if (i == 1 || i == 2 ) {
            lab.textAlignment = NSTextAlignmentCenter;
        }else if(i == 3){
            lab.textAlignment = NSTextAlignmentRight;
        }
        [self.bubbleBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView2.mas_bottom).offset(kLineSpacing);
            make.left.mas_equalTo(15 + i * labW);
            make.width.mas_equalTo(labW);
        }];
        [self.labs addObj:lab];
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
    FYChatNiuNiuWinCell *cell = [tableView dequeueReusableCellWithIdentifier:FYChatNiuNiuWinCellID];
    if (self.dataSoure.count > indexPath.row) {
        cell.list = self.dataSoure[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}
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
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView1;
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
- (UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc]init];
        _nickLab.textColor = HexColor(@"#1A1A1A");
        _nickLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _nickLab;
}
- (UILabel *)minLab{
    if (!_minLab) {
        _minLab = [[UILabel alloc]init];
        _minLab.textColor = HexColor(@"#1A1A1A");
        _minLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _minLab;
}
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYChatNiuNiuWinCell class] forCellReuseIdentifier:FYChatNiuNiuWinCellID];
    }
    return _tableView;
}

@end
