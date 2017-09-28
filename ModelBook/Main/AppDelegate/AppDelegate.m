//
//  AppDelegate.m
//  ModelBook
//
//  Created by zdjt on 2017/8/7.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EAIntroView.h"
#import <Masonry.h>
#import "UIColor+Ext.h"
#import "SMPageControl.h"
#import "UIImage+Ext.h"
#import "Const.h"
#import <UMSocialCore/UMSocialCore.h>
#import <RongIMKit/RongIMKit.h>
#import "UploadViewController.h"
#import "JobsViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ChatViewController.h"
#import "NetworkManager.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "ChatListViewController.h"
#import "ProfileViewController.h"
#import "TuSDKFramework.h"

@interface AppDelegate () <UITabBarControllerDelegate, UNUserNotificationCenterDelegate, RCIMReceiveMessageDelegate>

@property (strong, nonatomic) EAIntroView *introView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([UserInfoManager isLogin].intValue == 1) {
        BaseTabBarViewController *controller = [BaseTabBarViewController instantiateTabBarController];
        controller.delegate = self;
        self.window.rootViewController = controller;
    }else {
        self.window.rootViewController = [LoginViewController instantiateNavigationController];
    }
    // 2.显示窗口
    [self.window makeKeyAndVisible];
    // 3.设置根控制器
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 放大imageView
    NSString *imageName = @"";
    if (IS_IPHONE4) {
        imageName = @"iphone4";
    }else if (IS_IPHONE5) {
        imageName = @"iphone5";
    }else if (IS_IPHONE6) {
        imageName = @"iphoneNormal";
    }else {
        imageName = @"iphonePlus";
    }
    UIImageView *scaleImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scaleImageView.image = [UIImage imageNamed:imageName];
    [self.window addSubview:scaleImageView];
    [UIView animateWithDuration:2 animations:^{
        scaleImageView.transform = CGAffineTransformScale(scaleImageView.transform, 1.25f, 1.25f);
    } completion:^(BOOL finished) {
        [scaleImageView removeFromSuperview];
        
        if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
            
        } else { // 这次打开的版本和上一次不一样，显示新特性
            // 3.1显示新特性
            [self showIntroView];
            // 3.2将当前的版本号存进沙盒
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
    
    // 又拍云短视频
    /**
     *  初始化SDK，应用密钥是您的应用在 TuSDK 的唯一标识符。每个应用的包名(Bundle Identifier)、密钥、资源包(滤镜、贴纸等)三者需要匹配，否则将会报错。
     *
     *  @param appkey 应用秘钥 (请前往 http://tusdk.com 申请秘钥)
     */
    [TuSDK initSdkWithAppKey:@"e17b36fa25069ac1-00-nvyfr1"];
    /**
     *  指定开发模式,需要与lsq_tusdk_configs.json中masters.key匹配， 如果找不到devType将默认读取master字段
     *  如果一个应用对应多个包名，则可以使用这种方式来进行集成调试。
     */
    //     [TuSDK initSdkWithAppKey:@"30f2fe79726dfb83-01-dmlup1" devType:@"debug"];
    
    // 设置友盟appkey
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59a4e170e88bad4c77000ad1"];
    [UMessage setBadgeClear:YES];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    // 融云
    [[RCIM sharedRCIM] initWithAppKey:@"pwe86ga5phmm6"];
    
    // 连接融云
    if ([UserInfoManager isLogin].intValue == 1) {
        [[RCIM sharedRCIM] connectWithToken:[UserInfoManager token] success:^(NSString *userId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RCIM sharedRCIM] setCurrentUserInfo:[[RCUserInfo alloc] initWithUserId:userId name:[UserInfoManager userName] portrait:[UserInfoManager headpic]]];
            });
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            
        }];
    }
    
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE)];
    
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    
    // 接收消息代理
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    
    // UM
    [UMessage startWithAppkey:@"59a4e170e88bad4c77000ad1" launchOptions:launchOptions httpsEnable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    return YES;
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx51a06f8c96d162cb" appSecret:@"ff2a216c593975c899949ea617531578" redirectURL:nil];
    
}

- (void)confitUShareSettings
{
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

/** 展示引导页 */
- (void)showIntroView
{
    NSArray *images = @[@"bg1", @"bg2", @"bg3", @"bg4"];
    NSMutableArray *pages = [NSMutableArray array];
    for (int i = 0; i < images.count; i++) {
        UIView *pageView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        pageView.backgroundColor = [UIColor whiteColor];
        
        // 下一页
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:15.f];
        if (i == images.count - 1) {
            [nextButton setTitle:NSLocalizedString(@"introTextB", nil) forState:UIControlStateNormal];
        }else {
            [nextButton setTitle:NSLocalizedString(@"introTextA", nil) forState:UIControlStateNormal];
        }
        nextButton.layer.cornerRadius = 3.f;
        nextButton.layer.masksToBounds = YES;
        [nextButton addTarget:self action:@selector(nextButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [pageView addSubview:nextButton];
        [nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(pageView.mas_bottom).offset(-30.f);
            make.height.mas_equalTo(50.f);
            //            if (i == 0) {
            //                make.left.equalTo(pageView.mas_left).offset(5.f);;
            //                make.right.equalTo(pageView.mas_right).offset(-5.f);
            //            }else {
            make.left.equalTo(pageView.mas_left).offset(34.f);
            make.right.equalTo(pageView.mas_right).offset(-34.f);
            //            }
        }];
        
        // 图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        //        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:images[i]];
        [pageView addSubview:imageView];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pageView.mas_top).offset(20);
            //            if (i == 0) {
            //                make.left.equalTo(pageView.mas_left).offset(5.f);
            //                make.right.equalTo(pageView.mas_right).offset(-5.f);
            //                make.bottom.equalTo(pageView.mas_bottom).offset(-85.f);
            //            }else {
            make.left.equalTo(pageView.mas_left).offset(34.f);
            make.right.equalTo(pageView.mas_right).offset(-34.f);
            make.bottom.equalTo(pageView.mas_bottom).offset(-105.f);
            //            }
        }];
        
        EAIntroPage *page = [EAIntroPage pageWithCustomView:pageView];
        [pages addObject:page];
    }
    
    
    // pageControl
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xD6FAFF];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0xA9D7FD];
    [pageControl sizeToFit];
    
    self.introView = [[EAIntroView alloc] initWithFrame:self.window.bounds];
    [self.introView setPages:pages];
    self.introView.skipButton.hidden = YES;
    self.introView.tapToNext = NO;
    self.introView.pageControl = (UIPageControl *)pageControl;
    self.introView.pageControlY = 110;
    
    [self.introView showInView:[UIApplication sharedApplication].keyWindow animateDuration:0.0f withInitialPageIndex:0];
}

- (void)nextButtonEvent
{
    [self.introView goNextPage];
}

- (void)switchRootViewController
{
    BaseTabBarViewController *controller = [BaseTabBarViewController instantiateTabBarController];
    controller.delegate = self;
    self.window.rootViewController = controller;
}

- (void)switchRootViewControllerWithSection:(SectionType)sectionType
{
    BaseTabBarViewController *controller = [BaseTabBarViewController instantiateTabBarController];
    controller.delegate = self;
    self.window.rootViewController = controller;
    controller.selectedIndex = SectionTypeChat;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:alipayOrderPaySuccessNotification object:nil userInfo:@{@"resultStatus":[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]]}];
        }];
    }
    return  [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                                             withString:@""]
                        stringByReplacingOccurrencesOfString:@">"
                        withString:@""]
                       stringByReplacingOccurrencesOfString:@" "
                       withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self userInfoHandle:userInfo];
    
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self userInfoHandle:userInfo];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self userInfoHandle:notification.userInfo];
}

- (void)userInfoHandle:(NSDictionary *)userInfo
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) return;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    if ([userInfo.allKeys containsObject:@"rc"]) {
        NSDictionary *rcDict = userInfo[@"rc"];
        NSString *targetid = rcDict[@"fId"];
        [UserInfoManager setTargetid:targetid];
        
        UIViewController *controller = self.window.rootViewController;
        if ([controller isKindOfClass:[BaseTabBarViewController class]]) {
            BaseTabBarViewController *vc = (BaseTabBarViewController *)controller;
            vc.selectedIndex = 3;
        }
    }else {
        NSString *recordId = userInfo[@"recordId"];
        NSDictionary *apsDict = userInfo[@"aps"];
        NSString *badge = apsDict[@"badge"];
        if ([self.window.rootViewController isKindOfClass:[BaseTabBarViewController class]]) {
            BaseTabBarViewController *controller = (BaseTabBarViewController *)self.window.rootViewController;
            [[controller.tabBar.items objectAtIndex:4] setBadgeValue:badge];
        }
        NSLog(@"-----%@",recordId);
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if TARGET_IPHONE_SIMULATOR
    // 模拟器不能使用远程推送
#else
    NSLog(@"获取DeviceToken失败！！！");
    NSLog(@"ERROR：%@", error);
#endif
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    BaseNavigationViewController *controller = (BaseNavigationViewController *)viewController;
    if (tabBarController.selectedIndex == 1) {
        if (![controller.viewControllers.firstObject isKindOfClass:[JobsViewController class]]) {
            BaseNavigationViewController *selectedController = (BaseNavigationViewController *)viewController;
            [selectedController setViewControllers:@[[JobsViewController instantiateJobsViewController]]];
        }
    }else if (tabBarController.selectedIndex == 2) {
//        if (![controller.viewControllers.firstObject isKindOfClass:[UploadViewController class]]) {
//            UploadViewController *uploadVC = [[UploadViewController alloc] init];
//            BaseNavigationViewController *selectedController = (BaseNavigationViewController *)viewController;
//            [selectedController setViewControllers:@[uploadVC]];
//        }
    }else if (tabBarController.selectedIndex == 4) {
        if (![controller.viewControllers.firstObject isKindOfClass:[ProfileViewController class]]) {
            ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]];
            profileVC.navigationItem.title = NSLocalizedString(@"profileAboutMe", nil);
            BaseNavigationViewController *selectedController = (BaseNavigationViewController *)viewController;
            [selectedController setViewControllers:@[profileVC]];
        }
    }
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:alipayOrderPaySuccessNotification object:nil userInfo:@{@"resultStatus":[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]]}];
        }];
    }
    return [[UMSocialManager defaultManager]  handleOpenURL:url options:options];;
}

#pragma mark - RCIMReceiveMessageDelegate

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    
    RCUserInfo *info = message.content.senderUserInfo;
    [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:info.userId];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UserInfoManager setTargetid:info.userId];
                UIViewController *controller = self.window.rootViewController;
                if ([controller isKindOfClass:[BaseTabBarViewController class]]) {
                    BaseTabBarViewController *vc = (BaseTabBarViewController *)controller;
                    vc.selectedIndex = 3;
                }
            });
            
        }
    }
    //    NSLog(@"-----%@---%@---%@-----%d",info.userId, info.name, info.portraitUri, left);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
    };
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 角标清零
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end

