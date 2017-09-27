//
//  MBJobDetailModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBJobDetailModel.h"
#import "ProfileUserInfoModel.h"

@implementation MBJobDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        
        self.hasComment = [dict[@"hasComment"] boolValue];
        self.beginTime = [NSString stringWithFormat:@"%@",dict[@"beginTime"]];
        self.chargeTypeName = [NSString stringWithFormat:@"%@",dict[@"chargeTypeName"]];
        self.userNumber = [NSString stringWithFormat:@"%@",dict[@"userNumber"]];
        self.endTime = [NSString stringWithFormat:@"%@",dict[@"endTime"]];
        self.createUserHeadpic = [NSString stringWithFormat:@"%@",dict[@"createUserHeadpic"]];
        self.createUsername = [NSString stringWithFormat:@"%@",dict[@"createUsername"]];
        self.jobId = [NSString stringWithFormat:@"%@",dict[@"jobId"]];
        self.jobImage = [NSString stringWithFormat:@"%@",dict[@"jobImage"]];
        self.jobName = [NSString stringWithFormat:@"%@",dict[@"jobName"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.jobAddress = [NSString stringWithFormat:@"%@",dict[@"jobAddress"]];
        self.recordStateName = [NSString stringWithFormat:@"%@",dict[@"recordStateName"]];
        self.chargeType = [NSString stringWithFormat:@"%@",dict[@"chargeType"]];
        self.chargePrice = [NSString stringWithFormat:@"%@",dict[@"chargePrice"]];
        self.recordId = [NSString stringWithFormat:@"%@",dict[@"recordId"]];
        self.jobContent = [NSString stringWithFormat:@"%@",dict[@"jobContent"]];
        self.recordState = [NSString stringWithFormat:@"%@",dict[@"recordState"]];
        self.requestState = [NSString stringWithFormat:@"%@",dict[@"requestState"]];
        self.showState = [NSString stringWithFormat:@"%@",dict[@"showState"]];
        self.sex = [NSString stringWithFormat:@"%@",dict[@"sex"]];
        
//        NSArray *recoreArray = dict[@"record"];
//        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:recoreArray.count];
//        for (NSDictionary *dict in recoreArray) {
//            MBJobDetailRecordModel *model = [[MBJobDetailRecordModel alloc] initWithDict:dict];
//            [arrayM addObject:model];
//        }
//        self.recoreArray = arrayM;

        if ([self.beginTime isEqualToString:@"(null)"] || [self.beginTime isEqualToString:@"<null>"]) self.beginTime = @"";
        if ([self.chargeTypeName isEqualToString:@"(null)"] || [self.chargeTypeName isEqualToString:@"<null>"]) self.chargeTypeName = @"";
        if ([self.userNumber isEqualToString:@"(null)"] || [self.userNumber isEqualToString:@"<null>"]) self.userNumber = @"";
        if ([self.endTime isEqualToString:@"(null)"] || [self.endTime isEqualToString:@"<null>"]) self.endTime = @"";
        if ([self.createUserHeadpic isEqualToString:@"(null)"] || [self.createUserHeadpic isEqualToString:@"<null>"]) self.createUserHeadpic = @"";
        if ([self.createUsername isEqualToString:@"(null)"] || [self.createUsername isEqualToString:@"<null>"]) self.createUsername = @"";
        if ([self.jobId isEqualToString:@"(null)"] || [self.jobId isEqualToString:@"<null>"]) self.jobId = @"";
        if ([self.jobImage isEqualToString:@"(null)"] || [self.jobImage isEqualToString:@"<null>"]) self.jobImage = @"";
        if ([self.jobName isEqualToString:@"(null)"] || [self.jobName isEqualToString:@"<null>"]) self.jobName = @"";
        if ([self.jobName isEqualToString:@"(null)"] || [self.jobName isEqualToString:@"<null>"]) self.jobName = @"";
        if ([self.userId isEqualToString:@"(null)"] || [self.userId isEqualToString:@"<null>"]) self.userId = @"";
        if ([self.jobAddress isEqualToString:@"(null)"] || [self.jobAddress isEqualToString:@"<null>"]) self.jobAddress = @"";
        if ([self.recordStateName isEqualToString:@"(null)"] || [self.recordStateName isEqualToString:@"<null>"]) self.recordStateName = @"";
        if ([self.chargeType isEqualToString:@"(null)"] || [self.chargeType isEqualToString:@"<null>"]) self.chargeType = @"";
        if ([self.chargePrice isEqualToString:@"(null)"] || [self.chargePrice isEqualToString:@"<null>"]) self.chargePrice = @"";
        if ([self.recordId isEqualToString:@"(null)"] || [self.recordId isEqualToString:@"<null>"]) self.recordId = @"";
        if ([self.jobContent isEqualToString:@"(null)"] || [self.jobContent isEqualToString:@"<null>"]) self.jobContent = @"";
        if ([self.recordState isEqualToString:@"(null)"] || [self.recordState isEqualToString:@"<null>"]) self.recordState = @"";
        if ([self.requestState isEqualToString:@"(null)"] || [self.requestState isEqualToString:@"<null>"]) self.requestState = @"";
        if ([self.sex isEqualToString:@"(null)"] || [self.sex isEqualToString:@"<null>"]) self.sex = @"";
    }
    return self;
}

@end

@implementation MBJobDetailRecordModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.hasComment = [dict[@"hasComment"] boolValue];
        self.jobId = [NSString stringWithFormat:@"%@",dict[@"jobId"]];
        self.recordCreateTime = [NSString stringWithFormat:@"%@",dict[@"recordCreateTime"]];
        self.recordId = [NSString stringWithFormat:@"%@",dict[@"recordId"]];
        self.recordState = [NSString stringWithFormat:@"%@",dict[@"recordState"]];
        self.recordType = [NSString stringWithFormat:@"%@",dict[@"recordType"]];
        self.recordUpdateTime = [NSString stringWithFormat:@"%@",dict[@"recordUpdateTime"]];
        self.state = [NSString stringWithFormat:@"%@",dict[@"state"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.showState = [NSString stringWithFormat:@"%@",dict[@"showState"]];
        
        ProfileUserInfoModel *user = [[ProfileUserInfoModel alloc] initWithDict:dict[@"user"]];
        self.user = user;
    }
    return self;
}

@end
