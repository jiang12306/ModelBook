//
//  PhotoCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.selectButton];
        [self.contentView addSubview:self.typeImgView];
    }
    return self;
}

- (UIButton *)selectButton
{
    if (!_selectButton)
    {
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-24, 0, 24, 24)];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"choose_n"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"choose_s"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (void)selectButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(PhotoCell:didClickSelectButton:)])
    {
        [self.delegate PhotoCell:self didClickSelectButton:sender];
    }
}

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-30, 30, 30)];
        _typeImgView.hidden = YES;
        _typeImgView.image = [UIImage imageNamed:@"video_play"];
    }
    return _typeImgView;
}

@end
