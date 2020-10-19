//
//  SSChatJieLongCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatJieLongCell.h"
#import "FYChatJieLongCell.h"

static NSString *const FYChatJieLongCellID = @"FYChatJieLongCellID";
@interface SSChatJieLongCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIImageView *headerImgView;
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) NSMutableArray <UILabel *>*labs;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong)NSArray <SSChatJieLongGrabList*> *dataSource;
@end
@implementation SSChatJieLongCell

- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    NSDictionary *dict = [model.message.text mj_JSONObject];
    SSChatJieLongModel *winModel = [SSChatJieLongModel mj_objectWithKeyValues:dict];
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.title.firstObject,winModel.title.lastObject];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    
    self.dataSource = [SSChatJieLongGrabList mj_objectArrayWithKeyValuesArray:winModel.grabList];
    [self.tableView reloadData];
    
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        lab.textColor = idx == 0 ? HexColor(@"#4BBC5A"):HexColor(@"#1A1A1A");
        switch (winModel.type) {
            case 1://手气最差
                if (idx == 0) {
                    lab.text = winModel.worstNick;
                }else{
                    lab.text = winModel.worstDesc;
                }
                break;
            case 2://手气最佳
                if (idx == 0) {
                    lab.text = winModel.bestNick;
                }else{
                    lab.text = winModel.bestDesc;
                }
                break;
            default:
                break;
        }
    }];
    
    
}
- (void)initChatCellUI{
    [super initChatCellUI];
    self.mMessageTimeLab.hidden = YES;
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.lineView1];
    [self.bubbleBackView addSubview:self.titleLab];
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
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-55);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing);
        make.bottom.equalTo(self.lineView1.mas_top);
    }];
    for (int i = 0; i < 2; i++) {
        UILabel *lab = [self setLabCent];
        [self.bubbleBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView1.mas_bottom).offset(kLineSpacing + i * 20);
            make.left.mas_equalTo(20);
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
    FYChatJieLongCell *cell = [tableView dequeueReusableCellWithIdentifier:FYChatJieLongCellID];
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
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
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
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qgSystemIcon"]];
        _headerImgView.backgroundColor =  [UIColor brownColor];
        _headerImgView.layer.cornerRadius = 5;
        _headerImgView.clipsToBounds = YES;
    }
    return _headerImgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HexColor(@"#1A1A1A");
        _titleLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _titleLab;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYChatJieLongCell class] forCellReuseIdentifier:FYChatJieLongCellID];
    }
    return _tableView;
}
//- (NSMutableArray<SSChatJieLongGrabList *> *)dataSource{
//    if (!_dataSource) {
//        _dataSource = [NSMutableArray arrayWithCapacity:0 ];
//    }
//    return _dataSource;
//}
@end

@implementation SSChatJieLongGrabList

@end
@implementation SSChatJieLongModel

@end
