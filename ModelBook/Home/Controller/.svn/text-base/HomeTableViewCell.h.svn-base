//
//  HomeTableViewCell.h
//  ModelBook
//
//  Created by 唐先生 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef void(^ClickAvatarHandle)();
typedef void(^ClickLikeBtnHandle)(BOOL isLike);
typedef void(^ClickContentHandle)(UIImageView * contentImageView);
typedef void(^ClickCommentHandle)(NSString * userID, NSString * nickName);

@interface HomeTableViewCell : UITableViewCell
@property (nonatomic,strong)UserModel *model;


/**
 设置点击头像回调

 @param clickAvatarBlock Block
 */
- (void)setClickAvatarHandle:(ClickAvatarHandle) clickAvatarBlock;

/**
 设置点击喜欢按钮回调

 @param clickLikeBtnBlock Block
 */
- (void)setClickLikeBtnHandle:(ClickLikeBtnHandle) clickLikeBtnBlock;

/**
 设置点击内容图片回调

 @param clickContentBlock Block
 */
- (void)setClickContentHandle:(ClickContentHandle) clickContentBlock;

/**
 设置点击评论回调

 @param clickCommentBlock Block
 */
- (void)setClickCommentHandle:(ClickCommentHandle) clickCommentBlock;
@end
