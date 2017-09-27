//
//  HomeTableViewCell.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CustomHudView.h"

@interface HomeTableViewCell(){
    ClickAvatarHandle _clickAvatarBlock;
    ClickLikeBtnHandle _clickLikeBtnBlock;
    ClickContentHandle _clickContentBlock;
    ClickCommentHandle _clickCommentBlock;
}
@property (weak, nonatomic) IBOutlet UIImageView *avatar;       // 头像
@property (weak, nonatomic) IBOutlet UILabel *nickName;         // 昵称
@property (weak, nonatomic) IBOutlet UIImageView *contentPic;   // 内容
@property (weak, nonatomic) IBOutlet UIButton *isLikeBtn;       // 喜欢
@property (weak, nonatomic) IBOutlet UILabel *likesNumLabel;    // 喜欢数
@property (weak, nonatomic) IBOutlet UIButton *redPackets;      // 发红包

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 头像
    self.avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer * avatarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAvatar)];
    [self.avatar addGestureRecognizer:avatarTap];
    
    // 内容图片
    self.contentPic.userInteractionEnabled = YES;
    UITapGestureRecognizer * contentPicTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickContentPic)];
    [self.contentPic addGestureRecognizer:contentPicTap];
}

//MARK: 点赞
- (IBAction)likes:(UIButton *)sender {
    sender.selected = !sender.selected;
    _clickLikeBtnBlock(sender.selected);
}
// MARK: 评论
- (IBAction)chat:(UIButton *)sender {
    // sender.selected = !sender.selected;
    if (_clickCommentBlock) {
        _clickCommentBlock(self.model.userId, self.model.nickname);
    }
}
//
- (IBAction)comment:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

//MARK: 点击头像
- (void)clickAvatar {
    if (_clickAvatarBlock) {
        _clickAvatarBlock();
    }
}

//MARK: 点击内容图片
- (void)clickContentPic {
    if (_clickContentBlock) {
        _clickContentBlock(self.contentPic);
    }
}

//MARK: 更多操作
- (IBAction)handle:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *storeToAlbum = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.contentPic.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }];
    UIAlertAction *reportAC = [UIAlertAction actionWithTitle:NSLocalizedString(@"Report", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelAC];
    [alertVC addAction:storeToAlbum];
    [alertVC addAction:reportAC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    (error==nil)?[CustomHudView showWithTip:NSLocalizedString(@"Save Success", nil)]:[CustomHudView showWithTip:error.description];
}



-(void)setModel:(UserModel *)model
{
    _model = model;
    
    // 头像
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.headPic] placeholderImage:nil];
    self.avatar.contentMode = UIViewContentModeScaleAspectFill;
    self.avatar.layer.masksToBounds = YES;
    
    // 昵称
    self.nickName.text = model.nickname;
    
    // 最新动态
    [self.contentPic sd_setImageWithURL:[NSURL URLWithString:model.headPic] placeholderImage:nil];
    self.contentPic.contentMode = UIViewContentModeScaleAspectFill;
    self.contentPic.layer.masksToBounds = YES;
    
    // 是否喜欢
    self.isLikeBtn.selected = model.isLiked;
    
    // 喜欢数
    self.likesNumLabel.text = [NSString stringWithFormat:@"%d likes",model.likes];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedBackgroundView = nil;
}

#pragma mark - 设置block回调
- (void)setClickAvatarHandle:(ClickAvatarHandle)clickAvatarBlock {
    _clickAvatarBlock = clickAvatarBlock;
}

- (void)setClickLikeBtnHandle:(ClickLikeBtnHandle)clickLikeBtnBlock {
    _clickLikeBtnBlock = clickLikeBtnBlock;
}

- (void)setClickContentHandle:(ClickContentHandle)clickContentBlock {
    _clickContentBlock = clickContentBlock;
}

- (void)setClickCommentHandle:(ClickCommentHandle)clickCommentBlock {
    _clickCommentBlock = clickCommentBlock;
}

@end
