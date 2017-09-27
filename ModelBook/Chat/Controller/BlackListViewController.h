//
//  BlackListViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/9/18.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BlackListViewController : BaseTableViewController

@property (copy, nonatomic) void(^reloadBlock)();

@end
