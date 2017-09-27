//
//  ImgScrollView.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/13.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ImgScrollView.h"
#import "UIImageView+WebCache.h"
@interface ImgScrollView()
@property (nonatomic,assign)int currentIndex;
@property (nonatomic,strong)NSArray *imgArr;
@end
@implementation ImgScrollView
-(instancetype)initWithFrame:(CGRect)frame imgArr:(NSArray *)imgArr setIndex:(int)index islocal:(BOOL)local
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = frame.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.contentView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        self.contentView.dataSource = self;
        self.contentView.delegate = self;
        [self.contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellID"];
        [self addSubview:self.contentView];
//        for (int i=0; i<imgArr.count;i++) {
//            NSString *str = imgArr[i];
//            
//            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
//            if (local) {
//                imgV.image = [UIImage imageNamed:str];
//            }else
//            {
//                [imgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"简介介绍页面_03_03"]];
//            }
//            [self addSubview:imgV];
//        }
        self.currentIndex = index;
        self.imgArr = imgArr;
        self.contentView.showsHorizontalScrollIndicator = NO;
        [self.contentView setContentOffset:CGPointMake(frame.size.width*index, 0)];
        self.contentView.pagingEnabled = YES;
        self.contentView.bounces = NO;
        self.coverView = [[CoverView alloc]initWithFrame:frame];
        [self addSubview:self.coverView];
        self.coverView.delegate = self;
    }
    return self;
}
#pragma mark - CoverViewDelegate
-(void)nextImgView
{
    if (self.currentIndex>=self.imgArr.count-1) {
        return;
    }
    self.currentIndex++;
    [self.contentView setContentOffset:CGPointMake(self.frame.size.width*self.currentIndex, 0)];
}
-(void)preImgView
{
    if (self.currentIndex<=0) {
        return;
    }
    self.currentIndex--;
    [self.contentView setContentOffset:CGPointMake(self.frame.size.width*self.currentIndex, 0)];
}
#pragma mark -collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imgN = self.imgArr[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    BOOL hasImage = NO;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:imgN] placeholderImage:[UIImage imageNamed:@"简介介绍页面_03_03"]];
            hasImage = YES;
            break;
        }
    }
    if (!hasImage) {
        UIImageView *view = [[UIImageView alloc]init];
        [view sd_setImageWithURL:[NSURL URLWithString:imgN] placeholderImage:[UIImage imageNamed:@"简介介绍页面_03_03"]];
        view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:view];
    }
    
    return cell;
    
}
@end
