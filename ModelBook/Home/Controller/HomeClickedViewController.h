//
//  HomeClickedViewController.h
//  ModelBook
//
//  Created by 唐先生 on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface HomeClickedViewController : UIViewController
+ (HomeClickedViewController *)instantiateJobDetailViewController;
@property(nonatomic,strong)UserModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *fileBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *bookBtn;

@end
