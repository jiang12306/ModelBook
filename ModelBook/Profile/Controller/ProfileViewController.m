//
//  ProfileViewController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileInfoView.h"
#import "ProfileClassifyView.h"
#import "ProfileChildCollectionViewController.h"
#import "Macros.h"
#import "ProfileChildMyJobsController.h"
#import "ProfileUserInfoModel.h"
#import "ProfileAboutMeController.h"
#import "ProfileFollowersController.h"
#import "ProfileAboutMeController.h"
#import "ProfileEditInfoController.h"
#import "WalletViewController.h"
#import "ProgressHUD.h"
#import "ChatViewController.h"
#import "JobCreateViewController.h"
#import "MBProfileHeaderPicController.h"
#import "LoginViewController.h"
#import "MBProfileScrollView.h"
#import "UIView+Alert.h"
#import <KSPhotoBrowser.h>
#import <KSPhotoItem.h>
#import "FollowInfoVC.h"

#define footerBtnWidth (IS_IPHONE320?300:360)

static CGFloat const profileInfoViewHeight = 115;
static CGFloat const classifyViewHeight = 45;
static CGFloat const footerViewHeight = 65;
static CGFloat const footerBtnHeight = 55;

static NSString * const userInfoURL = @"http://39.108.152.114/modeltest/user/query/myinfo";
static NSString * const chatChectURL = @"http://39.108.152.114/modeltest/chat/insert";
static NSString * const bookURL = @"http://39.108.152.114/modeltest/job/book";
static NSString * const cancelBookURL = @"http://39.108.152.114/modeltest/job/apply/cancel";
static NSString * const checkBookURL = @"http://39.108.152.114/modeltest/job/book/checkstate";

@interface ProfileViewController ()<UIScrollViewDelegate>
{
    CGFloat tabbarHeight;
}

/* 用户ID */
@property(nonatomic, strong)NSString *userId;
/* 个人信息 */
@property(nonatomic, strong)ProfileInfoView *profileInfoView;
/* scrollView */
@property(nonatomic, strong)MBProfileScrollView *scrollView;
/* 分类视图 */
@property(nonatomic, strong)ProfileClassifyView *classifyView;
/* 底部视图 */
@property(nonatomic, strong)UIView *footerView;
/* 用户信息 */
@property(nonatomic, strong)ProfileUserInfoModel *userInfoModel;
/* 用户类型 */
@property(nonatomic, assign)ProfileInfoType userInfoType;
/* 预约按钮 */
@property(nonatomic, strong)UIButton *bookBtn;
/* recoreID */
@property(nonatomic, strong)NSString *recordId;

@end

@implementation ProfileViewController

- (instancetype)initWithUserId:(NSString *)userId;
{
    _userId = [NSString stringWithFormat:@"%@",userId];
    return [super init];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.tabBarItem.badgeValue = nil;
}

- (void)initData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserInfo) name:reloadProfileInfoNotification object:nil];
    NSString *userId = [NSString stringWithFormat:@"%ld",[UserInfoManager userID]];
    _userInfoType = ProfileInfoTypeOther;
    if ([_userId isEqualToString:userId]) _userInfoType = ProfileInfoTypeSelf;
    if (!self.tabBarController.tabBar.hidden) tabbarHeight = tabBarHeight;
    [self requestUserInfo];
}

- (void)initLayout
{
    if (_userInfoType == ProfileInfoTypeSelf)
    {
        self.rightBtn.hidden = NO;
        [self.rightBtn setImage:[UIImage imageNamed:@"wallet2"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"wallet2"] forState:UIControlStateSelected];
        [self.rightBtn setImage:[UIImage imageNamed:@"wallet2"] forState:UIControlStateHighlighted];
        if (self.navigationItem.title.length == 0)
        {
            self.navigationItem.title = NSLocalizedString(@"profileTitle", nil);
            if (_initialTabPage == InitialTabPageAboutMe)
            {
                self.navigationItem.title = NSLocalizedString(@"profileAboutMe", nil);
            }
        }
    }
    else
    {
        self.navigationItem.title = NSLocalizedString(@"profileTitle", nil);
        if (_initialTabPage == InitialTabPageAboutMe)
        {
            self.navigationItem.title = NSLocalizedString(@"profileAbout", nil);
        }
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.profileInfoView];
    [self.view addSubview:self.classifyView];
    [self.view addSubview:self.scrollView];
    if (_userInfoType == ProfileInfoTypeOther)
    {
        [self.view addSubview:self.footerView];
        [self bookStateCheckRequest];
    }
    [self initChildViewController];
    if ([self.controllerFrom isEqualToString:@"jobdetail"]) {
        self.footerView.hidden = YES;
    }else {
        self.footerView.hidden = NO;
    }
}

#pragma mark - 子视图
- (void)initChildViewController
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    if (_initialTabPage == InitialTabPageAboutMe)
    {
        ProfileAboutMeController *aboutMe = [[ProfileAboutMeController alloc] initWithTableFrame:frame];
        aboutMe.userId = self.userId;
        [self addChildViewController:aboutMe];
        [_scrollView addSubview:aboutMe.view];
    }
    else
    {
        ProfileChildCollectionViewController *controller1 = [[ProfileChildCollectionViewController alloc] initWithCollectionViewFrame:frame];
        controller1.userId = self.userId;
        controller1.type = dataTypePhoto;
        [self addChildViewController:controller1];
        ProfileChildCollectionViewController *controller2 = [[ProfileChildCollectionViewController alloc] initWithCollectionViewFrame:frame];
        controller2.userId = self.userId;
        controller2.type = dataTypeVideo;
        [self addChildViewController:controller2];
        ProfileChildMyJobsController *controller3 = [[ProfileChildMyJobsController alloc] initWithTableFrame:frame];
        controller3.userId = self.userId;
        [self addChildViewController:controller3];
        [self setUpVc:0];// [self setUpVc:self.initialTabPage];
        self.scrollView.contentOffset = CGPointMake(0, 0); //CGPointMake(self.initialTabPage*screenWidth, 0);
    }
}

/**
 *  设置展示的View
 *
 *  @param index
 */
- (void)setUpVc:(NSInteger)index
{
    /** 获得当前控制器 */
    UIViewController *controller = self.childViewControllers[index];
    if ([controller isKindOfClass:[ProfileChildMyJobsController class]])
    {
        ProfileChildMyJobsController *vc = (ProfileChildMyJobsController *)controller;
        [vc switchToClassifyState];
    }
    controller.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame)*index, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    [_scrollView addSubview:controller.view];
    /* 设置按钮状态 */
    self.classifyView.curIndex = index;
    [self exitEdit];
}

- (void)exitEdit
{
    NSInteger curIndex = self.classifyView.curIndex;
    UIViewController *controller = self.childViewControllers[curIndex];
    if ([controller isKindOfClass:[ProfileChildCollectionViewController class]])
    {
        ProfileChildCollectionViewController *vc = (ProfileChildCollectionViewController *)controller;
        [vc reloadCollectView];
    }
}

#pragma mark - action
- (void)profileInfoButtonAction:(InfoClickType)clickType
{
    switch (clickType) {
        case InfoClickTypeAboutMe: //MARK: 关于我按钮回调
        {
            [self exitEdit];
            
            ProfileViewController *aboutMeVC = [[ProfileViewController alloc] initWithUserId:self.userId];
            aboutMeVC.initialTabPage = InitialTabPageAboutMe;
            aboutMeVC.pushFromMySelf = YES;
            WS(weakSelf);
            aboutMeVC.didSelectedTabPage = ^(NSInteger index) {
                weakSelf.scrollView.contentOffset = CGPointMake(index*screenWidth, 0);
                [weakSelf setUpVc:index];
            };
            aboutMeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutMeVC animated:YES];
        }
            break;
        case InfoClickTypeFollowers:    //MARK: 关注按钮回调
        {
            [self exitEdit];
            [ProgressHUD showText:NSLocalizedString(@"Function temporarily not opened!", nil)];
            
        }
            break;
        case InfoClickTypeAttention:    //MARK: 粉丝按钮回调
        {
            [self exitEdit];
            //            [ProgressHUD showText:NSLocalizedString(@"Function temporarily not opened!", nil)];
            FollowInfoVC * vc = [[FollowInfoVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case InfoClickTypeChat:
        {
            [self exitEdit];
            [self chatCheckRequest];
        }
            break;
        default:
        {
            [self exitEdit];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to log out?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 1)
                {
                    [UserInfoManager claearAllInfo];
                    [[UIApplication sharedApplication] delegate].window.rootViewController = [LoginViewController instantiateNavigationController];
                }
            }];
        }
            break;
    }
}

- (void)rightBtnAction:(UIButton *)btn
{
    NSLog(@"rightBtnAction");
    [self exitEdit];
    
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    [self.navigationController pushViewController:walletVC animated:YES];
}

#pragma mark - 预约、取消预约 按钮响应
- (void)bookAction:(UIButton *)sender
{
    if (sender.selected)
    {
        /* 取消预约 */
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        [md setValue:self.recordId forKey:@"recordId"];
        WS(weakSelf);
        [[NetworkManager sharedManager] requestWithHTTPPath:cancelBookURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"0"])
                {
                    [ProgressHUD showText:NSLocalizedString(@"Cancel the reservation success", nil)];
                    weakSelf.bookBtn.selected = NO;
                }
                else
                {
                    [ProgressHUD showText:NSLocalizedString(@"Cancel the reservation failure", nil)];
                }
            }
            else
            {
                [ProgressHUD showText:NSLocalizedString(@"Cancel the reservation failure", nil)];
            }
        } failure:^(NSError *error) {
            [ProgressHUD showText:NSLocalizedString(@"Cancel the reservation failure", nil)];
        }];
    }
    else
    {
        /* 预约 */
        JobCreateViewController *controller = [JobCreateViewController instantiateJobCreateViewController];
        controller.bookTargetId = self.userId;
        controller.controllerFrom = @"profile";
        controller.userTypeId = self.userInfoModel.userType.userTypeId;
        controller.userTypeName = self.userInfoModel.userType.userTypeName;
        BaseTabBarViewController *vc = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        BaseNavigationViewController *selectedController = (BaseNavigationViewController *)[vc showMainTabBarController:SectionTypeUpload];
        [selectedController setViewControllers:@[controller]];
    }
}

#pragma mark - network
- (void)requestUserInfo
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"currentUserId"];
    [md setValue:self.userId forKey:@"targetUserId"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:userInfoURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                weakSelf.userInfoModel = [[ProfileUserInfoModel alloc] initWithDict:responseObject[@"object"]];
                weakSelf.profileInfoView.userInfoModel = weakSelf.userInfoModel;
                if (weakSelf.initialTabPage == InitialTabPageAboutMe)
                {
                    UIViewController *vc = [weakSelf.childViewControllers firstObject];
                    if ([vc isKindOfClass:[ProfileAboutMeController class]])
                    {
                        ProfileAboutMeController *aboutMeVC = (ProfileAboutMeController *)vc;
                        aboutMeVC.userInfoModel = weakSelf.userInfoModel;
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

- (void)chatCheckRequest
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
    [md setValue:_userId forKey:@"targetUserId"];
    [md setValue:@"bookings" forKey:@"chatType"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:chatChectURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"] || [code isEqualToString:@"60402"])
            {
                ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:weakSelf.userId];
                chatVC.title = weakSelf.userInfoModel.nickname;
                [weakSelf.navigationController pushViewController:chatVC animated:YES];
            }
            else
            {
                [ProgressHUD showText:NSLocalizedString(@"Chat function is temporarily unavailable", nil)];
            }
        }
        else
        {
            [ProgressHUD showText:NSLocalizedString(@"Chat function is temporarily unavailable", nil)];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:NSLocalizedString(@"Chat function is temporarily unavailable", nil)];
    }];
}

- (void)bookStateCheckRequest
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
    [md setValue:_userId forKey:@"targetUserId"];
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:checkBookURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        weakSelf.bookBtn.userInteractionEnabled = YES;
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"60152"])
            {
                /* 存在预约 */
                NSDictionary *object = responseObject[@"object"];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    weakSelf.recordId = object[@"recordId"];
                }
                weakSelf.bookBtn.selected = YES;
            }
        }
    } failure:^(NSError *error) {
        weakSelf.bookBtn.userInteractionEnabled = YES;
    }];
}

#pragma mark - scrollView - delegate
/**
 *  减速完成
 *
 *  @param scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = screenWidth;
    
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > screenWidth * 0.5) {
        /* 往右边移动 */
        offsetX = offsetX + (screenWidth - extre);
        [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else if (extre < screenWidth * 0.5 && extre > 0){
        /* 往左边移动 */
        offsetX =  offsetX - extre;
        [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    /* 获取角标 */
    NSInteger index = offsetX / screenWidth;
    
    /* 添加控制器的view */
    [self setUpVc:index];
}

#pragma mark - lazy
- (ProfileInfoView *)profileInfoView
{
    if (!_profileInfoView) {
        _profileInfoView = [[ProfileInfoView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, profileInfoViewHeight)];
        _profileInfoView.userInfoType = self.userInfoType;
        _profileInfoView.isAboutMe = NO;
        if (_initialTabPage == InitialTabPageAboutMe) _profileInfoView.isAboutMe = YES;
        WS(weakSelf);
        _profileInfoView.profileInfoButtonClicked = ^(InfoClickType clickType) {
            [weakSelf profileInfoButtonAction:clickType];
        };
        _profileInfoView.profileInfoPhotoButtonClicked = ^(UIImageView *imageView) {
            if ((weakSelf.userInfoType == ProfileInfoTypeSelf))
            {
                [weakSelf exitEdit];
                
                MBProfileHeaderPicController *vc = [[MBProfileHeaderPicController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:weakSelf.userInfoModel.headpic]];
                KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
                browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
                browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
                browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
                browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
                browser.bounces = NO;
                [browser showFromViewController:weakSelf];
            }
        };
    }
    return _profileInfoView;
}

- (ProfileClassifyView *)classifyView
{
    if (!_classifyView) {
        _classifyView = [[ProfileClassifyView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.profileInfoView.frame), screenWidth, classifyViewHeight)];
        WS(weakSelf);
        _classifyView.didSelectedIndex = ^(NSInteger index) {
            if (weakSelf.initialTabPage == InitialTabPageAboutMe)
            {
                if (weakSelf.pushFromMySelf)
                {
                    if (weakSelf.didSelectedTabPage) weakSelf.didSelectedTabPage(index);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [weakSelf exitEdit];
                    
                    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:weakSelf.userId];
                    profileVC.initialTabPage = index;
                    [weakSelf.navigationController pushViewController:profileVC animated:YES];
                }
                return;
            }
            weakSelf.scrollView.contentOffset = CGPointMake(index*screenWidth, 0);
            [weakSelf setUpVc:index];
        };
    }
    return _classifyView;
}

- (MBProfileScrollView *)scrollView
{
    if (!_scrollView) {
        NSInteger count = classifyCount;
        CGFloat height = screenHeight-topBarHeight-profileInfoViewHeight-classifyViewHeight-tabbarHeight;
        if (_userInfoType == ProfileInfoTypeOther) height-=footerViewHeight;
        if (_initialTabPage == InitialTabPageAboutMe) count = 0;
        _scrollView = [[MBProfileScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.classifyView.frame), screenWidth, height)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(screenWidth*count, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-topBarHeight-footerViewHeight-tabbarHeight, screenWidth-tabbarHeight, footerViewHeight)];
        
        _bookBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-footerBtnWidth)/2, (footerViewHeight-footerBtnHeight)/2, footerBtnWidth, footerBtnHeight)];
        _bookBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [_bookBtn setTitle:NSLocalizedString(@"profileBook", nil) forState:UIControlStateNormal];
        [_bookBtn setTitle:NSLocalizedString(@"profileCancelBook", nil) forState:UIControlStateSelected];
        [_bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _bookBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        _bookBtn.layer.cornerRadius = 3;
        _bookBtn.userInteractionEnabled = NO;
        [_bookBtn addTarget:self action:@selector(bookAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_bookBtn];
    }
    return _footerView;
}

@end

