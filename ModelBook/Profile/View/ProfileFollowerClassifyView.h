//
//  ProfileFollowerClassifyView.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const classifyCount = 2;

typedef void(^didSelectedIndex)(NSInteger index);

@interface ProfileFollowerClassifyView : UIView

/* 点击事件block回调 */
@property(nonatomic, copy)didSelectedIndex didSelectedIndex;
/* 当前按钮index */
@property(nonatomic, assign)NSInteger curIndex;

@end