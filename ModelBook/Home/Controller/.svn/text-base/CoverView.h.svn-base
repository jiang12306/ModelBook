//
//  CoverView.h
//  ModelBook
//
//  Created by 唐先生 on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoverView;
@protocol CoverViewDelegate <NSObject>
-(void)nextImgView;
-(void)preImgView;

@end
@interface CoverView : UIView
@property(weak)id delegate;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
-(instancetype)initWithFrame:(CGRect)frame;
@end
