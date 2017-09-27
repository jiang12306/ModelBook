//
//  ProfileUserInfoModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileUserInfoModel.h"

@implementation ProfileUserInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.address = [NSString stringWithFormat:@"%@",dict[@"address"]];
        self.age = [NSString stringWithFormat:@"%@",dict[@"age"]];
        self.birthday = [NSString stringWithFormat:@"%@",dict[@"birthday"]];
        self.dayRate = [NSString stringWithFormat:@"%@",dict[@"dayRate"]];
        self.fieldId = [NSString stringWithFormat:@"%@",dict[@"fieldId"]];
        self.headpic = [NSString stringWithFormat:@"%@",dict[@"headpic"]];
        self.height = [NSString stringWithFormat:@"%@",dict[@"height"]];
        self.hourRate = [NSString stringWithFormat:@"%@",dict[@"hourRate"]];
        self.idcardName = [NSString stringWithFormat:@"%@",dict[@"idcardName"]];
        self.idcardNumber = [NSString stringWithFormat:@"%@",dict[@"idcardNumber"]];
        self.money = [NSString stringWithFormat:@"%@",dict[@"money"]];
        self.nickname = [NSString stringWithFormat:@"%@",dict[@"nickname"]];
        self.password = [NSString stringWithFormat:@"%@",dict[@"password"]];
        self.phone = [NSString stringWithFormat:@"%@",dict[@"phone"]];
        self.registerTime = [NSString stringWithFormat:@"%@",dict[@"registerTime"]];
        self.sex = [NSString stringWithFormat:@"%@",dict[@"sex"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.userTypeId = [NSString stringWithFormat:@"%@",dict[@"userTypeId"]];
        self.weight = [NSString stringWithFormat:@"%@",dict[@"weight"]];
        self.point = [NSString stringWithFormat:@"%@",dict[@"point"]];
        self.canChat = [dict[@"canChat"] boolValue];
        
        if ([self.address isEqualToString:@"(null)"]) self.address = @"";
        if ([self.age isEqualToString:@"(null)"]) self.age = @"";
        if ([self.birthday isEqualToString:@"(null)"]) self.birthday = @"";
        if ([self.dayRate isEqualToString:@"(null)"]) self.dayRate = @"";
        if ([self.fieldId isEqualToString:@"(null)"]) self.fieldId = @"";
        if ([self.headpic isEqualToString:@"(null)"]) self.headpic = @"";
        if ([self.height isEqualToString:@"(null)"]) self.height = @"";
        if ([self.hourRate isEqualToString:@"(null)"]) self.hourRate = @"";
        if ([self.idcardName isEqualToString:@"(null)"]) self.idcardName = @"";
        if ([self.idcardNumber isEqualToString:@"(null)"]) self.idcardNumber = @"";
        if ([self.money isEqualToString:@"(null)"]) self.money = @"";
        if ([self.nickname isEqualToString:@"(null)"]) self.nickname = @"";
        if ([self.password isEqualToString:@"(null)"]) self.password = @"";
        if ([self.phone isEqualToString:@"(null)"]) self.phone = @"";
        if ([self.registerTime isEqualToString:@"(null)"]) self.registerTime = @"";
        if ([self.sex isEqualToString:@"(null)"]) self.sex = @"";
        if ([self.userId isEqualToString:@"(null)"]) self.userId = @"";
        if ([self.userTypeId isEqualToString:@"(null)"]) self.userTypeId = @"";
        if ([self.weight isEqualToString:@"(null)"]) self.weight = @"";
        if ([self.point isEqualToString:@"(null)"]) self.point = @"";
        
        ProfileUserType *userType = [[ProfileUserType alloc] initWithDict:dict[@"userType"]];
        self.userType = userType;
    }
    return self;
}

@end

@implementation ProfileUserType

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.userTypeId = [NSString stringWithFormat:@"%@",dict[@"userTypeId"]];
        self.userTypeName = [NSString stringWithFormat:@"%@",dict[@"userTypeName"]];
    }
    return self;
}

@end
