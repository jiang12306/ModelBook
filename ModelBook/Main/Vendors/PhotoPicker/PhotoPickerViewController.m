//
//  PhotoPickerViewController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "PhotoCell.h"
#import "Macros.h"
#import "ProgressHUD.h"
#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#define MARGIN 5
#define COL 4

static NSString * const kIdentifierCellID = @"kIdentifierCellID";
static NSString * const kIdentifierFooterID = @"kIdentifierFooterID";

@interface PhotoPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoCellDelegate>

//@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *footLabel;
@property (strong, nonatomic) NSMutableArray<AssetModel *> *selectArray;/** 选择图片数组 */
@property (assign, nonatomic) NSInteger maxCount;/** 最多选择图片数量 */
@property (nonatomic, strong) NSString *resourceName;
/* 保存初始状态栏颜色 */
@property(nonatomic, assign)UIStatusBarStyle statusBarStyle;

@end

@implementation PhotoPickerViewController

- (instancetype)initWithMaxCount:(NSInteger)maxCount selectArray:(NSMutableArray *)selectArray
{
    self = [super init];
    if (self)
    {
        self.maxCount = maxCount;
        for (id obj in selectArray) {
            if ([obj isKindOfClass:[AssetModel class]]) {
                [self.selectArray addObject:obj];
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.resourceName = self.resourceType==SelectResourceTypePhoto?@"照片":@"视频";
    if (self.resourceType==SelectResourceTypeAll) self.resourceName = @"资源";
    self.navigationItem.title = [NSString stringWithFormat:@"选择%@",self.resourceName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    [self setupCollectionView];
    
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

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = MARGIN;
    flowLayout.minimumInteritemSpacing = MARGIN;
    CGFloat cellHeight = (screenWidth - (COL + 1) * MARGIN) / COL;
    flowLayout.itemSize = CGSizeMake(cellHeight, cellHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
    flowLayout.footerReferenceSize = CGSizeMake(screenWidth, 30);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-topBarHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kIdentifierCellID];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kIdentifierFooterID];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

/* 检测照片是否存在 */
- (NSMutableArray *)checkPhotoIsExist
{
    NSMutableArray *newArray = [NSMutableArray array];
    for (AssetModel *model in self.selectArray)
    {
        NSString *url = model.asset.defaultRepresentation.url.absoluteString;
        if (url) [newArray addObject:model];
    }
    return newArray;
}

#pragma mark -  Action
/** 选择完成 */
- (void)done
{
    if ([self.delegate respondsToSelector:@selector(PhotoPickerViewControllerDidSelectPhoto:)])
    {
        [self.delegate PhotoPickerViewControllerDidSelectPhoto:[self checkPhotoIsExist]];
    }
    [self cancel];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierCellID forIndexPath:indexPath];
    cell.delegate = self;
    AssetModel *model = self.photos[indexPath.item];
    cell.model = model;
    cell.selectButton.selected = model.isSelected;
    cell.typeImgView.hidden = YES;
    if ([model.resourceType isEqualToString:ALAssetTypeVideo]) cell.typeImgView.hidden = NO;
    
    for (AssetModel *selectModel in self.selectArray)
    {
        NSString *url = model.asset.defaultRepresentation.url.absoluteString;
        NSString *selectUrl = selectModel.asset.defaultRepresentation.url.absoluteString;
        if ([selectUrl isEqualToString:url])
        {
            model.isSelected = YES;
            cell.selectButton.selected = model.isSelected;
        }
    }
    
    if (!cell.backgroundView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        cell.backgroundView = imageView;
    }
    UIImageView *backView = (UIImageView *)cell.backgroundView;
    backView.image = model.thumbanilImage;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kIdentifierFooterID forIndexPath:indexPath];
        
        self.footLabel.frame = CGRectMake(0, 0, screenWidth, 30);
        NSString *unitStr = @"张";
        if (self.resourceType == SelectResourceTypeVideo) unitStr = @"个";
        NSString *msg = [NSString stringWithFormat:@"共 %lu %@%@",(unsigned long)self.photos.count,unitStr,self.resourceName];
        if (self.photos.count == 0) msg = [NSString stringWithFormat:@"暂无%@",self.resourceName];
        self.footLabel.text = msg;
        [footerView addSubview:self.footLabel];
        return footerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell && cell.model)
    {
        NSMutableArray *items = @[].mutableCopy;
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:(UIImageView *)cell.backgroundView image:[UIImage imageWithCGImage:cell.model.asset.defaultRepresentation.fullScreenImage]];
        [items addObject:item];
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces = NO;
        [browser showFromViewController:self];
    }
}

#pragma mark -  PhotoCellDelegate
- (void)PhotoCell:(PhotoCell *)cell didClickSelectButton:(UIButton *)button
{
    if (!button.selected)
    {
        if (self.selectArray.count >= _maxCount) {
            NSString *unitStr = @"张";
            if (self.resourceType == SelectResourceTypeVideo) unitStr = @"个";
            [ProgressHUD showText:[NSString stringWithFormat:@"最多只能选择%ld%@%@",(long)_maxCount,unitStr,self.resourceName]];
            return;
        }
        [self.selectArray addObject:cell.model];
        cell.model.isSelected = YES;
        [button setSelected:YES];
    }
    else
    {
        for (int i = 0; i<self.selectArray.count; i++) {
            AssetModel *model = self.selectArray[i];
            if ([model.asset.defaultRepresentation.url.absoluteString isEqualToString:cell.model.asset.defaultRepresentation.url.absoluteString]) {
//                [self.selectArray removeObject:model];
                [self.selectArray removeObjectAtIndex:i];
                cell.model.isSelected = NO;
                [button setSelected:NO];
            }
        }
    }
}

#pragma mark -  Lazy init
/** 利用ALAssetsLibrary时候，将得到的ALAsset存到数组里，会出现ALAsset - Type:Unknown, URLs:(null)的问题，就是找不出错误来。
 
 解决方案：初始化ALAssetsLibrary的时候，不要用alloc-init，用一个单例，如下：
 
 + (ALAssetsLibrary *)defaultAssetsLibrary
 {
 static dispatch_once_t pred = 0;
 static ALAssetsLibrary *library = nil;
 dispatch_once(&pred,
 ^{
 library = [[ALAssetsLibrary alloc] init];
 });
 return library;
 } */
- (ALAssetsLibrary *)assetsLibrary
{
    static ALAssetsLibrary *library = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray)
    {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)photos
{
    if (!_photos)
    {
        _photos = [NSMutableArray array];
        /** 遍历所有相册 */
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (!group) return;
            /** 遍历每个相册中的ALAsset */
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                NSString *resourceType = ALAssetTypePhoto;
                if (_resourceType == SelectResourceTypeVideo) resourceType = ALAssetTypeVideo;
                if (_resourceType == SelectResourceTypeAll)
                {
                    if (![assetType isEqualToString:ALAssetTypePhoto] && ![assetType isEqualToString:ALAssetTypeVideo]) {
                        return ;
                    }
                }
                else
                {
                    if (![assetType isEqualToString:resourceType]) return;
                }
                
                AssetModel *model = [[AssetModel alloc] init];
                model.resourceType = assetType;
                model.asset = result;
                model.thumbanilImage = [UIImage imageWithCGImage:result.thumbnail];
                [_photos addObject:model];
            }];
            
            _photos = (NSMutableArray *)[[_photos reverseObjectEnumerator] allObjects];
            [_collectionView reloadData];
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
    return _photos;
}

- (UILabel *)footLabel
{
    if (!_footLabel)
    {
        _footLabel = [[UILabel alloc] init];
        _footLabel.font = [UIFont systemFontOfSize:18];
        _footLabel.textColor = [UIColor lightGrayColor];
        _footLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
