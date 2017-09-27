//
//  TestViewController.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/11.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "TestViewController.h"
#import "Macros.h"
#import "ImgScrollView.h"
#import "UIView+Frame.h"
@interface TestViewController ()
@property (assign)int imgIndex;
@property (nonatomic,strong)NSArray *imgArr;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ImgScrollView *view = [[ImgScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 150) imgArr:self.imgArr setIndex:self.imgIndex islocal:NO];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(instancetype)initWithImgArr:(NSArray *)imgArr andSetIndex:(int)index
{
    self = [super init];
    if (self) {
        self.imgArr = imgArr;
        self.imgIndex = index;
    }
    return self;
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
