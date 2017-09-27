//
//  ProfileCommentImageModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileCommentImageModel.h"

@implementation ProfileCommentImageModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        
        self.hasNextPage = [dict[@"hasNextPage"] boolValue];
        
        NSArray *commentInfoArray = dict[@"list"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:commentInfoArray.count];
        for (NSDictionary *dict in commentInfoArray) {
            ProfileCommentImageItem *model = [[ProfileCommentImageItem alloc] initWithDict:dict];
            [arrayM addObject:model];
        }
        self.commentInfo = arrayM;
    }
    return self;
}

@end

@implementation ProfileCommentImageItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.jobCommentId = [NSString stringWithFormat:@"%@",dict[@"jobCommentId"]];
        self.commentTime = [NSString stringWithFormat:@"%@",dict[@"commentTime"]];
        self.commentImage = [NSString stringWithFormat:@"%@",dict[@"commentImage"]];
    }
    return self;
}

@end
