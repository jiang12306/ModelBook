//
//  ProfileMyJobListCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class jobInfo;

static CGFloat const myJobListHeight = 66;

typedef void(^backClassActionBlock)(void);

@interface ProfileMyJobListCell : UITableViewCell

@property(nonatomic, copy)backClassActionBlock backClassActionBlock;

- (void)handlerCellWithModel:(jobInfo *)model;

@end
