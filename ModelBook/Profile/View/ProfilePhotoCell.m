//
//  ProfilePhotoCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfilePhotoCell.h"
#import "ProfileResourceModel.h"
#import <UIImageView+WebCache.h>
#import "Macros.h"
#import <AVFoundation/AVFoundation.h>
#import "AssetModel.h"
#import "NSString+imgURL.h"

static CGFloat const imageTypeWidth = 28;
static CGFloat const videoTypeWidth = 30;

@interface ProfilePhotoCell ()

/* 类型 */
@property(nonatomic, strong)UIImageView *typeImgView;
/* imgViewWidth */
@property(nonatomic, assign)CGFloat imageWidth;
/* 删除 */
@property(nonatomic, strong)UIButton *deleteBtn;

@end

@implementation ProfilePhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    _imageWidth = screenWidth/3;
    [self addSubview:self.imgView];
    [self addSubview:self.typeImgView];
    [self addSubview:self.deleteBtn];
}

- (void)handlerCellWithModel:(ResourceItem *)model index:(NSInteger)index isEditing:(BOOL)isEditing
{
    self.deleteBtn.tag = index+1;
    self.deleteBtn.hidden = YES;
    if (isEditing) self.deleteBtn.hidden = NO;
    if ([model.fileType isEqualToString:@"1"])
    {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.fileSrc]];
        self.typeImgView.hidden = NO;
        self.typeImgView.image = [UIImage imageNamed:@"video_play"];
        WS(weakSelf);
        [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:model.fileSrc] completion:^(BOOL isInCache) {
            if (!isInCache)
            {
                weakSelf.imgView.image = [UIImage imageNamed:@"addImage"];
                dispatch_async(dispatch_queue_create(0, 0), ^{
                    UIImage *image = [self getVideoPreViewImage:model.fileSrc];
                    if (image)
                    {
                        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:model.fileSrc]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.imgView.image = image;
                    });
                });
            }
            else
            {
                [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.fileSrc]];
            }
        }];
    }
    else
    {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.fileSrc imgURLWithSize:self.imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    }
    self.typeImgView.frame = CGRectMake(_imageWidth-imageTypeWidth, 0, imageTypeWidth, imageTypeWidth);
    if ([model.fileType isEqualToString:@"1"])
    {
        /* 视频 */
        self.typeImgView.frame = CGRectMake(_imageWidth-videoTypeWidth-5, 5, videoTypeWidth, videoTypeWidth);
    }
}

- (void)handlerCellWithModel:(AssetModel *)model
{
    self.imgView.image = model.thumbanilImage;
    self.deleteBtn.hidden = YES;
    self.typeImgView.image = [UIImage imageNamed:@"video_play"];
    self.typeImgView.frame = CGRectMake(_imageWidth-imageTypeWidth, 0, imageTypeWidth, imageTypeWidth);
    if (model.resourceType == ALAssetTypeVideo) self.typeImgView.hidden = NO;
}

- (void)handlerCellWithDefaultImage
{
    self.deleteBtn.hidden = YES;
    self.typeImgView.hidden = YES;
    self.imgView.image = [UIImage imageNamed:@"addImage"];
}

- (UIImage *)getVideoPreViewImage:(NSString *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:url] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

- (void)deleteAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteItem:)]) {
        [self.delegate deleteItem:sender.tag-1];
    }
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageWidth, _imageWidth)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_imageWidth-20, 0, 20, 20)];
        [_deleteBtn setImage:[UIImage imageNamed:@"cell_icon_closechose"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"cell_icon_closechose"] forState:UIControlStateHighlighted];
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] init];
        _typeImgView.hidden = YES;
    }
    return _typeImgView;
}

@end
