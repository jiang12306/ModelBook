//
//  Handler.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "Handler.h"
#import "Macros.h"

@implementation Handler

/**
 根据内容获取文字宽度

 @param string 文本内容
 @param width 最大宽度
 @param font 字体
 @return 文字宽度
 */
+ (CGFloat)widthForString:(NSString *)string width:(CGFloat)width FontSize:(UIFont *)font
{
    CGRect rect =[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

/**
 获取文本高度

 @param string 文本
 @param width 最大宽度
 @param font 字体
 @return 文本高度
 */
+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width FontSize:(UIFont *)font
{
    CGRect rect =[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}

/** 时间戳转日期字符串 */
+ (NSString *)dateStrFromCstampTime:(NSString *)timeStamp
                     withDateFormat:(NSString *)format
{
    NSString *time = timeStamp;
    if (time.length>10) time = [time substringToIndex:10];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    return [self datestrFromDate:date withDateFormat:format];
}

/** 日期转日期字符串*/
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

/**
 处理工作时长
 
 @param beginTime 开始时间
 @param endTime 结束时间
 @param chargeType 类型：时薪/日薪
 @return 时长
 */
+ (int)handlerJobTime:(NSString *)beginTime endTime:(NSString *)endTime chargeType:(NSString *)chargeType
{
    /* 计算时长 */
    NSString *beginTimeStr = beginTime;
    if (beginTimeStr.length>13) beginTimeStr = [beginTimeStr substringToIndex:13];
    NSString *endTimeStr = endTime;
    if (endTimeStr.length>13) endTimeStr = [endTimeStr substringToIndex:13];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH"];
    NSDate *beginDate = [dateformatter dateFromString:beginTimeStr];
    NSDate *endDate = [dateformatter dateFromString:endTimeStr];
    
    NSTimeInterval begin = [beginDate timeIntervalSince1970];
    NSTimeInterval end = [endDate timeIntervalSince1970];
    
    NSTimeInterval time = end-begin;
    if ([chargeType isEqualToString:@"1"])
    {
        /* 日薪 */
        return ceil(time/(3600*24));
    }
    else
    {
        /* 时薪 */
        return ceil(time/3600);
    }
}

/**
 处理显示用户类型（摄影师/化妆师=12，模特=3，网红=4）
 
 @param userType 用户类型字符串
 @return 处理过后的字符串
 */
+ (NSString *)handlerUserTypeStr:(NSString *)userType
{
    NSString *userTypeStr = userType;
    for (NSString *str in [userTypeDic allKeys]) {
        userTypeStr = [userTypeStr stringByReplacingOccurrencesOfString:str withString:userTypeStr(str)];
    }
    return userTypeStr;
}

/* 获取当前屏幕显示的viewcontroller */
+ (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

/**
 *  将数组转化为json字符串
 *
 *  @return json字符串
 */
- (NSString *)convertToJson:(NSArray *)array
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) return nil;
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(NSData*)imageCompress:(UIImage*)image
{
    
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    float size=[imageData length]/1024;
    if (size<=200)
    {
        return UIImageJPEGRepresentation(image, 1) ;
    }
    else if (size>=200&&size<=1000)
    {
        return UIImageJPEGRepresentation(image, 0.5) ;
    }
    else if(size>1000)
    {
        return UIImageJPEGRepresentation(image, 0.05) ;
    }
    return nil;
}

@end
