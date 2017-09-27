//
//  ProfileAboutMePhotoCollectionCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileAboutMePhotoCollectionCell.h"
#import "ProfileCommentImageModel.h"
#import <UIImageView+WebCache.h>
#import "NSString+imgURL.h"

@interface ProfileAboutMePhotoCollectionCell ()

@end

@implementation ProfileAboutMePhotoCollectionCell

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
    [self addSubview:self.imageView];
}

- (void)handlerCellWithModel:(ProfileCommentImageItem *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model.commentImage imgURLWithSize:self.imageView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
}

#pragma mark - lazy
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
