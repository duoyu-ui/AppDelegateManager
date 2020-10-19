//
//  AddMemberController.m
//  Project
//
//  Created by Mike on 2019/2/12.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddMemberController.h"
#import "SearchCell.h"

#define TopViewHeight 52

@interface AddMemberController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) id userInfo;

@end

@implementation AddMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubview];
    [self addNotification];
}

- (void)setupSubview {
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.layer.cornerRadius = 3;
    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
    doneButton.frame = CGRectMake(0, 0, 53, 32);
    [doneButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [doneButton setTintColor:[UIColor whiteColor]];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [doneButton addTarget:self action:@selector(onDoneButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(TopViewHeight);
    }];
    
    UIImageView *searchBgView = [[UIImageView alloc] init];
    searchBgView.image = [UIImage imageNamed:@"group_search"];
    [topView addSubview:searchBgView];
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.left.mas_equalTo(topView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.placeholder = NSLocalizedString(@"搜索", nil);
    searchTextField.keyboardType = UIKeyboardTypeNumberPad;
    [topView addSubview:searchTextField];
    _searchTextField = searchTextField;
    
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.left.mas_equalTo(searchBgView.mas_right).offset(10);
        make.right.mas_equalTo(topView.mas_right).offset(-20);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.906 green:0.906 blue:0.906 alpha:1.000];
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(topView.mas_bottom);
    }];
    
    [self.view addSubview:self.tableView];
}


- (void)onDoneButton {
    if (self.isSelected) {
        [self addMember];
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请选择成员", nil)];
    }
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight + 2, SCREEN_WIDTH, SCREEN_HEIGHT - Height_NavBar -TopViewHeight -1) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = TBSeparaColor;
    }
    
    return _tableView;
}


/**
 添加群成员
 */
- (void)addMember {

    NSMutableArray *userIdArray = [NSMutableArray array];
    [userIdArray addObject: self.searchTextField.text];
    
    NSDictionary *parameters = @{
                                 @"groupId":self.groupId,
                                 @"userIds": userIdArray
                                 };
    
    [NET_REQUEST_MANAGER addgroupMember:parameters successBlock:^(NSDictionary *success) {
        if ([success objectForKey:@"code"] && [[success objectForKey:@"code"] integerValue] == 0) {
            NSString *msg = [NSString stringWithFormat:@"%@",[success objectForKey:@"alterMsg"]];
            SVP_SUCCESS_STATUS(msg);
        } else {
            
            [[FunctionManager sharedInstance] handleFailResponse:success];
        }
    } failureBlock:^(NSError *failure) {
        
        [[FunctionManager sharedInstance] handleFailResponse:failure];
    }];
}


- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 输入字符判断

- (void)textFieldDidChangeValue:(NSNotification *)text {
    UITextField *textField = (UITextField *)text.object;
    if (textField.text.length == 0) {
        return;
    }
    NSString *num = @"^[0-9]*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    BOOL isNum = [pre evaluateWithObject:textField.text];
    if (isNum) {
         [self getUserInfoData];
    }
}


// 查询群成员
- (void)getUserInfoData {
    
    NSDictionary *parameters = @{
                                 @"id":[NSString stringWithFormat:@"%@",self.searchTextField.text]
                                 };
    
    [SVProgressHUD show];
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER addGroupSelect:parameters successBlock:^(NSDictionary *success) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SVP_DISMISS;
        if ([success objectForKey:@"code"] && [[success objectForKey:@"code"] integerValue] == 0) {
            strongSelf.userInfo = success[@"data"];
            [strongSelf.tableView reloadData];
        } else {
             strongSelf.userInfo = nil;
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError *failure) {
        SVP_DISMISS;
        [[FunctionManager sharedInstance] handleFailResponse:failure];
    }];
}

#pragma mark - <UITableViewDataSource && Delegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.userInfo != nil && self.userInfo != [NSNull null]) {
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    if (cell == nil) {
        cell = [[SearchCell alloc]initWithStyle:0 reuseIdentifier:@"user"];
    }
    cell.obj = self.userInfo;
    __weak __typeof(self)weakSelf = self;
    cell.selectedBtnBlock = ^(BOOL isSelected) {
        weakSelf.isSelected = isSelected;
        return;
    };
    
    return cell;
}


@end
