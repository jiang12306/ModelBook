//
//  ContentView.h
//  ModelBook
//
//  Created by 唐先生 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgScrollView.h"
@interface ContentView : UIView
@property(nonatomic,strong)ImgScrollView *imgV;
@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,strong)UIButton *chatBtn;
@property(nonatomic,strong)UILabel *likeLabel;
@property(nonatomic,strong)UILabel *SuperLabel;
@property(nonatomic,strong)UIButton *Btn;
-(instancetype)initWithFrame:(CGRect)frame imgArr:(NSArray *)imgArr setIndex:(int)index islocal:(BOOL)local;
@end
