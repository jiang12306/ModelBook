//
//  UIViewController+Network.m
//  OrderTracking
//
//  Created by zdjt on 2017/4/5.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UIViewController+Network.h"
#import "Macros.h"
#import "CustomHudView.h"

@implementation UIViewController (Network)
/**
 网络请求
 
 @param path 路径
 @param params 参数
 @param progress 进度
 @param show 是否显示hud
 @param constructingBody 上传
 @param success 请求成功
 @param failure 请求失败
 */
- (void)networkWithPath:(NSString *)path
             parameters:(NSDictionary *)params
                showHud:(BOOL)show
       constructingBody:(void(^)(id<AFMultipartFormData> formData))constructingBodyBlock
               progress:(void(^)(NSProgress *uploadProgress))progress
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure
{
    // 显示加载状态
    __block CustomHudView *hud;
    if (show) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud = [CustomHudView showLoading];
        });
    }
    [[NetworkManager sharedManager] requestWithHTTPPath:path parameters:params constructingBody:^(id<AFMultipartFormData> formData) {
        if (constructingBodyBlock) constructingBodyBlock(formData);
    } progress:^(NSProgress *uploadProgress) {
        if (progress) progress(uploadProgress);
    } success:^(id responseObject) {
        if (hud) [hud hide:YES];
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (hud) [hud hide:YES];
        [CustomHudView showWithTip:@"请检查网络设置后重试"];
        if (failure) failure(error);
    }];
}

/**
 网络请求
 
 @param path 路径
 @param params 参数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)networkWithPath:(NSString *)path
             parameters:(NSDictionary *)params
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure
{
    [self networkWithPath:path parameters:params showHud:YES constructingBody:nil progress:nil success:success failure:failure];
}

/**
 网络请求
 
 @param path 路径
 @param params 参数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)networkWithPathWithoutHud:(NSString *)path
             parameters:(NSDictionary *)params
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure
{
    [self networkWithPath:path parameters:params showHud:NO constructingBody:nil progress:nil success:success failure:failure];
}

@end
