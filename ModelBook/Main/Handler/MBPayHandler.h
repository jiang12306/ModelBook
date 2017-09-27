//
//  MBPayHandler.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/15.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, payState) {
    /* 普通状态 */
    payStateNomal,
    /* 标记已完成状态 */
    payStateComplete
};

typedef void(^payRecordComupted)(BOOL success);

@interface MBPayHandler : NSObject

//currentUserId 付款方id
//tradeno 订单流水号，通过余额支付时也由app端生成
//money 分批交易金额
//recordId 任务记录id
//totalPrice 总金额
//dealTypeContent 交易详情
//dealMoneySource 交易来源 0-支付宝，1-余额
+ (void)handlerPayRecord:(NSMutableDictionary *)md payState:(payState)payState comupted:(payRecordComupted)comupted;

@end
