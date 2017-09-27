//
//  userModel.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.userId = dic[@"userId"];
        self.headPic = dic[@"headpic"];
        self.nickname = dic[@"nickname"];
        self.isLiked = dic[@"isLiked"];
        self.likes = [dic[@"likes"] intValue];
        self.phone = dic[@"phone"];
        self.userType = [dic[@"userTypeId"] intValue];
    }
    return self;
}
@end
