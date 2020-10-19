//
//  AgentCenterViewController.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AgentCenterViewController.h"
#import "BecomeAgentViewController.h"
#import "ReportFormsViewController.h"
#import "RecommendedViewController.h"
#import "ShareViewController.h"
#import "CopyViewController.h"
#import "AccountDeleteTipPopUpView.h"
@interface AgentTypeView ()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *lastBtn;
@end

@implementation AgentTypeView

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        
        NSInteger height = frame.size.height - 1;
        NSInteger marX = 0;
        NSInteger width = (frame.size.width - marX * 2)/buttonArray.count;
        //        if(buttonArray.count > 0){
        //            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1.5, width, 1)];
        //            lineView.backgroundColor = COLOR_X(243, 4, 0);
        //            [self addSubview:lineView];
        //            self.lineView = lineView;
        //        }
        for (NSInteger i = 0;i < buttonArray.count; i++) {
            NSDictionary *dic = buttonArray[i];
            NSDictionary *subDic = dic.allValues.firstObject;
            //            NSString *imgNormal = [dic objectForKey:@"imgNormal"];
            //            NSString *imgSelected = [dic objectForKey:@"imgNormal"];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(marX + (width * i), 0, width, height/2);
            [btn setTitle:dic.allKeys.firstObject forState:UIControlStateNormal];
            [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            //            [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            btn.adjustsImageWhenHighlighted = false;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            //            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            //            [btn setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
            //            [btn setImage:[UIImage imageNamed:imgSelected] forState:UIControlStateSelected];
            //            [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
            
            //            [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            //            [btn setContentMode:UIViewContentModeScaleAspectFit];
            [self addSubview:btn];
            btn.tag = i ;
            //            if(i == 0){
            //                CGPoint point = self.lineView.center;
            //                point.x = btn.center.x;
            //                self.lineView.center = point;
            //            }
            UIButton *subtitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            subtitleBtn.frame = CGRectMake(marX + (width * i), CGRectGetMaxY(btn.frame), width, height/2);
            //            [subtitleBtn setTitle:dic.allValues.firstObject forState:UIControlStateNormal];
            //            [subtitleBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            //            [subtitleBtn setTitleColor:HEXCOLOR(0xbe0036) forState:UIControlStateSelected];
            //            subtitleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            subtitleBtn.adjustsImageWhenHighlighted = false;
            subtitleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self addSubview:subtitleBtn];
            subtitleBtn.tag = 88+i ;
            NSString* preString = subDic.allKeys.firstObject;
            NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:preString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName:HEXCOLOR(0x666666)}];
            
            NSString* suffixString = subDic.allValues.firstObject;
            NSMutableAttributedString *attributeStr2 = [[NSMutableAttributedString alloc] initWithString:suffixString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName : HEXCOLOR(0xf68b00)}];
            if (i == 0) {
                [strAtt setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xbe0036)} range:NSMakeRange(0, preString.length)];
                [attributeStr2 setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x666666)} range:NSMakeRange(0, suffixString.length)];
            }
            if (i == 1) {
                [strAtt setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x00891e)} range:NSMakeRange(0, preString.length)];
                [attributeStr2 setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x00891e)} range:NSMakeRange(0, suffixString.length)];
            }
            if (i == 2) {
                [strAtt setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xf68b00)} range:NSMakeRange(0, preString.length)];
                [attributeStr2 setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xf68b00)} range:NSMakeRange(0, suffixString.length)];
            }
            [strAtt appendAttributedString:attributeStr2];
            
            subtitleBtn.titleLabel.numberOfLines = 0;
            [subtitleBtn setAttributedTitle:strAtt forState:UIControlStateNormal];
            
            if (i != buttonArray.count-1) {
                UIView* verticalLine = [UIView new];
                verticalLine.backgroundColor = HEXCOLOR(0xe4e4e4);
                [self addSubview:verticalLine];
                [verticalLine mas_makeConstraints:^(MASConstraintMaker *make){
                   
                    make.centerY.equalTo(self);
                    make.right.equalTo(btn);
                    //        make.top.equalTo(@15);
                    make.height.equalTo(@25);
                    make.width.equalTo(@0.5);
                }];
            }
        }
        self.lastBtn.selected = NO;
        //        UIButton* btn = [self viewWithTag:1];
        //        btn.selected = YES;
        //        self.lastBtn = btn;
        
        UIView* lineV = [UIView new];
        lineV.backgroundColor = HEXCOLOR(0xe4e4e4);
        [self addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self);
            make.centerX.equalTo(self);
            //            make.centerY.equalTo(self);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self).offset(-1);
        }];
    }
    return self;
}

-(void)buttonAction:(UIButton *)btn{
    if(btn.selected)
        return;
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        self.lineView.center = CGPointMake(btn.center.x, self.lineView.center.y);
    } completion:nil];
    if(self.selectBlock)
        self.selectBlock(@(btn.tag));
}
@end

@interface AgentLinkView ()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *lastBtn;
@end

@implementation AgentLinkView

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
//        if(buttonArray.count > 0){
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1.5, width, 1)];
//            lineView.backgroundColor = COLOR_X(243, 4, 0);
//            [self addSubview:lineView];
//            self.lineView = lineView;
//        }
        
            NSDictionary *dic = buttonArray[0];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(18);
                make.right.equalTo(self).offset(-109);
                make.height.equalTo(self);
                make.centerY.equalTo(self);
            }];
//            [btn setTitle:dic.allKeys.firstObject forState:UIControlStateNormal];
//            [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            NSString* preString = NSLocalizedString(@"代理推广链接\n", nil);
            NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:preString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName:HEXCOLOR(0x666666)}];
            
            NSString* suffixString = dic.allKeys.firstObject;
            NSMutableAttributedString *attributeStr2 = [[NSMutableAttributedString alloc] initWithString:suffixString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName : HEXCOLOR(0xf68b00)}];
            [strAtt appendAttributedString:attributeStr2];
            
            btn.titleLabel.numberOfLines = 0;
            [btn setAttributedTitle:strAtt forState:UIControlStateNormal];
            
            btn.adjustsImageWhenHighlighted = false;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:dic.allValues.firstObject] forState:UIControlStateNormal];
            
            [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
            btn.titleLabel.numberOfLines = 0;
            btn.tag = 70 ;
            
            UIButton *subtitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
            [self addSubview:subtitleBtn];
            [subtitleBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [subtitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-18);
                make.height.equalTo(@30);
                make.width.equalTo(@91);
                make.centerY.equalTo(btn);
            }];
            [subtitleBtn setTitle:NSLocalizedString(@"复制链接", nil) forState:UIControlStateNormal];
            [subtitleBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
            
            subtitleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            subtitleBtn.adjustsImageWhenHighlighted = false;
            subtitleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            subtitleBtn.titleLabel.numberOfLines = 0;
            [self layoutIfNeeded];
            subtitleBtn.layer.masksToBounds = true;
            subtitleBtn.layer.cornerRadius = 15;
            subtitleBtn.backgroundColor = HEXCOLOR(0xfd4c56);
            
            subtitleBtn.tag = 71;
            
        
        self.lastBtn.selected = NO;
//        UIButton* btn = [self viewWithTag:1];
//        btn.selected = YES;
//        self.lastBtn = btn;
    }
    return self;
}

-(void)buttonAction:(UIButton *)btn{
//    if(btn.selected)
//        return;
//    self.lastBtn.selected = NO;
//    btn.selected = YES;
//    self.lastBtn = btn;
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
//        self.lineView.center = CGPointMake(btn.center.x, self.lineView.center.y);
//    } completion:nil];
    if(self.selectBlock)
        self.selectBlock(@(btn.tag));
}
@end

@implementation CellItemView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.tag = 1;
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-11);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = HEXCOLOR(0x666666);
        label.tag = 2;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(24);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_X(220, 220, 220);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(@0.5);
        }];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_X(220, 220, 220);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];

        
//        UIView *lineView = [[UIView alloc] init];
//        lineView.backgroundColor = COLOR_X(220, 220, 220);
//        [self addSubview:lineView];
//        self.lineView = lineView;
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.bottom.right.equalTo(self);
//            make.right.equalTo(self);
//            make.width.equalTo(@0.5);
//            make.top.equalTo(self).offset(25);
//            make.bottom.equalTo(self).offset(-25);
//        }];
        
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btn];
        self.btn.backgroundColor = [UIColor clearColor];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)setIcon:(NSString *)icon{
    UIImageView *imageView = [self viewWithTag:1];
    imageView.image = [UIImage imageNamed:icon];
}

-(void)setTitle:(NSString *)title{
    UILabel *label = [self viewWithTag:2];
    label.text = title;
}

@end


@interface AgentCenterViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *menuArray;
@property(nonatomic,strong)CellItemView *item1;
@end

@implementation AgentCenterViewController
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.navigationController setNavigationBarHidden:true animated:NO];
////    self.navigationController.navigationBar.translucent = NO;
////    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//
//}

-(void)requestDatas{
    [[NetRequestManager sharedInstance] requestAgentDatas:^(id object) {
        NSDictionary* dic = object[@"data"];
//        NSString* amout= STR_TO_AmountFloatSTR(self.moneyDic[@"first"]);
        NSArray* aTypes = @[@{NSLocalizedString(@"今天注册人数", nil):@{[NSString stringWithFormat:@"%@",dic[@"todayRegisterCount"]]:[NSString stringWithFormat:@"/%@",dic[@"allSubordinate"]]}},
                            @{NSLocalizedString(@"今天充值总额", nil):@{@"￥":STR_TO_AmountFloatSTR(dic[@"todayRechargeMoney"])}},
                            @{NSLocalizedString(@"今天佣金分成", nil):@{@"￥":STR_TO_AmountFloatSTR(dic[@"todayCommission"])}}];
        AgentTypeView *typeView = [[AgentTypeView alloc] initWithFrame:CGRectMake(0, 0, self.iv.frame.size.width, 70) buttonArray:aTypes];
        [self.iv addSubview:typeView];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:false animated:NO];
////    self.navigationController.navigationBar.translucent = NO;
////    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forBarMetrics:UIBarMetricsDefault];
//}

-(void)feedback {
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"联系客服", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:false];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"代理中心", nil);
    self.menuArray = [NSMutableArray array];
    NSDictionary *dic = nil;
    dic = @{@"icon":@"agent_sqdl",@"title":[AppModel shareInstance].userInfo.agentFlag?NSLocalizedString(@"您已是代理", nil):NSLocalizedString(@"申请代理", nil),@"tag":@"1"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_fxzq",@"title":NSLocalizedString(@"分享赚钱", nil),@"tag":@"6"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_dlgz",@"title":NSLocalizedString(@"代理规则", nil),@"tag":@"2"};
    [self.menuArray addObject:dic];
    
    dic = @{@"icon":@"agent_tgjc",@"title":NSLocalizedString(@"推广教程", nil),@"tag":@"3"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_xjwj",@"title":NSLocalizedString(@"下级玩家", nil),@"tag":@"4"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"agent_wdbb",@"title":NSLocalizedString(@"我的报表", nil),@"tag":@"5"};
    [self.menuArray addObject:dic];
    
//    dic = @{@"icon":@"agent_gw",@"title":NSLocalizedString(@"保存下载官网", nil),@"tag":@"7"};
//    [self.menuArray addObject:dic];
//    dic = @{@"icon":@"agent_dz",@"title":NSLocalizedString(@"保存下载地址", nil),@"tag":@"8"};
//    [self.menuArray addObject:dic];
//    dic = @{@"icon":@"agent_wy",@"title":NSLocalizedString(@"保存下载网页", nil),@"tag":@"9"};
//    [self.menuArray addObject:dic];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
//    if (@available(iOS 11.0, *)) {
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
    UIView *headView = [self headView];
    [self.scrollView addSubview:headView];
    
    UIImageView* iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wavesIcon"]];
    iv.userInteractionEnabled = true;
    [self.scrollView addSubview:iv];
    self.iv = iv;
    [iv mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.left.equalTo(@10);
        make.top.equalTo(headView.mas_bottom).offset(5);
        make.height.equalTo(@148);
    }];

    
    
    [self.view layoutIfNeeded];
    
    [self requestDatas];
    
    // 代理推广链接
    NSString *url = [NSString stringWithFormat:@"%@?code=%@",[AppModel shareInstance].address,[AppModel shareInstance].userInfo.invitecode];
    NSArray* links = @[@{url:@"agent_link"}];
    AgentLinkView *lView = [[AgentLinkView alloc] initWithFrame:CGRectMake(0, 70, iv.frame.size.width, 70) buttonArray:links];
    lView.selectBlock = ^(id object) {
        if ([object integerValue]==71) {
            if (![FunctionManager isEmpty:url]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"复制成功", nil)];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = url;
            }
        }else{
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
    };
    [iv addSubview:lView];
    
    NSInteger hy = CGRectGetMaxY(iv.frame)+5;
    
    NSInteger perNum = 3;
    NSInteger width = (SCREEN_WIDTH-20)/perNum;
    NSInteger height = width * 0.6666;
    
    UIView* grid = [UIView new];
    grid.backgroundColor = [UIColor whiteColor];
    grid.frame = CGRectMake(10, hy, SCREEN_WIDTH-2*10, (self.menuArray.count/perNum+self.menuArray.count%perNum)*height);
    grid.userInteractionEnabled = true;
    [self.scrollView addSubview:grid];
    [self setBezierPath:grid cornersType:UIRectCornerAllCorners];
    
    for (NSInteger i = 0; i < self.menuArray.count; i ++) {
        NSInteger m = i%perNum;
        NSInteger n = i/perNum;
        CellItemView * item = [[CellItemView alloc] initWithFrame:CGRectMake(m * width, n * height, width, height)];
        [grid addSubview:item];
        NSDictionary *dic = self.menuArray[i];
        item.title = dic[@"title"];
        item.icon = dic[@"icon"];
        item.infoDic = self.menuArray[i];
        [item.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0)
            self.item1 = item;
        if (i == 2||i ==5) {
            item.lineView.hidden = true;
        }
    }
    
    if([AppModel shareInstance].userInfo.agentFlag == NO){
        [self performSelector:@selector(becomeAgent) withObject:nil afterDelay:0.5];
    }

    UIBarButtonItem *rightButtonItem = [self createBarButtonItemWithImage:ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE
                                                                   target:self
                                                                   action:@selector(feedback)
                                                               offsetType:CFCNavBarButtonOffsetTypeRight
                                                                imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
}

- (void)setBezierPath:(UIView*)view cornersType:(UIRectCorner)cornersType{
    [self.view layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:cornersType cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

-(void)becomeAgent{
//    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
//    WEAK_OBJ(weakSelf, self);
//    [view showWithText:NSLocalizedString(@"您还不是代理，是否申请代理？", nil) button1:NSLocalizedString(@"取消", nil)) button2:NSLocalizedString(@"提交", nil) callBack:^(id object) {
//        NSInteger index = [object integerValue];
//        if(index == 1){
//            [weakSelf toBeAgent];
//        }
//    }];
    __weak __typeof(self)weakSelf = self;
    AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
    [popupView showInApplicationKeyWindow];
    [popupView richElementsInViewWithModel:NSLocalizedString(@"您还不是代理，是否申请代理？", nil)];
    [popupView actionBlock:^(id data) {
        [weakSelf toBeAgent];
    }];
}

-(void)btnAction:(UIButton *)btn
{
    CellItemView *item = (CellItemView *)btn.superview;
    NSDictionary *dic = item.infoDic;
    NSInteger tag = [[dic objectForKey:@"tag"] integerValue];
    if(tag == 1){
        if([AppModel shareInstance].userInfo.agentFlag){
//            SVP_SUCCESS_STATUS(NSLocalizedString(@"您已经是代理", nil));
            AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
            [view showWithText:NSLocalizedString(@"您已经是代理", nil) button:NSLocalizedString(@"好的", nil) callBack:nil];
            return;
        }
//        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
//        WEAK_OBJ(weakSelf, self);
//        [view showWithText:NSLocalizedString(@"是否提交申请？", nil) button1:NSLocalizedString(@"取消", nil)) button2:NSLocalizedString(@"提交", nil) callBack:^(id object) {
//            NSInteger index = [object integerValue];
//            if(index == 1){
//                [weakSelf toBeAgent];
//            }
//        }];
        __weak __typeof(self)weakSelf = self;
        AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
        [popupView showInApplicationKeyWindow];
        [popupView richElementsInViewWithModel:NSLocalizedString(@"是否提交申请？", nil)];
        [popupView actionBlock:^(id data) {
            [weakSelf toBeAgent];
        }];
    }else if(tag == 2){
        BecomeAgentViewController *vc = [[BecomeAgentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.hiddenNavBar = YES;
        vc.imageUrl = [AppModel shareInstance].commonInfo[@"agent_rule"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 4){
        PUSH_C(self, RecommendedViewController, YES);
    }else if(tag == 5){
        ReportFormsViewController *vc = [[ReportFormsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userId = [AppModel shareInstance].userInfo.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 6){
        PUSH_C(self, ShareDetailViewController, YES);
    }else if(tag == 7 || tag == 8 || tag == 9){
        NSString *url = [NSString stringWithFormat:@"%@?code=%@",[AppModel shareInstance].address, [AppModel shareInstance].userInfo.invitecode];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else if(tag == 3){
        CopyViewController *vc = [[CopyViewController alloc] init];
        vc.title = dic[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)toBeAgent{
    __weak __typeof(self)weakSelf = self;
    [[NetRequestManager sharedInstance] askForToBeAgentWithSuccess:^(id object) {
        NSString* str = [object objectForKey:@"alterMsg"];
        if (![FunctionManager isEmpty:str]) {
//            AlertTipPopUpView* popupView = [[AlertTipPopUpView alloc]init];
//            [popupView showInApplicationKeyWindow];
//            [popupView richElementsInViewWithModel:str actionBlock:^(id data) {
//
//            }];
            AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
            [popupView showInApplicationKeyWindow];
            [popupView richElementsInViewWithModel:str];
            [popupView actionBlock:^(id data) {
            
            }];
        }
        
        [weakSelf requestUserinfo];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestUserinfo{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
        if([AppModel shareInstance].userInfo.agentFlag)
            weakSelf.item1.title = NSLocalizedString(@"您已是代理", nil);
    } fail:^(id object) {
        
    }];
}
-(UIView *)headView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    view.backgroundColor = BaseColor;
    
    float rate = 980/320.0;
    NSInteger height = (SCREEN_WIDTH - 30)/rate + 30;
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    containView.backgroundColor = [UIColor whiteColor];
    [view addSubview:containView];
    
    CGRect rect = view.frame;
    rect.size.height = height;
    view.frame = rect;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"agentBanner"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [containView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(containView).offset(15);
        make.right.bottom.equalTo(containView).offset(-15);
    }];
    return view;
}
@end
