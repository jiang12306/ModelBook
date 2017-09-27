//
//  PriceTypeView.m
//  ModelBook
//
//  Created by hinata on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PriceTypeView.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "TriangleView.h"

@interface PriceTypeView ()
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *hourButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightCons;

@property (weak, nonatomic) IBOutlet TriangleView *tView;

@end

@implementation PriceTypeView

+(PriceTypeView *)typeView
{
    PriceTypeView *view = [[NSBundle mainBundle] loadNibNamed:@"PriceTypeView" owner:nil options:nil].firstObject;
    return view;
}

- (void)showFrom:(UIView *)from
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    
    // 4.调整灰色图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    //    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.frame = CGRectMake(CGRectGetMidX(newFrame) - 30, CGRectGetMaxY(newFrame), 70, 90);
}

- (void)dismiss
{
    if (self.dismissBlock) self.dismissBlock();
    [self removeFromSuperview];
}

- (IBAction)dayButtonEvent:(UIButton *)sender {
    if (self.selectBlock) self.selectBlock(@"1", sender.titleLabel.text);
    [self dismiss];
}

- (IBAction)hourButtonEvent:(UIButton *)sender {
    if (self.selectBlock) self.selectBlock(@"0", sender.titleLabel.text);
    [self dismiss];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineHeightCons.constant = 0.5f;
    
    self.tView.fillColor = [UIColor colorWithHex:0x999999];
    
    self.contentView.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    
    [self.dayButton setTitle:NSLocalizedString(@"Day Rate", nil) forState:UIControlStateNormal];
    self.dayButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    [self.hourButton setTitle:NSLocalizedString(@"Hour Rate", nil) forState:UIControlStateNormal];
    self.hourButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
}

@end
