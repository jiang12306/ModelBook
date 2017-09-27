//
//  ProgressHUD.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

/** 请求状态  */
typedef NS_ENUM(NSInteger, ProgressHUDStatus) {
    
    /** 成功 */
    ProgressHUDStatusSuccess,
    
    /** 失败 */
    ProgressHUDStatusError,
    
    /** 信息 */
    ProgressHUDStatusInfo,
    
    /** 加载中 */
    ProgressHUDStatusWaitting
};

@interface ProgressHUD : MBProgressHUD

/** 返回一个HUD的单例 */
+ (instancetype)sharedHUD;

/**
 *  提示
 *
 *  @param status 状态
 *  @param text   内容
 */
+ (void)showStatus:(ProgressHUDStatus)status text:(NSString *)text;

#pragma mark - 建议使用的方法

/** 在window上添加一个只显示文字的HUD */
+ (void)showText:(NSString *)text;
/**
 *  提示
 *
 *  @param text  内容
 *  @param block 关闭回调
 */
+ (void)showText:(NSString *)text block:(dispatch_block_t)block;
/**
 *  显示提示
 *
 *  @param text  内容
 *  @param delay 展示时间
 *  @param block 关闭提示回调
 */
+ (void)showText:(NSString *)text delay:(NSTimeInterval)delay block:(dispatch_block_t)block;

#pragma mark - 状态
/** 在window上添加一个提示`信息`的HUD */
+ (void)showInfoText:(NSString *)text;
/** 在window上添加一个提示`失败`的HUD */
+ (void)showFailureText:(NSString *)text;
/** 在window上添加一个提示`成功`的HUD */
+ (void)showSuccessText:(NSString *)text;
/** 在window上添加一个提示`加载中`的HUD, 需要手动关闭 */
+ (void)showLoadingText:(NSString *)text;
/** 手动隐藏HUD */
+ (void)hide;


@end
