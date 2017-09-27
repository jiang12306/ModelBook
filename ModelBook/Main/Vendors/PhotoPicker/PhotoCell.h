//
//  PhotoCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

@class PhotoCell;
@protocol PhotoCellDelegate <NSObject>

@optional
- (void)PhotoCell:(PhotoCell *)cell didClickSelectButton:(UIButton *)button;

@end

@interface PhotoCell : UICollectionViewCell

@property (weak, nonatomic) id<PhotoCellDelegate> delegate;

@property (strong, nonatomic) UIButton *selectButton;

/* 类型 */
@property(nonatomic, strong)UIImageView *typeImgView;

@property (strong, nonatomic) AssetModel *model;

@end
