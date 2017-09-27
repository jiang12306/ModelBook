//
//  ProfileJobCommentModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProfileCommentModel;

@interface ProfileJobCommentModel : NSObject

/* 评论内容 */
@property(nonatomic, strong)ProfileCommentModel *jobComment;
/* 评论ID */
@property(nonatomic, strong)NSString *recordId;
/* 评论状态 */
@property(nonatomic, strong)NSString *recordState;
/* 开始时间 */
@property(nonatomic, strong)NSString *beginTime;
/* 结束时间 */
@property(nonatomic, strong)NSString *endTime;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
