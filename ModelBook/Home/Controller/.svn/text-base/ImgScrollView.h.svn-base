//
//  ImgScrollView.h
//  ModelBook
//
//  Created by 唐先生 on 2017/8/13.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoverView.h"
@interface ImgScrollView : UIView<CoverViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *contentView;
@property (nonatomic,strong)CoverView *coverView;
-(instancetype)initWithFrame:(CGRect)frame imgArr:(NSArray *)imgArr setIndex:(int)index islocal:(BOOL)local;
@end
