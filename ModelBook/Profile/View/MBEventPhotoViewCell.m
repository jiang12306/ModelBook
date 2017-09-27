//
//  MBEventPhotoViewCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBEventPhotoViewCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+imgURL.h"

@interface MBEventPhotoViewCell ()



@end

@implementation MBEventPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)handlerCellWithImage:(NSString *)image
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[image imgURLWithSize:self.imageView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
}

- (void)initLayout
{
    [self addSubview:self.imageView];
}

#pragma mark - lazy
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.5, 0, CGRectGetWidth(self.frame)-7, CGRectGetWidth(self.frame)-7)];
    }
    return _imageView;
}

@end
