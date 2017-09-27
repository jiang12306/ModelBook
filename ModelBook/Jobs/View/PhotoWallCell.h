//
//  PhotoWallCell.h
//  ModelBook
//
//  Created by zdjt on 2017/9/1.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoWallCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@property (copy, nonatomic) NSString *imageURL;

@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) NSInteger row;

@property (copy, nonatomic) void(^cellClickBlock)(PhotoWallCell *cell, NSInteger row);

@end
