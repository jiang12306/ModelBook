//
//  UploadEditViewController.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

@protocol UploadEditViewControllerDelegate <NSObject>

- (void)uploadResource:(NSMutableArray *)array isSelectedVideo:(BOOL)isSelectedVideo;

@end

@interface UploadEditViewController : BaseViewController

@property(nonatomic, weak)id<UploadEditViewControllerDelegate> delegate;

@end
