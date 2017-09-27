//
//  NeedView.m
//  ModelBook
//
//  Created by zdjt on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "NeedView.h"
#import "Const.h"
#import "UIColor+Ext.h"
#import "Masonry.h"

@interface NeedView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightCons;

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (strong, nonatomic) NSArray *arrayTwo;

@property (copy, nonatomic) NSString *field;

@end

@implementation NeedView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.arrayTwo = @[NSLocalizedString(@"P&MakeUp", nil), NSLocalizedString(@"Model", nil), NSLocalizedString(@"KOL", nil)];
    [self.pickView selectRow:0 inComponent:0 animated:YES];
    
    self.field = self.arrayTwo[0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cancleButton setTitle:NSLocalizedString(@"Cancle", nil) forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:13.f];
    [self.cancleButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self.confirmButton setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:13.f];
    [self.confirmButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    
    self.lineViewHeightCons.constant = 0.5f;
    
}

+ (id)needView
{
    NeedView *view = [[NSBundle mainBundle] loadNibNamed:@"NeedView" owner:nil options:nil].firstObject;
    return view;
}
- (void)show:(UIView *)parentView
{
    [parentView addSubview:self];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(parentView);
    }];
    
    //显示动画
    self.contentView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, CGRectGetHeight(self.frame));
    self.bgView.alpha = 0.0f;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 0.5;
        [self layoutIfNeeded];
    }];
}
- (void)dismiss
{
    self.contentView.transform = CGAffineTransformIdentity;
    self.bgView.alpha = 0.5;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self.contentView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, CGRectGetHeight(self.frame));
        self.bgView.alpha = 0.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)cancleButtonEvent:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)confirmButtonEvent:(UIButton *)sender {
    if (self.valueBlock) self.valueBlock(self.field);
    [self dismiss];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayTwo.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.arrayTwo[row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.field = self.arrayTwo[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:pageFontName size:14.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:0x999999];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

@end
