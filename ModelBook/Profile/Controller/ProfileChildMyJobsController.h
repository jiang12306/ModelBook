//
//  ProfileChildMyJobsController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  网络请求方式
 */
typedef NS_ENUM(NSInteger,HTTPRequestMethod) {
    HTTPRequestMethodGet,
    HTTPRequestMethodPost,
    HTTPRequestMethodDelete,
    HTTPRequestMethodPut,
    HTTPRequestMethodHead
};

@interface ProfileChildMyJobsController : BaseViewController

/* 用户ID */
@property(nonatomic, strong)NSString *userId;

- (instancetype)initWithTableFrame:(CGRect)frame;

- (void)switchToClassifyState;

@end
