//
//  MBJobDetailRecordView.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBJobDetailRecordView.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "MBJobDetailModel.h"
#import "MBJobDetailRecordCell.h"
#import "ProgressHUD.h"
#import "Macros.h"
#import "MBJobDetailRecordHeaderView.h"
#import "EqualSpaceFlowLayoutEvolve.h"

@interface MBJobDetailRecordView ()<UICollectionViewDelegate, UICollectionViewDataSource>

/* collection高度 */
@property(nonatomic, assign)CGFloat height;
/* cellWidth */
@property(nonatomic, assign)CGFloat cellWidth;
/* cellHeight */
@property(nonatomic, assign)CGFloat cellHeight;
/* keys */
@property(nonatomic, strong)NSMutableArray *allKeys;

@end

@implementation MBJobDetailRecordView

- (instancetype)initWithFrame:(CGRect)frame recordArray:(NSMutableArray<MBJobDetailRecordModel *> *)recordArray recordDic:(NSMutableDictionary *)recordDic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _recordDic = recordDic;
        _recordArray = recordArray;
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    self.cellWidth = 74;
    self.cellHeight = 83;
    NSInteger count = 4;
    for (NSMutableArray *array in [self.recordDic allValues]) {
        CGFloat height = 0;
        if (array.count>0) height = ((array.count-1)/count+1)*self.cellHeight+30;
        self.height+=height;
    }
    self.height += 25;
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), self.height);
    [self addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.allKeys.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *key = self.allKeys[section];
    NSMutableArray *array = self.recordDic[key];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBJobDetailRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBJobDetailRecordCell" forIndexPath:indexPath];
    NSString *key = self.allKeys[indexPath.section];
    NSMutableArray *array = self.recordDic[key];
    if (array.count>0)
    {
        MBJobDetailRecordModel *recordModel = array[indexPath.row];
        BOOL isSelected = NO;
        if ([self.selectedRecordArray containsObject:recordModel]) isSelected = YES;
        [cell handlerCellWithModel:recordModel isSelected:isSelected];
        WS(weakSelf);
        cell.didClickedRemarkAction = ^{
            if (weakSelf.didClickedRemarkBlock) weakSelf.didClickedRemarkBlock(recordModel);
        };
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.allKeys[indexPath.section];
    NSMutableArray *array = self.recordDic[key];
    if (array.count == 0)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MBJobDetailRecordDefaultHeaderView" forIndexPath:indexPath];
        return headerView;
    }
    else
    {
        MBJobDetailRecordHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MBJobDetailRecordHeaderView" forIndexPath:indexPath];
        headerView.title = jobTypeStr(key);
        return headerView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSString *key = self.allKeys[section];
    NSMutableArray *array = self.recordDic[key];
    if (array.count == 0)
    {
        return CGSizeZero;
    }
    else
    {
        return CGSizeMake(CGRectGetWidth(self.frame), 30);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.allKeys[indexPath.section];
    NSMutableArray *array = self.recordDic[key];
    if (array.count>0)
    {
        MBJobDetailRecordModel *recordModel = array[indexPath.row];
        if (_didSelectedRecordBlock) _didSelectedRecordBlock(recordModel);
    }
}

#pragma mark - setting方法
- (void)setSelectedRecordArray:(NSMutableArray<MBJobDetailRecordModel *> *)selectedRecordArray
{
    _selectedRecordArray = selectedRecordArray;
    [self.collectionView reloadData];
}

- (void)setRecordDic:(NSMutableDictionary *)recordDic
{
    _recordDic = recordDic;
    [self.collectionView reloadData];
}

- (void)setJobState:(MBJobState)jobState
{
    _jobState = jobState;
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        EqualSpaceFlowLayoutEvolve *flowLayout = [[EqualSpaceFlowLayoutEvolve alloc] init];
        flowLayout.betweenOfCell = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.cellWidth, self.cellHeight);
        CGFloat edge = (CGRectGetWidth(self.frame)-self.cellWidth*4-10)/2;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, edge, 0, edge);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), self.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[MBJobDetailRecordCell class] forCellWithReuseIdentifier:@"MBJobDetailRecordCell"];
        [_collectionView registerClass:[MBJobDetailRecordHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MBJobDetailRecordHeaderView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MBJobDetailRecordDefaultHeaderView"];
    }
    return _collectionView;
}

- (NSMutableArray *)allKeys
{
    if (!_allKeys) {
        _allKeys = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"]];
    }
    return _allKeys;
}

@end
