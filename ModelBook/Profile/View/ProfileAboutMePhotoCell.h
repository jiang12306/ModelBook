//
//  ProfileAboutMePhotoCell.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileCommentImageItem;

static CGFloat const photoCellHeight = 70;

@interface ProfileAboutMePhotoCell : UITableViewCell

/* 数据源 */
@property(nonatomic, strong)NSMutableArray<ProfileCommentImageItem *> *imageArray;

@end
