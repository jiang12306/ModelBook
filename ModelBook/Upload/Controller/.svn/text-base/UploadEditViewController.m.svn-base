//
//  UploadEditViewController.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UploadEditViewController.h"
#import "ProfilePhotoCell.h"
#import "PhotoPickerViewController.h"
#import "ProgressHUD.h"
#import "YBStatusBarNotificationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoHandler.h"
#import "ResourceUploadModel.h"

static NSString * const uploadResourceURL = @"http://39.108.152.114/modeltest/album/upload";

@interface UploadEditViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, PhotoPickerViewControllerDelegate>

/* uicollection */
@property(nonatomic, strong)UICollectionView *collectionView;
/* 选中的数组 */
@property(nonatomic, strong)NSMutableArray *selectArray;
/* 保存初始状态栏颜色 */
@property(nonatomic, assign)UIStatusBarStyle statusBarStyle;

@end

@implementation UploadEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18] ,NSForegroundColorAttributeName: [UIColor whiteColor]};//设置导航栏字体样式;
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#5a5a5a"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Upload Resource", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"tabBar-titleC", nil) style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [self.view addSubview:self.collectionView];
}

#pragma mark -  Action
/** 选择完成 */
- (void)done
{
    if (self.selectArray.count == 0)
    {
        [ProgressHUD showText:@"请选择上传资源"];
        return;
    }
    NSMutableArray *videoArray = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (AssetModel *model in self.selectArray) {
        if (model.resourceType == ALAssetTypeVideo)
        {
            [videoArray addObject:model];
        }
        else
        {
            [imageArray addObject:model];
        }
    }
    if ([self.delegate respondsToSelector:@selector(uploadResource:isSelectedVideo:)]) {
        [self.delegate uploadResource:videoArray isSelectedVideo:YES];
        [self.delegate uploadResource:imageArray isSelectedVideo:NO];
    }
    [self cancel];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - uicollection - datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.selectArray.count+1;
    return count>9?9:count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfilePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePhotoCell" forIndexPath:indexPath];
    if (indexPath.row<self.selectArray.count)
    {
        AssetModel *item = self.selectArray[indexPath.row];
        [cell handlerCellWithModel:item];
    }
    else
    {
        [cell handlerCellWithDefaultImage];
        cell.imgView.image = [UIImage imageNamed:@"choose"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = screenWidth/3;
    return CGSizeMake(cellHeight, cellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] initWithMaxCount:9 selectArray:self.selectArray];
    picker.resourceType = SelectResourceTypeAll;
    picker.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - PhotoPickerViewControllerDelegate
- (void)PhotoPickerViewControllerDidSelectPhoto:(NSMutableArray<AssetModel *> *)selectArray
{
//    if (selectArray.count == 0) return;
    self.selectArray = selectArray;
    [self.collectionView reloadData];
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ProfilePhotoCell class] forCellWithReuseIdentifier:@"ProfilePhotoCell"];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    }
    return _collectionView;
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
