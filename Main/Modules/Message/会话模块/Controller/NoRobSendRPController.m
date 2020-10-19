//
//  NoRobSendRPController.m
//  Project
//
//  Created by Mike on 2019/3/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "NoRobSendRPController.h"
#import "EnvelopeMessage.h"
#import "MessageItem.h"
#import "NetRequestManager.h"
#import "NotificationMessageModel.h"
#import "SelectMineNumCell.h"
#import "SendRedPackedTextCell.h"
#import "SendRPNumTableViewCell.h"
#import "SendRedCheckBalanceHelper.h"


@interface NoRobSendRPController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *rowList;
@property (nonatomic ,strong) UILabel *moneyLabel;
@property (nonatomic ,strong) UIButton *submit;
@property (nonatomic ,strong) MessageItem *message;
//@property (nonatomic ,strong) UILabel *promptLabel;
@property (nonatomic ,assign) NSInteger textFieldObjectIndex;

@property (nonatomic ,strong) NSMutableArray *selectNumArray;
// 红包个数
@property (nonatomic ,strong) NSString *redpbNum;
// NO 禁抢   YES 不中
@property (nonatomic ,assign) BOOL isNotPlaying;
// 总金额
@property (nonatomic ,strong) NSString *totalMoney;


@end

@implementation NoRobSendRPController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNotPlaying = NO;
    
    [self initSubviews];
    [self initLayout];
    [self initNotif];
    [self initData];
    
    self.selectNumArray = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[SelectMineNumCell class] forCellReuseIdentifier:@"SelectMineNumCell"];
    
    [self.tableView registerClass:[SendRedPackedTextCell class] forCellReuseIdentifier:@"SendRedPackedTextCell"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark ----- Data
- (void)initData {
    _message = (MessageItem *)self.CDParam;
    if (_message.type == 3) { // 禁抢
        _rowList =@[
            @{@"title":@"",@"right":@""},
            @{@"title":NSLocalizedString(@"总 金 额", nil),@"right":NSLocalizedString(@"元", nil),@"placeholder":[NSString stringWithFormat:@"%@ ~ %@",self.message.minMoney,self.message.maxMoney]},
            @{@"title":NSLocalizedString(@"红包个数", nil),@"right":NSLocalizedString(@"包", nil)},
            @{@"title":@"",@"":@""}];
    }
    [self.tableView reloadData];
    
}



#pragma mark ----- Layout
- (void)initLayout {

}

- (void)initNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}



#pragma mark ----- subView
- (void)initSubviews {

    self.view.backgroundColor = HexColor(@"#EDEDED");
    self.navigationItem.title = NSLocalizedString(@"发红包", nil);
    self.navigationController.delegate = self;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [btn addTarget:self action:@selector(action_cancle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [btn setTitleColor:HexColor(@"#CB332D") forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -Height_NavBar) style:UITableViewStylePlain];
    tableView.sectionFooterHeight = 4.0f;
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.scrollEnabled =NO;  // 设置tableview 不能滚动
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = HexColor(@"#EDEDED");
  
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

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return CD_Scal(80, 812);
    } else if (indexPath.row == 1) {
        return CD_Scal(75, 812);
    } else if (indexPath.row == 2) {
        return SCREEN_HEIGHT - CD_Scal(80, 812)*2;
    }
    return CD_Scal(10, 812);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *messDict = [_message.attr mj_JSONObject];
    NSDictionary *dict1 = [messDict objectForKey:@"1"];  // 禁抢红包
    NSDictionary *dict2 = [messDict objectForKey:@"2"];  // 不中
    NSArray *noPlayArray = [dict2 allKeys];
    
    if (indexPath.row == 0) {
        SendRedPackedTextCell *cell = [SendRedPackedTextCell cellWithTableView:tableView reusableId:@"SendRedPackedTextCell"];
        cell.deTextField.placeholder = [NSString stringWithFormat:@"%ld ~ %ld", [self.message.minMoney integerValue], [self.message.maxMoney integerValue]];
        cell.titleLabel.text = NSLocalizedString(@"红包金额", nil);
        cell.unitLabel.text = NSLocalizedString(@"元", nil);
        
        cell.object = self;
        return cell;
    } else if (indexPath.row == 1) {
        SendRPNumTableViewCell *cell = [SendRPNumTableViewCell cellWithTableView:tableView reusableId:@"SendRPNumTableViewCell"];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[dict1 allKeys]];
        cell.cellBackgroundColor = HexColor(@"#F6F6F6");
        for (NSInteger i = 0; i < noPlayArray.count; i++) {
            if (![dataArray containsObject:noPlayArray[i]]) {
                [dataArray addObject:noPlayArray[i]];
            }
        }
        cell.model = [[FunctionManager sharedInstance] orderBombArray: dataArray];
        cell.selectNumBlock = ^(NSArray *items) {
            NSIndexPath *indexPath = (NSIndexPath *)items.firstObject;
            self.isNotPlaying = NO;
            self.redpbNum = [[FunctionManager sharedInstance] orderBombArray: dataArray][indexPath.row];
            NSIndexPath *ip=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:ip,nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.selectNumArray removeAllObjects];
        };
        return cell;
    } else if (indexPath.row == 2) {
        SelectMineNumCell *cell = [SelectMineNumCell cellWithTableView:tableView reusableId:@"SelectMineNumCell"];
        NSArray *dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
       
        NSDictionary *numDict;
        if (self.isNotPlaying) {
            numDict = dict2[[NSString stringWithFormat:@"%@",self.redpbNum]];
        } else {
            numDict = dict1[[NSString stringWithFormat:@"%@",self.redpbNum]];
        }
        cell.maxNum = [numDict[@"bombMax"] intValue];
        cell.money = self.totalMoney;
        cell.model = dataArray;

        BOOL isNoPlay = NO;
        for (NSInteger index = 0; index < noPlayArray.count; index++) {
            if (self.redpbNum.integerValue == [noPlayArray[index] integerValue]) {
                isNoPlay = YES;
            }
        }
        
        cell.isBtnDisplay = isNoPlay;
        cell.selectNumBlock = ^(NSArray *items) {
            
            [self.selectNumArray removeAllObjects];
            for (NSInteger index = 0; index < items.count; index++) {
                NSIndexPath *indexPath = (NSIndexPath *)items[index];
                NSString *num = dataArray[indexPath.row];
                [self.selectNumArray addObject:num];
            }
            NSLog(@"%@", self.selectNumArray);
        };
        cell.selectNoPlayingBlock = ^(BOOL isSelect) {
            self.isNotPlaying =  isSelect;
        };
        cell.selectMoreMaxBlock = ^(BOOL isMoreMax) {
            if (self.redpbNum != nil) {
                NSString *str = [NSString stringWithFormat:NSLocalizedString(@"%@包多雷最多雷数不能超过%@个", nil), self.redpbNum,numDict[@"bombMax"]];
                SVP_ERROR_STATUS(str);
            } else {
                SVP_ERROR_STATUS(NSLocalizedString(@"请先选择红包个数", nil));
            }
        };
        cell.mineCellSubmitBtnBlock = ^(NSString *money){
            self.totalMoney = money;
            [self action_sendRedpacked];
        };
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark action
- (void)action_cancle {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToBottom" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


//#pragma mark action
//- (void)doneSend:(EnvelopeMessage *)message{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [ChatViewController sendCustomMessage:message];
//    });
//}


#pragma mark - 红包金额验证
- (BOOL)moneyCheck:(CGFloat)money {
    
    NSInteger max = 0;
    NSInteger min = 0;
    max = [self.message.maxMoney integerValue];
    min = [self.message.minMoney integerValue];
    
    if ((money > max) | (money < min)) {
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"红包发包范围:%@-%@", nil), self.message.minMoney,self.message.maxMoney];
        SVP_ERROR_STATUS(str);
        
        return NO;
    } else {
        return YES;
    }
}



#pragma mark - 发红包
- (void)action_sendRedpacked
{
    [self.view endEditing:YES];
    
    NSString * regex        = @"(^[0-9]{0,15}$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (self.totalMoney.length == 0) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入总金额", nil));
        return;
    }
    
    if (![self moneyCheck:self.totalMoney.floatValue]) {
        return;
    }
    
    if (self.redpbNum.length == 0) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请选择包数", nil));
        return;
    }
    
    if(![pred evaluateWithObject:self.redpbNum]){
        SVP_ERROR_STATUS(NSLocalizedString(@"红包个数请输入整数", nil));
        return;
    }
    
    if(![pred evaluateWithObject:self.totalMoney]){
        SVP_ERROR_STATUS(NSLocalizedString(@"金额请输入整数", nil));
        return;
    }
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (_message.type == 3) {  // 禁抢
        if (self.selectNumArray.count == 0) {
            SVP_ERROR_STATUS(NSLocalizedString(@"选择雷号", nil));
            return;
        }
        
        NSDictionary *messDict = [_message.attr mj_JSONObject];
        NSDictionary *dict1 = [messDict objectForKey:@"1"];  // 禁抢红包
        NSDictionary *dict2 = [messDict objectForKey:@"2"];  // 不中
        NSDictionary *numDict;
        if (self.isNotPlaying) {
            numDict = dict2[[NSString stringWithFormat:@"%@",self.redpbNum]];
        } else {
            numDict = dict1[[NSString stringWithFormat:@"%@",self.redpbNum]];
        }
        
        if (self.selectNumArray.count < [numDict[@"bombMin"] intValue]) {
            NSString *strMess = [NSString stringWithFormat:NSLocalizedString(@"%@包多雷玩法最少%i雷", nil), self.redpbNum, [numDict[@"bombMin"] intValue]];
            SVP_ERROR_STATUS(strMess);
            return;
        }
        
        [dic setObject:self.isNotPlaying ? @"2" : @"1" forKey:@"type"];   // 游戏类型  2不中玩法
        self.selectNumArray = (NSMutableArray *)[[FunctionManager sharedInstance] orderBombArray:self.selectNumArray];
        [dic setObject:self.selectNumArray forKey:@"bombList"];  // 雷号列表
    }
    
    _submit.enabled = NO;
    [self redpackedRequest:self.totalMoney packetNum:self.redpbNum extDict:dic];
    
}

- (void)redpackedRequest:(NSString *)money packetNum:(NSString *)packetNum extDict:(NSDictionary *)extDict {

    NSDictionary *parameters = @{
                                 @"ext":extDict,
                                 @"groupId":self.message.groupId,
                                 @"userId":[AppModel shareInstance].userInfo.userId,
                                 @"type":@(_message.type),
                                 @"money":money,
                                 @"count":@(self.redpbNum.integerValue)
                                 };
    
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER redpacketSend:parameters successBlock:^(NSDictionary *response) {
        PROGRESS_HUD_DISMISS;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.submit.enabled = YES;
        if ([response objectForKey:@"code"] != nil && [[response objectForKey:@"code"] integerValue] == 0) {
            [strongSelf action_cancle];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(id error) {
        PROGRESS_HUD_DISMISS
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.submit.enabled = YES;
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [(NSDictionary *)error stringForKey:@"alterMsg"];
            if ([msg containsString:NSLocalizedString(@"余额不足", nil)]) {
                [SendRedCheckBalanceHelper checkShowBalanceView:msg navigation:self.navigationController];
            } else {
                ALTER_HTTP_ERROR_MESSAGE(error)
            }
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }
    }];
}

#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)notiObject {
    
    UITextField *textFieldObj = (UITextField *)notiObject.object;
//    NSInteger mObjectInte = [textFieldObj.text integerValue];
  
    self.totalMoney = textFieldObj.text;
}

- (BOOL)money:(CGFloat)money {
    
    NSInteger max = 0;
    NSInteger min = 0;
    max = [self.message.maxMoney integerValue];
    min = [self.message.minMoney integerValue];
    
    if ((money > max) | (money < min)) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)count:(CGFloat)count {
    
    NSInteger max = 0;
    NSInteger min = 0;
    max = [self.message.maxCount integerValue];
    min = [self.message.minCount integerValue];
    
    if ((count > max) | (count < min)) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)leiNum:(CGFloat)number {
    CGFloat max = 9;
    CGFloat min = 0;
    if ((number > max) | (number < min)) {
        return NO;
    } else {
        return YES;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

