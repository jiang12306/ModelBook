//
//  InfoAddressView.h
//  ModelBook
//
//  Created by zdjt on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoAddressModel.h"

@interface InfoAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *stateView;

@property (weak, nonatomic) UISwitch *stateButton;

@property (strong, nonatomic) InfoAddressModel *model;

@property (copy, nonatomic) void(^changeBlock)(InfoAddressCell *currentCell);

@end
