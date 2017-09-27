//
//  JobListClassifyModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "JobListClassifyModel.h"

@implementation JobListClassifyModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.recordClassify = [NSString stringWithFormat:@"%@",[dict objectForKey:@"recordClassify"]];
        self.requestNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"requestNum"]];
    }
    return self;
}

@end
