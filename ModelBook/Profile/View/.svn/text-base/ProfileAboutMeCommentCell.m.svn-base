//
//  ProfileAboutMeCommentCell.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileAboutMeCommentCell.h"
#import "Macros.h"
#import "Const.h"
#import "ProfileCommentModel.h"
#import <UIImageView+WebCache.h>
#import "Handler.h"
#import "NSString+imgURL.h"
#import "UIColor+Ext.h"
#import <HCSStarRatingView.h>

@interface ProfileAboutMeCommentCell ()

/* 头像 */
@property(nonatomic, strong)UIImageView *imgView;
/* 昵称 */
@property(nonatomic, strong)UILabel *nickLabel;
/* 评论 */
@property(nonatomic, strong)UILabel *commentLabel;
/* 评分 */
@property(nonatomic, strong)HCSStarRatingView *pointView;
/* 时间 */
@property(nonatomic, strong)UILabel *timeLabel;
/* 按钮 */
@property(nonatomic, strong)UIButton *rightBtn;
/* 评论数据 */
@property(nonatomic, strong)ProfileCommentModel *model;

@end

@implementation ProfileAboutMeCommentCell

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
    [self addSubview:self.pointView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.nickLabel];
    [self addSubview:self.commentLabel];
    [self addSubview:self.rightBtn];
}

- (void)handlerCellWithModel:(ProfileCommentModel *)model
{
    _model = model;
    CGFloat point = [model.point floatValue];
    if (point<=0) point = 5;
    self.pointView.value = point;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.user.headpic imgURLWithSize:self.imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    CGFloat nickNameWidth = [Handler widthForString:[NSString stringWithFormat:@"%@：",model.user.nickname] width:100 FontSize:[UIFont fontWithName:pageFontName size:14]];
    CGFloat nickNameHeight = [Handler heightForString:[NSString stringWithFormat:@"%@：",model.user.nickname] width:1000 FontSize:[UIFont fontWithName:pageFontName size:14]];
    self.nickLabel.frame = CGRectMake(20, CGRectGetMaxY(self.imgView.frame)+10, nickNameWidth, nickNameHeight);
    self.commentLabel.frame = CGRectMake(CGRectGetMaxX(self.nickLabel.frame), CGRectGetMinY(self.nickLabel.frame), screenWidth-90-nickNameWidth, nickNameHeight);
    self.nickLabel.text = [NSString stringWithFormat:@"%@：",model.user.nickname];
    self.commentLabel.text = model.commentContent;
    self.timeLabel.text = [Handler dateStrFromCstampTime:model.commentTime withDateFormat:@"yyyy-MM-dd"];
    self.rightBtn.selected = NO;
    if (model.isUnfold)
    {
        self.rightBtn.selected = YES;
        CGRect frame = self.commentLabel.frame;
        frame.size.height = [Handler heightForString:model.commentContent width:screenWidth-90-nickNameWidth FontSize:[UIFont fontWithName:pageFontName size:14]];
        self.commentLabel.frame = frame;
    }
}

- (void)unfoldAction:(UIButton *)sender
{
    CGFloat nickNameWidth = [Handler widthForString:[NSString stringWithFormat:@"%@：",_model.user.nickname] width:100 FontSize:[UIFont fontWithName:pageFontName size:14]];
    CGFloat height = [Handler heightForString:_model.commentContent width:screenWidth-90-nickNameWidth FontSize:[UIFont fontWithName:pageFontName size:14]];
    if (height<35) return;
    
    sender.selected = !sender.selected;
    _model.isUnfold = sender.selected;
    if (_unfoldActionBlock) _unfoldActionBlock();
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    }
    return _imgView;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.imgView.frame)+10, 200, 20)];
        _nickLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nickLabel.font = [UIFont fontWithName:pageFontName size:14];
    }
    return _nickLabel;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.nickLabel.frame), 200, 0)];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _commentLabel.font = [UIFont fontWithName:pageFontName size:14];
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}

- (HCSStarRatingView *)pointView
{
    if (!_pointView) {
        _pointView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+6, CGRectGetMinY(self.imgView.frame)+7.5, 15*5, 15)];
        _pointView.maximumValue = 5;
        _pointView.minimumValue = 0;
        _pointView.spacing = 1;
        _pointView.value = 5;
        _pointView.allowsHalfStars = YES;
        _pointView.userInteractionEnabled = NO;
        _pointView.tintColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    }
    return _pointView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-115, CGRectGetMinY(self.imgView.frame), 70, 30)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont fontWithName:pageFontName size:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-60, CGRectGetMaxY(self.imgView.frame)+10, 50, 20)];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rightBtn setImage:[UIImage imageNamed:@"comment_n"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"comment_s"] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(unfoldAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
