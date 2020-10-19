//
//  EnvelopeViewController.m
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//  红包发包

#import "SendRedEnvelopeController.h"
#import "EnvelopeMessage.h"
#import "MessageItem.h"
#import "NetRequestManager.h"
#import "NotificationMessageModel.h"
#import "SendRPTextCell.h"
#import "SendRedCheckBalanceHelper.h"
#import "SendRedEnvelopeScrollView.h"
@interface SendRedEnvelopeController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,SendRedEnvelopeDelegate>{
    UITextField *_textField[3];
    UILabel *_titLabel[3];
    UILabel *_unitLabel[3];
}

@property (nonatomic, strong) NSArray *rowList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) MessageItem *message;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) NSString *moneyStr;
@property (nonatomic, strong) NSString *countStr;
@property (nonatomic, strong) NSString *mineStr;

@property (nonatomic, assign) NSInteger textFieldObjectIndex;
@property (nonatomic, strong) UITextField *moneyTxField;

@property (nonatomic , strong) SendRedEnvelopeScrollView *scrollView;

@end

@implementation SendRedEnvelopeController

#pragma mark - Getter

- (MessageItem *)message {
    
    if (!_message) {
        
        _message = (MessageItem *)self.CDParam;
    }
    return _message;
}

- (NSString *)setupTitleWithType:(NSInteger)type {
    switch (type) {
        case 0:
            return NSLocalizedString(@"发福利红包", nil);
            break;
        case 1:
            return NSLocalizedString(@"发扫雷红包", nil);
            break;
        case 2:
            return NSLocalizedString(@"发牛牛红包", nil);
            break;
        case 3:
            return NSLocalizedString(@"发禁抢红包", nil);
            break;
        case 4:
            return NSLocalizedString(@"发比分红包", nil);
            break;
        case 5:
            return NSLocalizedString(@"发比分红包", nil);
            break;
        case 7:
            return NSLocalizedString(@"发接龙红包", nil);
            break;
        case 8:
            return NSLocalizedString(@"二人牛牛红包", nil);
            break;
        default:
            return NSLocalizedString(@"发红包", nil);
            break;
    }
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    self.navigationController.delegate = self;
  
    if (self.isFu) {
        self.title = NSLocalizedString(@"发福利红包", nil);
    } else {
        self.title = [self setupTitleWithType:self.message.type];
    }
   
    [self loadPacketConfig];
    [self setSubviews];
    [self bindRefreshing];
//    [self setupSubview];
//    [self addNotification];

}
///设置子控件
- (void)setSubviews{
    [self setNavBtn];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.scrollView.isFu = self.isFu;
}
///设置导航栏按钮
- (void)setNavBtn{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [cancelBtn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HexColor(@"#CB332D") forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}
#pragma mark - 发红包代理
- (void)sendRedMoney:(NSString *)money count:(NSString *)count leiNums:(NSString *)leiNums{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
      if (!self.isFu && self.message.type == 1) {
          if (leiNums.length == 0) {
              SVP_ERROR_STATUS(NSLocalizedString(@"请输入雷数", nil));
              return;
          }
//          if(![pred evaluateWithObject:bombNum]){
//              SVP_ERROR_STATUS(NSLocalizedString(@"雷数请输入整数", nil));
//              return;
//          }
          [dic setObject:leiNums forKey:@"bombNum"];
      }
      

      [self redpackedRequest:money packetNum:count extDict:dic];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [_textField[0] becomeFirstResponder];
 
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHex:@"#EDEDED"];
        self.navigationController.navigationBar.tintColor = [UIColor colorFromHex:@"#EDEDED"];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }

}

- (void)restDataSource {
    
    if (self.isFu) {
        _rowList = @[@[@{@"title":NSLocalizedString(@"红包金额", nil),@"right":NSLocalizedString(@"元", nil),@"placeholder":[NSString stringWithFormat:NSLocalizedString(@"%@~%@ 元", nil),self.message.simpMinMoney,self.message.simpMaxMoney]},@{@"title":NSLocalizedString(@"红包个数", nil),@"right":NSLocalizedString(@"个", nil),@"placeholder":NSLocalizedString(@"填写红包个数", nil)}]];
        return;
    }
    
    if (self.message.type == 1) {
        _rowList = @[@[@{@"title":NSLocalizedString(@"总金额", nil),@"right":NSLocalizedString(@"元", nil),@"placeholder":[NSString stringWithFormat:NSLocalizedString(@"%@~%@ 元", nil),self.message.minMoney,self.message.maxMoney]},@{@"title":NSLocalizedString(@"红包个数", nil),@"right":NSLocalizedString(@"个", nil),@"placeholder":NSLocalizedString(@"填写红包个数", nil)}],@[@{@"title":NSLocalizedString(@"雷数", nil),@"right":@"",@"placeholder":NSLocalizedString(@"范围0-9", nil)}]];
    }else if (self.message.type == 8) { //二人牛牛
        self.countStr = self.message.maxCount;
        _rowList = @[@[@{@"title":NSLocalizedString(@"总金额", nil),@"right":NSLocalizedString(@"元", nil),@"placeholder":[NSString stringWithFormat:NSLocalizedString(@"%@~%@ 元", nil),self.message.minMoney,self.message.maxMoney]}]];
    }else if (self.message.type == 2) {
        _rowList = @[@[@{@"title":NSLocalizedString(@"总金额", nil),@"right":NSLocalizedString(@"元", nil),@"placeholder":[NSString stringWithFormat:NSLocalizedString(@"%@~%@ 元", nil),self.message.minMoney,self.message.maxMoney]},@{@"title":NSLocalizedString(@"红包个数", nil),@"right":NSLocalizedString(@"个", nil),@"placeholder":NSLocalizedString(@"填写红包个数", nil)}]];
    }
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)setupSubview {
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [cancelBtn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    _tableView = [UITableView groupTable];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =  [UIColor colorFromHex:@"#EDEDED"];
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SendRPTextCell class] forCellReuseIdentifier:@"SendRPTextCell"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _tableView.tableHeaderView = headerView;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _tableView.tableFooterView = footerView;
    
    _moneyLabel = [UILabel new];
    [footerView addSubview:_moneyLabel];
    _moneyLabel.font = [UIFont systemFontOfSize:60];
    _moneyLabel.textColor = Color_0;
    _moneyLabel.text = @"0";
    _moneyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.top.equalTo(footerView.mas_top).offset(30);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.9);
    }];
    
    _submitBtn = [UIButton new];
    [footerView addSubview:_submitBtn];
    _submitBtn.layer.cornerRadius = 8;
    _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.backgroundColor = [UIColor colorFromHex:@"#E16754"];

    [_submitBtn setTitle:NSLocalizedString(@"塞钱进红包", nil) forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(checkRedPacked) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.4);
        make.height.equalTo(@(54));
        make.bottom.equalTo(footerView.mas_bottom);
    }];
}

- (void)bindRefreshing {

    // 下拉刷新
    CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPacketConfig)];
    [refreshHeader setTitle:CFCRefreshAutoHeaderIdleText forState:MJRefreshStateIdle];
    [refreshHeader setTitle:CFCRefreshAutoHeaderPullingText forState:MJRefreshStatePulling];
    [refreshHeader setTitle:CFCRefreshAutoHeaderRefreshingText forState:MJRefreshStateRefreshing];
    [refreshHeader.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoHeaderColor)];
    [refreshHeader.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
    [refreshHeader setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    [self.scrollView setMj_header:refreshHeader];
}

- (void)stopRefreshing {
    if (self.scrollView.mj_header && [self.scrollView.mj_header isRefreshing]) {
        [self.scrollView.mj_header endRefreshing];
    }
}

#pragma mark - Request

/// 获取群设置信息
- (void)loadPacketConfig {
    [SVProgressHUD show];
    if (self.message.groupId) {
        [[NetRequestManager sharedInstance] getGroupInfoWithGroupId:self.message.groupId success:^(id object) {
            [self stopRefreshing];
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                if ([object[@"code"] integerValue] == 0) {
                    NSDictionary *JSONData = [object[@"data"] mj_JSONObject];
                    MessageItem *model = [MessageItem mj_objectWithKeyValues:JSONData];
                    self.scrollView.item = model;
//                    self.message.minMoney = model.minMoney;
//                    self.message.maxMoney = model.maxMoney;
//                    self.message.minCount = model.minCount;
//                    self.message.maxCount = model.maxCount;
//                    self.message.simpMinCount = model.simpMinCount;
//                    self.message.simpMaxCount = model.simpMaxCount;
                    
//                    [self restDataSource];
                }
            }
            [SVProgressHUD dismiss];
            
        } fail:^(id object) {
            
            [self stopRefreshing];
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.rowList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rowList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SendRPTextCell *cell = [SendRPTextCell cellWithTableView:tableView reusableId:@"SendRPTextCell"];
    cell.object = self;
    cell.titleLabel.text = _rowList[indexPath.section][indexPath.row][@"title"];
    cell.titleLabel.textColor = Color_0;
    cell.deTextField.placeholder = _rowList[indexPath.section][indexPath.row][@"placeholder"];
    cell.unitLabel.text = _rowList[indexPath.section][indexPath.row][@"right"];;
    cell.unitLabel.textColor = Color_0;
    cell.deTextField.userInteractionEnabled = YES;
    cell.deTextField.tag = indexPath.section * 1000 + indexPath.row;
    cell.isUpdateTextField = NO;
    cell.isFu = self.isFu;
   if (indexPath.section == 0 ) {
        if (self.isFu) {
            cell.deTextField.placeholder = [NSString stringWithFormat:@"%@~%@",self.message.simpMinCount,self.message.simpMaxCount];
        } else {
            if(self.message.type == 1) {
                cell.titleLabel.textColor = COLOR_X(140, 140, 140);
                cell.deTextField.text = [NSString stringWithFormat:@"%@", self.message.maxCount];
                cell.deTextField.userInteractionEnabled = NO;
                cell.deTextField.textColor = COLOR_X(140, 140, 140);
                cell.isUpdateTextField = YES;
                cell.unitLabel.textColor = COLOR_X(140, 140, 140);
            } else if(self.message.type == 2) {
                if (self.message.maxCount.integerValue == self.message.minCount.integerValue) {
                    cell.titleLabel.textColor = COLOR_X(140, 140, 140);
                    cell.deTextField.text = [NSString stringWithFormat:@"%@",self.message.maxCount];
                    cell.deTextField.userInteractionEnabled = NO;
                    cell.deTextField.textColor = COLOR_X(140, 140, 140);
                    cell.isUpdateTextField = YES;
                    cell.unitLabel.textColor = COLOR_X(140, 140, 140);
                } else {
                    cell.deTextField.placeholder = [NSString stringWithFormat:@"%@~%@",self.message.minCount,self.message.maxCount];
                }
            }else if (self.message.type == 8) {
                if (self.message.maxCount.integerValue == self.message.minCount.integerValue) {
                    cell.isUpdateTextField = YES;
                    cell.deTextField.text = self.message.maxCount;
                    cell.unitLabel.textColor = [UIColor blackColor];
                    cell.titleLabel.textColor = [UIColor blackColor];
                    cell.deTextField.textColor = [UIColor blackColor];
                    cell.deTextField.text = [NSString stringWithFormat:@"%@",self.message.maxCount];
                    cell.deTextField.userInteractionEnabled = NO;
                }
            }
        }
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *label = [UILabel new];
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize2:13];
    label.textColor = COLOR_X(140, 140, 140);
    
    if (self.isFu) {
//        label.text = [NSString stringWithFormat:NSLocalizedString(@"红包发包范围: %@-%@元", nil),self.message.simpMinMoney,self.message.simpMaxMoney];
        label.hidden = YES;
    }else {
        if (self.message.type == 1) {
//            label.text = (section == 0)? [NSString stringWithFormat:NSLocalizedString(@"红包发包范围: %@-%@元", nil),self.message.minMoney,self.message.maxMoney]:NSLocalizedString(@"雷数范围0-9", nil);
        } else if (self.message.type == 2 || self.message.type == 8) {
//            label.text = (section == 0)? [NSString stringWithFormat:NSLocalizedString(@"红包发包范围: %@-%@元", nil),self.message.minMoney,self.message.maxMoney]:[NSString stringWithFormat:NSLocalizedString(@"红包个数: %@-%@元", nil),self.message.minCount,self.message.maxCount];
        }
    }
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(20);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 35;
}


#pragma mark - Action

- (void)dismissClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTobottomLabeltom" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkRedPacked
{
    [self.view endEditing:YES];
    
    NSString *money = self.moneyStr;
    NSString *packetNum = self.countStr;
    NSString *bombNum = [self.mineStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * regex = @"(^[0-9]{0,15}$)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (money.length == 0) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入总金额", nil));
        return;
    }
    if (packetNum.length == 0) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入红包个数", nil));
        return;
    }
    if (![pred evaluateWithObject:packetNum]){
        SVP_ERROR_STATUS(NSLocalizedString(@"红包个数请输入整数", nil));
        return;
    }
    if (![pred evaluateWithObject:money]){
        SVP_ERROR_STATUS(NSLocalizedString(@"金额请输入整数", nil));
        return;
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (!self.isFu && self.message.type == 1) {
        if (bombNum.length == 0) {
            SVP_ERROR_STATUS(NSLocalizedString(@"请输入雷数", nil));
            return;
        }
        if(![pred evaluateWithObject:bombNum]){
            SVP_ERROR_STATUS(NSLocalizedString(@"雷数请输入整数", nil));
            return;
        }
        [dic setObject:bombNum forKey:@"bombNum"];
    }
    
    _submitBtn.enabled = NO;
    [self redpackedRequest:money packetNum:packetNum extDict:dic];
}

#pragma mark - 发红包

- (void)redpackedRequest:(NSString *)money packetNum:(NSString *)packetNum extDict:(NSDictionary *)extDict
{
    NSDictionary *parameters = @{
                                 @"ext":extDict,
                                 @"groupId":self.message.groupId,
                                 @"userId":[AppModel shareInstance].userInfo.userId,
                                 @"type":self.isFu ? @(0) : @(self.message.type),
                                 @"money":money,
                                 @"count":@(packetNum.integerValue)
                                 };

    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER redpacketSend:parameters successBlock:^(NSDictionary *response) {
        PROGRESS_HUD_DISMISS
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        strongSelf.submitBtn.enabled = YES;
        if (response != nil && [response objectForKey:@"code"]) {
            if ([[response objectForKey:@"code"] integerValue] == 0) {
                FYLog(NSLocalizedString(@"=================== 红包发送成功 ===================", nil));
                [strongSelf dismissClick];
            } else {
                if ([[response objectForKey:@"code"] integerValue] == 1) {
                    // 重新获取配置
                    [self.scrollView.mj_header beginRefreshing];
                }
                [[FunctionManager sharedInstance] handleFailResponse:response];
            }
        }
    } failureBlock:^(id error) {
        PROGRESS_HUD_DISMISS
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.submitBtn.enabled = YES;
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [SendRedCheckBalanceHelper checkShowBalanceView:msg navigation:self.navigationController];
            } else {
                ALTER_HTTP_ERROR_MESSAGE(error)
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[FunctionManager sharedInstance] handleFailResponse:error];
            });
        }
    }];
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 1000) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (textField.text.length >= 1) {
            textField.text = [textField.text substringToIndex:1];
            return NO;
        }
    }
    
    // 金额不能以0开头
//    if (!textField.tag && range.location == 0) {
//        if ([string hasPrefix:@"0"]) {
//            textField.text = @"";
//            return NO;
//        }
//    }
    
    return YES;
}

#pragma mark - 输入字符判断

- (void)textFieldDidChangeValue:(NSNotification *)text{
    UITextField *textFieldObj = (UITextField *)text.object;
    self.textFieldObjectIndex = textFieldObj.tag;
    self.moneyTxField = textFieldObj;
    if (textFieldObj.tag == 0) {
        self.textFieldObjectIndex = 0;
    } else if (textFieldObj.tag == 1) {
        self.textFieldObjectIndex = 1;
    } else if (textFieldObj.tag == 1000) {
        self.textFieldObjectIndex = 2;
    }
    
    if(!self.isFu && self.message.type == 1) {
        self.countStr = self.message.maxCount;
    }
    if(!self.isFu && self.message.type == 2) {
        if (self.message.maxCount.integerValue == self.message.minCount.integerValue) {
            self.countStr = self.message.maxCount;
        }
    }
    
    if (textFieldObj.tag == 0) {
        self.moneyStr = textFieldObj.text;
    } else if (textFieldObj.tag == 1) {
        self.countStr = textFieldObj.text;
    } if (textFieldObj.tag == 1000) {
        self.mineStr = textFieldObj.text;
    }
    
    NSInteger sendMoney = [self.moneyStr integerValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld", sendMoney];
    
    NSInteger countTemp = [self.countStr integerValue];
    BOOL count = [self countAction:countTemp];
    BOOL money = [self moneyAction:sendMoney];
    BOOL length = self.mineStr.length <= 0 ? NO : [self bombIsCheck:[self.mineStr integerValue]];
    if (self.message.type == 8) { //二人牛牛
        length = YES;
    }
    
    if ((self.isFu && money && count) ||
        (!self.isFu && self.message.type == 1 && money && length) ||
        (!self.isFu && self.message.type == 8 && money && length) ||
        (self.message.type == 2 && money && count)) {
        self.submitBtn.enabled = YES;
        self.submitBtn.alpha = 1.0;
        self.promptLabel.text = @"";
    }else {
        self.submitBtn.enabled = NO;
        self.submitBtn.alpha = 0.7;
    }
    
}

- (BOOL)moneyAction:(CGFloat)money {
    NSInteger max = 0;
    NSInteger min = 0;
    if (self.isFu) {
        max = [self.message.simpMaxMoney integerValue];
        min = [self.message.simpMinMoney integerValue];
    } else {
        max = [self.message.maxMoney integerValue];
        min = [self.message.minMoney integerValue];
    }
    
    if ((money > max) | (money < min)) {
        if (self.textFieldObjectIndex == 0) {
            if (self.isFu) {
                self.promptLabel.text = [NSString stringWithFormat:NSLocalizedString(@"红包发包范围:%@-%@", nil), self.message.simpMinMoney,self.message.simpMaxMoney];
            } else {
                self.promptLabel.text = [NSString stringWithFormat:NSLocalizedString(@"红包发包范围:%@-%@", nil), self.message.minMoney,self.message.maxMoney];
            }
        }
        return NO;
    } else {
        if (self.textFieldObjectIndex == 0) {
            self.promptLabel.text = @"";
        }
        return YES;
    }
}

- (BOOL)countAction:(CGFloat)count {
    NSInteger max = 0;
    NSInteger min = 0;
    if (self.isFu) {
        max = [self.message.simpMaxCount integerValue];
        min = [self.message.simpMinCount integerValue];
    } else {
        max = [self.message.maxCount integerValue];
        min = [self.message.minCount integerValue];
    }
    
    if ((count > max) | (count < min)) {
        if (self.textFieldObjectIndex == 1) {
            if (self.isFu) {
                self.promptLabel.text = [NSString stringWithFormat:NSLocalizedString(@"红包个数范围:%@-%@", nil), self.message.simpMinCount,self.message.simpMaxCount];
            } else {
                self.promptLabel.text = [NSString stringWithFormat:NSLocalizedString(@"红包个数范围:%@-%@", nil), self.message.minCount,self.message.maxCount];
            }
        }
        return NO;
    } else {
        if (self.textFieldObjectIndex == 1) {
            self.promptLabel.text = @"";
        }
        return YES;
    }
}


/// 雷数校验
- (BOOL)bombIsCheck:(CGFloat)number {
    CGFloat max = 9;
    CGFloat min = 0;
    if ((number > max) | (number < min)) {
        if (self.textFieldObjectIndex == 1000) {
            self.promptLabel.text = NSLocalizedString(@"雷数范围:0-9", nil);
        }
        return NO;
    } else {
        if (self.textFieldObjectIndex == 2) {
            self.promptLabel.text = @"";
        }
        return YES;
    }
}

- (SendRedEnvelopeScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[SendRedEnvelopeScrollView alloc]init];
        _scrollView.srDelegate = self;
    }
    return _scrollView;;
}
#pragma mark - dealloc

- (void)dealloc {
    self.navigationController.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
