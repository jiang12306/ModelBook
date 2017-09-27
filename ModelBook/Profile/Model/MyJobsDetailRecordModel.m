//
//  MyJobsDetailRecordModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MyJobsDetailRecordModel.h"
#import "ProfileUserInfoModel.h"

@implementation MyJobsDetailRecordModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.jobId = [NSString stringWithFormat:@"%@",dict[@"jobId"]];
        self.recordCreateTime = [NSString stringWithFormat:@"%@",dict[@"recordCreateTime"]];
        self.recordId = [NSString stringWithFormat:@"%@",dict[@"recordId"]];
        self.recordState = [NSString stringWithFormat:@"%@",dict[@"recordState"]];
        self.recordUpdateTime = [NSString stringWithFormat:@"%@",dict[@"recordUpdateTime"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        
        MyJobsDetailRecordUser *user = [[MyJobsDetailRecordUser alloc] initWithDict:dict[@"user"]];
        self.user = user;
    }
    return self;
}

@end

@implementation MyJobsDetailRecordUser

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.phone = [NSString stringWithFormat:@"%@",dict[@"phone"]];
        self.nickname = [NSString stringWithFormat:@"%@",dict[@"nickname"]];
        self.userTypeId = [NSString stringWithFormat:@"%@",dict[@"userTypeId"]];
        self.likes = [NSString stringWithFormat:@"%@",dict[@"likes"]];
        self.headpic = [NSString stringWithFormat:@"%@",dict[@"headpic"]];
        
        ProfileUserType *userType = [[ProfileUserType alloc] initWithDict:dict[@"userType"]];
        self.userType = userType;
    }
    return self;
}

@end
