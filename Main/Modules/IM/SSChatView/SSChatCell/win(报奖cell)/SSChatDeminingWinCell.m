//
//  SSChatDeminingWinCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatDeminingWinCell.h"
#import "FYDeminingWinCell.h"
#import "FYDeminingWinModel.h"
static NSString *const FYDeminingWinCellId = @"FYDeminingWinCellId";
@interface SSChatDeminingWinCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UIView *lineView2;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *dateLab;
@property (nonatomic , strong) NSMutableArray <UILabel *>*labs;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray<SSChatDeminingWinGrabList*> *datasArr;
@end
@implementation SSChatDeminingWinCell
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    
    FYDeminingWinModel *winModel = [FYDeminingWinModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.title.firstObject,winModel.title.lastObject];
    self.dateLab.text = winModel.date;
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                obj.textColor = HexColor(@"#4BBC5A");
                obj.text = [NSString stringWithFormat:@"@%@",winModel.nick];
                break;
            case 1:
                if (winModel.left.length > 0) {
                    obj.text = winModel.left;
                }else if(winModel.leftTime.length > 0){
                    obj.text = winModel.leftTime;
                }else{
                    obj.text = @"";
                }
                break;
            case 2:
                obj.textColor = HexColor(@"#CB332D");
                obj.text = [NSString stringWithFormat:@"%@",winModel.bombCountExplode];
                break;
            default:
                break;
        }
    }];
    [self.datasArr removeAllObjects];
    [winModel.grabList enumerateObjectsUsingBlock:^(SSChatDeminingWinGrabList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.datasArr addObj:[SSChatDeminingWinGrabList mj_objectWithKeyValues:obj]];
    }];
    [self.tableView reloadData];
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
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kLineSpacing);
        make.left.mas_equalTo(15);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLab);
        make.height.mas_equalTo(kLineHeight);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(self.dateLab.mas_top).offset(-kLineSpacing);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.lineView1.mas_top).offset(-75);
    }];
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [self setLabCent];
        [self.bubbleBackView addSubview:lab];
        [self.labs addObj:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView2.mas_bottom).offset(kLineSpacing + i * 20);
            make.left.equalTo(self.dateLab);
            make.right.mas_equalTo(-10);
        }];
    }
    [self.bubbleBackView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.lineView.mas_bottom).offset(5);
        make.bottom.equalTo(self.lineView2.mas_top).offset(-5);
    }];
}
- (UILabel *)setLabCent{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:kCellFont];
    lab.textColor = HexColor(@"#1A1A1A");
    return lab;
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
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
}

- (NSMutableArray <SSChatDeminingWinGrabList*>*)datasArr{
    if (!_datasArr) {
        _datasArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasArr;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYDeminingWinCell class] forCellReuseIdentifier:FYDeminingWinCellId];
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FYDeminingWinCell *cell = [tableView dequeueReusableCellWithIdentifier:FYDeminingWinCellId];
    if (self.datasArr.count > indexPath.row) {
        cell.list = self.datasArr[indexPath.row];
    }
    return cell;
}
/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}
/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
@end
