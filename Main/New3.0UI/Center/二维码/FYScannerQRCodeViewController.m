//
//  FYScannerQRCodeViewController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScannerQRCodeViewController+Transfer.h"
#import "FYScannerQRCodeViewController+Friend.h"
#import "FYScannerQRCodeViewController.h"
#import "FYUserQRCodeViewController.h"
#import "FYMobileContactInformation.h"
#import <AVFoundation/AVFoundation.h>


@interface FYScannerQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSString *scannerString;
@property (nonatomic, strong) UIView *bottomView;
//icon_qr_picture
//icon_qr_scan
@property (nonatomic,strong) UIButton *buttonMyQRCode;
@property (nonatomic,strong) UIButton *buttonPicture;
@property (nonatomic, strong) UILabel *labelQRCodeName;
@property (nonatomic, strong) UILabel *labelBottomName;
@property (nonatomic, strong) UIView *qrCodeView;

@property (nonatomic,strong) AVCaptureSession *captureSession;//捕捉会话

@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;//输入流

@property (nonatomic,strong) AVCaptureMetadataOutput *metaDataOutput;//输出流

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;//预览涂层

@property (nonatomic, assign) FYQRCodeType type;

@end

@implementation FYScannerQRCodeViewController

#pragma mark - Actions

- (void)pressButtonCloseAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        FYUserQRCodeViewController *subView=[FYUserQRCodeViewController new];
        [self.navigationController pushViewController:subView animated:YES];
    } else if (sender.tag == 2) {
        UIImagePickerController *imagePicker=[UIImagePickerController new];
        imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersNavigationBarHidden
{
    return YES;
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = FYQRCodeTypeDefault;
    }
    return self;
}

- (instancetype)initWithType:(FYQRCodeType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *backgroundColor = [UIColor colorWithWhite:0.12 alpha:1];
    [self.view setBackgroundColor:backgroundColor];
    
    UIView *topStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    [topStatusView setBackgroundColor:backgroundColor];
    [self.view addSubview:topStatusView];
    
    CGFloat imageSize = 50;
    UIImage *btnImage = [[UIImage imageNamed:@"icon_qr_close"] imageByScalingProportionallyToSize:CGSizeMake(imageSize, imageSize)];
    UIButton *buttonClose = [UIButton new];
    [buttonClose setImage:btnImage forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(pressButtonCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonClose];
    [buttonClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        make.top.equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
    }];

    [self bottomView];
    
    [self.buttonMyQRCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonPicture addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.labelBottomName.text=NSLocalizedString(@"扫码", nil);
    self.labelQRCodeName.text=NSLocalizedString(@"扫二维码", nil);
    
    [self qrCodeView];
    [self.qrCodeView.layer addSublayer:self.videoPreviewLayer];
    
#if TARGET_IPHONE_SIMULATOR
    ALTER_INFO_MESSAGE(NSLocalizedString(@"模拟器不能使用扫码功能", nil))
#elif TARGET_OS_IPHONE
    [self startCapture];
#endif
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (image) {
        NSLog(NSLocalizedString(@"拿到了图片", nil));
        CIDetector *detector=[CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count == 0) {
            return;
        }
        CIQRCodeFeature *firstResult=[features firstObject];
        NSLog(@"%@",firstResult.messageString);
        [self QRStringResult:firstResult.messageString];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //获取到扫描的数据
    AVMetadataMachineReadableCodeObject *dateObject = (AVMetadataMachineReadableCodeObject *) [metadataObjects lastObject];
    NSLog(@"metadataObjects[last]==%@",dateObject.stringValue);
    NSString *tempScan=dateObject.stringValue;
    [self QRStringResult:tempScan];
}
#pragma makr - 请求权限
- (BOOL)requestDeviceAuthorization{
    
    AVAuthorizationStatus deviceStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted ||
        deviceStatus ==AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

-(void)QRStringResult:(NSString *)qrString{
    if ([qrString rangeOfString:@"code="].location != NSNotFound) {
        self.scannerString = qrString;
        [self stopCapture];
        [self scannerQRCodeResult];
    }
}
//开始扫描
- (void)startCapture{
    if (![self requestDeviceAuthorization]) {
        NSLog(NSLocalizedString(@"没有访问相机权限！", nil));
        return;
    }
    //这也可以判断相机权限
    /*
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? NSLocalizedString(@"相机准许", nil):NSLocalizedString(@"相机不准许", nil));
        if (granted) {

        }else{
           
        }
    }];
    */
    [self.captureSession beginConfiguration];
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    // 设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    if ([self.captureSession canAddOutput:self.metaDataOutput]) {
        [self.captureSession addOutput:self.metaDataOutput];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSArray *types = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code];
        self.metaDataOutput.metadataObjectTypes =types;
//        NSArray *metadatTypes =  [_metaDataOutput availableMetadataObjectTypes];
//        NSLog(@"metadatTypes == %@",metadatTypes);
    }
    [self.captureSession commitConfiguration];
    
    [self.captureSession startRunning];
}
//停止扫描
- (void)stopCapture{
    [self.captureSession stopRunning];
}
- (void)dealloc{
    [self.captureSession stopRunning];
    self.deviceInput = nil;
    self.metaDataOutput = nil;
    self.captureSession = nil;
    self.videoPreviewLayer = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIButton *)buttonPicture{
    if (!_buttonPicture) {
        _buttonPicture=[UIButton new];
        _buttonPicture.tag = 2;
        [_buttonPicture setImage:[UIImage imageNamed:@"icon_qr_picture"] forState:UIControlStateNormal];
        [self.view addSubview:_buttonPicture];
        [_buttonPicture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(-20);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
    }
    return _buttonPicture;
}

-(UIButton *)buttonMyQRCode{
    if (!_buttonMyQRCode) {
        _buttonMyQRCode=[UIButton new];
        _buttonMyQRCode.tag = 1;
        [_buttonMyQRCode setImage:[UIImage imageNamed:@"icon_qr_scan"] forState:UIControlStateNormal];
        [self.view addSubview:_buttonMyQRCode];
        [_buttonMyQRCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(-20);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
    }
    return _buttonMyQRCode;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[UIView new];
        _bottomView.backgroundColor =[UIColor blackColor];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.view);
            make.height.mas_equalTo(TAB_BAR_AND_DANGER_HEIGHT);
        }];
    }
    return _bottomView;
}

-(UILabel *)labelQRCodeName{
    if (!_labelQRCodeName) {
        _labelQRCodeName=[UILabel new];
        _labelQRCodeName.font = [UIFont systemFontOfSize:16];
        _labelQRCodeName.textColor = [UIColor lightGrayColor];
        [self.view addSubview:_labelQRCodeName];
        [_labelQRCodeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(self.buttonMyQRCode.mas_top).mas_offset(-20);
        }];
    }
    return _labelQRCodeName;
}

-(UILabel *)labelBottomName{
    if (!_labelBottomName) {
        _labelBottomName=[UILabel new];
        _labelBottomName.font = [UIFont boldSystemFontOfSize:16];
        _labelBottomName.textColor = [UIColor whiteColor];
        [self.bottomView addSubview:_labelBottomName];
        [_labelBottomName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _labelBottomName;
}

-(UIView *)qrCodeView{
    if (!_qrCodeView) {
        _qrCodeView=[UIView new];
        [self.view addSubview:_qrCodeView];
        [_qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
            make.bottom.mas_equalTo(self.labelQRCodeName.mas_top).mas_offset(-50);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _qrCodeView;
}

#pragma mark Scanner Code

- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _captureSession;
}
- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error) {
            return nil;
        }
    }
    return _deviceInput;
}
- (AVCaptureMetadataOutput *)metaDataOutput{
    if (!_metaDataOutput) {
        _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metaDataOutput setMetadataObjectsDelegate:self queue:        dispatch_get_main_queue()];
 
    }
    return _metaDataOutput;
}
- (AVCaptureVideoPreviewLayer *)videoPreviewLayer{
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPreviewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    }
    return _videoPreviewLayer;
}

-(void)scannerQRCodeResult{
    NSRange range=[self.scannerString rangeOfString:@"?code="];
    if (range.location != NSNotFound) {
        NSString *codeString=[self.scannerString substringFromIndex:range.location + range.length];
        [self HTTPGetUserIDWithCode:codeString];
    }
}

- (void)HTTPGetUserIDWithCode:(NSString *)codeString
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    NSDictionary *parameters = @{ @"invitecode":codeString };
    [NET_REQUEST_MANAGER requestWithAct:ActRequestScannerQRCodeGetUserInfo parameters:parameters success:^(id object) {
        PROGRESS_HUD_DISMISS
        FYLog(@"QRCode UserInfo:%@", object);
        NSDictionary *dict = [object valueForKey:@"data"];
        if (dict) {
            NSString *nick = [dict valueForKey:@"nick"];
            NSString *userID = [dict valueForKey:@"userId"];
            NSString *avatar = [dict valueForKey:@"avatar"];
            FYContactSimpleModel *tempUser=[FYContactSimpleModel new];
            tempUser.nick = nick;
            tempUser.avatar = avatar;
            tempUser.userId = userID;
            [weakSelf doQRCodeResult:tempUser];
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}

- (void)doQRCodeResult:(FYContactSimpleModel *)contactSimpleModel
{
    if (FYQRCodeTypeDefault == self.type) {
        return [self doQRCodeResultForDefault:contactSimpleModel];
    } else if (FYQRCodeTypeAddFriends == self.type) {
        return [self doQRCodeResultForAddFriends:contactSimpleModel];
    } else if (FYQRCodeTypeTransferMoney == self.type) {
        return [self doQRCodeResultForAddFriendsToTransferMoney:contactSimpleModel];
        // return [self doQRCodeResultForTransferMoney:contactSimpleModel];
    } else if (FYQRCodeTypeAddFriendsTransferMoney == self.type){
        return [self doQRCodeResultForAddFriendsToTransferMoney:contactSimpleModel];
    }
    
    return [self doQRCodeResultForDefault:contactSimpleModel];
}


- (void)doQRCodeResultForDefault:(FYContactSimpleModel *)contactSimpleModel
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
