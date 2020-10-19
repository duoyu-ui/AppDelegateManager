//
//  VVAlertViewController.m
//  ProjectXZHB
//
//  Created by Mike on 2019/3/17.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SystemAlertViewController.h"
#import "VVAlertGroupHeaderView.h"
#import "SystemAlertTextCell.h"
#import "NSString+Size.h"
#import "VVAlertModel.h"

@interface SystemAlertViewController () <UITableViewDataSource,UITableViewDelegate, VVAlertGroupHeaderViewDelegate>
{
    UIView *_shadowView;
    UIView *_contentView;
    
    UIEdgeInsets _contentMargin;
    CGFloat _contentViewWidth;
    CGFloat _buttonHeight;
    
    BOOL _firstDisplay;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SystemAlertViewController


+ (instancetype)alertControllerWithTitle:(NSString *)title dataArray:(NSArray *)dataArray {
    
    SystemAlertViewController *instance = [SystemAlertViewController new];
    instance.titleStr = title;
    instance.dataArray = dataArray;
    if(dataArray.count == 1){
        VVAlertModel *model = dataArray[0];
        model.expend = YES;
    }
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting
{
    _contentMargin = UIEdgeInsetsMake(25, 20, 0, 20);
    _contentViewWidth = SCREEN_WIDTH -30*2;
    _buttonHeight = 45;
    _firstDisplay = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.bgView];
    
    //创建对话框
    [self creatShadowView];
    [self creatContentView];
    
    self.titleLabel.text = self.titleStr;
    
    [_contentView addSubview:self.tableView];
}

#pragma mark - Getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, _contentViewWidth, _shadowView.bounds.size.height - 50) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 44;
        [_tableView registerClass:[SystemAlertTextCell class] forCellReuseIdentifier:@"SystemAlertTextCell"];
    }
    return _tableView;
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    VVAlertModel *model = self.dataArray[section];
    return model.isExpend ? model.friends.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VVAlertModel *model = self.dataArray[indexPath.section];
    static NSString *cellId = @"SystemAlertTextCell";
    SystemAlertTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
        cell = [SystemAlertTextCell cellWithTableView:tableView reusableId:cellId];
    // 倒序
    cell.model = model.friends[indexPath.row];
    return cell;

}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VVAlertModel *model = self.dataArray[indexPath.section];

    CGFloat height =  [model.friends[indexPath.row] heightWithFont:[UIFont vvFontOfSize:15] constrainedToWidth:SCREEN_WIDTH -30*2 -(30 + 10 + 1)];
    height = height + 10 *2;
    if (height > 44) {
        return height;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    VVAlertModel *model = self.dataArray[section];
    
    NSString *nameStr = [NSString stringWithFormat:@"%zd. %@",section+1, model.name];
    CGFloat height =  [nameStr heightWithFont:[UIFont vvFontOfSize:16] constrainedToWidth:SCREEN_WIDTH -30*2 -15*2];
    height = height + 10 *2;
    if (height > 44) {
        return height;
    }
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    VVAlertGroupHeaderView *headerView = [VVAlertGroupHeaderView VVAlertGroupHeaderViewWithTableView:tableView];
    headerView.delegate = self;
    headerView.index = section +1;
    VVAlertModel *model = self.dataArray[section];
    headerView.groupModel = model;
    headerView.tag = section;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)VVAlertGroupHeaderViewDidClickBtn:(VVAlertGroupHeaderView *)headerView {
    
    for (NSInteger index = 0; index < self.dataArray.count; index++) {
         VVAlertModel *model = self.dataArray[index];
        if (headerView.tag == index) {
            if (model.expend == YES) {
                model.expend = NO;
            } else {
                model.expend = YES;
            }
        } else {
            model.expend = NO;
        }
    }

    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.dataArray.count)];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.backgroundColor = [UIColor clearColor];

    //更新弹出框的frame
    [self updateShadowAndContentViewFrame];
    
    //显示弹出动画
    [self showAppearAnimation];
}


- (void)updateShadowAndContentViewFrame {
    //更新警告框的frame
    CGRect frame = _shadowView.frame;
    frame.size.height = 400;
    _shadowView.frame = frame;
    
    _shadowView.center = self.view.center;
    _contentView.frame = _shadowView.bounds;
}


#pragma mark - 显示弹出动画
- (void)showAppearAnimation {
    
    if (_firstDisplay) {
        _firstDisplay = NO;
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.bgView.alpha = 0.0;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->_shadowView.transform = CGAffineTransformIdentity;
            self->_shadowView.alpha = 1;
            self.bgView.alpha = 1.0;
        } completion:nil];
    }
}

#pragma mark - 事件响应
- (void)didClickCloseBtn:(UIButton *)sender {
    
    [self showDisappearAnimation];
}


#pragma mark - 消失动画
- (void)showDisappearAnimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        self->_shadowView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self->_contentView.alpha = 0;
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.closeCallBack) {
                self.closeCallBack(1);
            }
        }];
    }];
}


#pragma mark - 创建内部视图

//阴影层
- (void)creatShadowView {
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentViewWidth, 400)];
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    _shadowView.layer.shadowRadius = 20;
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 10);
    //    _shadowView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_shadowView];
}

//内容层
- (void)creatContentView {
    _contentView = [[UIView alloc] initWithFrame:_shadowView.bounds];
    _contentView.backgroundColor = [UIColor colorWithRed:250/255.0f green:251/255.0f blue:252/255.0f alpha:1];
    _contentView.layer.backgroundColor = [UIColor clearColor].CGColor;
    _contentView.layer.cornerRadius = 10;
    _contentView.clipsToBounds = YES;
    _contentView.layer.masksToBounds = YES;
    [_shadowView addSubview:_contentView];
    
    UIView *topView = [[UIView alloc] init];
    [_contentView addSubview:topView];
    topView.backgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self->_contentView);
        make.height.mas_equalTo(50);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont vvBoldFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
    }];
    
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(didClickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [closeBtn setImage:[UIImage imageNamed:@"message_close"] forState:UIControlStateNormal];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
    [topView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.mas_equalTo(topView.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
}


@end
