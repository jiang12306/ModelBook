//
//  ProfileChildCollectionViewController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileChildCollectionViewController.h"
#import "ProfilePhotoCell.h"
#import "ProfileResourceModel.h"
#import <MJRefresh.h>
#import "UIColor+Ext.h"
#import <KSPhotoBrowser.h>
#import <KSPhotoItem.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIView+Alert.h"
#import "ProgressHUD.h"

static NSString * const queryPhotoURL = @"http://39.108.152.114/modeltest/album/query";

static NSInteger const count = 3;
static NSString * const kProfilePhotoCellIdentifier = @"kProfilePhotoCellIdentifier";

@interface ProfileChildCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProfilePhotoCellDelegate>

/* collectionView frame */
@property(nonatomic, assign)CGRect frame;
/* collection */
@property(nonatomic, strong)UICollectionView *collectionView;
/* 数据源 */
@property(nonatomic, strong)NSMutableArray *dataSource;
/* 页码 */
@property(nonatomic, assign)NSInteger pageNum;
/* 是否继续加载更多 */
@property(nonatomic, assign)BOOL isContinue;
/* 缺省 */
@property(nonatomic, strong)UIView *defaultView;
/* 铺满需要的数量 */
@property(nonatomic, assign)NSInteger minCount;
/* 是否编辑模式 */
@property(nonatomic, assign)BOOL isEditing;

@end

@implementation ProfileChildCollectionViewController

- (instancetype)initWithCollectionViewFrame:(CGRect)frame
{
    _isContinue = YES;
    _pageNum = 1;
    _frame = frame;
    _minCount = round(CGRectGetHeight(frame)/(CGRectGetWidth(frame)/3))*3;
    return [super init];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
}

- (void)initData
{
    [self requestPhotoList];
}

- (void)reloadCollectView
{
    if (self.isEditing)
    {
        self.isEditing = NO;
        [self.collectionView reloadData];
    }
}

- (void)initLayout
{
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.collectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:reloadPohtoNotification object:nil];
}

- (void)reloadData
{
    [_dataSource removeAllObjects];
    _isContinue = YES;
    _pageNum = 1;
    [self requestPhotoList];
}

#pragma mark - network
- (void)requestPhotoList
{
    if (!self.isContinue) return;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:self.userId forKey:@"userId"];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)self.type] forKey:@"fileType"];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum] forKey:@"pageNum"];
    [md setValue:@"12" forKey:@"pageSize"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:queryPhotoURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                ProfileResourceModel *model = [[ProfileResourceModel alloc] initWithDict:responseObject[@"object"]];
                [weakSelf.dataSource addObjectsFromArray:model.resourceInfo];
                [weakSelf.collectionView reloadData];
                weakSelf.isContinue = model.hasNextPage;
                if (!weakSelf.isContinue)
                {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    if (weakSelf.pageNum == 1) weakSelf.collectionView.mj_footer = nil;
                }
                else if (weakSelf.pageNum == 1)
                {
                    weakSelf.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(requestPhotoList)];
                }
                weakSelf.pageNum++;
            }
        }
        [weakSelf handlerRequestData];
    } failure:^(NSError *error) {
        [weakSelf handlerRequestData];
    }];
}

- (void)deleteResource:(NSString *)albumIds
{
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/album/delete_batch" parameters:@{@"albumIds":albumIds} constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:NSLocalizedString(@"Delete Success", nil)];
                [weakSelf reloadData];
            }
            else
            {
                [ProgressHUD showText:responseObject[@"msg"]];
            }
        }
        else
        {
            [ProgressHUD showText:NSLocalizedString(@"Delete Failure", nil)];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:NSLocalizedString(@"Delete Failure", nil)];
    }];
}

- (void)handlerRequestData
{
    //    self.collectionView.hidden = NO;
    //    if (self.dataSource.count == 0) self.collectionView.hidden = YES;
}

#pragma mark - uicollection - datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count<_minCount?_minCount:self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfilePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProfilePhotoCellIdentifier forIndexPath:indexPath];
    if (indexPath.row<self.dataSource.count)
    {
        ResourceItem *item = self.dataSource[indexPath.row];
        [cell handlerCellWithModel:item index:indexPath.row isEditing:self.isEditing];
        cell.delegate = self;
    }
    else
    {
        [cell handlerCellWithDefaultImage];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = screenWidth/count;
    return CGSizeMake(cellHeight, cellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEditing)
    {
        [self reloadCollectView];
        return;
    }
    
    if (indexPath.row<self.dataSource.count && !_isEditing)
    {
        if (self.type == dataTypePhoto)
        {
            NSMutableArray *items = @[].mutableCopy;
            for (int i = 0; i < _dataSource.count; i++) {
                ProfilePhotoCell *cell = (ProfilePhotoCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                ResourceItem *model = self.dataSource[i];
                NSString *url = model.fileSrc;
                
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imgView imageUrl:[NSURL URLWithString:url]];
                [items addObject:item];
            }
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
            browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
            browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
            browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
            browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
            browser.bounces = NO;
            [browser showFromViewController:self];
        }
        else
        {
            ResourceItem *model = self.dataSource[indexPath.row];
            NSURL *url = [NSURL URLWithString:model.fileSrc];
            AVPlayer *player = [AVPlayer playerWithURL:url];
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            playerViewController.player = player;
            [self presentViewController:playerViewController animated:YES completion:nil];
            [playerViewController.player play];
        }
    }
}

- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    self.isEditing = YES;
    [self.collectionView reloadData];
}

#pragma mark - ProfilePhotoCellDelegate
- (void)deleteItem:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to delete this resource?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    WS(weakSelf);
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            ResourceItem *model = self.dataSource[index];
            [weakSelf deleteResource:model.albumId];
        }
    }];
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ProfilePhotoCell class] forCellWithReuseIdentifier:kProfilePhotoCellIdentifier];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
        if ([self.userId isEqualToString:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]])
        {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(handleLongPressed:)];
            longPress.minimumPressDuration = 1.0;
            [_collectionView addGestureRecognizer:longPress];
        }
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [[UIView alloc] initWithFrame:self.frame];
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame)-30)/2, CGRectGetWidth(self.frame), 30)];
        msgLabel.text = NSLocalizedString(@"Temporarily no data", nil);
        msgLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        msgLabel.font = [UIFont systemFontOfSize:16];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:msgLabel];
    }
    return _defaultView;
}

@end
