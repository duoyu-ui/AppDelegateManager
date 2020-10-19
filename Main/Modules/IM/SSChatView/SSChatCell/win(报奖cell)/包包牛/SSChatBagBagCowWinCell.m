//
//  SSChatBagBagCowWinCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatBagBagCowWinCell.h"
#import "FYBagBagCowWinCell.h"
#import "FYBagBagCowRecordObject.h"
static NSString *const FYBagBagCowWinCellID = @"FYBagBagCowWinCellID";
@interface SSChatBagBagCowWinCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UIView *lineView2;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *dateLab;
@property (nonatomic , strong) UILabel *endLab;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray <SSChatBagBagCowWinData*>*dataArr;
@end
@implementation SSChatBagBagCowWinCell
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    NSDictionary *dict = [model.message.text mj_JSONObject];
    SSChatBagBagCowWinModel *winModel = [SSChatBagBagCowWinModel mj_objectWithKeyValues:dict];
    
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.msg.firstObject,winModel.msg[1]];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    self.dateLab.text = winModel.gameNumber;
    self.endLab.text = winModel.msg[2];
    self.dataArr = [SSChatBagBagCowWinData mj_objectArrayWithKeyValuesArray:winModel.data];
    [self.tableView reloadData];
}
- (void)initChatCellUI{
    [super initChatCellUI];
    self.mMessageTimeLab.hidden = YES;
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.lineView1];
    [self.bubbleBackView addSubview:self.dateLab];
    [self.bubbleBackView addSubview:self.endLab];
    [self.bubbleBackView addSubview:self.lineView2];
    [self.bubbleBackView addSubview:self.tableView];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.top.equalTo(self.headerImgView);
        make.height.mas_equalTo(12);
    }];
    NSString *text = NSLocalizedString(@"官方", nil);
    CGSize textSize = [text textSizeWithFont:[UIFont systemFontOfSize:10] limitWidth:kScreenWidth * 0.5];
    [self.officialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nicknameLabel);
        make.width.mas_equalTo(textSize.width + 10);
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
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.bottom.mas_equalTo(self.bubbleBackView.mas_bottom).offset(-kLineSpacing);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.lineView.mas_top).offset(kLineSpacing * 2 + 20);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.dateLab.mas_top).offset(-kLineSpacing);
    }];
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.titleLab);
         make.top.mas_equalTo(self.lineView.mas_bottom).offset(kLineSpacing);
     }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.top.equalTo(self.lineView1.mas_bottom).offset(kLineSpacing);
        make.bottom.equalTo(self.lineView2.mas_top);
    }];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYBagBagCowWinCell class] forCellReuseIdentifier:FYBagBagCowWinCellID];
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FYBagBagCowWinCell *cell = [tableView dequeueReusableCellWithIdentifier:FYBagBagCowWinCellID];
    
    if (self.dataArr.count > indexPath.row) {
        SSChatBagBagCowWinData *list = self.dataArr[indexPath.row];
        cell.list = list;
        switch (indexPath.row) {
            case 0:
                cell.nickLab.text = [NSString stringWithFormat:NSLocalizedString(@"(庄)%@", nil),list.nickname];
                cell.numLab.text = [FYBagBagCowTool setCowNumber:list.niu];
                break;
            case 1:
                cell.nickLab.text = [NSString stringWithFormat:NSLocalizedString(@"(闲)%@", nil),list.nickname];
                cell.numLab.text = [FYBagBagCowTool setCowNumber:list.niu];
                break;
            case 2:
                cell.nickLab.text = [NSString stringWithFormat:NSLocalizedString(@"(弃)%@", nil),list.nickname];
                cell.numLab.text = NSLocalizedString(@"弃包", nil);
                break;
            default:
                break;
        }
    }
    return cell;
}
/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
#pragma mark - 懒加载
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

- (UILabel *)endLab{
    if (!_endLab) {
        _endLab = [[UILabel alloc]init];
        _endLab.textColor = HexColor(@"#1A1A1A");
        _endLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _endLab;
}
@end
@implementation SSChatBagBagCowWinModel

@end
@implementation SSChatBagBagCowWinData

@end
