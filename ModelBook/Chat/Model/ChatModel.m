//
//  ChatModel.m
//  ModelBook
//
//  Created by zdjt on 2017/8/17.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ChatModel.h"

@implementation UserType

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userTypeId":@"userTypeId",
             @"userTypeName":@"userTypeName"
             };
}

@end

@implementation TargetUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId":@"userId",
             @"phone":@"phone",
             @"nickname":@"nickname",
             @"userTypeId":@"userTypeId",
             @"userType":@"userType",
             @"likes":@"likes",
             @"headpic":@"headpic"
             };
}

+(NSValueTransformer *)userTypeJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[UserType class]];
}

@end

@implementation ChatModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"chatId":@"chatId",
             @"userId":@"userId",
             @"targetUserId":@"targetUserId",
             @"targetUser":@"targetUser",
             @"chatTime":@"chatTime",
             @"endTime":@"endTime",
             @"chatType":@"chatType",
             };
}

+(NSValueTransformer *)targetUserJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[TargetUser class]];
}

@end
