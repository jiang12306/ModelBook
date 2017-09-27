//
//  ProgressHUD.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProgressHUD.h"
// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE 13.0f

@interface ProgressHUD ()

@end

@implementation ProgressHUD

+ (instancetype)sharedHUD {
    
    static ProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[ProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(ProgressHUDStatus)status text:(NSString *)text {
    
    ProgressHUD *hud = [ProgressHUD sharedHUD];
    [hud show:YES];
    hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    /** 标题  */
    //    [hud setLabelText:text];
    //    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    /** 内容  */
    [hud setDetailsLabelText:text];
    [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    });
    hud.userInteractionEnabled = NO;
    
    switch (status) {
            
        case ProgressHUDStatusSuccess: {
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
            hud.customView = sucView;
            [hud hide:YES afterDelay:1.0f];
        }
            break;
            
        case ProgressHUDStatusError: {
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            hud.customView = errView;
            [hud hide:YES afterDelay:1.0f];
        }
            break;
            
        case ProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case ProgressHUDStatusInfo: {
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_info"]];
            hud.customView = errView;
            [hud hide:YES afterDelay:1.0f];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showText:(NSString *)text
{
    [self showText:text block:nil];
}

+ (void)showText:(NSString *)text block:(dispatch_block_t)block
{
    [self showText:text delay:1.0f block:block];
}

+ (void)showText:(NSString *)text delay:(NSTimeInterval)delay block:(dispatch_block_t)block
{
    ProgressHUD *hud = [ProgressHUD sharedHUD];
    [hud show:YES];
    /** 标题  */
    //    [hud setLabelText:text];
    //    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    /** 内容  */
    [hud setDetailsLabelText:text];
    [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    });
    [hud hide:YES afterDelay:delay];
    
    /** 隐藏回调  */
    if (block) {
        [hud setCompletionBlock:^(){
            block();
        }];
    }
//    if (block) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            block();
//        });
//    }
}


+ (void)showInfoText:(NSString *)text {
    
    [self showStatus:ProgressHUDStatusInfo text:text];
}

+ (void)showFailureText:(NSString *)text {
    
    [self showStatus:ProgressHUDStatusError text:text];
}

+ (void)showSuccessText:(NSString *)text {
    
    [self showStatus:ProgressHUDStatusSuccess text:text];
}

+ (void)showLoadingText:(NSString *)text {
    
    [self showStatus:ProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    
    [[ProgressHUD sharedHUD] hide:YES];
}
@end
