//
//  JobListModel.h
//  ModelBook
//
//  Created by zdjt on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JobListModel : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) long jobId;

@property (copy, nonatomic) NSString *jobName;

@property (copy, nonatomic) NSString *jobImage;

@property (strong, nonatomic) NSNumber *jobState;

@property (strong, nonatomic) NSNumber *userNumber;

@property (strong, nonatomic) NSNumber *requestState;

@property (strong, nonatomic) NSNumber *recordId;

@property (strong, nonatomic) NSNumber *showState;

@end
