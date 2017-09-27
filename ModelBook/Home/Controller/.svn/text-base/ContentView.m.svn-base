//
//  ContentView.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView
-(instancetype)initWithFrame:(CGRect)frame imgArr:(NSArray *)imgArr setIndex:(int)index islocal:(BOOL)local
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgV = [[ImgScrollView alloc]initWithFrame:CGRectMake(0, 0, 200, 200) imgArr:imgArr setIndex:index islocal:local];
        self.likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 205, 30, 30)];
        [self.likeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.chatBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 205, 30, 30)];
        [self.chatBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return self;
}

@end
