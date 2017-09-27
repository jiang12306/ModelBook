//
//  Macros.h
//  ModelBook
//
//  Created by zdjt on 2017/8/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

typedef NS_ENUM(NSInteger, payType) {
    payTypeAliPay,
    payTypeBalance
};

//@{@"1":@"我发起",@"2":@"被邀请",@"3":@"被邀请已确认",@"4":@"被邀请已取消",@"5":@"我申请等待",@"6":@"我申请拒绝",@"7":@"我申请确认",@"8":@"进行中",@"9":@"已完成",@"10":@"已支付",@"11":@"已评价",@"12":@"已过期",@"13":@"已隐藏",@"14":@"我申请取消待处理",@"15":@"对方申请取消待处理"}

typedef NS_ENUM(NSInteger, MBJobState) {
    /* 默认 */
    MBJobStateNomal = 0,
    /* 我发起的 */
    MBJobStateCreate = 1,
    /* 被邀请的 */
    MBJobStateInvite,
    /* 被邀请已确认 */
    MBJobStateInviteConfirm,
    /* 被邀请已取消 */
    MBJobStateInviteCancel,
    /* 我申请等待 */
    MBJobStateApplyWait,
    /* 我申请拒绝 */
    MBJobStateApplyReject,
    /* 我申请确认 */
    MBJobStateApplyConfirm,
    /* 进行中 */
    MBJobStateProgress,
    /* 已完成 */
    MBJobStateComplete,
    /* 已支付 */
    MBJobStatePaid,
    /* 已评价 */
    MBJobStateEvaluate,
    /* 已过期 */
    MBJobStateOverdue,
    /* 已隐藏 */
    MBJobStateHidden,
    /* 我申请取消待处理 */
    MBJobStateMyCancelWait,
    /* 对方申请取消待处理 */
    MBJobStateCancelWait,
};

// 服务器地址
#define NETWORK_SERVER_DOMAIN @"http://39.108.152.114/modeltest/"

#define screenWidth CGRectGetWidth([UIScreen mainScreen].bounds) // 屏幕宽度

#define screenHeight CGRectGetHeight([UIScreen mainScreen].bounds) // 屏幕高度

#define topBarHeight 64
#define tabBarHeight 49

// 联系客服
#define CALL_CUSTOMER_CARE [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://12345"]]

// 以屏幕短的一边为X
#define PortraitX MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

// 以屏幕长的一边为Y
#define PortraitY MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

// 适配X方向长度，基准屏幕宽度375
#define Adapter_X(w) ((w) * (PortraitX / 375.0f))

// 适配Y方向长度，基准屏幕高度568，当屏幕高度于568时，按照568进行适配
#define Adapter_Y(h) (PortraitY < 667.0f ? ((h) * (PortraitY / 667.0f)) : (h))

#define IS_IPHONE4          CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960))
#define IS_IPHONE5          CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136))
#define IS_IPHONE6          CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(750, 1334))
#define IS_IPHONE6p         CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(1242, 2208))
#define IS_IPHONE320        [[UIScreen mainScreen] preferredMode].size.width == 640

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self

#define userTypeDic @{@"1":@"摄影师/化妆师",@"2":@"化妆师",@"3":@"模特",@"4":@"网红",@"5":@"公司",@"6":@"中模",@"7":@"外模"}
#define myJobListClassifyDic @{@"0":@"我发起",@"1":@"我申请",@"2":@"被邀请",@"3":@"进行中",@"4":@"已完成",@"5":@"已取消",@"6":@"已过期"}

#define chargeTypeDic @{@"0":@"元/时",@"1":@"元/天"}

#define jobStatusDic @{@"1":@"我发起",@"2":@"被邀请",@"3":@"被邀请已确认",@"4":@"被邀请已取消",@"5":@"申请等待中",@"6":@"申请已拒绝",@"7":@"申请已确认",@"8":@"进行中",@"9":@"已完成",@"10":@"已支付",@"11":@"已评价",@"12":@"已过期",@"13":@"已隐藏",@"14":@"已取消",@"15":@"对方已取消"}

#define chargeTypeStr(type) [chargeTypeDic objectForKey:type]

#define userTypeStr(type) [userTypeDic objectForKey:type]

#define jobTypeStr(type) [jobStatusDic objectForKey:type]

#define myJobListClassifyDicStr(type) [myJobListClassifyDic objectForKey:type]

#define blank @""

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#endif /* Macros_h */
