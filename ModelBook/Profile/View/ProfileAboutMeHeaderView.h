//
//  ProfileAboutMeHeaderView.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

//Chiang
typedef void (^SelectAuthorizeType) (NSInteger authorizeIndex);

@class ProfileUserInfoModel;

@interface ProfileAboutMeHeaderView : UIView

/* 用户模型数据 */
@property(nonatomic, strong)ProfileUserInfoModel *userInfoModel;

/** Chiang block回调给controller认证类型
 *  @param type=1，个人认证；type=2，企业认证
 */
-(void)clickedSelectAuthorizeType:(SelectAuthorizeType )type;

@end
