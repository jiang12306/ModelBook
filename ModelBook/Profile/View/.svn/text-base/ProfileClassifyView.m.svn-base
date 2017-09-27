//
//  ProfileClassifyView.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileClassifyView.h"
#import "Macros.h"

@implementation ProfileClassifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    NSArray *nomalImageArray = @[[UIImage imageNamed:@"upload_camer"],[UIImage imageNamed:@"upload_video"],[UIImage imageNamed:@"upload_other"]];
    NSArray *selectedImageArray = @[[UIImage imageNamed:@"upload_camer_selected"],[UIImage imageNamed:@"upload_video_selected"],[UIImage imageNamed:@"upload_other_selected"]];
    CGFloat btnWidth = screenWidth/classifyCount;
    for (int i = 0; i<classifyCount; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, CGRectGetHeight(self.frame))];
        [btn setImage:nomalImageArray[i] forState:UIControlStateNormal];
        [btn setImage:selectedImageArray[i] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

#pragma mark - action
- (void)btnAction:(UIButton *)sender
{
    if (_didSelectedIndex) _didSelectedIndex(sender.tag-1);
}

#pragma mark - setting方法
- (void)setCurIndex:(NSInteger)curIndex
{
    _curIndex = curIndex;
    if (_curIndex<0) _curIndex = 0;
    if (_curIndex>classifyCount-1) _curIndex = classifyCount-1;
    for (UIButton *btn in self.subviews) {
        btn.selected = NO;
    }
    UIButton *btn = [self viewWithTag:_curIndex+1];
    btn.selected = YES;
}

@end
