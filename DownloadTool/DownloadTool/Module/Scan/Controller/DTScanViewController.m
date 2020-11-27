//
//  DTScanViewController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DTCommonHelper.h"
#import <Photos/Photos.h>

@interface DTScanViewController () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) AVCaptureDevice *scanDevice;              //设
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;        //设备输入
@property (nonatomic, strong) AVCaptureMetadataOutput *dataOutput;      //数据输出
@property (nonatomic, strong) AVCaptureSession *session;                //捕获会话任务
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer; //相机图像层
@property (nonatomic, strong) UIImagePickerController *imagePicker;     //相册
@property (nonatomic, strong) UIView *maskView;                         //灰色背景
@property (nonatomic, strong) UIView *minddleView;                      //中间框
@property (nonatomic, strong) UIView *scanLine;                         //扫描横线
@property (nonatomic, strong) UIButton *photoButton;                    //相册

@end

@implementation DTScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupScanViewUI];
    [self startScanSession];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setupScanViewUI{
    [self.view.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.minddleView];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(LL_SafeAreaTopStatusBar + 10);
        make.width.height.mas_equalTo(25);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.closeButton.mas_left);
        make.centerY.equalTo(self.closeButton);
    }];
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.minddleView.mas_bottom).offset(20);
        make.width.height.mas_equalTo(40);
    }];
}

- (void)dealloc{
    [self stopScanSession];
}

#pragma mark - Session
- (void)startScanSession{
    [self.session startRunning];
    [self addScanLineAnimation];
}
- (void)stopScanSession{
    [self.session stopRunning];
    [self removeScanLineAnimation];
}

#pragma mark - Animation
- (void)addScanLineAnimation{
    self.scanLine.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @(-50);
    animation.toValue = @([self getScanRect].size.height - 50);
    animation.duration = 3;
    animation.repeatCount = OPEN_MAX;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.scanLine.layer addAnimation:animation forKey:@"scanLineAnimationName"];
}

- (void)removeScanLineAnimation{
    [self.scanLine.layer removeAnimationForKey:@"scanLineAnimationName"];
    self.scanLine.hidden = YES;
}

#pragma mark - CLick
- (void)clickCloseButton{
    [self.navigationController popViewControllerAnimated:YES];
}

//打开相册
- (void)clickPhotoButton{
    if (![self isLibaryAuthStatusCorrect]) {
        [self showPermissionAlert];
        return;
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate 捕获
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count == 0) {
        return;
    }
    [self stopScanSession];
    NSString *result = [metadataObjects.firstObject stringValue];
    //信息处理
    NSLog(@"result ==> %@", result);
    
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(pickUpMessage:)]) {
        [self.delegate pickUpMessage:result];
    }
}


#pragma mark - UIImagePickerControllerDelegate 相册
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSString *result = [DTCommonHelper messageFromQRCodeImage:image];
    //信息处理
    NSLog(@"result ==> %@", result);
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(pickUpMessage:)]) {
        [self.delegate pickUpMessage:result];
    }
}



#pragma mark - Helper
//相机是否存在，比如早期iPad，模拟器，itouch
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
//前置摄像头是否正常
- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
//后置摄像头是否正常
- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
//相机权限是否正常
- (BOOL)isCameraAuthStatusCorrect{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}
//相册权限是否正常，需要导入Photos框架
- (BOOL)isLibaryAuthStatusCorrect{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined || authStatus == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}


#pragma mark - Check
- (BOOL)statusCheck{
    if (![self isCameraAvailable]){
        [self showWarn:@"设备无相机" shouldPop:YES];
        return NO;
    }
    
    if (![self isRearCameraAvailable] && ![self isFrontCameraAvailable]) {
        [self showWarn:@"设备相机错误" shouldPop:YES];
        return NO;
    }
    
    if (![self isCameraAuthStatusCorrect]) {
        [self showPermissionAlert];
        return NO;
    }
    
    return YES;
}

#pragma mark - Alert
- (void)showPermissionAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"需要相机/相册的权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *requestAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:requestAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showWarn:(NSString *)message shouldPop:(BOOL)pop{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if (!pop) {
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}









#pragma mark - Lazy
- (UILabel *)textTitleLabel{
    if (!_textTitleLabel) {
        _textTitleLabel = [[UILabel alloc] init];
        _textTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _textTitleLabel.textColor = [UIColor whiteColor];
        _textTitleLabel.text = @"扫一扫";
        _textTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"scan_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
    }
    return _closeButton;
}

- (AVCaptureDevice *)scanDevice{
    if (!_scanDevice) {
        _scanDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _scanDevice;
}

//设备输入
- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        NSError *error;
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.scanDevice error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    return _deviceInput;
}

//数据输出
- (AVCaptureMetadataOutput *)dataOutput{
    if (!_dataOutput) {
        _dataOutput = [[AVCaptureMetadataOutput alloc]init];
        [_dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        /*
           扫描区域
            1.他的结构体4个值的范围都为0~1，也就是按照实际需要的x/相机画面宽度，y/相机画面高度，width/相机画面宽度，height/相机画面高度去赋值
            2.他默认是横屏的，也就是结构体数值和平常用的Rect是xy相反的
         */
        _dataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1);
    }
    return _dataOutput;
}

//捕获会话任务
- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:(SCREEN_HEIGHT < 500) ? AVCaptureSessionPreset640x480 : AVCaptureSessionPreset1920x1080];
        
        //输入
        if ([_session canAddInput:self.deviceInput]) {
            [_session addInput:self.deviceInput];
        }
        
        //输出
        if ([_session canAddOutput:self.dataOutput]){
            [_session addOutput:self.dataOutput];
            self.dataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        }
    }
    return _session;
}

//相机图像层
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.bounds;
    }
    return _previewLayer;
}

//相册
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imagePicker;
}

- (CGRect)getScanRect{
    return CGRectMake((SCREEN_WIDTH-200)/2, (SCREEN_HEIGHT-200)/2, 200, 200);
}

//遮罩
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        _maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        UIBezierPath *fullBezierPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
        UIBezierPath *scanBezierPath = [UIBezierPath bezierPathWithRect:[self getScanRect]];
        
        [fullBezierPath appendPath:[scanBezierPath  bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = fullBezierPath.CGPath;
        _maskView.layer.mask = shapeLayer;
    }
    return _maskView;
}

//框
- (UIView *)minddleView{
    if (!_minddleView) {
        _minddleView = [[UIView alloc] initWithFrame:[self getScanRect]];
        _minddleView.clipsToBounds = YES;
        _minddleView.layer.borderColor = kZIColor.CGColor;
        _minddleView.layer.borderWidth = 1;
    }
    return _minddleView;
}

//横线
- (UIView *)scanLine{
    if (!_scanLine) {
        _scanLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getScanRect].size.width, 50)];
        _scanLine.hidden = YES;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5, 1);
        gradient.frame = _scanLine.layer.bounds;
        
        gradient.colors = @[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor,
                            (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor,
                            (__bridge id)[UIColor whiteColor].CGColor];
        gradient.locations = @[@0,@0.96,@0.97];
        [_scanLine.layer addSublayer:gradient];
        [self.minddleView addSubview:_scanLine];
    }
    return _scanLine;
}

//相册
- (UIButton *)photoButton{
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setImage:[UIImage imageNamed:@"scan_pict"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(clickPhotoButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_photoButton];
    }
    return _photoButton;
}


@end
