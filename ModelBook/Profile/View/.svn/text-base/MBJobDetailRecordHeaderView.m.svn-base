//
//  MBJobDetailRecordHeaderView.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/9.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBJobDetailRecordHeaderView.h"
#import "UIColor+Ext.h"
#import "Const.h"

@interface MBJobDetailRecordHeaderView ()

/* 标题 */
@property(nonatomic, strong)UILabel *titleLabel;

@end

@implementation MBJobDetailRecordHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 20)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = [UIFont fontWithName:pageFontName size:9];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
