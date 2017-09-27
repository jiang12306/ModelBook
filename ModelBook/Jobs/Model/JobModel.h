//
//  JobModel.h
//  ModelBook
//
//  Created by zdjt on 2017/8/29.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JobModel : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) long jobId;

@property (copy, nonatomic) NSString *jobName;

@property (copy, nonatomic) NSString *jobAddress;

@property (strong, nonatomic) NSNumber *createUserId;

@property (assign, nonatomic) long createTime;

@property (copy, nonatomic) NSString *beginTime;

@property (copy, nonatomic) NSString *endTime;

@property (strong, nonatomic) NSNumber *userNumber;

@property (copy, nonatomic) NSString *userType;

@property (copy, nonatomic) NSString *userSex;

@property (strong, nonatomic) NSNumber *chargeType;

@property (strong, nonatomic) NSNumber *chargePrice;

@property (strong, nonatomic) NSNumber *chargeNumber;

@property (strong, nonatomic) NSNumber *chargeTotalPrice;

@property (assign, nonatomic) int jobState;

@property (copy, nonatomic) NSString *jobImage;

@property (copy, nonatomic) NSString *jobContent;

@property (copy, nonatomic) NSString *createUsername;

@property (copy, nonatomic) NSString *createUserHeadpic;

@property (strong, nonatomic) NSNumber *requestState;

@property (strong, nonatomic) NSNumber *recordId;

@property (strong, nonatomic) NSNumber *canChat;

@property (strong, nonatomic) NSNumber *showState;

@end
