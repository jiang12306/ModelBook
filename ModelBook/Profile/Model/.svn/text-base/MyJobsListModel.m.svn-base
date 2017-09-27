//
//  MyJobsListModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MyJobsListModel.h"
#import "Macros.h"

@implementation MyJobsListModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.hasNextPage = [dict[@"hasNextPage"] boolValue];
        
        NSArray *jobInfoArray = dict[@"list"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:jobInfoArray.count];
        for (NSDictionary *dict in jobInfoArray) {
            jobInfo *model = [[jobInfo alloc] initWithDict:dict];
            [arrayM addObject:model];
        }
        self.jobInfo = arrayM;
    }
    return self;
}

@end

@implementation jobInfo

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.jobId = [NSString stringWithFormat:@"%@",dict[@"jobId"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.recordId = [NSString stringWithFormat:@"%@",dict[@"recordId"]];
        self.showState = [NSString stringWithFormat:@"%@",dict[@"showState"]];
        self.recordState = [NSString stringWithFormat:@"%@",dict[@"recordState"]];
        self.recordUpdateTime = [NSString stringWithFormat:@"%@",dict[@"recordUpdateTime"]];
        self.requestNum = [NSString stringWithFormat:@"%@",dict[@"requestNum"]];
        self.isHide = [dict[@"isHide"] boolValue];
        jobItem *job = [[jobItem alloc] initWithDict:dict[@"job"]];
        self.job = job;
    }
    return self;
}

@end

@implementation jobItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.jobId = [NSString stringWithFormat:@"%@",dict[@"jobId"]];
        self.jobImage = [NSString stringWithFormat:@"%@",dict[@"jobImage"]];
        self.jobName = [NSString stringWithFormat:@"%@",dict[@"jobName"]];
    }
    return self;
}

@end
