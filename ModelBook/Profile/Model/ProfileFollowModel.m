//
//  ProfileFollowModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileFollowModel.h"
#import "ProfileUserInfoModel.h"

@implementation ProfileFollowModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.hasNextPage = [dict[@"hasNextPage"] boolValue];
        
        NSArray *followItemArray = dict[@"list"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:followItemArray.count];
        for (NSDictionary *dict in followItemArray) {
            ProfileFollowItem *model = [[ProfileFollowItem alloc] initWithDict:dict];
            [arrayM addObject:model];
        }
        self.followItemArray = arrayM;
    }
    return self;
}

@end

@implementation ProfileFollowItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        
        self.remarkName = [NSString stringWithFormat:@"%@",dict[@"remarkName"]];
        self.bothStatus = [NSString stringWithFormat:@"%@",dict[@"bothStatus"]];
        self.followId = [NSString stringWithFormat:@"%@",dict[@"followId"]];
        self.followTime = [NSString stringWithFormat:@"%@",dict[@"followTime"]];
        self.isChat = [NSString stringWithFormat:@"%@",dict[@"isChat"]];
        self.isInform = [NSString stringWithFormat:@"%@",dict[@"isInform"]];
        self.targetUserId = [NSString stringWithFormat:@"%@",dict[@"targetUserId"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        
        ProfileFollowUserItem *user = [[ProfileFollowUserItem alloc] initWithDict:dict[@"user"]];
        self.user = user;
    }
    return self;
}

@end

@implementation ProfileFollowUserItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.canLive = [NSString stringWithFormat:@"%@",dict[@"canLive"]];
        self.headpic = [NSString stringWithFormat:@"%@",dict[@"headpic"]];
        self.nickname = [NSString stringWithFormat:@"%@",dict[@"nickname"]];
        self.phone = [NSString stringWithFormat:@"%@",dict[@"phone"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.userTypeId = [NSString stringWithFormat:@"%@",dict[@"userTypeId"]];
        
        ProfileUserType *userType = [[ProfileUserType alloc] initWithDict:dict[@"userType"]];
        self.userType = userType;
    }
    return self;
}

@end
