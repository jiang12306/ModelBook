//
//  PhotoPickerViewController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BaseViewController.h"

/**
 选择资源类型

 - SelectResourceTypePhoto: 图片
 - SelectResourceTypeVideo: 视频
 */
typedef NS_ENUM(NSInteger, SelectResourceType) {
    SelectResourceTypePhoto = 0,
    SelectResourceTypeVideo,
    SelectResourceTypeAll
};

@protocol PhotoPickerViewControllerDelegate <NSObject>

@optional
- (void)PhotoPickerViewControllerDidSelectPhoto:(NSMutableArray<AssetModel  *> *)selectArray;

@end

@interface PhotoPickerViewController : UIViewController

@property (weak, nonatomic) id<PhotoPickerViewControllerDelegate> delegate;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

/* 资源类型 */
@property(nonatomic, assign)SelectResourceType resourceType;


/**
 *  初始化方法
 *
 *  @param maxCount    最多选择图片数量
 *  @param selectArray 已经选择过的图片数组
 *
 *  @return
 */
- (instancetype)initWithMaxCount:(NSInteger)maxCount selectArray:(NSMutableArray *)selectArray;

@end
