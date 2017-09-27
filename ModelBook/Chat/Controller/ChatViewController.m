//
//  CihatViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/29.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ChatViewController.h"
#import "UIViewController+Ext.h"
#import "UserInfoManager.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
}

- (void)backItemOnClick:(UIBarButtonItem *)item {
    if ([self.controllerFrom isEqualToString:@"Push"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [super backItemOnClick:item];
        if (self.operateBlock) self.operateBlock();
    }
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent
{
    RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld", [UserInfoManager userID]] name:[UserInfoManager userName] portrait:[UserInfoManager headpic]];
    messageContent.senderUserInfo = info;
    return messageContent;
}

@end
