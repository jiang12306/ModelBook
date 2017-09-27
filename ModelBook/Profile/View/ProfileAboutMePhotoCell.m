//
//  ProfileAboutMePhotoCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileAboutMePhotoCell.h"
#import "Macros.h"
#import "ProfileCommentImageModel.h"
#import "ProfileAboutMePhotoCollectionCell.h"
#import "ProgressHUD.h"
#import <KSPhotoItem.h>
#import <KSPhotoBrowser.h>
#import "Handler.h"

@interface ProfileAboutMePhotoCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

/* collectionview */
@property(nonatomic, strong)UICollectionView *collectionView;
/* 右侧按钮 */
@property(nonatomic, strong)UIImageView *rightImgView;
/* 右侧按钮 */
@property(nonatomic, strong)UIButton *rightBtn;

@end

@implementation ProfileAboutMePhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    [self addSubview:self.collectionView];
    [self addSubview:self.rightImgView];
    [self addSubview:self.rightBtn];
}

#pragma mark - action
- (void)nextPageAction:(UIButton *)sender
{
    if (_collectionView.contentOffset.x == (_collectionView.contentSize.width-CGRectGetWidth(_collectionView.frame)))
    {
        [ProgressHUD showText:NSLocalizedString(@"No more pictures!", nil)];
    }
    CGFloat offset_x = _collectionView.contentOffset.x+CGRectGetWidth(_collectionView.frame);
    if (offset_x>(_collectionView.contentSize.width-CGRectGetWidth(_collectionView.frame)))
    {
        offset_x = (_collectionView.contentSize.width-CGRectGetWidth(_collectionView.frame));
    }
    [_collectionView setContentOffset:CGPointMake(offset_x, 0) animated:YES];
}

- (void)setImageArray:(NSMutableArray<ProfileCommentImageItem *> *)imageArray
{
    _imageArray = imageArray;
    [_imageArray addObjectsFromArray:imageArray];
    [self.collectionView reloadData];
    _rightImgView.hidden = NO;
    _rightBtn.hidden = NO;
    if ((photoCellHeight*_imageArray.count)<(screenWidth-50))
    {
        _rightImgView.hidden = YES;
        _rightBtn.hidden = YES;
    }
}

#pragma mark - uicollection - datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileAboutMePhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileAboutMePhotoCollectionCell" forIndexPath:indexPath];
    if (indexPath.row<self.imageArray.count)
    {
        ProfileCommentImageItem *item = self.imageArray[indexPath.row];
        [cell handlerCellWithModel:item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.imageArray.count)
    {
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < _imageArray.count; i++) {
            ProfileAboutMePhotoCollectionCell *cell = (ProfileAboutMePhotoCollectionCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            ProfileCommentImageItem *model = self.imageArray[i];
            NSString *url = model.commentImage;
            
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:url]];
            [items addObject:item];
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
        //        browser.delegate = self;
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces = NO;
        [browser showFromViewController:[Handler topViewController]];
    }
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(photoCellHeight, photoCellHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-30, photoCellHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ProfileAboutMePhotoCollectionCell class] forCellWithReuseIdentifier:@"ProfileAboutMePhotoCollectionCell"];
    }
    return _collectionView;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-20, (photoCellHeight-20)/2, 10, 20)];
        _rightImgView.image = [UIImage imageNamed:@"arrow-right"];
    }
    return _rightImgView;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-30, 0, 30, photoCellHeight)];
        [_rightBtn addTarget:self action:@selector(nextPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
