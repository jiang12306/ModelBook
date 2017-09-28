//
//  BaseTabBarViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/7.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "UIColor+Ext.h"
#import "AFNetworkReachabilityManager.h"
#import "UploadViewController.h"
#import "ProfileViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "BaseTabbar.h"

#import "UploadView.h"
#import "UploadEditViewController.h"
#import "PhotoPickerViewController.h"
#import "ProgressHUD.h"
#import "YBStatusBarNotificationManager.h"
#import "VideoHandler.h"
#import <AVFoundation/AVFoundation.h>
#import "ResourceUploadModel.h"
#import "RecordCameraViewController.h"
#import "UpYunFormUploader.h"
#import "Handler.h"
#import "VPImageCropperViewController.h"

static NSString * const uploadResourceURL = @"http://39.108.152.114/modeltest/album/upload/upyun";
#define ORIGINAL_MAX_WIDTH 640.0f

@interface BaseTabBarViewController () <MyTabBarDelegate, UploadEditViewControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, VPImageCropperDelegate>
/* 是否有一个已上传完毕 */
@property(nonatomic, assign)BOOL isUploadSuccess;
//MARK: 获取相册
@property (strong, nonatomic) ALAssetsLibrary * assetsLibraryToUpload;
@end

@implementation BaseTabBarViewController

#pragma mark - 相册相关
- (ALAssetsLibrary *)assetsLibraryToUpload
{
    static ALAssetsLibrary *library = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark -
+ (BaseNavigationViewController *)instantiateNavigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"TBNavSBID"];
}

+ (BaseTabBarViewController *)instantiateTabBarController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"TBVCSBID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
        
//    self.tabBar.backgroundImage = [UIImage new];
//    self.tabBar.shadowImage = [UIImage new];
//    self.tabBar.translucent = NO;
    
    // MARK: 分栏
    // 获取storyboard
    // 首页
    UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    // 工作
    UIStoryboard *jobSB = [UIStoryboard storyboardWithName:@"Jobs" bundle:[NSBundle mainBundle]];
    //    UIStoryboard *uploadSB = [UIStoryboard storyboardWithName:@"Upload" bundle:[NSBundle mainBundle]];
    // 上传
//     UploadViewController *uploadVC = [[UploadViewController alloc] init];
    // 聊天
    UIStoryboard *chatSB = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
    //    UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"Profile" bundle:[NSBundle mainBundle]];
    // 我的
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]];
    profileVC.navigationItem.title = NSLocalizedString(@"tabBar-titleE", nil);
    
    // 获取navigationcontroller
    // 首页
    BaseNavigationViewController *homeNav = [homeSB instantiateViewControllerWithIdentifier:@"HomeNavSBID"];
    // 工作
    BaseNavigationViewController *jobsNav = [jobSB instantiateViewControllerWithIdentifier:@"JobNavSBID"];
    //  BaseNavigationViewController *uploadNav = [uploadSB instantiateViewControllerWithIdentifier:@"UploadNavSBID"];
    // 上传
//      BaseNavigationViewController *uploadNav = [[BaseNavigationViewController alloc] initWithRootViewController:uploadVC];
    // 聊天
    BaseNavigationViewController *chatNav = [chatSB instantiateViewControllerWithIdentifier:@"ChatNavSBID"];
    //    BaseNavigationViewController *profileNav = [profileSB instantiateViewControllerWithIdentifier:@"ProfileNavSBID"];
    // 我的
    BaseNavigationViewController *profileNav = [[BaseNavigationViewController alloc] initWithRootViewController:profileVC];
    
    // 初始化子控制器
    // 首页
    [self addChildVc:homeNav title:NSLocalizedString(@"tabBar-titleA", nil) image:@"home_normal" selectedImage:@"home_selected"];
    // 工作
    [self addChildVc:jobsNav title:NSLocalizedString(@"tabBar-titleB", nil) image:@"jobs_normal" selectedImage:@"jobs_selected"];
    // 上传
//     [self addChildVc:uploadNav title:NSLocalizedString(@"tabBar-titleC", nil) image:@"upload_normal" selectedImage:@"upload_selected"];
    // 聊天
    [self addChildVc:chatNav title:NSLocalizedString(@"tabBar-titleD", nil) image:@"chat_normal" selectedImage:@"chat_selected"];
    // 我的
    [self addChildVc:profileNav title:NSLocalizedString(@"tabBar-titleE", nil) image:@"profile_normal" selectedImage:@"profile_selected"];
    
    // 设置tabBarItem
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont fontWithName:buttonFontName size:12.f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xa7d7ff],NSFontAttributeName:[UIFont fontWithName:buttonFontName size:12.f]} forState:UIControlStateSelected];
    
    [self takeNetInfo];
    
    BaseTabbar *tabBar = [[BaseTabbar alloc] initWithFrame:self.tabBar.frame];
    tabBar.myTabBarDelegate = self;
    //设置tabbar时只能用keyValue方式
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //设置TabBar的TintColor
    self.tabBar.tintColor = [UIColor colorWithRed:89/255.0 green:217/255.0 blue:247/255.0 alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    int badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (badge > 0) {
        [[self.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",badge]];
    }
}

-(void)takeNetInfo{
    //监控网络
    //1. 获取网络监控的管理者
    AFNetworkReachabilityManager *netWorkManager = [AFNetworkReachabilityManager sharedManager];
    //2. 设置网络状态发生变化时的代码
    [netWorkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自己的网络(3G,4G)");
            default:
                break;
        }
    }];
    //3. 启动监控
    [netWorkManager startMonitoring];
}

#pragma mark - 初始化子控制器
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 添加为子控制器
    [self addChildViewController:childVc];
}

/** 跳转MainTabBarController主页面 */
- (UIViewController *)showMainTabBarController:(SectionType)sectionType
{
    if (!self) return nil;
    
    self.selectedIndex = sectionType;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    for (UINavigationController *controller in self.viewControllers) {
        [controller popToRootViewControllerAnimated:YES];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    return self.selectedViewController;
}

#pragma mark - MyTabBarDelegate 弹出视图的按钮响应
-(void)addButtonClick:(BaseTabbar *)tabBar
{
    UploadView * view = [[UploadView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [view setChooseSocialityHandle:^(SocialityType socialityType) {
        switch (socialityType) {
            case SocialityType_Album: // 相册读取
            {
                UploadEditViewController *vc = [[UploadEditViewController alloc] init];
                vc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case SocialityType_Photo:   // 拍照
            {
                if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                    }
                    else {
                        if ([self isFrontCameraAvailable]) {
                            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                        }
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
            }
                break;
            default: // SocialityType_Video // 拍视屏
            {
                RecordCameraViewController *vc = [RecordCameraViewController new];
                vc.inputRecordMode = lsqRecordModeKeep;
                [self presentViewController:vc animated:YES completion:nil];
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }];
    [view showView];
}

#pragma mark - UploadEditViewControllerDelegate 相册上传代理
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

#pragma mark - UIImagePickerControllerDelegate 相机代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
#if 1
        // 保存照片
        [self saveImageToPhotoAlbum:portraitImg];
#else
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
#endif
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
        // NSData *data=[self imageCompress:editedImage];
        // 保存照片
        [self saveImageToPhotoAlbum:editedImage];
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

//MARK: 保存
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        return;
    }else{
        msg = @"保存图片成功" ;
    }
    
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
//MARK: 上传刚拍的照片
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

#pragma mark - 上传
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

@end
