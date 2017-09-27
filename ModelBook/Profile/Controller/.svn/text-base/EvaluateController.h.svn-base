//
//  EvaluateController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class MBJobDetailRecordModel;

typedef void(^commentSuccessBlock)(void);

typedef NS_ENUM(NSInteger, MBEvaluateType) {
    MBEvaluateTypeComment = 0,
    MBEvaluateTypeReport
};

@interface EvaluateController : BaseViewController

/* 类型 */
@property(nonatomic, assign)MBEvaluateType type;
/* 是否查看评论 */
@property(nonatomic, assign)BOOL isShowComment;
/* record信息 */
@property(nonatomic, strong)MBJobDetailRecordModel *recordModel;
/* 评论成功回调 */
@property(nonatomic, copy)commentSuccessBlock commentSuccessBlock;

@end
