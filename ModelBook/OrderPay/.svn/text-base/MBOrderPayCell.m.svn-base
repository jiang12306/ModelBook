//
//  MBOrderPayCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/31.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBOrderPayCell.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "Macros.h"

@interface MBOrderPayCell ()

/* 标题 */
@property(nonatomic, strong)UILabel *titleLabel;
/* detail */
@property(nonatomic, strong)UILabel *detailLabel;
/* 箭头 */
@property(nonatomic, strong)UIImageView *rightImgView;

@end

@implementation MBOrderPayCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.rightImgView];
}

- (void)handlerCellWithOrder:(NSString *)title detail:(NSString *)detail isShowNext:(BOOL)isShowNext
{
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
    self.rightImgView.hidden = YES;
    if (isShowNext) self.rightImgView.hidden = NO;
}

#pragma mark - lazy
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 11, 70, 22)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont fontWithName:pageFontName size:14];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 11, screenWidth-40-100, 22)];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _detailLabel.font = [UIFont fontWithName:pageFontName size:14];
    }
    return _detailLabel;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.detailLabel.frame)+10, (44-12.5)/2, 6.5, 12.5)];
        _rightImgView.image = [UIImage imageNamed:@"arrow-right"];
    }
    return _rightImgView;
}

@end
