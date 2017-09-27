//
//  followInfoCell.h
//  ModelBook
//
//  Created by HZ on 2017/9/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FollowInfoModel;

typedef void(^clickHandleBtn)(NSString * handleStr);

@interface followInfoCell : UITableViewCell

/**
 数据模型
 */
@property (nonatomic)FollowInfoModel * dataModel;

/**
 设置操作按钮操作

 @param clidkHandleBtn block
 */
- (void)setHandleBtnHandle:(clickHandleBtn) clickHandleBtn;
@end
