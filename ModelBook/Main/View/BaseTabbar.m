//
//  BaseTabbar.m
//  ModelBook
//
//  Created by Lee on 2017/9/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseTabbar.h"

#define AddButtonMargin 10

@interface BaseTabbar()

//指向中间按钮
@property (nonatomic,weak) UIButton *addButton;
//指向“添加”标签
@property (nonatomic,weak) UILabel *addLabel;

@end

@implementation BaseTabbar
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //创建中间按钮
        UIButton *addBtn = [[UIButton alloc] init];
        //设置默认背景图片
        [addBtn setBackgroundImage:[UIImage imageNamed:@"upload_normal"] forState:UIControlStateNormal];
        //设置按下时背景图片
//        [addBtn setBackgroundImage:[UIImage imageNamed:@"AddButtonIcon-Active"] forState:UIControlStateHighlighted];
        //button的大小与图片一致
        [addBtn sizeToFit];
        //添加响应事件
        [addBtn addTarget:self action:@selector(addBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        //将按钮添加到TabBar
        [self addSubview:addBtn];
        self.addButton = addBtn;
    }
    return self;
}

//响应中间按钮点击事件
-(void)addBtnDidClick
{
    if([self.myTabBarDelegate respondsToSelector:@selector(addButtonClick:)])
    {
        [self.myTabBarDelegate addButtonClick:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //去掉TabBar上部的横线
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1)   //横线的高度为0.5
        {
            UIImageView *line = (UIImageView *)view;
            line.hidden = YES;
        }
    }
    
    //设置按钮的位置
    // 1.设置按钮的位置
    CGPoint temp = self.addButton.center;
    temp.x = self.frame.size.width/2;
    temp.y = self.frame.size.height/2;
    self.addButton.center = temp;
//    self.addButton.center = CGPointMake(self.center.x, self.frame.size.height * 0.5 - 1.5 * AddButtonMargin);
    
    //创建并设置按钮下方的文本
//    UILabel *addLbl = [[UILabel alloc] init];
//    addLbl.text = @"上传";
//    addLbl.font = [UIFont systemFontOfSize:12];
//    addLbl.textColor = [UIColor grayColor];
//    [addLbl sizeToFit];
//    //设置“添加”label的位置
//    addLbl.center = CGPointMake(self.center.x, CGRectGetMaxY(self.addButton.frame)  + 0.5);
//    [self addSubview:addLbl];
//    self.addLabel = addLbl;
    
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1=child.frame;
            temp1.size.width=tabbarButtonW;
            temp1.origin.x=tabbarButtonIndex * tabbarButtonW;
            child.frame=temp1;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
    //将按钮放到视图层次最前面
    [self bringSubviewToFront:self.addButton];
}

//重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有TabBar的，那么肯定是在根控制器页面
    //在根控制器页面，那么我们就需要判断手指点击的位置是否在按钮或“添加”标签上
    //是的话让按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO)
    {
        
        //将当前TabBar的触摸点转换坐标系，转换到按钮的身上，生成一个新的点
        CGPoint newA = [self convertPoint:point toView:self.addButton];
        //将当前TabBar的触摸点转换坐标系，转换到“添加”标签的身上，生成一个新的点
        CGPoint newL = [self convertPoint:point toView:self.addLabel];
        
        //判断如果这个新的点是在按钮身上，那么处理点击事件最合适的view就是按钮
        if ( [self.addButton pointInside:newA withEvent:event])
        {
            return self.addButton;
        }
        //判断如果这个新的点是在“添加”标签身上，那么也让按钮处理事件
        else if([self.addLabel pointInside:newL withEvent:event])
        {
            return self.addButton;
        }
        else
        {//如果点不在按钮身上，直接让系统处理就可以了
            
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {
        //TabBar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
