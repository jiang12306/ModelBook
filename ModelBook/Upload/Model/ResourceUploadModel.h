//
//  ResourceUploadModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceUploadModel : NSObject

/* 数据 */
@property(nonatomic, strong)NSData *data;
/* fileName */
@property(nonatomic, strong)NSString *fileName;
/* 文件路径 */
@property(nonatomic, strong)NSString *filePath;
/* 视频首帧图 */
@property(nonatomic, strong)NSData *imageData;
/* 图片 */
@property(nonatomic, strong)UIImage *image;

@end
