//
//  CoverView.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, (frame.size.height-35)/2, 25, 35)];
        [self addSubview:self.leftBtn];
        [self.leftBtn addTarget:self action:@selector(tapLeft) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-10-25, (frame.size.height-35)/2, 25, 35)];
        [self addSubview:self.rightBtn];
        [self.rightBtn addTarget:self action:@selector(tapRight) forControlEvents:UIControlEventTouchUpInside];
        [self.leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
    }
    return self;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.leftBtn.frame, point)) {
        return self.leftBtn;
    }else if(CGRectContainsPoint(self.rightBtn.frame, point))
    {
        return self.rightBtn;
    }else
    {
        return nil;
    }
}
-(void)tapLeft
{
    [self.delegate preImgView];
}
-(void)tapRight
{
    [self.delegate nextImgView];
}
@end
