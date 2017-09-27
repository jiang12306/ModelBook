//
//  UploadView.m
//  ModelBook
//
//  Created by Lee on 2017/9/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UploadView.h"
#import "UploadButtonItem.h"
#import "UIColor+Ext.h"
#import "Macros.h"

@interface UploadView ()
{
    ChooseSocialityHandle _chooseSocialityHandle; // 选择社交类型处理 Block
    UIButton * _albumUpload; // 相册选取上传
    UIButton * _photoUpload; // 拍照上传
    UIButton * _videoUpload; // 拍视频上传
}
/* 标题数组 */
@property(nonatomic, strong)NSArray *titleArray;
/* 图片数组 */
@property(nonatomic, strong)NSArray<UIImage *> *imageArray;
@end

@implementation UploadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self UIConfig];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 配置UI
- (void)UIConfig {
    //MARK: 蒙层
    UIView * shadowView = [[UIView alloc]initWithFrame:self.bounds];
    shadowView.backgroundColor = [UIColor grayColor];//[UIColor colorWithHexString:@"#C4EAF3"];
    shadowView.alpha = 0.7;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    shadowView.userInteractionEnabled = YES;
    [shadowView addGestureRecognizer:tap];
    [self addSubview:shadowView];
    
    //MARK: 类按钮创建 (相册、拍照、拍视频)
    CGFloat eachWidth = screenWidth / 10.0;
    NSInteger itemCount = self.titleArray.count;
    UIView * itemsView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight /3.0 * 2 - eachWidth, screenWidth, eachWidth * 2.5)];
    itemsView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    itemsView.alpha = 0.7;
    [self addSubview:itemsView];
    
    for (int i = 0; i < itemCount; i++) {
        UploadButtonItem *item = [[UploadButtonItem alloc] initWithFrame:CGRectMake((itemCount * i + 1) * eachWidth,
                                                                                    eachWidth / 2,//screenHeight /3.0 * 2,
                                                                                    eachWidth * 2,
                                                                                    eachWidth * 2)];
//        [item.layer addAnimation:[self positionWithPoint:item.frame.origin] forKey:@"positionY"];
//        [item.layer addAnimation:[self springAniWithRect:item.bounds] forKey:@"boundsAni"];
        item.tag = i + 10086;
        item.title = self.titleArray[i];
        item.image = self.imageArray[i];
        //[self addSubview:item];
        [itemsView addSubview:item];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
        [item addGestureRecognizer:tap];
    }
}

//MARK: Item 点击响应
- (void)itemAction:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag - 10086;
    SocialityType type;
    switch (tag) {
        case 0:
        {
            type = SocialityType_Album;
        }
            break;
        case 1:
        {
            type = SocialityType_Photo;
        }
            break;
//        case 2:
//        {
//            type = SocialityType_Video;
//        }
//            break;
        default:
        {
            type = SocialityType_Video;
        }
            break;
    }
    if (_chooseSocialityHandle) {
        [self removeView];
        _chooseSocialityHandle(type);
    }
}

#pragma mark - 懒加载
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[NSLocalizedString(@"album", nil), NSLocalizedString(@"photo", nil), NSLocalizedString(@"video", /*NSLocalizedString(@"livestreem", */nil)];
    }
    return _titleArray;
}

- (NSArray<UIImage *> *)imageArray {
    if (!_imageArray) {
        _imageArray = @[[UIImage imageNamed:@"video1"], [UIImage imageNamed:@"camer"], [UIImage imageNamed:@"video3"]/*, [UIImage imageNamed:@"video2"]*/];
    }
    return _imageArray;
}

#pragma mark - Block设置
- (void)setChooseSocialityHandle:(ChooseSocialityHandle)chooseSocialityHandle {
    _chooseSocialityHandle = chooseSocialityHandle;
}

#pragma mark - 弹出
- (void)showView {
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}
- (void)creatShowAnimation {
    self.layer.position = self.center;
    self.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 移除
- (void)removeView {
    [self removeFromSuperview];
}

@end
