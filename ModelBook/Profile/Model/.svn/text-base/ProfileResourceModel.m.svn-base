//
//  ProfileResourceModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileResourceModel.h"

@implementation ProfileResourceModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.hasNextPage = [dict[@"hasNextPage"] boolValue];
        
        NSArray *resourceInfoArray = dict[@"list"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:resourceInfoArray.count];
        for (NSDictionary *dict in resourceInfoArray) {
            ResourceItem *model = [[ResourceItem alloc] initWithDict:dict];
            [arrayM addObject:model];
        }
        self.resourceInfo = arrayM;
    }
    return self;
}

@end

@implementation ResourceItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.albumId = [NSString stringWithFormat:@"%@",dict[@"albumId"]];
        self.fileSrc = [NSString stringWithFormat:@"%@",dict[@"fileSrc"]];
        self.fileType = [NSString stringWithFormat:@"%@",dict[@"fileType"]];
        self.isDisabled = [dict[@"isDisabled"] boolValue];
        self.uploadTime = [NSString stringWithFormat:@"%@",dict[@"uploadTime"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
    }
    return self;
}

@end
