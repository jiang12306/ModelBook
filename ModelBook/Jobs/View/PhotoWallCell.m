//
//  PhotoWallCell.m
//  ModelBook
//
//  Created by zdjt on 2017/9/1.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PhotoWallCell.h"
#import "UIImageView+WebCache.h"

@interface PhotoWallCell ()

@end

@implementation PhotoWallCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    self.imageView = imageView;
    [self addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!/both/%dx%d",imageURL,(int)self.bounds.size.width,(int)self.bounds.size.height]] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)tapEvent:(UIGestureRecognizer *)sender
{
    if (self.cellClickBlock) self.cellClickBlock(self, self.row);
}

@end
