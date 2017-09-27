//
//  NetworkManager.m
//  OrderTracking
//
//  Created by zdjt on 2017/4/5.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "NetworkManager.h"
#import "Macros.h"

@implementation NetworkManager

+ (NetworkManager *)sharedManager
{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initWithBaseURL:[NSURL URLWithString:NETWORK_SERVER_DOMAIN]
                                   sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; // 创建session对象
        sharedInstance.requestSerializer.timeoutInterval = 30.f; // 设置请求超时
        sharedInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                                    @"text/plain",
                                                                    @"application/json",
                                                                    @"text/json",
                                                                    nil]; // 添加类型到可接收内容类型中
        sharedInstance.securityPolicy.allowInvalidCertificates = YES; // 允许无效的SSL证书
    });
    return sharedInstance;
}

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
                    failure:(void(^)(NSError *error))failure
{
    [[NetworkManager sharedManager] POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (constructingBodyBlock) constructingBodyBlock(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
}

@end
