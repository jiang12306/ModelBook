//
//  MBCommentViewController.h
//  ModelBook
//
//  Created by zdjt on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"
#import "MBJobDetailModel.h"

@class MBJobDetailRecordModel;

typedef NS_ENUM(NSUInteger, MBCommentType) {
    MBCommentTypeDefault = 0,
    MBCommentTypeComplete,
    MBCommentTypeReport
};

@interface MBCommentViewController : BaseViewController

/* record信息 */
@property(nonatomic, strong)MBJobDetailRecordModel *recordModel;
/* 评论成功回调 */
@property(nonatomic, copy) void(^commentSuccessBlock)(void);

@property (assign, nonatomic) MBCommentType commentType;

/* 是否查看评论 */
@property(nonatomic, assign)BOOL isShowComment;

@end
