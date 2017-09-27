//
//  MBEventPhotoView.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBEventPhotoView.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "MBEventPhotoViewCell.h"
#import "ProgressHUD.h"
#import <KSPhotoItem.h>
#import <KSPhotoBrowser.h>
#import "Handler.h"

@interface MBEventPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UILabel *title;
@property(nonatomic, strong)UIButton *rightImgBtn;

@end

@implementation MBEventPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    [self addSubview:self.title];
    [self addSubview:self.collectionView];
    [self addSubview:self.rightImgBtn];
}

#pragma mark - action
- (void)nextPhotoAction
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

#pragma mark - UICollectionView - datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBEventPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBEventPhotoViewCell" forIndexPath:indexPath];
    [cell handlerCellWithImage:self.dataSource[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.dataSource.count)
    {
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < self.dataSource.count; i++) {
            MBEventPhotoViewCell *cell = (MBEventPhotoViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            NSString *url = self.dataSource[i];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:url]];
            [items addObject:item];
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces = NO;
        [browser showFromViewController:[Handler topViewController]];
    }
}

#pragma mark - setting方法
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
    self.rightImgBtn.hidden = YES;
    CGFloat count = CGRectGetWidth(self.collectionView.frame)/94;
    if (_dataSource.count>count) self.rightImgBtn.hidden = NO;
}

- (void)setJobState:(MBJobState)jobState
{
    _jobState = jobState;
}

#pragma mark - lazy
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 20)];
        _title.text = @"Phtots Of Event";
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor colorWithHexString:@"#666666"];
        _title.font = [UIFont fontWithName:pageFontName size:10];
    }
    return _title;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(80+7, 80);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.title.frame)+9, CGRectGetWidth(self.frame)-60, 80) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MBEventPhotoViewCell class] forCellWithReuseIdentifier:@"MBEventPhotoViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)rightImgBtn
{
    if (!_rightImgBtn) {
        _rightImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.collectionView.frame), CGRectGetMinY(self.collectionView.frame), 30, CGRectGetHeight(self.collectionView.frame))];
        [_rightImgBtn setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
        [_rightImgBtn setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateHighlighted];
        _rightImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rightImgBtn addTarget:self action:@selector(nextPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightImgBtn;
}

@end
