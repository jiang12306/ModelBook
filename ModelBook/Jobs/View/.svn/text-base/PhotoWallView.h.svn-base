//
//  PhotoWallView.h
//  ModelBook
//
//  Created by zdjt on 2017/9/1.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoWallCell.h"

typedef NS_ENUM(NSUInteger, ModelType) {
    ModelTypeDefault,
    ModelTypeImage,
};

@interface PhotoWallView : UIView

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataSource;

@property (assign, nonatomic) ModelType modeltype;

@property (copy, nonatomic) void(^didSelectItemBlock)(NSInteger row);

@property (copy, nonatomic) NSString *controllerFrom;

@end
