//
//  MBJobDetailRecordView.h
//  ModelBook
//
//  Created by 高昇 on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"
@class MBJobDetailRecordModel;

typedef void(^didSelectedRecordBlock)(MBJobDetailRecordModel *recordModel);
typedef void(^didClickedRemarkBlock)(MBJobDetailRecordModel *recordModel);

@interface MBJobDetailRecordView : UIView

@property(nonatomic, strong)UICollectionView *collectionView;
/* 当前job状态 */
@property(nonatomic, assign)MBJobState jobState;
/* 索引 */
@property(nonatomic, strong)NSMutableDictionary *recordDic;
/* record数据源 */
@property(nonatomic, strong)NSMutableArray<MBJobDetailRecordModel *> *recordArray;
/* 选中的recordArray */
@property(nonatomic, strong)NSMutableArray<MBJobDetailRecordModel *> *selectedRecordArray;

/* 点击回调 */
@property(nonatomic, copy)didSelectedRecordBlock didSelectedRecordBlock;
@property(nonatomic, copy)didClickedRemarkBlock didClickedRemarkBlock;

- (instancetype)initWithFrame:(CGRect)frame recordArray:(NSMutableArray<MBJobDetailRecordModel *> *)recordArray recordDic:(NSMutableDictionary *)recordDic;

@end
