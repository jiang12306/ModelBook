//
//  JobListClassifyModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobListClassifyModel : NSObject

@property(nonatomic, strong)NSString *recordClassify;
@property(nonatomic, strong)NSString *requestNum;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
