//
//  RegisterViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/8/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController

+ (RegisterViewController *)instantiateRegisterViewController;

@property (copy, nonatomic) NSString *controllerFrom;

@end
