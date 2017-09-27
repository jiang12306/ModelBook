//
//  ProfilePhotoCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResourceItem;
@class AssetModel;

@protocol ProfilePhotoCellDelegate <NSObject>

- (void)deleteItem:(NSInteger)index;

@end

@interface ProfilePhotoCell : UICollectionViewCell

/* 图片 */
@property(nonatomic, strong)UIImageView *imgView;
/* 删除 */
@property(nonatomic, weak)id<ProfilePhotoCellDelegate> delegate;

- (void)handlerCellWithModel:(ResourceItem *)model index:(NSInteger)index isEditing:(BOOL)isEditing;

- (void)handlerCellWithDefaultImage;

- (void)handlerCellWithModel:(AssetModel *)model;

@end
