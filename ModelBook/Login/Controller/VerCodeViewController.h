//
//  VerCodeViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/8/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

@interface VerCodeViewController : BaseViewController

+ (VerCodeViewController *)instantiateVerCodeViewController;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *vercode;

@end
