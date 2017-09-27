//
//  JobModel.m
//  ModelBook
//
//  Created by zdjt on 2017/8/29.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "JobModel.h"

@implementation JobModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"jobId":@"jobId",
             @"jobName":@"jobName",
             @"jobAddress":@"jobAddress",
             @"createUserId":@"createUserId",
             @"createTime":@"createTime",
             @"beginTime":@"beginTime",
             @"endTime":@"endTime",
             @"userNumber":@"userNumber",
             @"userType":@"userType",
             @"userSex":@"userSex",
             @"chargeType":@"chargeType",
             @"chargePrice":@"chargePrice",
             @"chargeNumber":@"chargeNumber",
             @"chargeTotalPrice":@"chargeTotalPrice",
             @"jobState":@"jobState",
             @"jobImage":@"jobImage",
             @"jobContent":@"jobContent",
             @"createUsername":@"createUsername",
             @"requestState":@"requestState",
             @"recordId":@"recordId",
             @"createUserHeadpic":@"createUserHeadpic",
             @"canChat":@"canChat",
             @"showState":@"showState"
             };
}

@end
