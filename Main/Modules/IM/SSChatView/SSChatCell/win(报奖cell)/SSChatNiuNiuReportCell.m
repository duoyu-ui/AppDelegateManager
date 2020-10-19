//
//  SSChatNiuNiuReportCell.m
//  Project
//
//  Created by 汤姆 on 2019/9/5.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SSChatNiuNiuReportCell.h"
#import "ChatNiuNiuReportContentCell.h"
#import "NiuNiuReportModel.h"
static NSString *const ChatNiuNiuReportContentCellId = @"ChatNiuNiuReportContentCellId";
@interface SSChatNiuNiuReportCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *periodLab;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray <NiuNiuReportModel*>*dataSource;

@property (nonatomic, strong) UIImageView *bjImage;
@end
@implementation SSChatNiuNiuReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bjImage];
        [self.bjImage addSubview:self.periodLab];
        [self.bjImage addSubview:self.tableView];
        NSArray <NSString *>*titles = @[NSLocalizedString(@"昵称", nil),NSLocalizedString(@"抢包", nil),NSLocalizedString(@"点数", nil),NSLocalizedString(@"投注", nil),NSLocalizedString(@"盈亏", nil)];
        CGFloat w = (SCREEN_WIDTH - 50 - 40) / 5;
      
        [self.bjImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.bottom.equalTo(self);
            make.left.mas_equalTo(10);
        }];

        [self.periodLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bjImage);
            make.top.mas_equalTo(40);
        }];
        UIView *titleView = [[UIView alloc]init];
        [self.bjImage addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w*5);
            make.centerX.equalTo(self.bjImage);
            make.top.mas_equalTo(115);
            make.height.mas_equalTo(20);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bjImage);
            make.left.mas_equalTo(20);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.top.equalTo(titleView.mas_bottom);
        }];
        [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *lab = [[UILabel alloc]init];
            lab.font = [UIFont systemFontOfSize:13];
            lab.textColor = [UIColor whiteColor];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = obj;
            [titleView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(w * idx);
                make.width.mas_equalTo(w);
            }];
        }];
    }
    return self;
}
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    [self.dataSource removeAllObjects];
    NSString *qi = [NSString stringWithFormat:@"%@",model.message.cowcowRewardInfoDict[@"data"][0][@"period"]];
    
    self.periodLab.text = [NSString stringWithFormat:NSLocalizedString(@"第%@期", nil),qi];

    
    NSArray *models = [NiuNiuReportModel mj_objectArrayWithKeyValuesArray:model.message.cowcowRewardInfoDict[@"data"]];
    [self.dataSource addObjectsFromArray:models];
    NSInteger countTry=0;
    for (NiuNiuReportModel *model in self.dataSource) {
        if ([model.userName hasPrefix:NSLocalizedString(@"试玩", nil)]) {
            countTry ++;
            NSString *lastIdentifier=@"";
            if (model.userName.length > 3) {
                lastIdentifier = [model.userName substringFromIndex:model.userName.length - 3];
            }
            model.userName = [NSString stringWithFormat:NSLocalizedString(@"试玩%ld*%@", nil),countTry,lastIdentifier];
        }
    }
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatNiuNiuReportContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatNiuNiuReportContentCellId forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UIImageView *)bjImage{
    if (!_bjImage) {
        _bjImage = [[UIImageView alloc]init];
        UIImage *img = [UIImage imageNamed:@"robReportBj"];
        UIEdgeInsets inset = UIEdgeInsetsMake(137, 0, 137, 0);
        //图片拉伸
        img = [img resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
        _bjImage.image = img;
    }
    return _bjImage;
}
- (UILabel *)periodLab{
    if (!_periodLab) {
        _periodLab = [[UILabel alloc]init];
       _periodLab.font = [UIFont fontWithName:@"BernardMT-Condensed" size:21];
        _periodLab.textColor = HexColor(@"#FE4C56");
        _periodLab.numberOfLines = 0;
        _periodLab.textAlignment = NSTextAlignmentCenter;
    }
    return _periodLab;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[ChatNiuNiuReportContentCell class] forCellReuseIdentifier:ChatNiuNiuReportContentCellId];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
- (NSMutableArray<NiuNiuReportModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
@end
