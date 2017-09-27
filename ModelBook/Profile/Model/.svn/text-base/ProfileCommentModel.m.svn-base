//
//  ProfileCommentModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileCommentModel.h"
#import "MyJobsDetailRecordModel.h"

@implementation ProfileCommentModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.jobCommentId = [NSString stringWithFormat:@"%@",dict[@"jobCommentId"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.commentContent = [NSString stringWithFormat:@"%@",dict[@"commentContent"]];
        self.commentTime = [NSString stringWithFormat:@"%@",dict[@"commentTime"]];
        self.commentImage = [NSString stringWithFormat:@"%@",dict[@"commentImage"]];
        self.commentTag = [NSString stringWithFormat:@"%@",dict[@"commentTag"]];
        self.point = [NSString stringWithFormat:@"%@",dict[@"point"]];
        
        if ([self.commentContent isEqualToString:@"<null>"] || [self.commentContent isEqualToString:@"<null>"]) self.commentContent = @"";
        
        MyJobsDetailRecordUser *user = [[MyJobsDetailRecordUser alloc] initWithDict:dict[@"user"]];
        self.user = user;
    }
    return self;
}

@end
