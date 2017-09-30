//
//  MBProfileHeaderPicController.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/9.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBProfileHeaderPicController.h"
#import <UIImageView+WebCache.h>
#import "UserInfoManager.h"
#import "Macros.h"
#import <Photos/Photos.h>
#import "ProgressHUD.h"
#import "ResourceUploadModel.h"
#import "PhotoPickerViewController.h"
#import "UpYunFormUploader.h"
#import "Handler.h"
#import "NSString+imgURL.h"
#import <AssetsLibrary/ALAsset.h>

static NSString *uploadHeaderPicURL = @"http://39.108.152.114/modeltest/user/upload/headpic/upyun";

@interface MBProfileHeaderPicController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)UIButton *cancelBtn;
@property(nonatomic, strong)UIButton *saveBtn;
@property(nonatomic, strong)UIButton *uploadBtn;

@end

@implementation MBProfileHeaderPicController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.navigationItem.title = NSLocalizedString(@"My Photo", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightBtn.hidden = NO;
    [self.rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];//Chiang
    [self.rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateHighlighted];//Chiang
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.saveBtn];
    [self.bgView addSubview:self.uploadBtn];
}

- (void)rightBtnAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.imgView.frame)-10, CGRectGetWidth(self.view.frame), 180);
    }];
}

- (void)cancelAction:(UIButton *)sender
{
    [self hide];
}

- (void)saveAction:(UIButton *)sender
{
    WS(weakSelf);
    [self hide:^{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:weakSelf.imgView.image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showText:NSLocalizedString(@"Save Success", nil)];
                });
            }
        }];
    }];
}

- (void)uploadAction:(UIButton *)sender
{
    WS(weakSelf);
    [self hide:^{
//        PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] initWithMaxCount:1 selectArray:[NSMutableArray array]];
//        picker.delegate = weakSelf;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
//        [weakSelf presentViewController:nav animated:YES completion:nil];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:picker animated:YES completion:nil];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

- (void)hide
{
    [self hide:nil];
}

- (void)hide:(void (^)(void))animations
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.imgView.frame)+180, CGRectGetWidth(self.view.frame), 180);
    } completion:^(BOOL finished) {
        if (animations) {
            animations();
        }
    }];
}

- (void)uploadResourceRequest:(SelectResourceType)resourceType uploadData:(NSMutableArray<ResourceUploadModel *> *)uploadData isVideo:(BOOL)isVideo
{
    if (uploadData.count == 0) return;
    
    ResourceUploadModel *model = [uploadData firstObject];
    WS(weakSelf);
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    [up uploadWithBucketName:@"modelbook1" operator:@"modelbook" password:@"m12345678" fileData:[Handler imageCompress:model.image] fileName:nil saveKey:model.fileName otherParameters:nil success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
        NSString *urlStr = responseBody[@"url"];
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
        [md setValue:urlStr forKey:@"headpic"];
        [[NetworkManager sharedManager] requestWithHTTPPath:uploadHeaderPicURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"0"])
                {
                    [ProgressHUD showText:NSLocalizedString(@"Avatar uploaded successfully", nil)];
                    /* 重新设置头像 */
                    NSString *headpic = responseObject[@"object"];
                    [UserInfoManager setHeadpic:headpic];
                    /* 替换本地头像 */
                    [weakSelf.imgView sd_setImageWithURL:[NSURL URLWithString:[headpic imgURLWithSize:weakSelf.imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:reloadProfileInfoNotification object:nil];
                }
                else
                {
                    [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
                }
            }
            else
            {
                [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
            }
        } failure:^(NSError *error) {
            [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
        }];
    } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
        [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
    } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
        //NSLog(@"-----%lld",completedBytesCount/totalBytesCount);
    }];
}

#pragma mark - PhotoPickerViewControllerDelegate
- (void)PhotoPickerViewControllerDidSelectPhoto:(NSMutableArray<AssetModel *> *)selectArray
{
    if (selectArray.count == 0) return;
    [ProgressHUD showText:NSLocalizedString(@"To upload", nil)];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (AssetModel *model in selectArray)
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
    [self uploadResourceRequest:SelectResourceTypePhoto uploadData:imageArray isVideo:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    WS(weakSelf);
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];
        if (image)
        {
            [ProgressHUD showText:NSLocalizedString(@"To upload", nil)];
            NSMutableArray *imageArray = [NSMutableArray array];
            ResourceUploadModel *uploadModel = [[ResourceUploadModel alloc] init];
            uploadModel.image = image;
            uploadModel.fileName = fileName.length>0?fileName:@"headPic";
            [imageArray addObject:uploadModel];
            [self uploadResourceRequest:SelectResourceTypePhoto uploadData:imageArray isVideo:NO];
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, CGRectGetWidth(self.view.frame)-16, CGRectGetHeight(self.view.frame)-topBarHeight-180)];
        _imgView.userInteractionEnabled = YES;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[[UserInfoManager headpic] imgURLWithSize:_imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame)+180, CGRectGetWidth(self.view.frame), 180)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bgView.frame)-50, CGRectGetWidth(self.view.frame), 50)];
        _cancelBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [_cancelBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.cancelBtn.frame)-5-50, CGRectGetWidth(self.view.frame), 50)];
        _saveBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [_saveBtn setTitle:NSLocalizedString(@"Save Photo", nil) forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIButton *)uploadBtn
{
    if (!_uploadBtn) {
        _uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.saveBtn.frame)-5-50, CGRectGetWidth(self.view.frame), 50)];
        _uploadBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [_uploadBtn setTitle:NSLocalizedString(@"Upload Photo", nil) forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

@end
