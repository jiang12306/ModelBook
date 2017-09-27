//
//  UIViewController+Network.h
//  OrderTracking
//
//  Created by zdjt on 2017/4/5.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface UIViewController (Network)
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
                failure:(void(^)(NSError *error))failure;

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
                failure:(void(^)(NSError *error))failure;

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
                          failure:(void(^)(NSError *error))failure;

@end
