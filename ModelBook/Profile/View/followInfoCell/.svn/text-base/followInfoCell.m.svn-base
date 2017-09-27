//
//  followInfoCell.m
//  ModelBook
//
//  Created by HZ on 2017/9/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "followInfoCell.h"
#import "FollowInfoModel.h"

@interface followInfoCell ()
{
    clickHandleBtn _clickHandleBtn;
}
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLB;
// 操作按钮
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;

@end

@implementation followInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 数据处理
- (void)setDataModel:(FollowInfoModel *)dataModel {
    _dataModel = dataModel;
    
    self.avatarIV.image = [UIImage imageNamed:dataModel.avatarStr];
    self.nicknameLB.text = dataModel.nicknameStr;
    
    NSString * btnTitle = @"";
    if ([dataModel.handleStr isEqualToString:@"0"]) {
        btnTitle = @"取消关注";
    }
    else if ([dataModel.handleStr isEqualToString:@"1"]) {
        btnTitle = @"关注";
    }
    else if ([dataModel.handleStr isEqualToString:@"2"]) {
        btnTitle = @"取消收藏";
    }
    else if ([dataModel.handleStr isEqualToString:@"3"]) {
        btnTitle = @"取消屏蔽";
    }
    [self.handleBtn setTitle:btnTitle forState:UIControlStateNormal];
}

#pragma mark - 点击操作按钮
- (IBAction)clickHandleBtn:(UIButton *)sender {
    if (_clickHandleBtn) {
        _clickHandleBtn(self.dataModel.handleStr);
    }
}
#pragma mark - 设置回调
- (void)setHandleBtnHandle:(clickHandleBtn)clickHandleBtn {
    _clickHandleBtn = clickHandleBtn;
}

@end
