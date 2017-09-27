//
//  MBPayHandler.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/15.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBPayHandler.h"
#import "NetworkManager.h"
#import "ProgressHUD.h"

@implementation MBPayHandler

+ (void)handlerPayRecord:(NSMutableDictionary *)md payState:(payState)payState comupted:(payRecordComupted)comupted
{
    if (payState == payStateComplete)
    {
        [md setValue:@"0" forKey:@"payState"];
    }
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/pay/result" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:responseObject[@"msg"]];
                if (comupted) comupted(YES);
            }
            else
            {
                [ProgressHUD showText:@"保存记录失败"];
                if (comupted) comupted(NO);
            }
        }
        else
        {
            [ProgressHUD showText:@"保存记录失败"];
            if (comupted) comupted(NO);
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:@"保存记录失败"];
        if (comupted) comupted(NO);
    }];
}

@end
