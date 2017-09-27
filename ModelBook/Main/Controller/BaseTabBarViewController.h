//
//  BaseTabBarViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/8/7.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationViewController.h"
#import "Const.h"

typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeHome = 0,
    SectionTypeJobs,
    SectionTypeUpload,
    SectionTypeChat,
    SectionTypeProfile
};

@interface BaseTabBarViewController : UITabBarController

+ (BaseNavigationViewController *)instantiateNavigationController;
+ (BaseTabBarViewController *)instantiateTabBarController;

- (UIViewController *)showMainTabBarController:(SectionType)sectionType;

@end
