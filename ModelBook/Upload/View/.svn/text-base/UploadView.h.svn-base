//
//  UploadView.h
//  ModelBook
//
//  Created by Lee on 2017/9/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 社交类型

 - SocialityType_Album: 相册上传
 - SocialityType_Photo: 拍照上传
 - SocialityType_Video: 拍视频上传
 */
typedef NS_ENUM(NSInteger, SocialityType) {
    SocialityType_Album = 0,
    SocialityType_Photo,
    SocialityType_Video,
};

/**
 选择社交类型处理

 @param socialityType 社交类型
 */
typedef void(^ChooseSocialityHandle)(SocialityType socialityType);

@interface UploadView : UIView

/**
 显示视图
 */
- (void)showView;

/**
 选择社交类型处理

 @param chooseSocialityHandle Block
 */
- (void)setChooseSocialityHandle:(ChooseSocialityHandle)chooseSocialityHandle;
@end
