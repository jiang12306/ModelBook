//
//  userModel.h
//  ModelBook
//
//  Created by 唐先生 on 2017/8/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    UserTypePhoto= 1,
    UserTypeMakeUp,
    UserTypeModel,
    UserTypeKOL,
    UserTypePAndMakeUp = 12,
}UserType;
@interface UserModel : NSObject
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *headPic;//用户头像地址
@property (nonatomic,assign)int likes;
@property (nonatomic,copy)NSString *nickname;//昵称
@property (nonatomic)UserType userType;
@property (nonatomic)BOOL isLiked;
@property (nonatomic, copy)NSMutableArray * commentArray; // 评论数组

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
