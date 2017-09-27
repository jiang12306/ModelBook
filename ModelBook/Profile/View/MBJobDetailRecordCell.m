//
//  MBJobDetailRecordCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBJobDetailRecordCell.h"
#import "MBJobDetailModel.h"
#import <UIImageView+WebCache.h>
#import "ProfileUserInfoModel.h"
#import "NSString+imgURL.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "Macros.h"

@interface MBJobDetailRecordCell ()

/* 头像 */
@property(nonatomic, strong)UIImageView *imgView;
/* 标记按钮 */
@property(nonatomic, strong)UIImageView *remarkImgView;
/* 标记文字 */
@property(nonatomic, strong)UILabel *remarkLabel;
/* 按钮 */
@property(nonatomic, strong)UIButton *remarkBtn;

@end

@implementation MBJobDetailRecordCell

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
    [self addSubview:self.remarkImgView];
    [self addSubview:self.remarkLabel];
    [self addSubview:self.remarkBtn];
}

- (void)handlerCellWithModel:(MBJobDetailRecordModel *)model isSelected:(BOOL)isSelected
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.user.headpic imgURLWithSize:self.imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    _remarkImgView.image = [UIImage imageNamed:@"remark_n"];
    if (isSelected) _remarkImgView.image = [UIImage imageNamed:@"remark_s"];
//    MBJobState jobState = [model.showState integerValue];
//    switch (jobState) {
//        case MBJobStateCreate:
//            case MBJobStateInvite:
//            case MBJobStateInviteCancel:
//            case MBJobStateApplyWait:
//            case MBJobStateApplyReject:
//            case MBJobStateOverdue:
//            case MBJobStateHidden:
//        {
//            self.remarkImgView.hidden = YES;
//            self.remarkBtn.hidden = YES;
//            self.remarkLabel.hidden = NO;
//            self.remarkLabel.text = jobTypeStr(model.showState);
//        }
//            break;
//
//        default:
//        {
//            self.remarkImgView.hidden = NO;
//            self.remarkBtn.hidden = NO;
//            self.remarkLabel.hidden = YES;
//        }
//            break;
//    }
}

#pragma mark - action
- (void)remarkAction:(UIButton *)sender
{
    if (_didClickedRemarkAction) _didClickedRemarkAction();
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 0, CGRectGetWidth(self.frame)-25, CGRectGetWidth(self.frame)-25)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UIImageView *)remarkImgView
{
    if (!_remarkImgView) {
        _remarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-16)/2, CGRectGetMaxY(self.imgView.frame)+7, 16, 16)];
        _remarkImgView.image = [UIImage imageNamed:@"remark_n"];
    }
    return _remarkImgView;
}

- (UILabel *)remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame)+7, CGRectGetWidth(self.frame), 16)];
        _remarkLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _remarkLabel.font = [UIFont fontWithName:pageFontName size:9];
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _remarkLabel;
}

- (UIButton *)remarkBtn
{
    if (!_remarkBtn) {
        _remarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(self.imgView.frame))];
        [_remarkBtn addTarget:self action:@selector(remarkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remarkBtn;
}

@end
