//
//  FYVideoPlayController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYVideoPlayController.h"
#import <Photos/PHPhotoLibrary.h>
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/UIView+ZFFrame.h>
#import "AppDelegate.h"
#import "FYVideoTool.h"
// iphoneX iphoneXs iphoneXS MAX 宏定义
#define ISIPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)
/// 导航栏高度
#define KNavBarHeight ISIPHONE_X ? 88 : 64
#define kAPPDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define tabbarH ([UIApplication sharedApplication].statusBarFrame.size.height == 20 ? 0:34)
@interface FYVideoPlayController ()<NSURLSessionDelegate>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic,strong) NSURLSession *session;
@property(nonatomic,strong) NSURLSessionDownloadTask *downTask;
@property (nonatomic , strong) UIView *downloadView;
@property (nonatomic , strong) UIView *downloadBGView;
@property (nonatomic , strong) UIView *downloadContentView;
@property (nonatomic , strong) UIButton *downloadCancelBtn;
@property (nonatomic , strong) UIView *progressView;
@property (nonatomic , strong) MBProgressHUD *hudView;
@end

@implementation FYVideoPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self setPlayContainer];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_back2"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(backClicke)];
    self.navigationItem.leftBarButtonItem = item;
    UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_more_square_black"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(download)];
     self.navigationItem.rightBarButtonItem = downloadItem;

}
//下载
- (void)download{
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"下载至相册", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alerVc addAction:[ UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MJWeakSelf
        [self setDownloadSubviewAnimations:^{
            [weakSelf downloadFileWithUrl:[NSURL URLWithString:weakSelf.message.videoRemotePath]];
        }];
    }]];
    [alerVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alerVc animated:YES completion:nil];
}
- (void)setDownloadSubviewAnimations:(void (^)(void))animations{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.downloadView];
    self.downloadView.frame = window.bounds;
    [self.downloadView addSubview:self.downloadBGView];
    [self.downloadView addSubview:self.downloadContentView];
    [self.downloadContentView addSubview:self.downloadCancelBtn];
    [self.downloadContentView addSubview:self.progressView];
    self.downloadBGView.frame = self.downloadView.bounds;
    self.downloadContentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,   200 + tabbarH);
    [self.downloadCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downloadContentView);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-(10 + tabbarH));
        make.height.mas_equalTo(45);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.centerX.equalTo(self.downloadContentView);
        make.bottom.equalTo(self.downloadCancelBtn.mas_top).offset(-10);
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.progressView animated:YES];
    hud.backgroundColor = UIColor.clearColor;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    self.hudView = hud;
    [UIView animateWithDuration:0.3 animations:^{
        self.downloadContentView.frame = CGRectMake(0, SCREEN_HEIGHT - (  200 + tabbarH), SCREEN_WIDTH,   200 + tabbarH);
    } completion:^(BOOL finished) {
        animations();
    }];
    
}
///取消下载
- (void)downloadCance{
    [self downloadViewDismiss];
    [self.downTask cancel];
}
- (void)downloadViewDismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.downloadContentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200+ tabbarH);
    } completion:^(BOOL finished) {
        [self.downloadView removeFromSuperview];
    }];
}
///通过url下载
- (void)downloadFileWithUrl:(NSURL *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:1.0 timeoutInterval:5.0];
    ///下载任务
    [[self.session downloadTaskWithRequest:request]resume];
    self.downTask = [_session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (location != nil && error == nil) {
            NSFileManager *fileManger = [NSFileManager defaultManager];
            ///沙盒Documents路径
            NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            //拼接文件绝对路径
            NSString *path = [documents stringByAppendingPathComponent:response.suggestedFilename];
            //视频存放到这个位置
            [fileManger moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
            ///保存到相册
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }];
    ///开始下载任务
    [self.downTask resume];
    
    
}
//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"保存到相册成功", nil)];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"下载失败", nil)];
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


// 进度数据
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
       self.hudView.progress = progress;
        if (progress == 1) {
            [self.hudView hideAnimated:YES];
            [self downloadViewDismiss];
        }
    });
}
- (void)backClicke{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setPlayContainer{
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:self.message.videoRemotePath]];
    self.containerView.image = [FYVideoTool getImageWithAsset:asset];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-tabbarH);
    }];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    self.player.assetURL = [NSURL URLWithString:self.message.videoRemotePath];
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    self.player.resumePlayRecord = YES;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        kAPPDelegate.allowOrentitaionRotation = isFullScreen;
        [self setNeedsStatusBarAppearanceUpdate];
        if (!isFullScreen) {
            /// 解决导航栏上移问题
            self.navigationController.navigationBar.zf_height = KNavBarHeight;
        }
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (!self.player.isLastAssetURL) {
            [self.player playTheNext];
        } else {
            [self.player stop];
        }
    };
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape && [self.topViewController class] == self) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}
///最顶层的控制器
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}
- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
    }
    return _containerView;
}
///初始化session
- (NSURLSession *)session{
    if(!_session){
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}
- (UIView *)downloadView{
    if (!_downloadView) {
        _downloadView = [[UIView alloc]init];
    }
    return _downloadView;
}
- (UIView *)downloadBGView{
    if (!_downloadBGView) {
        _downloadBGView = [[UIView alloc]init];
        _downloadBGView.backgroundColor = UIColor.blackColor;
        _downloadBGView.alpha = 0.3;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadViewDismiss)];
       [_downloadBGView addGestureRecognizer:tap];
    }
    return _downloadBGView;
}
- (UIView *)downloadContentView{
    if (!_downloadContentView) {
        _downloadContentView = [[UIView alloc]init];
    }
    return _downloadContentView;
}
- (UIButton *)downloadCancelBtn{
    if (!_downloadCancelBtn) {
        _downloadCancelBtn = [[UIButton alloc]init];
        [_downloadCancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_downloadCancelBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _downloadCancelBtn.backgroundColor = UIColor.whiteColor;
        _downloadCancelBtn.layer.cornerRadius = 8;
        _downloadCancelBtn.layer.masksToBounds = YES;
        [_downloadCancelBtn addTarget:self action:@selector(downloadCance) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadCancelBtn;
}
- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.backgroundColor = UIColor.whiteColor;
        _progressView.layer.cornerRadius = 8;
        _progressView.layer.masksToBounds = YES;
    }
    return _progressView;;
}

@end
