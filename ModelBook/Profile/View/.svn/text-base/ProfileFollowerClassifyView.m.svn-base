//
//  ProfileFollowerClassifyView.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileFollowerClassifyView.h"
#import "Macros.h"
#import "UIColor+Ext.h"
#import "Const.h"

@interface ProfileFollowerClassifyView ()

/* 标题源 */
@property(nonatomic, strong)NSArray *titleArray;

@end

@implementation ProfileFollowerClassifyView

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
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = screenWidth/classifyCount;
    for (int i = 0; i<classifyCount; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, CGRectGetHeight(self.frame))];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0xa7d7ff] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:line];
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
        if ([btn isKindOfClass:[UIButton class]]) btn.selected = NO;
    }
    UIButton *btn = [self viewWithTag:_curIndex+1];
    btn.selected = YES;
}

#pragma mark - lazy
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[NSLocalizedString(@"profileFollowers", nil),NSLocalizedString(@"profileFollowing", nil)];
    }
    return _titleArray;
}

@end
