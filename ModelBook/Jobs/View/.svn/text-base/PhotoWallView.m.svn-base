//
//  PhotoWallView.m
//  ModelBook
//
//  Created by zdjt on 2017/9/1.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PhotoWallView.h"

@interface PhotoWallView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@end

@implementation PhotoWallView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
}

#pragma mark - 初始化视图

- (void)setupViews
{
    UICollectionViewFlowLayout *bannerLayout = [[UICollectionViewFlowLayout alloc] init];
    bannerLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:bannerLayout];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor= [UIColor clearColor];
    collectionView.userInteractionEnabled = YES;
    [self addSubview:collectionView];
    
    [self.collectionView registerClass:[PhotoWallCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - 赋值

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoWallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.modeltype == ModelTypeImage) {
        cell.image = self.dataSource[indexPath.row];
    }else {
        cell.imageURL = self.dataSource[indexPath.row];
    }
    cell.row = indexPath.row;
    cell.cellClickBlock = ^(PhotoWallCell *cellView, NSInteger row) {
        if (self.didSelectItemBlock) self.didSelectItemBlock(row);
    };
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.controllerFrom isEqualToString:@"comment"]) {
        return CGSizeMake(100.f, 100.f);
    }
    return CGSizeMake((CGRectGetWidth(self.bounds) - 4 * 10) / 3, self.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}



@end
