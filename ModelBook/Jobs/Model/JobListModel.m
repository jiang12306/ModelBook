//
//  JobListModel.m
//  ModelBook
//
//  Created by zdjt on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "JobListModel.h"

@implementation JobListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"jobId":@"jobId",
             @"jobName":@"jobName",
             @"jobImage":@"jobImage",
             @"jobState":@"jobState",
             @"userNumber":@"userNumber",
             @"requestState":@"requestState",
             @"recordId":@"recordId",
             @"showState":@"showState"
             };
}

@end
