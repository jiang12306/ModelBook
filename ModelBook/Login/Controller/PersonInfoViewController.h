//
//  PersonInfoAViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/8/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PersonInfoViewController : BaseTableViewController

+ (PersonInfoViewController *)instantiatePersonInfoViewController;
+ (BaseNavigationViewController *)instantiateNavigationController;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *controllerFrom;

@end
