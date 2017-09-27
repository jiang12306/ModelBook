//
//  ProfileEditInfoCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const ProfileEditInfoCellHeight = 40;

@protocol ProfileEditInfoCellDelegate <NSObject>

- (BOOL)textFieldBeginEditing:(NSInteger)index;

@end

@interface ProfileEditInfoCell : UITableViewCell

/* textField */
@property(nonatomic, strong)UITextField *textField;
/* textField点击代理 */
@property(nonatomic, weak)id<ProfileEditInfoCellDelegate> delegate;

- (void)handlerCellWithImage:(UIImage *)image title:(NSString *)title value:(NSString *)value index:(NSInteger)index unit:(NSString *)unit;

@end
