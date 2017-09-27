//
//  ProfileMyJobClassCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/20.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileMyJobClassCell.h"
#import "Macros.h"
#import "Const.h"
#import "UIColor+Ext.h"

@interface ProfileMyJobClassCell ()

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel *redBtn;
@property(nonatomic, strong)UIImageView *rightImgView;

@end

@implementation ProfileMyJobClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    [self addSubview:self.imgView];
    [self addSubview:self.titleLab];
    [self addSubview:self.rightImgView];
    [self addSubview:self.redBtn];
}

- (void)handlerCellWithImage:(UIImage *)image title:(NSString *)title count:(NSInteger)count
{
    self.imgView.image = image;
    self.titleLab.text = title;
    self.redBtn.hidden = YES;
    if (count >0)
    {
        self.redBtn.hidden = NO;
        self.redBtn.text = [NSString stringWithFormat:@"%ld",(long)count];
    }
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, (myJobClassHeight-30)/2, 30, 30)];
    }
    return _imgView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMinY(self.imgView.frame), screenWidth-60-80, 30)];
        _titleLab.font = [UIFont fontWithName:pageFontName size:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-20-16, (myJobClassHeight-12.5)/2, 7.5, 12.5)];
        _rightImgView.image = [UIImage imageNamed:@"arrow-right"];
    }
    return _rightImgView;
}

- (UILabel *)redBtn
{
    if (!_redBtn) {
        _redBtn = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.rightImgView.frame)-8-20, (myJobClassHeight-14)/2, 14, 14)];
        _redBtn.backgroundColor = [UIColor redColor];
        _redBtn.layer.cornerRadius = 5;
        _redBtn.layer.masksToBounds = YES;
        _redBtn.textAlignment = NSTextAlignmentCenter;
        _redBtn.textColor = [UIColor whiteColor];
        _redBtn.font = [UIFont boldSystemFontOfSize:8];
    }
    return _redBtn;
}

@end
