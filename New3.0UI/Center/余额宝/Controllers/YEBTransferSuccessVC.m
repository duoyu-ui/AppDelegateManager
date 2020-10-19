//
//  YEBTransferSuccessVC.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBTransferSuccessVC.h"
#import "YEBTranferSuccessCell.h"
#import "YEBTransferSuccessView.h"
#import "YEBTransferModel.h"
#import "NSDate+dy_extension.h"
@interface YEBTransferSuccessVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *datasource;
@property (nonatomic, strong) YEBTransferSuccessView *headerView;
@property (nonatomic, strong) YEBTransferModel *model;
@property (nonatomic, copy) NSString *shiftOutMoney;

@end

@implementation YEBTransferSuccessVC {
    
    ///0 == in 1 == out
    int _vcType;
    
}

+ (instancetype)transferInSuccessVCWithResult:(YEBTransferModel *)model {
    
    YEBTransferSuccessVC *vc = [YEBTransferSuccessVC new];
    vc->_vcType = 0;
    vc.model = model;
    return vc;
}

+ (instancetype)transferOutSuccessVCWithMoney:(NSString *)money {
    
    YEBTransferSuccessVC *vc = [YEBTransferSuccessVC new];
    vc->_vcType = 1;
    vc.shiftOutMoney = money;
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupSubView {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    
    if (_vcType) {
        
        self.title = NSLocalizedString(@"结果详情", nil);
        self.headerView = [YEBTransferSuccessView successView];
        self.tableView.tableHeaderView = self.headerView;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
        self.headerView.moneyLabel.text = self.shiftOutMoney;
        self.headerView.timeLabel.text = [NSDate dy_timeStampToDateStrWithInterval:NSDate.new.timeIntervalSince1970 * 1000 dataFormat:@"YYYY-MM-dd HH:mm:ss"];
        
    } else {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"YEBTranferSuccessCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        if (self.model) {
            self.datasource = @[
                                @{@"upTitle":[NSString stringWithFormat:@"%@:  %@%@",NSLocalizedString(@"成功转入",nil),self.model.money,NSLocalizedString(@"元",nil)], @"subTitle":[NSString stringWithFormat:NSLocalizedString(@"操作时间：%@", nil), self.model.createTime]},
                                @{@"upTitle":NSLocalizedString(@"开始计算收益", nil), @"subTitle":[NSString stringWithFormat:NSLocalizedString(@"操作时间：%@", nil),self.model.beginTime]},
                                @{@"upTitle":NSLocalizedString(@"收益到账时间", nil), @"subTitle":[NSString stringWithFormat:NSLocalizedString(@"操作时间：%@", nil), self.model.endTime]}
                                ];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:NSLocalizedString(@"转入成功", nil) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yeb-transferIn-success"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setEnabled:0];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.rowHeight = 56;

    }
    
}

- (void)doneBtnClick {

    NSMutableArray *arrayM = self.navigationController.viewControllers.mutableCopy;
    [arrayM removeLastObject];
    [arrayM removeLastObject];
    [self.navigationController setViewControllers:arrayM.copy animated:YES];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 168);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YEBTranferSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dict = self.datasource[indexPath.row];
    cell.upTitle.text = dict[@"upTitle"];
    cell.subTitle.text = dict[@"subTitle"];
    if (indexPath.row == 0) {
        cell.upLine.hidden = YES;
        cell.bottomLine.backgroundColor = kThemeTextColor;
        cell.upTitle.textColor = kThemeTextColor;
        cell.icon.backgroundColor = kThemeTextColor;
    } else {
        cell.upTitle.textColor = kColorWithHex(0x666666);
        cell.bottomLine.backgroundColor = kColorWithHex(0xe2e2e2);
        cell.upLine.backgroundColor = kColorWithHex(0xe2e2e2);
        cell.icon.backgroundColor = kColorWithHex(0xe2e2e2);
    }
    if (indexPath.row == self.datasource.count - 1) {
        cell.bottomLine.hidden = YES;
    }
    return cell;
}

@end
