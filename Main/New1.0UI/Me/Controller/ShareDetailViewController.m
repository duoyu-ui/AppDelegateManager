//
//  ShareDetailViewController.m
//  Project
//
//  Created by fy on 2019/1/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ShareDetailViewController.h"
#import "FYShareDataImageView.h"
#import "FYShareDetailModel.h"


@interface ShareDetailViewController ()

@property (nonatomic, strong) FYShareDataImageView *shareDataView;

@property (nonatomic, strong) FYShareDetailModel *model;

@end

@implementation ShareDetailViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    [self setupSubview];
}

- (void)setupSubview {
    self.view.backgroundColor = COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.view addSubview:self.shareDataView];
    CGFloat kSafeHeight = Height_Bar;
    [self.shareDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(kSafeHeight);
    }];
    
    CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadShoreData)];
    [refreshHeader setTitle:CFCRefreshAutoHeaderIdleText forState:MJRefreshStateIdle];
    [refreshHeader setTitle:CFCRefreshAutoHeaderPullingText forState:MJRefreshStatePulling];
    [refreshHeader setTitle:CFCRefreshAutoHeaderRefreshingText forState:MJRefreshStateRefreshing];
    [refreshHeader.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoHeaderColor)];
    [refreshHeader.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
    [refreshHeader setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    [self.shareDataView setMj_header:refreshHeader];
    [self.shareDataView.mj_header beginRefreshing];
}

- (void)setupNav
{
    UIBarButtonItem *rightButtonItem = [self createBarButtonItemWithImage:@"fenxiang"
                                                                   target:self
                                                                   action:@selector(shoreClick)
                                                               offsetType:CFCNavBarButtonOffsetTypeRight
                                                                imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE*0.8f];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
}

#pragma mark - Request

- (void)loadShoreData {
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestShareListWithSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        [self.shareDataView.mj_header endRefreshing];
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = [response mj_JSONObject];
            NSMutableArray <FYShareDetailModel*>*lists = [FYShareDetailModel mj_objectArrayWithKeyValuesArray:object[@"data"][@"records"]];
            if (lists.count) {
                FYShareDetailModel *shoreModel = lists.firstObject;
                self.shareDataView.model = shoreModel;
                self.model = shoreModel;
                self.title = shoreModel.title;
            }
        }
        
    } fail:^(id object) {
        PROGRESS_HUD_DISMISS
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

/// 截图
- (UIImage *)screenShotView:(FYShareDataImageView *)scrollView {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.shareImageView.size, NO, [UIScreen mainScreen].scale);
    [scrollView.shareImageView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Action

/// 复制
- (void)copyCodeClick {
    if (![FunctionManager isEmpty:[AppModel shareInstance].userInfo.invitecode]) {
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = [AppModel shareInstance].userInfo.invitecode;
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"复制成功", nil)];
    }
}

/// 分享
- (void)shoreClick {
    if (self.model.firstAvatar == nil) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍微等下,图片还未加载完成", nil)];
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"分享图片", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *image = [self screenShotView:self.shareDataView];
        [self activity:@[image]];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"分享链接", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self activity:@[[NSString stringWithFormat:@"%@%@",self.model.url,[AppModel shareInstance].userInfo.invitecode]]];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Getters

- (void)activity:(NSArray *)items {
    UIActivityViewController *act = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    act.excludedActivityTypes = @[UIActivityTypeMail,
                                  UIActivityTypePostToTwitter,
                                  UIActivityTypeMessage,
                                  UIActivityTypePrint,
                                  UIActivityTypeCopyToPasteboard,
                                  UIActivityTypeAssignToContact,
                                  UIActivityTypeAddToReadingList,
                                  UIActivityTypePostToFlickr,
                                  UIActivityTypePostToVimeo,
                                  UIActivityTypePostToTencentWeibo,
                                  UIActivityTypeAirDrop,
                                  UIActivityTypeOpenInIBooks];

    [self presentViewController:act animated:YES completion:nil];
}

- (FYShareDataImageView *)shareDataView {
    
    if (!_shareDataView) {
        _shareDataView = [[FYShareDataImageView alloc]init];
        [_shareDataView.copyBtn addTarget:self action:@selector(copyCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareDataView;
}

@end
