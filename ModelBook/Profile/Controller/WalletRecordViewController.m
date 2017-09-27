//
//  WalletRecordViewController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "WalletRecordViewController.h"
#import "WalletRecordCell.h"
#import "WalletTradeRecordModel.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "NSString+imgURL.h"

static NSString * const tradeRecordURL = @"http://39.108.152.114/modeltest/dealrecord/query";

@interface WalletRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

/* tableView */
@property(nonatomic, strong)UITableView *tableView;
/* headerView */
@property(nonatomic, strong)UIView *headerView;
/* 昵称 */
@property(nonatomic, strong)UILabel *titleLab;
/* 记录数据源 */
@property(nonatomic, strong)NSMutableArray *dataSource;
/* 页码 */
@property(nonatomic, assign)NSInteger pageNum;
/* 是否继续加载更多 */
@property(nonatomic, assign)BOOL isContinue;

@end

@implementation WalletRecordViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _pageNum = 1;
        _isContinue = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestTradeRecordRequest];
    [self initlayout];
}

- (void)initlayout
{
    self.navigationItem.title = NSLocalizedString(@"History", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mar - network
- (void)requestTradeRecordRequest
{
    if (!_isContinue) return;
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum]
          forKey:@"pageNum"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:tradeRecordURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                WalletTradeRecordModel *model = [[WalletTradeRecordModel alloc] initWithDict:responseObject[@"object"]];
                [weakSelf.dataSource addObjectsFromArray:model.recordArray];
                [weakSelf.tableView reloadData];
                weakSelf.isContinue = model.hasNextPage;
                if (!weakSelf.isContinue)
                {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    if (weakSelf.pageNum == 1) weakSelf.tableView.mj_footer = nil;
                }
                else if (weakSelf.pageNum == 1)
                {
                    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(requestTradeRecordRequest)];
                }
                weakSelf.pageNum++;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self.tableView.mj_footer endRefreshing];
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletRecordCell"];
    if (!cell) {
        cell = [[WalletRecordCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WalletRecordCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row<self.dataSource.count)
    {
        WalletTradeRecordModelItem *model = self.dataSource[indexPath.row];
        [cell handlerCellWithModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return walletRecordCellHeight;
}

#pragma mark - lazy
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 95)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 80, 80)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[[UserInfoManager headpic] imgURLWithSize:imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
        [_headerView addSubview:imgView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+20, 32.5, CGRectGetWidth(self.view.frame)-(CGRectGetMaxX(imgView.frame)+20)-65, 30)];
        _titleLab.text = @"钱包  $0";
        _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLab.font = [UIFont fontWithName:pageFontName size:14];
        [_headerView addSubview:_titleLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame)-0.5, CGRectGetWidth(self.view.frame), 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [_headerView addSubview:line];
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-topBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
