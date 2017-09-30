//
//  HomeSearchViewController.m
//  ModelBook
//
//  Created by 蒋宽 on 2017/9/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "HomeSearchViewController.h"

@interface HomeSearchViewController ()

@property (nonatomic, strong) UIImageView* logoIV;
@property (nonatomic, strong) UITextField* searchTF;

@end

@implementation HomeSearchViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.font = [UIFont fontWithName:pageFontName size:16.f];
    tLabel.text = NSLocalizedString(@"Search", nil);
    tLabel.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = tLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self setupBackItem];
    [self initLayout];
}

-(void)initLayout
{
    self.logoIV = [[UIImageView alloc]initWithFrame:CGRectMake(50, 80, 30, 30)];
    self.logoIV.image = [UIImage imageNamed:@"style_default_1.5.0_btn_back"];
    [self.view addSubview:self.logoIV];
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(self.logoIV.frame.origin.x + self.logoIV.frame.size.width + 20, self.logoIV.frame.origin.y, self.view.frame.size.width - self.logoIV.frame.origin.x*2 -  self.logoIV.frame.size.width - 20, self.logoIV.frame.size.height)];
    self.searchTF.layer.cornerRadius = 10;
    self.searchTF.layer.masksToBounds = YES;
    self.searchTF.layer.borderColor = [UIColor grayColor].CGColor;
    self.searchTF.layer.borderWidth = 1.f;
    self.searchTF.placeholder = NSLocalizedString(@"Search", nil);
    [self.view addSubview:self.searchTF];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"barFrame = %@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
