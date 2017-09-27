//
//  ProfileFollowersController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileFollowersController.h"
#import "ProfileFollowerClassifyView.h"
#import "ProfileFollowersChildController.h"

static CGFloat const classifyViewHeight = 35;

@interface ProfileFollowersController ()<UIScrollViewDelegate>

/* scrollView */
@property(nonatomic, strong)UIScrollView *scrollView;
/* 导航栏 */
@property(nonatomic, strong)ProfileFollowerClassifyView *classifyView;

@end

@implementation ProfileFollowersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.navigationItem.title = NSLocalizedString(@"profileFollowers", nil);
    [self.view addSubview:self.classifyView];
    [self.view addSubview:self.scrollView];
    [self initChildViewController];
}

- (void)initChildViewController
{
    CGRect frame = CGRectMake(0, classifyViewHeight, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    ProfileFollowersChildController *controller1 = [[ProfileFollowersChildController alloc] initWithTableFrame:frame followType:ProfileFollowTypeFollowers];
    [self addChildViewController:controller1];
    ProfileFollowersChildController *controller2 = [[ProfileFollowersChildController alloc] initWithTableFrame:frame followType:ProfileFollowTypeFollowing];
    [self addChildViewController:controller2];
    
    [self setUpVc:self.initialTabPage];
    self.scrollView.contentOffset = CGPointMake(self.initialTabPage*screenWidth, 0);
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
    controller.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame)*index, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    [_scrollView addSubview:controller.view];
    /* 设置按钮状态 */
    self.classifyView.curIndex = index;
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
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.classifyView.frame), screenWidth, screenHeight-topBarHeight-classifyViewHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(screenWidth*classifyCount, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (ProfileFollowerClassifyView *)classifyView
{
    if (!_classifyView) {
        _classifyView = [[ProfileFollowerClassifyView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, classifyViewHeight)];
        WS(weakSelf);
        _classifyView.didSelectedIndex = ^(NSInteger index) {
            weakSelf.scrollView.contentOffset = CGPointMake(index*screenWidth, 0);
            [weakSelf setUpVc:index];
        };
    }
    return _classifyView;
}

@end
