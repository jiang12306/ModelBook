//
//  WalletTradeRecordModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WalletTradeRecordModelItem;
@class ProfileUserInfoModel;

@interface WalletTradeRecordModel : NSObject

@property(nonatomic, assign)BOOL hasNextPage;
@property(nonatomic, strong)NSArray<WalletTradeRecordModelItem *> *recordArray;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface WalletTradeRecordModelItem : NSObject

/* 交易金额 */
@property(nonatomic, strong)NSString *dealMoney;
/* 交易ID */
@property(nonatomic, strong)NSString *dealRecordId;
/* 交易时间 */
@property(nonatomic, strong)NSString *dealRecordTime;
/* 交易用户 */
@property(nonatomic, strong)NSString *userId;
/* 订单号 */
@property(nonatomic, strong)NSString *tradeNo;
/* 目标 */
@property(nonatomic, strong)NSString *targetUserId;
/* 状态 */
@property(nonatomic, strong)NSString *state;
/* recordID */
@property(nonatomic, strong)NSString *recordId;
/* 描述 */
@property(nonatomic, strong)NSString *dealTypeContent;
/* 交易方式 */
@property(nonatomic, strong)NSString *dealMoneySource;
/* 开始时间 */
@property(nonatomic, strong)NSString *beginTime;
/* 结束时间 */
@property(nonatomic, strong)NSString *endTime;
/* 类型 */
@property(nonatomic, strong)NSString *chargeType;
/* 目标用户信息 */
@property(nonatomic, strong)ProfileUserInfoModel *targetUser;
/* 当前用户ID */
@property(nonatomic, strong)ProfileUserInfoModel *user;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
