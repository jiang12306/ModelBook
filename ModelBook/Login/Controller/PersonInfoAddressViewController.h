//
//  PersonInfoAddressViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonInfoAddressViewController : BaseViewController

+ (PersonInfoAddressViewController *)instantiatePersonInfoAddressViewController;

@property (copy, nonatomic) void(^valueBlock)(NSString *text);

@end
