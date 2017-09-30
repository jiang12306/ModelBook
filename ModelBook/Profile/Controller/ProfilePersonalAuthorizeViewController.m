//
//  ProfilePersonalAuthorizeViewController.m
//  ModelBook
//
//  Created by Jiang Kuan on 2017/9/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfilePersonalAuthorizeViewController.h"
#import "UploadEditViewController.h"
#import "AssetModel.h"
#import "ResourceUploadModel.h"

@interface ProfilePersonalAuthorizeViewController () <UITextFieldDelegate, UIActionSheetDelegate, UploadEditViewControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *identifierNumTF;
@property (nonatomic, strong) UIButton* uploadBtn;
@property (nonatomic, strong) UIImageView* uploadIV;

@property (nonatomic, strong) UIButton* sureBtn;//确定按钮

@end

@implementation ProfilePersonalAuthorizeViewController

#define ORIGINAL_MAX_WIDTH 640.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initLayout];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray* labArr = @[NSLocalizedString(@"Profile Name", nil),NSLocalizedString(@"Identifier Number", nil),NSLocalizedString(@"Identifier Photo", nil)];
    for (int i = 0; i < labArr.count; i ++) {
        UILabel* lab = [self createLabelWithFrame:CGRectMake(40, 40 + (20 + 20)*i, 50, 20) text:labArr[i] fontSize:15.f];
        
        [self.view addSubview:lab];
        
        if (i == 0) {//姓名
            self.nameTF = [self createTextFieldWithFrame:CGRectMake(lab.frame.origin.x + lab.frame.size.width, lab.frame.origin.y, self.view.frame.size.width - lab.frame.origin.x*2 - lab.frame.size.width, lab.frame.size.height) placeholder:labArr[i] fontSize:15.f];
            [self.view addSubview:self.nameTF];
        }else if (i == 1) {//证件号
            self.identifierNumTF = [self createTextFieldWithFrame:CGRectMake(lab.frame.origin.x + lab.frame.size.width, lab.frame.origin.y, self.view.frame.size.width - lab.frame.origin.x*2 - lab.frame.size.width, lab.frame.size.height) placeholder:labArr[i] fontSize:15.f];
            [self.view addSubview:self.identifierNumTF];
        }else if (i == 2) {//证件
            self.uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(lab.frame.origin.x + lab.frame.size.width, lab.frame.origin.y, self.view.frame.size.width - lab.frame.origin.x*2 - lab.frame.size.width, lab.frame.size.height)];
            [self.uploadBtn addTarget:self action:@selector(clickedUploadButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.uploadBtn setTitleColor:[UIColor colorWithRed:190.f/255 green:190.f/255 blue:190.f/255 alpha:1.f] forState:UIControlStateNormal];
            self.uploadBtn.titleLabel.font = [UIFont fontWithName:pageFontName size:15];
            [self.uploadBtn setTitle:NSLocalizedString(@"upload", nil) forState:UIControlStateNormal];
            [self.view addSubview:self.uploadBtn];
            
            UIView * underLine = [self createUnderLineWithFrame:CGRectMake(0,self.uploadBtn.frame.size.height-1,self.uploadBtn.frame.size.width,1) bgColor:[UIColor blackColor]];
            [self.uploadBtn addSubview:underLine];
            
            UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(self.uploadBtn.frame.size.width - 7.5, (20 - 12.5)/2, 7.5, 12.5)];
            iv.image = [UIImage imageNamed:@"arrow-right"];
            [self.uploadBtn addSubview:iv];
        }
    }
    self.sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(35, self.view.frame.size.height - 200, self.view.frame.size.width - 35*2, 50)];
    self.sureBtn.backgroundColor = [UIColor colorWithRed:153.f/255 green:204.f/255 blue:249.f/255 alpha:1];
    [self.sureBtn addTarget:self action:@selector(clickedSureButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.sureBtn setTitle:NSLocalizedString(@"profileconfirm", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.sureBtn];
}

-(UILabel* )createLabelWithFrame:(CGRect )frame text:(NSString* )text fontSize:(CGFloat )fontSize {
    UILabel* lab = [[UILabel alloc]initWithFrame:frame];
    lab.text = text;
    lab.font = [UIFont fontWithName:pageFontName size:fontSize];
    return lab;
}

-(UITextField* )createTextFieldWithFrame:(CGRect )frame placeholder:(NSString* )placeholder fontSize:(CGFloat )fontSize {
    UITextField* tf = [[UITextField alloc]initWithFrame:frame];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.placeholder = placeholder;
    tf.font = [UIFont fontWithName:pageFontName size:fontSize];
    tf.borderStyle = UITextBorderStyleNone;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView * underLine = [self createUnderLineWithFrame:CGRectMake(0,frame.size.height-1,frame.size.width,1) bgColor:[UIColor blackColor]];
    [tf addSubview:underLine];
    
    return tf;
}

//下划线
-(UIView* )createUnderLineWithFrame:(CGRect )frame bgColor:(UIColor* )bgColor {
    UIView * underLine = [[UIView alloc]initWithFrame:frame];
    underLine.backgroundColor = bgColor;
    return underLine;
}

//点击上传button
-(void)clickedUploadButton:(UIButton* )sender {
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [sheet showInView:self.view];
}

#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//相册
        UploadEditViewController *vc = [[UploadEditViewController alloc] init];
        vc.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (buttonIndex == 1) {//拍照
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
}

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

#pragma mark - UploadEditViewControllerDelegate 相册上传代理
- (void)uploadResource:(NSMutableArray *)array isSelectedVideo:(BOOL)isSelectedVideo
{
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (AssetModel *model in array)
    {
        UIImage *image = [UIImage imageWithCGImage:[model.asset.defaultRepresentation fullScreenImage]];
        if (image)
        {
            ResourceUploadModel *uploadModel = [[ResourceUploadModel alloc] init];
            uploadModel.image = image;
            uploadModel.fileName = model.asset.defaultRepresentation.filename;
            [imageArray addObject:uploadModel];
            
            [self showImageViewWithImageArray:imageArray];
            
            break;
        }
    }
}

-(void)showImageViewWithImageArray:(NSArray* )arr {
    if (!self.uploadIV) {
        self.uploadIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.uploadBtn.frame.origin.x, self.uploadBtn.frame.origin.y + self.uploadBtn.frame.size.height + 30, 80, 80)];
        [self.view addSubview:self.uploadIV];
    }
    ResourceUploadModel *uploadModel = [arr objectAtIndex:0];
    
    self.uploadIV.image = uploadModel.image;
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

//MARK: 保存
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
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

//点击确定button
-(void)clickedSureButton:(UIButton* )sender {
    if (self.nameTF.text.length == 0) {
        return;
    }
    if (self.identifierNumTF.text.length == 0) {
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
