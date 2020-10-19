//
//  RecommendedViewController.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "RecommendedViewController.h"
#import "RecommendNet.h"
#import "RecommendCell.h"
#import "ReportForms2ViewController.h"

@interface RecommendedViewController ()<UITableViewDelegate,UITableViewDataSource,ActionSheetDelegate>{
    UITableView *_tableView;
    RecommendNet *_model;
}
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIButton *totalNumLabel;
@property(nonatomic,strong)UIButton *totalNumLabel2;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UITextField *levelTextField;
@end

@implementation RecommendedViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"下级玩家", nil);
    [self initData];
    [self initSubviews];
}

#pragma mark ----- Data
- (void)initData{
    _model = [[RecommendNet alloc]init];
    if (_uid == nil) {
        _uid = [AppModel shareInstance].userInfo.userId;
    }
}
-(void)feedback{
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"联系客服", nil);
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ----- subView
- (void)initSubviews{
    
//    self.navigationItem.title = NSLocalizedString(@"我的玩家", nil);

    UIButton *serviceBtn = [[UIButton alloc]init];
    [serviceBtn setImage:[UIImage imageNamed:@"msg-operation-1"] forState:UIControlStateNormal];
    serviceBtn.adjustsImageWhenHighlighted = NO;
    serviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [serviceBtn addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:serviceBtn];
    
    __weak RecommendNet *weakModel = _model;
    
    UIView *headView = [self headView];
    [self.view addSubview:headView];
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    __weak __typeof(self)weakSelf = self;

    _tableView.rowHeight = 130;
//    _tableView.separatorColor = TBSeparaColor;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getData:0];
    }]; [_tableView.mj_header setAlpha:0];
    _tableView.StateView = [StateView StateViewWithHandle:^{
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakModel.isMost) {
            [strongSelf getData:weakModel.page];
        }
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(headView.mas_bottom).offset(-40);
    }];
    SVP_SHOW;
    [self getData:0];
}

#pragma mark net
- (void)getData:(NSInteger)page{
    WEAK_OBJ(weakObj, self);
    [_model getPlayerWithPage:page success:^(NSDictionary *obj){
        SVP_DISMISS;
        [weakObj reload];
    } failure:^(NSError *error) {
        [weakObj reload];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
    
    WEAK_OBJ(weakSelf, self);
    [_model requestCommonInfoWithSuccess:^(NSDictionary *obj) {
        [weakSelf updateHeadInfo];
    } failure:^(NSError *error) {
        [weakObj reload];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

-(void)updateHeadInfo{
    NSInteger agent = 0;
    if(_model.commonInfo[@"agent"])
        agent = [_model.commonInfo[@"agent"] integerValue];
    NSInteger user = 0;
    if(_model.commonInfo[@"user"])
        user = [_model.commonInfo[@"user"] integerValue];
    
    NSString *preString = [NSString stringWithFormat:NSLocalizedString(@"团队成员：%@\n", nil),INT_TO_STR((agent + user))];
    
    NSString *suffixString = [NSString stringWithFormat:NSLocalizedString(@"代理人数：%zd\n玩家人数：%zd", nil),agent,user];
    
    [self.totalNumLabel setAttributedTitle:[FunctionManager attributedStringWithString:preString stringColor:HEXCOLOR(0x666666) stringFont:[UIFont systemFontOfSize:15]    numInPreStringColor:HEXCOLOR(0xbe0036) numInPreStringFont:[UIFont systemFontOfSize:15]  subString:suffixString subStringColor:HEXCOLOR(0x999999) subStringFont:[UIFont systemFontOfSize:12] numInSubColor:HEXCOLOR(0xf68b00) numInSubFont:[UIFont systemFontOfSize:12]] forState:UIControlStateNormal];
    
    [self.totalNumLabel setTitle:preString forState:UIControlStateNormal];
    
    agent = 0;
    if(_model.commonInfo[@"pagent"])
        agent = [_model.commonInfo[@"pagent"] integerValue];
    user = 0;
    if(_model.commonInfo[@"puser"])
        user = [_model.commonInfo[@"puser"] integerValue];
    preString = [NSString stringWithFormat:NSLocalizedString(@"直推成员：%@\n", nil),INT_TO_STR((agent + user))];
    suffixString = [NSString stringWithFormat:NSLocalizedString(@"代理人数：%zd\n玩家人数：%zd", nil),agent,user];
    
    [self.totalNumLabel2 setAttributedTitle:[FunctionManager attributedStringWithString:preString stringColor:HEXCOLOR(0x666666) stringFont:[UIFont systemFontOfSize:15]    numInPreStringColor:HEXCOLOR(0xbe0036) numInPreStringFont:[UIFont systemFontOfSize:15]  subString:suffixString subStringColor:HEXCOLOR(0x999999) subStringFont:[UIFont systemFontOfSize:12] numInSubColor:HEXCOLOR(0xf68b00) numInSubFont:[UIFont systemFontOfSize:12]] forState:UIControlStateNormal];
}

- (void)reload{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    if(_model.IsNetError){
        [_tableView.StateView showNetError];
    }
    else if(_model.isEmpty){
        [_tableView.StateView showEmpty];
    }else{
        [_tableView.StateView hidState];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_tableView reloadData];
    });
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCell *cell = (RecommendCell *)[tableView CDdequeueReusableCellWithIdentifier:_model.dataList[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.detailButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    //cell.detailButton.hidden = YES;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    RecommendedViewController *vc = [[RecommendedViewController alloc]init];
//    CDTableModel *model = _model.dataList[indexPath.row];
//    vc.uid = model.obj[@"id"];
//    vc.title = [NSString stringWithFormat:NSLocalizedString(@"%@的玩家", nil),model.obj[@"nickname"]];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

-(void)detailAction:(UIButton *)btn{
    UITableViewCell *cell = [[FunctionManager sharedInstance] cellForChildView:btn];
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    CDTableModel *model = _model.dataList[path.row];
    NSDictionary *dic = model.obj;
    ReportForms2ViewController *vc = [[ReportForms2ViewController alloc] init];
    vc.userId = dic[@"userId"];
    vc.isAgent = [dic[@"agentFlag"] boolValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)headView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 208)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [UIImage imageNamed:@"navBarBg"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:img];
    bgView.frame = view.bounds;
    [view addSubview:bgView];
    
    
    UIImageView* iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wavesIcon"]];
    iv.userInteractionEnabled = true;
    [view addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(view);
        make.left.equalTo(@10);
        make.bottom.equalTo(view.mas_bottom).offset(-40);
        make.height.equalTo(@168);
    }];
    
    UIView* lineV = [UIView new];
    lineV.backgroundColor = HEXCOLOR(0xe4e4e4);
    [iv addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(iv);
        make.centerY.equalTo(iv);
        make.height.equalTo(@0.5);
        make.width.equalTo(iv);
    }];
    
    UIButton *playerBtn = [[UIButton alloc] init];
    playerBtn.adjustsImageWhenHighlighted = false;
    playerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    playerBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    playerBtn.titleLabel.numberOfLines = 0;
    [playerBtn setImage:[UIImage imageNamed:@"teamPlayers"] forState:UIControlStateNormal];
    [playerBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [iv addSubview:playerBtn];
    [playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iv).offset(15);
       make.top.equalTo(iv).offset(18); make.right.equalTo(iv.mas_centerX);
//        make.height.equalTo(@35);
    }];
    [playerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    self.totalNumLabel = playerBtn;
    
    playerBtn = [[UIButton alloc] init];
    playerBtn.adjustsImageWhenHighlighted = false;
    playerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    playerBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    playerBtn.titleLabel.numberOfLines = 0;
    [playerBtn setImage:[UIImage imageNamed:@"followerPlayers"] forState:UIControlStateNormal];
    [playerBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [iv addSubview:playerBtn];
    [playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalNumLabel.mas_right);
        make.right.equalTo(iv).offset(-15);
        make.top.equalTo(self.totalNumLabel);
//        make.height.equalTo(@35);
    }];
    [playerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    self.totalNumLabel2 = playerBtn;
    
    
    UIView* verticalLine = [UIView new];
    verticalLine.backgroundColor = HEXCOLOR(0xe4e4e4);
    [iv addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(iv);
        make.centerY.equalTo(self.totalNumLabel2);
//        make.top.equalTo(@15);
        make.height.equalTo(@25);
        make.width.equalTo(@0.5);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"agentSearch"] forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@"搜索", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = HEXCOLOR(0xf68b00);
    [iv addSubview:btn];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 18;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(iv.mas_right).offset(-15);
        make.top.equalTo(lineV.mas_bottom).offset(15);
        make.height.equalTo(@35);
        make.width.equalTo(@90);
    }];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:3];
    [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.levelTextField = [[UITextField alloc] init];
    self.levelTextField.text = NSLocalizedString(@"全部", nil);
    self.levelTextField.textColor = HEXCOLOR(0x999999);
    self.levelTextField.font = [UIFont systemFontOfSize2:15];
    self.levelTextField.backgroundColor = HEXCOLOR(0xeeeeee);
    self.levelTextField.layer.masksToBounds = YES;
    self.levelTextField.layer.cornerRadius = 18;
    
    UIView *tfRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, 18)];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    imageView.image=[UIImage imageNamed:@"playerSearchTypeIcon"];
    imageView.contentMode = UIViewContentModeLeft;
    
    [tfRightView addSubview:imageView];
    
    self.levelTextField.rightView = tfRightView;
    
    self.levelTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.levelTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.levelTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [iv addSubview:self.levelTextField];;
    [self.levelTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(btn.mas_left).offset(-10); make.top.height.equalTo(btn);
        make.width.equalTo(@105);
    }];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [iv addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.levelTextField);
    }];
    [btn1 addTarget:self action:@selector(showTypes) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountTextField = [[UITextField alloc] init];
    self.accountTextField.placeholder = NSLocalizedString(@"账户ID", nil);
    self.accountTextField.textColor = Color_0;
    self.accountTextField.font = [UIFont systemFontOfSize2:15];
    self.accountTextField.backgroundColor = HEXCOLOR(0xeeeeee);
    self.accountTextField.layer.masksToBounds = YES;
    self.accountTextField.layer.cornerRadius = 18;
    self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [iv addSubview:self.accountTextField];;
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalNumLabel);
        make.height.equalTo(@35);
        make.right.equalTo(self.levelTextField.mas_left).offset(-10); make.top.equalTo(lineV.mas_bottom).offset(15);
    }];
    return view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    CGPoint point = scrollView.contentOffset;
    CGRect rect = self.bgView.frame;
    rect.origin.y = -point.y;
    self.bgView.frame = rect;
    [_tableView.mj_header setAlpha:0];
}

-(void)searchAction{
    [self.view endEditing:YES];
    _model.userString = self.accountTextField.text;
    SVP_SHOW;
    [self getData:0];
}

-(void)showTypes{
    [self.view endEditing:YES];
    ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:@[NSLocalizedString(@"全部", nil),NSLocalizedString(@"代理用户", nil),NSLocalizedString(@"会员用户", nil)]];
    sheet.titleLabel.text = NSLocalizedString(@"请选择用户类型", nil);
    sheet.delegate = self;
    [sheet showWithAnimationWithAni:YES];
}

-(void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
    if(index == 0){
        self.levelTextField.text = NSLocalizedString(@"全部", nil);
        _model.type = -1;
    }
    else if(index == 1){
        self.levelTextField.text = NSLocalizedString(@"代理用户", nil);
        _model.type = 1;
    }
    else if(index == 2){
        self.levelTextField.text = NSLocalizedString(@"会员用户", nil);
        _model.type = 0;
    }
}

@end
