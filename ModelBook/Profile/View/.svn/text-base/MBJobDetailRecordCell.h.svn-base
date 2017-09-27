//
//  MBJobDetailRecordCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBJobDetailRecordModel;

typedef void(^didClickedRemarkAction)(void);

@interface MBJobDetailRecordCell : UICollectionViewCell

/* 点击回调 */
@property(nonatomic, copy)didClickedRemarkAction didClickedRemarkAction;

- (void)handlerCellWithModel:(MBJobDetailRecordModel *)model isSelected:(BOOL)isSelected;

@end
