//
//  ProfileAboutMeCommentCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileCommentModel;

static CGFloat const cellMinHeight = 105;

typedef void(^unfoldActionBlock)(void);

@interface ProfileAboutMeCommentCell : UITableViewCell

@property(nonatomic, copy)unfoldActionBlock unfoldActionBlock;

- (void)handlerCellWithModel:(ProfileCommentModel *)model;

@end
