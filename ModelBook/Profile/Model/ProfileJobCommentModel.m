//
//  ProfileJobCommentModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileJobCommentModel.h"
#import "ProfileCommentModel.h"

@implementation ProfileJobCommentModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        
        self.recordId = [NSString stringWithFormat:@"%@",dict[@"recordId"]];
        self.recordState = [NSString stringWithFormat:@"%@",dict[@"recordState"]];
        self.beginTime = [NSString stringWithFormat:@"%@",dict[@"beginTime"]];
        self.endTime = [NSString stringWithFormat:@"%@",dict[@"endTime"]];
        
        ProfileCommentModel *jobComment = [[ProfileCommentModel alloc] initWithDict:dict[@"jobComment"]];
        self.jobComment = jobComment;
    }
    return self;
}

@end
