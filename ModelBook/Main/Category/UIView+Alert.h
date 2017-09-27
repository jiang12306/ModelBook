//
//  UIView+Alert.h
//  YBJK
//
//  Created by mahong on 16/7/20.
//  Copyright © 2016年 mahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (Alert)<UIAlertViewDelegate,UIActionSheetDelegate>

/** UIAlertView */
-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

/** UIActionSheet */
-(void)showInView:(UIView *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromToolbar:(UIToolbar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromTabBar:(UITabBar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromRect:(CGRect)rect
             inView:(UIView *)view
           animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

@end
