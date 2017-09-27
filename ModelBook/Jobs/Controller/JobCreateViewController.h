//
//  JobCreateViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/8/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

@interface JobCreateViewController : BaseViewController

+ (JobCreateViewController *)instantiateJobCreateViewController;

@property (copy, nonatomic) NSString *controllerFrom;

@property (copy, nonatomic) NSString *bookTargetId;

@property (copy, nonatomic) NSString *userTypeId;

@property (copy, nonatomic) NSString *userTypeName;

@end
