//
//  CustomHudView.m
//  Networking
//
//  Created by zdjt on 2017/1/4.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "CustomHudView.h"

@implementation CustomHudView

+ (CustomHudView *)showLoading {
    CustomHudView *hud = [CustomHudView showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    return hud;
}

+ (CustomHudView *)showLoading:(NSString *)text {
    CustomHudView *hud = [CustomHudView showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    return hud;
}

+ (void)showWithTip:(NSString *)text {
    CustomHudView *hud = [CustomHudView showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0f];
    hud.detailsLabelText = text;
    [hud hide:YES afterDelay:2];
}

@end
