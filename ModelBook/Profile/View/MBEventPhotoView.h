//
//  MBEventPhotoView.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"

@interface MBEventPhotoView : UIView

@property(nonatomic, strong)UICollectionView *collectionView;
/* 当前job状态 */
@property(nonatomic, assign)MBJobState jobState;
@property(nonatomic, strong)NSArray *dataSource;

@end
