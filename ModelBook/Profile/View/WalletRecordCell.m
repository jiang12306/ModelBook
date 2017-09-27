//
//  WalletRecordCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "WalletRecordCell.h"
#import "UIColor+Ext.h"
#import "Macros.h"
#import "Const.h"
#import "WalletTradeRecordModel.h"
#import "Handler.h"
#import <UIImageView+WebCache.h>
#import "ProfileUserInfoModel.h"
#import "NSString+imgURL.h"

@interface WalletRecordCell ()

/* 星期 */
@property(nonatomic, strong)UILabel *weekLabel;
/* 背景视图 */
@property(nonatomic, strong)UIView *bgView;
/* 头像 */
@property(nonatomic, strong)UIImageView *imgView;
/* 昵称 */
@property(nonatomic, strong)UILabel *nickLabel;
/* 时长 */
@property(nonatomic, strong)UILabel *durationLabel;
/* 时间 */
@property(nonatomic, strong)UILabel *timeLabel;
/* 状态 */
@property(nonatomic, strong)UILabel *stateLabel;
/* 金额标题 */
@property(nonatomic, strong)UILabel *moneyTitleLabel;
/* 金额 */
@property(nonatomic, strong)UILabel *moneyLabel;
/* 下划线 */
@property(nonatomic, strong)UIView *line1;
/* 下划线 */
@property(nonatomic, strong)UIView *line2;
/* 支付方式 */
@property(nonatomic, strong)UILabel *payMethodTitle;
/* 支付方式 */
@property(nonatomic, strong)UILabel *payMethodBtn;
/* 更多 */
@property(nonatomic, strong)UILabel *moreLabel;

@end

@implementation WalletRecordCell

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
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.weekLabel];
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.nickLabel];
    [self.bgView addSubview:self.durationLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.stateLabel];
    [self.bgView addSubview:self.moneyTitleLabel];
    [self.bgView addSubview:self.moneyLabel];
    [self.bgView addSubview:self.line1];
    [self.bgView addSubview:self.line2];
    [self.bgView addSubview:self.payMethodTitle];
    [self.bgView addSubview:self.payMethodBtn];
    [self.bgView addSubview:self.moreLabel];
}

- (void)handlerCellWithModel:(WalletTradeRecordModelItem *)model
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.targetUser.headpic imgURLWithSize:self.imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    self.nickLabel.text = model.targetUser.nickname;
    self.timeLabel.text = [Handler dateStrFromCstampTime:model.dealRecordTime withDateFormat:@"yyyy-MM-dd"];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@￥",model.dealMoney];
    self.payMethodBtn.text = @"  支付宝支付";
    if ([model.dealMoneySource isEqualToString:@"1"]) {
        self.payMethodBtn.text = @"  余额支付";
    }
    self.weekLabel.text = [Handler dateStrFromCstampTime:model.dealRecordTime withDateFormat:@"EEEE HH:mm"];
    int time = [Handler handlerJobTime:model.beginTime endTime:model.endTime chargeType:model.chargeType];
    self.durationLabel.text = [NSString stringWithFormat:@"Booked for %d hours",time];
}

#pragma mark - lazy
- (UILabel *)weekLabel
{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
        _weekLabel.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        _weekLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _weekLabel.font = [UIFont fontWithName:pageFontName size:12];
        _weekLabel.textAlignment = NSTextAlignmentCenter;
        _weekLabel.text = @"Wednesday 11:04";
    }
    return _weekLabel;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, walletRecordCellHeight)];
    }
    return _bgView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.weekLabel.frame)+20, 70, 70)];
    }
    return _imgView;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+8, CGRectGetMinY(self.imgView.frame), screenWidth-(CGRectGetMaxX(self.imgView.frame)+8)-16, 24)];
        _nickLabel.backgroundColor = [UIColor whiteColor];
        _nickLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nickLabel.font = [UIFont fontWithName:pageFontName size:14];
        _nickLabel.text = @"Jessica Brown";
    }
    return _nickLabel;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nickLabel.frame), CGRectGetMaxY(self.nickLabel.frame), CGRectGetWidth(self.nickLabel.frame)/2, 18)];
        _durationLabel.backgroundColor = [UIColor whiteColor];
        _durationLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _durationLabel.font = [UIFont fontWithName:pageFontName size:12];
        _durationLabel.text = @"Booked for 2 hours";
    }
    return _durationLabel;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.durationLabel.frame), CGRectGetMinY(self.durationLabel.frame), CGRectGetWidth(self.durationLabel.frame), CGRectGetHeight(self.durationLabel.frame))];
        _stateLabel.backgroundColor = [UIColor whiteColor];
        _stateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _stateLabel.font = [UIFont fontWithName:pageFontName size:12];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.text = @"Payment Successful";
    }
    return _stateLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nickLabel.frame), CGRectGetMaxY(self.durationLabel.frame), CGRectGetWidth(self.nickLabel.frame), 18)];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _timeLabel.font = [UIFont fontWithName:pageFontName size:12];
        _timeLabel.text = @"2017-8-29";
    }
    return _timeLabel;
}

- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame), CGRectGetMaxY(self.imgView.frame), screenWidth-CGRectGetMaxX(self.imgView.frame), 1.5)];
        _line1.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _line1;
}

- (UILabel *)moneyTitleLabel
{
    if (!_moneyTitleLabel) {
        _moneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.imgView.frame), CGRectGetMaxY(self.imgView.frame), 2*screenWidth/3-CGRectGetMinX(self.imgView.frame), 40)];
        _moneyTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _moneyTitleLabel.font = [UIFont fontWithName:pageFontName size:18];
        _moneyTitleLabel.text = @"Total Amount Paid";
    }
    return _moneyTitleLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moneyTitleLabel.frame), CGRectGetMinY(self.moneyTitleLabel.frame), screenWidth/3-CGRectGetMinX(self.imgView.frame), CGRectGetHeight(self.moneyTitleLabel.frame))];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont fontWithName:pageFontName size:15];
        _moneyLabel.text = @"1500$";
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _moneyLabel;
}

- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyTitleLabel.frame), screenWidth, 1.5)];
        _line2.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _line2;
}

- (UILabel *)payMethodTitle
{
    if (!_payMethodTitle) {
        _payMethodTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.imgView.frame), CGRectGetMaxY(self.line2.frame), screenWidth/2-CGRectGetMinX(self.imgView.frame), 45)];
        _payMethodTitle.text = @"Payment Method:";
        _payMethodTitle.textAlignment = NSTextAlignmentRight;
        _payMethodTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        _payMethodTitle.font = [UIFont fontWithName:pageFontName size:14];
    }
    return _payMethodTitle;
}

- (UILabel *)payMethodBtn
{
    if (!_payMethodBtn) {
        _payMethodBtn = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.payMethodTitle.frame), CGRectGetMinY(self.payMethodTitle.frame), CGRectGetWidth(self.payMethodTitle.frame), CGRectGetHeight(self.payMethodTitle.frame))];
        _payMethodBtn.text = @"支付宝";
        _payMethodBtn.textColor = [UIColor colorWithHexString:@"#666666"];
        _payMethodBtn.font = [UIFont fontWithName:buttonFontName size:14];
    }
    return _payMethodBtn;
}

- (UILabel *)moreLabel
{
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payMethodTitle.frame), screenWidth, CGRectGetHeight(self.bgView.frame)-CGRectGetMaxY(self.payMethodTitle.frame))];
        _moreLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _moreLabel.font = [UIFont fontWithName:pageFontName size:12];
        _moreLabel.text = @"More Details";
        _moreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moreLabel;
}

@end
