//
//  NSString+imgURL.m
//  ModelBook
//
//  Created by txy on 2017/9/18.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "NSString+imgURL.h"

@implementation NSString (imgURL)
-(NSString *)imgURLWithSize:(CGSize)size
{
    NSString *sizeStr = [NSString stringWithFormat:@"%.fx%.f",size.width,size.height];
    NSString *urlStr = [NSString stringWithFormat:@"%@!/both/%@",self,sizeStr];
    return urlStr;
}
@end
