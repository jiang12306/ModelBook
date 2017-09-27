//
//  MBOrderPayCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/31.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBOrderPayCell : UITableViewCell

- (void)handlerCellWithOrder:(NSString *)title detail:(NSString *)detail isShowNext:(BOOL)isShowNext;

@end
