//
//  RegisterViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebViewController.h"
#import "CDAlertViewController.h"
#import "LoginRegisterModel.h"
#import "RSA.h"


@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,ActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger sexType;

@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *accountNum;
@property (nonatomic, copy) NSString *pw;

@property (nonatomic, strong) FLAnimatedImageView *vertifyImgBtn;
@property (nonatomic, copy) NSData *imageCaptchaData;
@property (nonatomic, copy) NSString *rsaGenerated;

@property (nonatomic, strong) UIButton *genderBtn;
@property (nonatomic, strong) UIButton *dateBtn;

@end

@implementation RegisterViewController

#pragma mark - getter

- (NSMutableArray *)cells {
    
    if (!_cells) {
        
        _cells = [[NSMutableArray alloc] init];
    }
    return _cells;
}

- (NSMutableArray *)dataList {
    
    if (!_dataList) {
        
        _dataList = [NSMutableArray arrayWithCapacity:13];
    }
    return _dataList;
}

#pragma mark - life cycle

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"注册", nil);
    
    [self initializeData];
    [self setupSubview];
    [self makeLayout];
}

- (void)initializeData {
    _sexType = 0;
    _dateString = @"";
    
    [SVProgressHUD show];
    [NET_REQUEST_MANAGER checkRegisterWithDic:nil success:^(id object) {
        [SVProgressHUD dismiss];
        LoginRegisterModel* model = [LoginRegisterModel mj_objectWithKeyValues:object];
        [self.dataList addObjectsFromArray:[model getRegisterTypes]];
        
        self.rsaGenerated = [RSA randomlyGenerated16BitString];
        [self loadCaptchaData];
        
    } fail:^(id object) {
        
//        [[FunctionManager sharedInstance] handleFailResponse:object];
        [SVProgressHUD dismiss];
        [self showAlert];
    }];
    
}
- (void)showAlert{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"线路切换", nil) message:NSLocalizedString(@"网络不好,请切换线路试试吧", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPingVC];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)showPingVC{
    PingViewController *vc = [[PingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadCaptchaData {
    
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestImageCaptchaWithPhone:weakSelf.rsaGenerated type:GetSmsCodeFromVCRegister success:^(id object) {
        weakSelf.imageCaptchaData = object;
        [weakSelf.tableView reloadData];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - layout

- (void)setupSubview {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"线路切换", nil) style:UIBarButtonItemStyleDone target:self action:@selector(showPingVC)];
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 52;
    _tableView.sectionFooterHeight = 8.0f;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView.backgroundColor = BaseColor;
    _tableView.separatorColor = TBSeparaColor;
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    _tableView.tableFooterView = fotView;
    
    
    UIButton *btn = [UIButton new];
    [fotView addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [btn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action_submit) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MBTNColor;
    [btn delayEnable];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(16));
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@(44));
        make.top.equalTo(fotView.mas_top).offset(38);
    }];
    
    UIView *thirdView = [UIView new];
    [fotView addSubview:thirdView];
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(fotView);
        make.top.equalTo(btn.mas_bottom).offset(50);
    }];
    
    UILabel *thirdLabel = [UILabel new];
    [thirdView addSubview:thirdLabel];
    thirdLabel.font = [UIFont systemFontOfSize2:14];
    thirdLabel.text = NSLocalizedString(@"没有邀请码请联系客服", nil);
    thirdLabel.textColor = Color_9;
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(thirdView);
    }];
    
    UIView *lineleft = [UIView new];
    [thirdView addSubview:lineleft];
    lineleft.backgroundColor = COLOR_X(210, 210, 210);
    
    [lineleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdView.mas_left).offset(15);
        make.right.greaterThanOrEqualTo(thirdLabel.mas_left).offset(-15);
        make.centerY.equalTo(thirdLabel.mas_centerY);
        make.height.equalTo(@(1.0));
    }];
    
    UIView *lineright = [UIView new];
    [thirdView addSubview:lineright];
    lineright.backgroundColor = COLOR_X(210, 210, 210);
    [lineright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(thirdLabel.mas_right).offset(15);
        make.right.equalTo(thirdView.mas_right).offset(-15);
        make.height.equalTo(@(1.0));
        make.centerY.equalTo(thirdLabel.mas_centerY);
    }];
    
    UIButton *wx = [UIButton new];
    [thirdView addSubview:wx];
    [wx setBackgroundImage:[UIImage imageNamed:@"serverIcon"] forState:UIControlStateNormal];
    [wx addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    
    [wx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(thirdView);
        make.top.equalTo(thirdLabel.mas_bottom).offset(20);
    }];
}

- (void)makeLayout {
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - <UITableViewDataSource && Delegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataList[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        NSArray *list = self.dataList[indexPath.section];
        NSInteger type = [list[indexPath.row][kType] integerValue];
        cell.tag = type;
        cell.imageView.image = [UIImage imageNamed:list[indexPath.row][kImg]];
        [self.cells addObject:
          @{
            @{list[indexPath.row][kSubTit]:list[indexPath.row][kIsOn]}:cell
            
            }];
        if (type == EnumActionTag1) {
            _codeBtn = [UIButton new];
            [cell.contentView addSubview:_codeBtn];
            [_codeBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            _codeBtn.layer.cornerRadius = 6;
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.backgroundColor = COLOR_X(244, 112, 35);//[UIColor colorWithHexString:@""];
            [_codeBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.height.equalTo(@(30));
                make.width.equalTo(@(86));
            }];
        }
        if (type == EnumActionTag9) {
            if(self.imageCaptchaData!=nil){
                _vertifyImgBtn = [FLAnimatedImageView new];
                [cell.contentView addSubview:_vertifyImgBtn];
                _vertifyImgBtn.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageCaptchaData];
                [_vertifyImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-15);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.height.equalTo(@(30));
                    make.width.equalTo(@(86));
                }];
                _vertifyImgBtn.userInteractionEnabled = true;
                UITapGestureRecognizer* tagG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_refreshImgCode)];
                [_vertifyImgBtn addGestureRecognizer:tagG];
            }
        }
        if (type == EnumActionTag11) {
            _genderBtn = [UIButton new];
            _genderBtn.userInteractionEnabled = NO;
            [cell.contentView addSubview:_genderBtn];
            [_genderBtn setTitle:(_sexType == 0)?NSLocalizedString(@"男", nil):NSLocalizedString(@"女", nil) forState:UIControlStateNormal];
            [_genderBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            _genderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            
            //            [_vertifyImgBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.height.equalTo(@(30));
                make.width.equalTo(@(86));
            }];
        }
        if (type == EnumActionTag12) {
            
            _dateBtn = [UIButton new];
            _dateBtn.userInteractionEnabled = NO;
            [cell.contentView addSubview:_dateBtn];
            [_dateBtn setTitle:[_dateString isEqualToString:  @""]? NSLocalizedString(@"选择日期 >", nil) : _dateString forState:UIControlStateNormal];
            [_dateBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            _dateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            
            //            [_vertifyImgBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.height.equalTo(@(30));
                make.width.equalTo(@(95));
            }];
        }
        UITextField* textField = [UITextField new];
        textField.tag = 9000;
        [cell.contentView addSubview:textField];
        textField.placeholder = list[indexPath.row][kTit];
        textField.secureTextEntry =
        (type == EnumActionTag2
         ||
         type == EnumActionTag3)
        ?YES:NO;
        textField.userInteractionEnabled =
        (type == EnumActionTag11
         ||
         type == EnumActionTag12)
        ?NO:YES;
        textField.font = [UIFont systemFontOfSize2:15];
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.returnKeyType = UIReturnKeyDone;
        textField.textColor = [UIColor colorWithHexString:@"#000000"];
        if(type == EnumActionTag0){
            textField.keyboardType = UIKeyboardTypePhonePad;
        }
        CGFloat r =
        (type == EnumActionTag1
         ||
         type == EnumActionTag9
         ||
         type == EnumActionTag11
         ||
         type == EnumActionTag12)
        ?121:15;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(50);
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-r);
        }];
        [self checkOpenInstalll:textField type:type];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = self.dataList[indexPath.section];
    NSInteger type = [list[indexPath.row][kType] integerValue];
    
    if (type == EnumActionTag11) {
        ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:@[NSLocalizedString(@"男", nil),NSLocalizedString(@"女", nil)]];
        sheet.titleLabel.text = NSLocalizedString(@"请选择性别", nil);
//        sheet.tag = type;
        sheet.delegate = self;
        [sheet showWithAnimationWithAni:YES];
        
    }
    
    if (type == EnumActionTag12) {
        __weak typeof(self) weakSelf = self;
        [CDAlertViewController showDatePikerDate:^(NSString *date) {
            weakSelf.dateString = date;
            [weakSelf.dateBtn setTitle:date forState:UIControlStateNormal];
//            [weakSelf updateType:type date:date];
        }];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    for (int i = 0; i<self.cells.count; i++) {
        NSDictionary* cellDic = self.cells[i];
        UITableViewCell *cell = cellDic.allValues.firstObject;
        UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
        [tf resignFirstResponder];
    }
}


#pragma mark ActionSheetDelegate

- (void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
    if(index == 2) {
        return;
    }
    
    _sexType = index;
    [_genderBtn setTitle:(_sexType == 0)?NSLocalizedString(@"男", nil):NSLocalizedString(@"女", nil) forState:UIControlStateNormal];
}


#pragma mark - Action

- (void)action_submit {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i<self.cells.count; i++) {
        NSDictionary *cellDic = self.cells[i];
        UITableViewCell* cell = cellDic.allValues.firstObject;
        
        NSDictionary* paramDic = cellDic.allKeys.firstObject;
        NSString* param = paramDic.allKeys.firstObject;
        NSString* isOptional = paramDic.allValues.firstObject;
            switch (cell.tag) {
                case EnumActionTag0:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *account = tf.text;
                    
                    if (account.length < 8 ||
                        account.length > 11) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:account}];
                }
                    break;
                case EnumActionTag1:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *vertifyCode = tf.text;
                    if (vertifyCode.length == 0) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入验证码", nil));
                        return;
                    }
                    if (vertifyCode.length < 3) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请入正确的验证码", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:vertifyCode}];
                }
                    break;
                case EnumActionTag2:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *pw = tf.text;
                    if (pw.length > 16 ||
                        pw.length < 6) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入6-16位密码", nil));
                        return;
                    }
                    _pw = pw;

                    [dic addEntriesFromDictionary:@{param:pw}];
                }
                    break;
                case EnumActionTag3:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *cpw = tf.text;
                    if (cpw.length > 16 ||
                        cpw.length < 6) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入6-16位密码", nil));
                        return;
                    }
                    if (![cpw isEqualToString:_pw]) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"密码不一致", nil));
                        return;
                    }
//                    [dic addEntriesFromDictionary:@{list[j][kSubTit]:cpw}];
                }
                    break;
                    
                case EnumActionTag4:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入邀请码", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                    
                case EnumActionTag5:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入QQ号", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag6:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入微信号", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag7:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入邮箱", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag8:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入真实姓名", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag9:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入图形验证码", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                    [dic addEntriesFromDictionary:@{@"piccodeUUID":_rsaGenerated}];
                }
                    break;
                case EnumActionTag10:
                {
                    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                    NSString *inviteCode = tf.text;
                    if (inviteCode.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请输入用户名", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:inviteCode}];
                }
                    break;
                case EnumActionTag11:
                {
                    
                    [dic addEntriesFromDictionary:@{param:@(_sexType)}];
                }
                    break;
                case EnumActionTag12:
                {
                    if (_dateString.length == 0&&
                        [isOptional boolValue] == YES) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请选择出生日期", nil));
                        return;
                    }
                    [dic addEntriesFromDictionary:@{param:_dateString}];
                }
                    break;
                default:
                    break;
            }
        }
    
    
    
    [self.view endEditing:YES];
    
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER toRegisterAPI:dic successBlock:^(NSDictionary *success) {
        [[AppModel shareInstance] setLoginType:FYLoginTypeDefault];
        SVP_SUCCESS_STATUS(NSLocalizedString(@"注册成功", nil));
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[AppModel shareInstance] loginToUpdateUserInformation:YES];
    } failureBlock:^(NSError *failure) {
        [[FunctionManager sharedInstance] handleFailResponse:failure];
    }];
//    [NET_REQUEST_MANAGER registerWithDic:dic success:^(id object) {
//        SVP_SUCCESS_STATUS(NSLocalizedString(@"注册成功", nil));
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    } fail:^(id object) {
//        [[FunctionManager sharedInstance] handleFailResponse:object];
//    }];
}

- (void)action_refreshImgCode {
    
    WEAK_OBJ(weakSelf, self);
    _rsaGenerated = [RSA randomlyGenerated16BitString];
    [NET_REQUEST_MANAGER requestImageCaptchaWithPhone:_rsaGenerated type:GetSmsCodeFromVCRegister success:^(id object) {
        weakSelf.imageCaptchaData = object;
        weakSelf.vertifyImgBtn.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageCaptchaData];
    } fail:^(id object) {
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)action_getCode {
    
    for (int i = 0; i<self.cells.count; i++) {
        NSDictionary* cellDic = self.cells[i];
        UITableViewCell* cell = cellDic.allValues.firstObject;
        
        switch (cell.tag) {
            case EnumActionTag0:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *account = tf.text;
                
                if (account.length < 8 || account.length > 11) {
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
                    return;
                }
                _accountNum = account;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_accountNum type:GetSmsCodeFromVCRegister success:^(id object) {
        SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
        int time = ![FunctionManager isEmpty:object[@"data"]]?[object[@"data"] intValue]:60;
        [weakSelf.codeBtn beginTime:time];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)feedback {
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"联系客服", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)checkOpenInstalll:(UITextField *)textField type:(EnumActionTag)type{
    if (type != EnumActionTag4) {
        return;
    }
    if ([kTenant isEqualToString:@"pig666"]) {
        textField.text = @"66666";
        textField.enabled = NO;
    }
    if ([kTenant isEqualToString:@"wujiu590"]) {
        textField.text = @"01584";
        textField.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
