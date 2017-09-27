//
//  JobListCell.h
//  ModelBook
//
//  Created by zdjt on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobListModel.h"

@interface JobListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) UISwitch *stateButton;

@property (strong, nonatomic) JobListModel *model;

@property (copy, nonatomic) void(^applyBlock)(JobListCell *cell);

@property (copy, nonatomic) void(^cancleBlock)(JobListCell *cell);

@property (copy, nonatomic) void(^coverBlock)(JobListCell *cell);

@end
