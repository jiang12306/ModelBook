//
//  ProfileResourceModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

//{
//    code = 0;
//    msg = "\U64cd\U4f5c\U6210\U529f";
//    object =     {
//        endRow = 6;
//        firstPage = 1;
//        hasNextPage = 0;
//        hasPreviousPage = 0;
//        isFirstPage = 1;
//        isLastPage = 1;
//        lastPage = 1;
//        list =         (
//                        {
//                            albumId = 14;
//                            fileSrc = "http://39.108.152.114:80/model//upload/album/image/8cce4e4c0f4548ee8af51b220b413c18.gif";
//                            fileType = 0;
//                            isDisabled = 0;
//                            uploadTime = 1502335292000;
//                            userId = 8;
//                        },
//                        {
//                            albumId = 16;
//                            fileSrc = "http://39.108.152.114:80/model//upload/album/image/efc5fe04491c4694a8d89a170b90d3e7.gif";
//                            fileType = 0;
//                            isDisabled = 0;
//                            uploadTime = 1502335451000;
//                            userId = 8;
//                        },
//                        {
//                            albumId = 17;
//                            fileSrc = "http://39.108.152.114:80/model//upload/album/image/909a90561fa642f5989725395bafffa6.jpg";
//                            fileType = 0;
//                            isDisabled = 0;
//                            uploadTime = 1502335451000;
//                            userId = 8;
//                        },
//                        {
//                            albumId = 18;
//                            fileSrc = "http://39.108.152.114:80/model//upload/album/image/1930b01d107a48988aead1cb80041905.gif";
//                            fileType = 0;
//                            isDisabled = 0;
//                            uploadTime = 1502335510000;
//                            userId = 8;
//                        },
//                        {
//                            albumId = 19;
//                            fileSrc = "http://39.108.152.114:80/model//upload/album/image/66982366cbd84d30969bde877d13c350.gif";
//                            fileType = 0;
//                            isDisabled = 0;
//                            uploadTime = 1502335510000;
//                            userId = 8;
//                        },
//                        {
//                            albumId = 20;
//                            fileSrc = "http://39.108.152.114:80/model//upload/album/image/3533f236acc04957b938216f4635748f.jpg";
//                            fileType = 0;
//                            isDisabled = 0;
//                            uploadTime = 1502335510000;
//                            userId = 8;
//                        }
//                        );
//        navigatePages = 8;
//        navigatepageNums =         (
//                                    1
//                                    );
//        nextPage = 0;
//        pageNum = 1;
//        pageSize = 9;
//        pages = 1;
//        prePage = 0;
//        size = 6;
//        startRow = 1;
//        total = 6;
//    };
//}

#import <Foundation/Foundation.h>
@class ResourceItem;

@interface ProfileResourceModel : NSObject

@property(nonatomic, assign)BOOL hasNextPage;
@property(nonatomic, strong)NSArray<ResourceItem *> *resourceInfo;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface ResourceItem : NSObject

/* 上传文件id */
@property(nonatomic, strong)NSString *albumId;
/* 上传文件路径 */
@property(nonatomic, strong)NSString *fileSrc;
/* 文件类型，0代表图片，1代表视频 */
@property(nonatomic, assign)NSString *fileType;
/* 是否禁用，等于false时允许显示，等于true时禁止显示 */
@property(nonatomic, assign)BOOL isDisabled;
/* 上传文件路径 */
@property(nonatomic, strong)NSString *uploadTime;
/* 用户id */
@property(nonatomic, strong)NSString *userId;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
