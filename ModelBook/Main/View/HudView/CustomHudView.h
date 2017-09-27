//
//  CustomHudView.h
//  Networking
//
//  Created by zdjt on 2017/1/4.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBProgressHUD.h"

@interface CustomHudView : MBProgressHUD

+ (CustomHudView *)showLoading;

+ (CustomHudView *)showLoading:(NSString *)text;

+ (void)showWithTip:(NSString *)text;

@end
