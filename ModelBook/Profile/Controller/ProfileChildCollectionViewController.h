//
//  ProfileChildCollectionViewController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

/**
 数据类型

 - dataTypePhoto: 图片
 - dataTypeVideo: 视频
 */
typedef NS_ENUM(NSInteger, dataType) {
    dataTypePhoto = 0,
    dataTypeVideo
};

@interface ProfileChildCollectionViewController : BaseViewController

- (instancetype)initWithCollectionViewFrame:(CGRect)frame;

/* 用户ID */
@property(nonatomic, strong)NSString *userId;
/* 数据类型 */
@property(nonatomic, assign)dataType type;

- (void)reloadCollectView;

@end
