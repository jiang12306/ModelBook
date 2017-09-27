//
//  ProfileEditInfoCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileEditInfoCell.h"
#import "Macros.h"
#import "Const.h"
#import "Handler.h"

@interface ProfileEditInfoCell ()<UITextFieldDelegate>

/* 图片 */
@property(nonatomic, strong)UIImageView *imgView;
/* 右边箭头 */
@property(nonatomic, strong)UIImageView *rightImgView;
/* 临时保存index */
@property(nonatomic, assign)NSInteger index;
/* 单位 */
@property(nonatomic, strong)UILabel *unitLabel;

@end

@implementation ProfileEditInfoCell

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
    [self addSubview:self.textField];
    [self addSubview:self.rightImgView];
    [self addSubview:self.unitLabel];
}

- (void)handlerCellWithImage:(UIImage *)image title:(NSString *)title value:(NSString *)value index:(NSInteger)index unit:(NSString *)unit
{
    _index = index;
    self.imgView.image = image;
    self.textField.placeholder = title;
    if (value.length>0 && ![value isEqualToString:@"(null)"]) self.textField.text = value;
    self.rightImgView.hidden = YES;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.unitLabel.hidden = NO;
    self.unitLabel.text = unit;
    if (index<5) self.unitLabel.hidden = YES;
    if (index<4)
    {
        self.rightImgView.hidden = NO;
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
    [self textFieldAction:self.textField];
}

- (void)textFieldAction:(UITextField *)textField
{
    CGFloat width = [Handler widthForString:textField.placeholder width:CGRectGetWidth(textField.frame) FontSize:[UIFont fontWithName:pageFontName size:14]];
    if (textField.text.length>0)
    {
        width = [Handler widthForString:textField.text width:CGRectGetWidth(textField.frame) FontSize:[UIFont fontWithName:pageFontName size:14]];
    }
    CGFloat frame_x = CGRectGetMinX(textField.frame)+width+10;
    self.unitLabel.frame = CGRectMake(frame_x, CGRectGetMinY(self.textField.frame), 40, 40);
}

#pragma mark - textField - delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL result = YES;
    if ([self.delegate respondsToSelector:@selector(textFieldBeginEditing:)])
    {
        result = [self.delegate textFieldBeginEditing:_index];
    }
    return result;
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(60, (ProfileEditInfoCellHeight-25)/2, 25, 25)];
    }
    return _imgView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+35, 0, screenWidth-(CGRectGetMaxX(self.imgView.frame)+35)-60, 40)];
        _textField.font = [UIFont fontWithName:pageFontName size:14];
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-6.5-60, (ProfileEditInfoCellHeight-12.5)/2, 6.5, 12.5)];
        _rightImgView.image = [UIImage imageNamed:@"arrow-right"];
    }
    return _rightImgView;
}

- (UILabel *)unitLabel
{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.textField.frame), 50, 40)];
        _unitLabel.font = [UIFont fontWithName:pageFontName size:14];
    }
    return _unitLabel;
}

@end
