//
//  WalletTradeRecordModel.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "WalletTradeRecordModel.h"
#import "ProfileUserInfoModel.h"

@implementation WalletTradeRecordModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.hasNextPage = [dict[@"hasNextPage"] boolValue];
        
        NSArray *recordArray = dict[@"list"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:recordArray.count];
        for (NSDictionary *dict in recordArray) {
            WalletTradeRecordModelItem *model = [[WalletTradeRecordModelItem alloc] initWithDict:dict];
            [arrayM addObject:model];
        }
        self.recordArray = arrayM;
    }
    return self;
}

@end

@implementation WalletTradeRecordModelItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        if (![dict isKindOfClass:[NSDictionary class]]) return self;
        self.dealMoney = [NSString stringWithFormat:@"%@",dict[@"dealMoney"]];
        self.dealRecordId = [NSString stringWithFormat:@"%@",dict[@"dealRecordId"]];
        self.dealRecordTime = [NSString stringWithFormat:@"%@",dict[@"dealRecordTime"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        self.tradeNo = [NSString stringWithFormat:@"%@",dict[@"tradeNo"]];
        self.targetUserId = [NSString stringWithFormat:@"%@",dict[@"targetUserId"]];
        self.state = [NSString stringWithFormat:@"%@",dict[@"state"]];
        self.recordId = [NSString stringWithFormat:@"%@",dict[@"recordId"]];
        self.dealTypeContent = [NSString stringWithFormat:@"%@",dict[@"dealTypeContent"]];
        self.dealMoneySource = [NSString stringWithFormat:@"%@",dict[@"dealMoneySource"]];
        self.beginTime = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"job"] objectForKey:@"beginTime"]];
        self.endTime = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"job"] objectForKey:@"endTime"]];
        self.chargeType = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"job"] objectForKey:@"chargeType"]];
        ProfileUserInfoModel *targetUser = [[ProfileUserInfoModel alloc] initWithDict:dict[@"targetUser"]];
        self.targetUser = targetUser;
        ProfileUserInfoModel *user = [[ProfileUserInfoModel alloc] initWithDict:dict[@"user"]];
        self.user = user;
    }
    return self;
}

@end
