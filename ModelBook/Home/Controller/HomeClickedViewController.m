//
//  HomeClickedViewController.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "HomeClickedViewController.h"
#import "BaseTabBarViewController.h"
#import "UIViewController+Ext.h"
@interface HomeClickedViewController ()

@end

@implementation HomeClickedViewController
+ (HomeClickedViewController *)instantiateJobDetailViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"HomeClickID"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self setupBackItem];
    // Do any additional setup after loading the view.
}
-(void)setModel:(UserModel *)model
{
    _model = model;
    self.navigationItem.title = model.nickname;
}

- (void)backItemOnClick:(UIBarButtonItem *)item{
    BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [controller showMainTabBarController:SectionTypeHome];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
