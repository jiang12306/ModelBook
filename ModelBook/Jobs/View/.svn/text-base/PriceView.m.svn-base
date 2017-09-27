//
//  PriceView.m
//  ModelBook
//
//  Created by zdjt on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PriceView.h"
#import "UIColor+Ext.h"
#import "Masonry.h"
#import "Const.h"

@interface PriceView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *hourbutton;

@property (weak, nonatomic) IBOutlet UIButton *dayButton;

@end

@implementation PriceView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.hourbutton setTitle:NSLocalizedString(@"Hour Rate", nil) forState:UIControlStateNormal];
    [self.dayButton setTitle:NSLocalizedString(@"Day Rate", nil) forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.layer.masksToBounds = YES;
    
    self.hourbutton.layer.cornerRadius = 3.f;
    self.hourbutton.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    self.hourbutton.layer.borderWidth =0.5f;
    self.hourbutton.titleLabel.font = [UIFont fontWithName:buttonFontName size:14.f];
    [self.hourbutton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    self.dayButton.layer.cornerRadius = 3.f;
    self.dayButton.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    self.dayButton.layer.borderWidth =0.5f;
    self.dayButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:14.f];
    [self.dayButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
}

+ (id)priceView
{
    PriceView *view = [[NSBundle mainBundle] loadNibNamed:@"PriceView" owner:nil options:nil].firstObject;
    return view;
}

- (void)show:(UIView *)parentView
{
    [parentView addSubview:self];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(parentView);
    }];
    
    self.bgView.alpha = .0f;
    self.contentView.alpha = .0f;
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, .1f, .1f);
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:.2f animations:^{
        self.bgView.alpha = .5f;
        self.contentView.alpha = 1.f;
        self.contentView.transform = CGAffineTransformIdentity;
        [self layoutIfNeeded];
    }];
}
- (void)dismiss
{
    self.bgView.alpha = .5f;
    self.contentView.alpha = 1.f;
    self.contentView.transform = CGAffineTransformIdentity;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:.2f animations:^{
        self.bgView.alpha = .0f;
        self.contentView.alpha = .0f;
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, .1f, .1f);
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)hourButtonEvent:(UIButton *)sender {
    if (self.valueBlock) self.valueBlock(sender.titleLabel.text);
    [self dismiss];
}

- (IBAction)dayButtonEvent:(UIButton *)sender {
    if (self.valueBlock) self.valueBlock(sender.titleLabel.text);
    [self dismiss];
}

@end
