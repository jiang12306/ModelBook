//
//  MBEventPhotoViewCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBEventPhotoViewCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView *imageView;

- (void)handlerCellWithImage:(NSString *)image;

@end
