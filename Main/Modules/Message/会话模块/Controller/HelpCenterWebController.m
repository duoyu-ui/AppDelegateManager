//
//  HelpCenterWebController.m
//  Project
//
//  Created by Mike on 2019/3/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "HelpCenterWebController.h"

@interface HelpCenterWebController ()

@property(nonatomic,strong)NSMutableArray *guideArray;

@end

@implementation HelpCenterWebController

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    
    NSString *addressURL = [NSString stringWithFormat:@"%@dist/#/index/helpCenter?accesstoken=%@&tenant=%@", [AppModel shareInstance].address, [AppModel shareInstance].userInfo.token,kNewTenant];
    self.url = addressURL;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"新手教程", nil);
    self.isForceEscapeWebVC = YES;
    UIButton *regisBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    regisBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [regisBtn setTitle:NSLocalizedString(@"玩法规则", nil) forState:UIControlStateNormal];
    [regisBtn addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    [regisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:regisBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 玩法规则
 */
- (void)guideAction {
    
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
    vc.navigationItem.title = NSLocalizedString(@"玩法规则", nil);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 新手引导
 */
- (void)showGuide {
    if(self.guideArray.count == 0){
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    self.webView.userInteractionEnabled = NO;
    GuideView *guideView = [[GuideView alloc] initWithArray:self.guideArray target:self selector:@selector(funa)];
    [guideView showWithAnimationWithAni:YES];
    [self.webView reload];
}

- (void)funa {
    
    self.webView.userInteractionEnabled = YES;
}
@end
