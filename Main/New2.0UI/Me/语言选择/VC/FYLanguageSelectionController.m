//
//  FYLanguageSelectionController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLanguageSelectionController.h"
#import "FYRootUI4TabBarController.h"
#import "FYCenterMainViewController.h"
#import "FYLanguageModel.h"
#import "FYLanguageConfig.h"
#import "NSBundle+FYUtils.h"
#import "AppDelegate.h"
static NSString *const FYLanguageSelectionCellID = @"FYLanguageSelectionCellID";
@interface FYLanguageSelectionController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIView *navBgView;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIButton *cancelBtn;
@property (nonatomic , strong) UIButton *doneBtn;
@property (nonatomic , strong) UITableView *tableView ;
@property (nonatomic , strong) NSArray *datasArr;
@property (nonatomic , assign) NSInteger row;
@end

@implementation FYLanguageSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
    self.datasArr = @[NSLocalizedString(@"跟随系统", nil),@"简体中文",@"English"];
    [self.tableView reloadData];
    self.row = -1;
}
- (void)initSubview{
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.navBgView];
    [self.view addSubview:self.tableView];
    [self.navBgView addSubview:self.cancelBtn];
    [self.navBgView addSubview:self.doneBtn];
    [self.navBgView addSubview:self.titleLab];
    [self.navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navBgView.mas_bottom);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navBgView);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBgView);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBgView);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(65);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FYLanguageSelectionCellID];
    cell.backgroundColor = UIColor.whiteColor;
    cell.tintColor = HexColor(@"#DB1E23");

    if (self.datasArr.count > indexPath.row) {
        cell.textLabel.textColor = UIColor.blackColor;
        cell.textLabel.text = self.datasArr[indexPath.row];
    }
    //用户没有自己设置的语言，则跟随手机系统
    if (![FYLanguageConfig userLanguage].length) {
        cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        
        if ([NSBundle isChineseLanguage]) {
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    return cell;
}
/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}
/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
/**cell点击*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
       UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
           return;
       }
       for (UITableViewCell *acell in tableView.visibleCells) {
           acell.accessoryType = acell == cell ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
       }
    self.doneBtn.backgroundColor = HexColor(@"#3ABD68");
    self.doneBtn.selected = YES;
    self.row = indexPath.row;
}

/// 获取根控制器
-(FYRootUI4TabBarController *)currentTtabarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (FYRootUI4TabBarController *)tabbarController;
    }
    return nil;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FYLanguageSelectionCellID];
    }
    return _tableView;
}


- (UIView *)navBgView{
    if (!_navBgView) {
        _navBgView = [[UIView alloc]init];
        _navBgView.backgroundColor = BaseColor;
    }
    return _navBgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = UIColor.blackColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = NSLocalizedString(@"切换语言", nil);
    }
    return _titleLab;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:HexColor(@"#EB4A4A") forState:UIControlStateNormal];
        [_cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cancelBtn;
}
- (UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]init];
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 4;
        [_doneBtn addTarget:self action:@selector(doneSelectLanguage) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.backgroundColor = UIColor.grayColor;
        [_doneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_doneBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [_doneBtn setTitleColor:HexColor(@"#FFFFFF") forState:UIControlStateSelected];
        _doneBtn.selected = NO;
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _doneBtn;
}
- (void)doneSelectLanguage{
    if (self.row == 0) {
        [FYLanguageConfig setUserLanguage:nil];
    } else  if (self.row == 1) {
        [FYLanguageConfig setUserLanguage:@"zh-Hans"];
    } else if (self.row == 2){
        [FYLanguageConfig setUserLanguage:@"en-GB"];
    }
    FYRootUI4TabBarController *tbc = [[FYRootUI4TabBarController alloc]init];
    tbc.selectedIndex = 4;
    CFCNavigationController *nav = tbc.selectedViewController;
    SystemSettingsController *setVc = [[SystemSettingsController alloc]init];
    [setVc.navigationController setNavigationBarHidden:YES animated:YES];
    NSMutableArray *vcs = nav.viewControllers.mutableCopy;
    [vcs addObj:setVc];
    //解决奇怪的动画bug。异步执行
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = tbc;
        nav.viewControllers = vcs;
    });
    
}

- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
