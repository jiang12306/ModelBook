//
//  NetworkManager.h
//  OrderTracking
//
//  Created by zdjt on 2017/4/5.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager *)sharedManager;

/**
 网络请求
 
 @param path 路径
 @param params 参数
 @param constructingBody 上传
 @param progress 进度
 @param success 请求成功
 @param failure 请求失败
 */
- (void)requestWithHTTPPath:(NSString *)path
                 parameters:(NSDictionary *)params
           constructingBody:(void(^)(id<AFMultipartFormData> formData))constructingBodyBlock
                   progress:(void(^)(NSProgress *uploadProgress))progress
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

@end
