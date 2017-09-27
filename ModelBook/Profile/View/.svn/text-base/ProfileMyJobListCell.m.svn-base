//
//  ProfileMyJobListCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileMyJobListCell.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "Handler.h"
#import "Macros.h"
#import "MyJobsListModel.h"
#import <UIImageView+WebCache.h>
#import "UserInfoManager.h"
#import "NSString+imgURL.h"

static CGFloat const leftEdge = 30;
static CGFloat const rightBtnWidth = 90;
static CGFloat const imageWidth = 28;
static CGFloat const textLabelHeight = 35;

@interface ProfileMyJobListCell ()

/* 图片 */
@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UILabel *timeLabel;
/* title */
@property(nonatomic, strong)UILabel *titleLabel;
/* rightdetail */
@property(nonatomic, strong)UILabel *rightDetailLabel;
@property(nonatomic, strong)UIImageView *rightImgView;
@property(nonatomic, strong)UILabel *redBtn;

@end

@implementation ProfileMyJobListCell

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
    [self addSubview:self.timeLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightDetailLabel];
    [self addSubview:self.rightImgView];
    [self addSubview:self.redBtn];
}

- (void)handlerCellWithModel:(jobInfo *)model
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.job.jobImage imgURLWithSize:self.imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    self.timeLabel.text = [Handler dateStrFromCstampTime:model.recordUpdateTime withDateFormat:@"MM-dd-yyyy"];
    self.titleLabel.text = model.job.jobName;
    NSInteger count = [model.requestNum integerValue];
    self.redBtn.hidden = YES;
    if (count>0)
    {
        self.redBtn.hidden = NO;
        self.redBtn.text = model.requestNum;
    }
    self.rightDetailLabel.text = jobTypeStr(model.showState);
}

- (void)imageTagAction
{
    if (_backClassActionBlock) _backClassActionBlock();
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftEdge, (myJobListHeight-imageWidth)/2, imageWidth, imageWidth)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
//        _imgView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTagAction)];
//        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+8, CGRectGetMinY(self.imgView.frame), screenWidth-CGRectGetMinX(self.rightDetailLabel.frame)-8, 10)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont fontWithName:pageFontName size:10];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.timeLabel.frame), CGRectGetMaxY(self.imgView.frame)-14, CGRectGetWidth(self.timeLabel.frame), 14)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = [UIFont fontWithName:pageFontName size:14];
    }
    return _titleLabel;
}

- (UILabel *)rightDetailLabel
{
    if (!_rightDetailLabel) {
        _rightDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.redBtn.frame)-rightBtnWidth-8, (myJobListHeight-textLabelHeight)/2, rightBtnWidth, textLabelHeight)];
        _rightDetailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _rightDetailLabel.font = [UIFont fontWithName:pageFontName size:12];
        _rightDetailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightDetailLabel;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-20-16, (myJobListHeight-12.5)/2, 7.5, 12.5)];
        _rightImgView.image = [UIImage imageNamed:@"arrow-right"];
    }
    return _rightImgView;
}

- (UILabel *)redBtn
{
    if (!_redBtn) {
        _redBtn = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.rightImgView.frame)-8-20, (myJobListHeight-14)/2, 14, 14)];
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
