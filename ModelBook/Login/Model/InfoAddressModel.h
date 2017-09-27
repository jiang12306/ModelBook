//
//  InfoAddressCell.h
//  ModelBook
//
//  Created by zdjt on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoAddressModel : NSObject

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) BOOL state;

+ (InfoAddressModel *)modelWithName:(NSString *)name State:(BOOL)state;

@end
