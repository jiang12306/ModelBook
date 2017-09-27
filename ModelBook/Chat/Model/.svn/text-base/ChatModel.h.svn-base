//
//  ChatModel.h
//  ModelBook
//
//  Created by zdjt on 2017/8/17.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserType : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) long userTypeId;

@property (copy, nonatomic) NSString *userTypeName;

@property (assign, nonatomic) BOOL isOpen;

@end

@interface TargetUser : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) long userId;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *nickname;

@property (assign, nonatomic) long userTypeId;

@property (copy, nonatomic) UserType *userType;

@property (assign, nonatomic) long likes;

@property (copy, nonatomic) NSString *headpic;

@end

@interface ChatModel : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) long chatId;

@property (assign, nonatomic) long userId;

@property (assign, nonatomic) long targetUserId;

@property (strong, nonatomic) TargetUser *targetUser;

@property (assign, nonatomic) long chatTime;

@property (assign, nonatomic) long endTime;

@property (copy, nonatomic) NSString *chatType;

@end
