//
//  WalletRecordCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WalletTradeRecordModelItem;

static CGFloat const walletRecordCellHeight = 250;

@interface WalletRecordCell : UITableViewCell

- (void)handlerCellWithModel:(WalletTradeRecordModelItem *)model;

@end
