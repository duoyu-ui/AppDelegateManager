//
//  FYJSSLBettHUDView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLBettHUDView.h"
#import "FYJSSLBettHUDCell.h"
@interface FYJSSLBettHUDView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray <FYJSSLDataSource*>*list;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UIView *lineView2;
@property (nonatomic , strong) UILabel *numLab;
@property (nonatomic , strong) UILabel *moneylab;
/// 取消
@property (nonatomic , strong) UIButton *cancelBtn;
///确定
@property (nonatomic , strong) UIButton *determineBtn;

@property (nonatomic , copy) NSString *singleMoney;
@property (nonatomic, copy) bettDetermine block;


@end
@implementation FYJSSLBettHUDView
+ (void)showJJSLBetHubWithList:(NSArray <FYJSSLDataSource*>*)list money:(NSString*)money odds:(NSString*)odds block:(bettDetermine)block{
    FYJSSLBettHUDView *hview = [[FYJSSLBettHUDView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hview];
    hview.block = ^{
        block();
    };
    [hview showJJSLBetHubWithList:list money:money odds:odds];
}
- (void)showJJSLBetHubWithList:(NSArray<FYJSSLDataSource *> *)list money:(NSString *)money odds:(NSString *)odds{
    self.list = list;
    CGFloat tbH = list.count < 5 ? list.count * 20 : 100;
    self.moneylab.text = [NSString stringWithFormat:NSLocalizedString(@"总金额 : %zd元", nil),[money integerValue]];
    self.numLab.text = [NSString stringWithFormat:NSLocalizedString(@"赔率 : %@", nil),odds];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tbH + 149);
    }];
    [self.tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        self.bgView.frame = self.bounds;
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.cancelBtn];
        [self.contentView addSubview:self.determineBtn];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.lineView2];
        [self.contentView addSubview:self.numLab];
        [self.contentView addSubview:self.moneylab];
        [self.contentView addSubview:self.tableView];
        CGFloat contentViewW = SCREEN_WIDTH * 0.75;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(contentViewW);
            make.height.mas_equalTo(150);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(15);
        }];
        NSArray <NSString*>*headerArr = @[NSLocalizedString(@"位数", nil),NSLocalizedString(@"投注号码", nil)];
        CGFloat labW = contentViewW / 2 - 0.5;
        [headerArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *lab = [[UILabel alloc]init];
            lab.text = obj;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:16];
            lab.textColor = HexColor(@"#FFFFFF");
            lab.backgroundColor = HexColor(@"#6B6B6B");
            [self.contentView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.top.equalTo(self.titleLab.mas_bottom).offset(15);
                make.width.mas_equalTo(labW);
                make.left.mas_equalTo(idx * (labW + 0.5));
            }];
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kLineHeight);
            make.centerX.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(75);
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(50);
            make.right.equalTo(self.lineView.mas_left);
        }];
        [self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(50);
            make.left.equalTo(self.lineView.mas_right);
        }];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.height.mas_equalTo(25);
            make.right.equalTo(self.lineView.mas_left);
            make.bottom.equalTo(self.cancelBtn.mas_top);
        }];
        [self.moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(25);
            make.left.equalTo(self.lineView.mas_right);
            make.bottom.equalTo(self.determineBtn.mas_top);
        }];
        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLineHeight);
            make.right.left.equalTo(self.contentView);
            make.bottom.equalTo(self.lineView.mas_top);
        }];
        [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLineHeight);
            make.right.left.equalTo(self.contentView);
            make.top.equalTo(self.moneylab.mas_bottom);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.lineView1.mas_top);
            make.top.equalTo(self.titleLab.mas_bottom).offset(35);
        }];
    }
    return self;
}
- (void)determineHud{
    if (self.block != nil) {
        self.block();
        [self dismissHud];
    }
}
//取消
- (void)dismissHud{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}
#pragma mark - 懒加载
-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[FYJSSLBettHUDCell class] forCellReuseIdentifier:[FYJSSLBettHUDCell reuseIdentifier]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = HexColor(@"#000000");
        _bgView.alpha = 0.55;
    }
    return _bgView;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = HexColor(@"#FAFCFE");
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
        _titleLab.text = NSLocalizedString(@"投注详情", nil);
        _titleLab.textColor = HexColor(@"#1A1A1A");
    }
    return _titleLab;
}
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc]init];
        _numLab.font = [UIFont boldSystemFontOfSize:15];
        _numLab.textColor = HexColor(@"#666666");
        _numLab.backgroundColor = HexColor(@"#F5F5F5");
        _numLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numLab;
}
- (UILabel *)moneylab{
    if (!_moneylab) {
        _moneylab = [[UILabel alloc]init];
        _moneylab.font = [UIFont boldSystemFontOfSize:15];
        _moneylab.textColor = HexColor(@"#666666");
        _moneylab.backgroundColor = HexColor(@"#F5F5F5");
        _moneylab.textAlignment = NSTextAlignmentCenter;
    }
    return _moneylab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#C5C5C5");
    }
    return _lineView;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#C5C5C5");
    }
    return _lineView1;
}
- (UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.backgroundColor = HexColor(@"#C5C5C5");
    }
    return _lineView2;
}
- (UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [[UIButton alloc]init];
        [_determineBtn setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [_determineBtn setTitleColor:HexColor(@"#CB332D") forState:UIControlStateNormal];
        _determineBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _determineBtn.backgroundColor = HexColor(@"#FAFCFE");
        [_determineBtn addTarget:self action:@selector(determineHud) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HexColor(@"#3875F6") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _cancelBtn.backgroundColor = HexColor(@"#FAFCFE");
        [_cancelBtn addTarget:self action:@selector(dismissHud) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FYJSSLBettHUDCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYJSSLBettHUDCell reuseIdentifier]];
    if (self.list.count > indexPath.row) {
        cell.list = self.list[indexPath.row];
    }
    return cell;
}
/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
@end
