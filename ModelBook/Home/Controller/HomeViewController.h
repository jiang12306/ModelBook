//
//  HomeViewController.h
//  ModelBook
//
//  Created by 唐先生 on 2017/8/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController
/** 按钮高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonH;
/** 摄影化妆师按钮 */
@property (weak, nonatomic) IBOutlet UIButton *ClassficationBtn;
/** 模特按钮 */
@property (weak, nonatomic) IBOutlet UIButton *ModelBtn;
/** 网红按钮 */
@property (weak, nonatomic) IBOutlet UIButton *KOLBtn;
/** UICollectionView表 */
@property (weak, nonatomic) IBOutlet UICollectionView *ContentCollectionView;
/** UITableView表 */
@property (weak, nonatomic) IBOutlet UITableView *mode2TableView;
@end
