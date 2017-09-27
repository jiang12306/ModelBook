//
//  UploadViewController.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/11.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UploadViewController.h"
#import "UploadButtonItem.h"
#import "Macros.h"
#import "ProfileViewController.h"
#import "PhotoPickerViewController.h"
#import "ResourceUploadModel.h"
#import "ProgressHUD.h"
#import "VideoHandler.h"
#import "YBStatusBarNotificationManager.h"
#import "UploadEditViewController.h"

#import "VPImageCropperViewController.h"

#import "RecordCameraViewController.h"
#import "UpYunFormUploader.h"
#import "Handler.h"

#import "UploadView.h"


#import <AVFoundation/AVFoundation.h>

// static NSString * const uploadResourceURL = @"http://39.108.152.114/model/album/upload";

static NSString * const uploadResourceURL = @"http://39.108.152.114/modeltest/album/upload/upyun";


#define uploadItemSpace (IS_IPHONE320?35:50)

#define ORIGINAL_MAX_WIDTH 640.0f

static CGFloat const bottomViewHeight = 70;
static CGFloat const uploadItemHeight = 70;
static CGFloat const uploadItemWidth = 70;
static CGFloat const uploadItemImgViewWidth = 60;
static CGFloat const uploadItemImgViewHeight = 60;

@interface UploadViewController ()<PhotoPickerViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UploadEditViewControllerDelegate, VPImageCropperDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

/* 顶部图片 */
@property(nonatomic, strong)UIImageView *imgView;
/* 底部视图 */
@property(nonatomic, strong)UIView *bottomView;
/* 标题数组 */
@property(nonatomic, strong)NSArray *titleArray;
/* 图片数组 */
@property(nonatomic, strong)NSArray<UIImage *> *imageArray;
/* 是否选择视频 */
@property(nonatomic, assign)BOOL isSelectedVideo;
/* 是否有一个已上传完毕 */
@property(nonatomic, assign)BOOL isUploadSuccess;

//MARK: 自定义相机
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

// 拍摄的照片
@property (nonatomic)UIImage *image;

// 拍照后取消按钮
@property (nonatomic, strong)UIButton *cancleBtn;
// 前后镜头切换按钮
@property (nonatomic, strong)UIButton *switchBtn;
// 拍照后确认按钮
@property (nonatomic, strong)UIButton *okBtn;
// 拍照后的图片
@property (nonatomic, strong)UIImageView * imageView;

//MARK: 获取相册
@property (strong, nonatomic) ALAssetsLibrary * assetsLibraryToUpload;

@end
static NSString *cellID = @"CellID";
@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"tabBar-titleC", nil);
    
    UploadView * view = [[UploadView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
//    [self.view addSubview:self.imgView];
//    // 自定义相机
//    [self customCamera];
//    [self customCameraUI];
//
//    [self.view addSubview:self.bottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - “相册、视频、直播”按钮点击action
- (void)buttonAction:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    switch (tag) {
        case 1:
        {
            //            ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]];
            //            profileVC.initialTabPage = InitialTabPageVideo;
            //            profileVC.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:profileVC animated:YES];
            
            UploadEditViewController *vc = [[UploadEditViewController alloc] init];
            vc.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            //            ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]];
            //            profileVC.initialTabPage = InitialTabPagePhoto;
            //            profileVC.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:profileVC animated:YES];
            RecordCameraViewController *vc = [RecordCameraViewController new];
            vc.inputRecordMode = lsqRecordModeKeep;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 自定义相机
- (void)customCamera{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, screenWidth, screenHeight-tabBarHeight-bottomViewHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

- (void)customCameraUI {
    // 左边取消
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBtn.frame = CGRectMake(60, screenHeight-tabBarHeight-bottomViewHeight-60, 60, 60);
    [self.cancleBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancleBtn];
    self.cancleBtn.hidden = YES; // 拍照时隐藏，拍照后显示
    // 右边切换
    self.switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchBtn.frame = CGRectMake(screenWidth-60-60, screenHeight-tabBarHeight-bottomViewHeight-60, 60, 60);
    [self.switchBtn setTitle:NSLocalizedString(@"switch", nil) forState:UIControlStateNormal];
    self.switchBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.switchBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.switchBtn addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchBtn];
    self.switchBtn.hidden = NO;// 拍照时显示，拍照后隐藏
    // 右边确认
    self.okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okBtn.frame = CGRectMake(screenWidth-60-60, screenHeight-tabBarHeight-bottomViewHeight-60, 60, 60);
    [self.okBtn setTitle:NSLocalizedString(@"upload", nil) forState:UIControlStateNormal];
    self.okBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.okBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.okBtn addTarget:self action:@selector(uploadCameraPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okBtn];
    self.okBtn.hidden = YES; // 拍照时隐藏，拍照后显示
    
    // 中间点击拍照
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-uploadItemImgViewWidth)/2, screenHeight-tabBarHeight-bottomViewHeight-uploadItemImgViewHeight-10, uploadItemImgViewWidth, uploadItemImgViewHeight)];
    imageView.image = [UIImage imageNamed:@"photograph_Select"];
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shutterCamera)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
}

- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        
        animation.duration = .5f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
//MARK: 截取照片
- (void) shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        
        // 显示拍照的图片
        self.imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.view insertSubview:_imageView belowSubview:self.cancleBtn];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = _image;
        
        // 按钮显示控制
        self.cancleBtn.hidden = NO;
        self.switchBtn.hidden = YES;
        self.okBtn.hidden = NO;
        
        [self.session stopRunning];
        
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
    }];
}
//MARK: 保存至相册并上传
- (void)uploadCameraPhoto {
    [self saveImageToPhotoAlbum:self.image];
}

- (void)saveImageToPhotoAlbum:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
    //                                                    message:msg
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"确定"
    //                                          otherButtonTitles:nil];
    //    [alert show];
    
    [self cancle];
    
    {
        //        UploadEditViewController *vc = [[UploadEditViewController alloc] init];
        //        vc.delegate = self;
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
        /** 遍历所有相册 */
        [self.assetsLibraryToUpload enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            NSMutableArray * medioArray = [NSMutableArray array];
            if (!group) return;
            /** 遍历每个相册中的ALAsset */
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                
                AssetModel *model = [[AssetModel alloc] init];
                model.resourceType = assetType;
                model.asset = result;
                model.thumbanilImage = [UIImage imageWithCGImage:result.thumbnail];
                [medioArray addObject:model];
            }];
            
            medioArray = (NSMutableArray *)[[medioArray reverseObjectEnumerator] allObjects];
            
            for (AssetModel *model in medioArray) {
                if (model.resourceType != nil) {
                    [self uploadPhoto:model];
                    break;
                }
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}
// 取消拍照的图片，并恢复镜头
-(void)cancle{
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    // 按钮显示控制
    self.cancleBtn.hidden = YES;
    self.switchBtn.hidden = NO;
    self.okBtn.hidden = YES;
}
//MARK: 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 10086;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 10086) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - 上传刚拍的照片
- (void)uploadPhoto:(AssetModel *)model {
    NSMutableArray *imageArray = [NSMutableArray array];
    
    UIImage *image = [UIImage imageWithCGImage:[model.asset.defaultRepresentation fullScreenImage]];
    if (image)
    {
        ResourceUploadModel *uploadModel = [[ResourceUploadModel alloc] init];
        uploadModel.image = image;
        uploadModel.fileName = model.asset.defaultRepresentation.filename;
        [imageArray addObject:uploadModel];
    }
    
    [self uploadResourceRequest:SelectResourceTypePhoto uploadData:imageArray];
}

#pragma mark - 上传（暂弃）
- (void)uploadAction:(UITapGestureRecognizer *)tap
{
    /*
     #if 1
     UploadEditViewController *vc = [[UploadEditViewController alloc] init];
     vc.delegate = self;
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
     [self.navigationController presentViewController:nav animated:YES completion:nil];
     
     
     WS(weakSelf);
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     }];
     UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose Upload Photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     weakSelf.isSelectedVideo = NO;
     //[weakSelf selectUploadResource:SelectResourceTypePhoto];
     }];
     UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose Upload video", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     weakSelf.isSelectedVideo = YES;
     //[weakSelf selectUploadResource:SelectResourceTypeVideo];
     }];
     [alert addAction:action1];
     [alert addAction:action2];
     [alert addAction:action3];
     [self presentViewController:alert animated:YES completion:nil];
     #else
     // 拍照  孙总方法
     if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
     UIImagePickerController *controller = [[UIImagePickerController alloc] init];
     controller.sourceType = UIImagePickerControllerSourceTypeCamera;
     if ([self isFrontCameraAvailable]) {
     controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
     }
     NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
     [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
     controller.mediaTypes = mediaTypes;
     controller.delegate = self;
     [self presentViewController:controller
     animated:YES
     completion:^(void){
     NSLog(@"Picker View Controller is presented");
     }];
     }
     #endif
     */
}

#pragma mark - UploadEditViewControllerDelegate
- (void)uploadResource:(NSMutableArray *)array isSelectedVideo:(BOOL)isSelectedVideo
{
    self.isUploadSuccess = NO;
    [ProgressHUD showText:NSLocalizedString(@"To upload", nil)];
    [[YBStatusBarNotificationManager shareManager] displayWithText:NSLocalizedString(@"Resources on the cross...", nil) Duration:60*30];
    NSMutableArray *imageArray = [NSMutableArray array];
    if (isSelectedVideo)
    {
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        for (int i = 0; i<array.count; i++)
        {
            AssetModel *model = array[i];
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                NSURL *videoURL =[model.asset valueForProperty:ALAssetPropertyAssetURL];
                AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
                [VideoHandler startExportVideoWithVideoAsset:videoAsset fileName:[NSString stringWithFormat:@"%d",i] completion:^(NSString *outputPath) {
                    if (outputPath.length>0)
                    {
                        NSArray *array = [outputPath componentsSeparatedByString:@"/"];
                        ResourceUploadModel *uploadModel = [[ResourceUploadModel alloc] init];
                        uploadModel.data = [NSData dataWithContentsOfFile:outputPath];
                        uploadModel.fileName = array.lastObject;
                        [imageArray addObject:uploadModel];
                    }
                    dispatch_group_leave(group);
                }];
            });
        }
        WS(weakSelf);
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [weakSelf uploadResourceRequest:SelectResourceTypeVideo uploadData:imageArray];
        });
    }
    else
    {
        for (AssetModel *model in array)
        {
            UIImage *image = [UIImage imageWithCGImage:[model.asset.defaultRepresentation fullScreenImage]];
            if (image)
            {
                ResourceUploadModel *uploadModel = [[ResourceUploadModel alloc] init];
                uploadModel.image = image;
                uploadModel.fileName = model.asset.defaultRepresentation.filename;
                [imageArray addObject:uploadModel];
            }
        }
        [self uploadResourceRequest:SelectResourceTypePhoto uploadData:imageArray];
    }
}

#pragma mark - network
- (void)uploadResourceRequest:(SelectResourceType)resourceType uploadData:(NSMutableArray<ResourceUploadModel *> *)uploadData
{
    if (uploadData.count == 0)
    {
        self.isUploadSuccess = YES;
        return;
    }
    __block NSInteger count = 0;
    __block NSString *picStr = @"";
    WS(weakSelf);
    for (ResourceUploadModel *model in uploadData) {
        UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
        NSData *data = nil;
        if (resourceType == SelectResourceTypePhoto)
        {
            data = [Handler imageCompress:model.image];
        }
        else if (resourceType == SelectResourceTypeVideo)
        {
            data = model.data;
        }
        [up uploadWithBucketName:@"modelbook1" operator:@"modelbook" password:@"m12345678" fileData:data fileName:nil saveKey:model.fileName otherParameters:nil success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
            NSString *urlStr = responseBody[@"url"];
            picStr = [NSString stringWithFormat:@"%@,%@",picStr, urlStr];
            count++;
            if (count == uploadData.count)
            {
                NSMutableDictionary *md = [NSMutableDictionary dictionary];
                [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
                [md setValue:[NSString stringWithFormat:@"%ld",(long)resourceType] forKey:@"fileType"];
                [md setValue:[picStr substringFromIndex:1] forKey:@"files"];
                [[NetworkManager sharedManager] requestWithHTTPPath:uploadResourceURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
                    if (weakSelf.isUploadSuccess)
                    {
                        [[YBStatusBarNotificationManager shareManager] dismiss];
                    }
                    
                    if ([responseObject isKindOfClass:[NSDictionary class]])
                    {
                        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                        if ([code isEqualToString:@"0"])
                        {
                            if (weakSelf.isUploadSuccess)
                            {
                                [ProgressHUD showText:NSLocalizedString(@"Upload Success", nil)];
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:reloadPohtoNotification object:nil];
                        }
                    }
                    weakSelf.isUploadSuccess = YES;
                } failure:^(NSError *error) {
                    if (weakSelf.isUploadSuccess)
                    {
                        [[YBStatusBarNotificationManager shareManager] dismiss];
                        [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
                    }
                    weakSelf.isUploadSuccess = YES;
                }];
            }
        } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
            [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
        } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
            //NSLog(@"-----%lld",completedBytesCount/totalBytesCount);
        }];
    }
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/*-topBarHeight*/-tabBarHeight-bottomViewHeight)];
        _imgView.image = [UIImage imageNamed:@"upload_top"];
    }
    return _imgView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight/*-topBarHeight*/-tabBarHeight-bottomViewHeight, screenWidth, bottomViewHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        NSInteger uploadItemCount = self.titleArray.count;
        CGFloat edge = (screenWidth-uploadItemCount*uploadItemWidth-(uploadItemCount-1)*uploadItemSpace)/2;
        for (int i = 0; i<uploadItemCount; i++) {
            CGFloat offset_x = edge+(uploadItemSpace+uploadItemWidth)*i;
            UploadButtonItem *item = [[UploadButtonItem alloc] initWithFrame:CGRectMake(offset_x, 0, uploadItemWidth, uploadItemHeight)];
            item.tag = i+1;
            item.title = self.titleArray[i];
            item.image = self.imageArray[i];
            [_bottomView addSubview:item];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
            [item addGestureRecognizer:tap];
        }
    }
    return _bottomView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        //        _titleArray = @[NSLocalizedString(@"video", nil),NSLocalizedString(@"photo", nil),NSLocalizedString(@"livestreem", nil)];
        _titleArray = @[NSLocalizedString(@"album", nil),NSLocalizedString(@"video", nil),NSLocalizedString(@"livestreem", nil)];
    }
    return _titleArray;
}

- (NSArray<UIImage *> *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[[UIImage imageNamed:@"video1"],[UIImage imageNamed:@"camer"],[UIImage imageNamed:@"video2"]];
    }
    return _imageArray;
}

- (ALAssetsLibrary *)assetsLibraryToUpload
{
    static ALAssetsLibrary *library = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}
#pragma mark VPImageCropperDelegate
-(NSData*) imageCompress:(UIImage*)image
{
    
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    float size=[imageData length]/1024;
    if (size<=200)
    {
        return UIImageJPEGRepresentation(image, 1) ;
    }
    else if (size>=200&&size<=1000)
    {
        return UIImageJPEGRepresentation(image, 0.5) ;
    }
    else if(size>1000)
    {
        return UIImageJPEGRepresentation(image, 0.05) ;
    }
    return nil;
}

//确定相片裁剪
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        NSData *data=[self imageCompress:editedImage];
        
        //        [ProgressHUD showText:@"开始上传"];
        //        NSMutableArray *imageArray = [NSMutableArray array];
        //        ResourceUploadModel *uploadModel = [[ResourceUploadModel alloc] init];
        //        uploadModel.data = data;
        //        [imageArray addObject:uploadModel];
        //
        //        [self uploadResourceRequest:SelectResourceTypePhoto uploadData:imageArray isVideo:NO];
        
        
    }];
}

//取消裁剪相片
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark camera utility
//相机模式是否可用
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//相机是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos
{
    __block BOOL result = NO;
    if ([(__bridge NSString *)kUTTypeImage length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

//前置摄像头是否存在
- (BOOL) isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

//照片库模式是否可用
- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
//------

@end

