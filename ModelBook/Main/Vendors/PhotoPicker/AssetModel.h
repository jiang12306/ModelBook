//
//  AssetModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetModel : NSObject

@property (strong, nonatomic) ALAsset *asset;

@property (strong, nonatomic) UIImage *thumbanilImage;/** 缩略图 */

@property (strong, nonatomic) UIImage *originalImage;/** 原图 */

@property (strong, nonatomic) UIImage *fullImage;/** 全屏图片 */

@property (strong, nonatomic) NSString *resourceType;/** 全屏图片 */

@property (assign, nonatomic) BOOL isSelected;

@end
