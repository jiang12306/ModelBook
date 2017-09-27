//
//  MBJobDetailModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBJobDetailRecordModel;
@class ProfileUserInfoModel;

@interface MBJobDetailModel : NSObject

@property(nonatomic, strong)NSString *beginTime;
@property(nonatomic, strong)NSString *chargeTypeName;
@property(nonatomic, strong)NSString *userNumber;
@property(nonatomic, strong)NSString *endTime;
@property(nonatomic, strong)NSString *createUserHeadpic;
@property(nonatomic, strong)NSString *createUsername;
@property(nonatomic, strong)NSString *jobId;
@property(nonatomic, strong)NSString *jobImage;
@property(nonatomic, strong)NSString *jobName;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *jobAddress;
@property(nonatomic, strong)NSString *recordStateName;
@property(nonatomic, strong)NSString *chargeType;
@property(nonatomic, strong)NSString *chargePrice;
@property(nonatomic, strong)NSString *recordId;
@property(nonatomic, strong)NSString *jobContent;
@property(nonatomic, strong)NSString *recordState;
@property(nonatomic, strong)NSString *requestState;
@property(nonatomic, strong)NSString *showState;
@property(nonatomic, strong)NSString *sex;
@property(nonatomic, assign)BOOL hasComment;
/* recordArray */
//@property(nonatomic, strong)NSArray<MBJobDetailRecordModel *> *recoreArray;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface MBJobDetailRecordModel : NSObject

@property(nonatomic, assign)BOOL hasComment;
@property(nonatomic, strong)NSString *jobId;
@property(nonatomic, strong)NSString *recordCreateTime;
@property(nonatomic, strong)NSString *recordId;
@property(nonatomic, strong)NSString *recordState;
@property(nonatomic, strong)NSString *recordType;
@property(nonatomic, strong)NSString *recordUpdateTime;
@property(nonatomic, strong)NSString *state;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *showState;
@property(nonatomic, strong)ProfileUserInfoModel *user;
/* 手动添加，用于评论传递 */
@property(nonatomic, strong)NSString *beginTime;
@property(nonatomic, strong)NSString *endTime;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
