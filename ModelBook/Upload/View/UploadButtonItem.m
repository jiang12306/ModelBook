//
//  UploadButtonItem.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UploadButtonItem.h"
#import "Const.h"
#import "UIColor+Ext.h"

@interface UploadButtonItem ()

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UILabel *label;

@end

@implementation UploadButtonItem

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
    [self addSubview:self.imgView];
    [self addSubview:self.label];
}

- (void)setImage:(UIImage *)image
{
    self.imgView.image = image;
}

- (void)setTitle:(NSString *)title
{
    self.label.text = title;
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-40)/2, 5, 40, 35)];
    }
    return _imgView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame), 22)];
        _label.font = [UIFont fontWithName:pageFontName size:11];
        _label.textColor = [UIColor colorWithHexString:@"#666666"];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
