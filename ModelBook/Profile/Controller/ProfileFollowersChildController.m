//
//  ProfileFollowersChildController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileFollowersChildController.h"
#import <MJRefresh.h>
#import "ProfileFollowersTableCell.h"
#import "ProfileFollowModel.h"

static NSString * const myfansRequestURL = @"http://39.108.152.114/modeltest/follow/query/my_fans";
static NSString * const myconcernRequestURL = @"http://39.108.152.114/modeltest/follow/query/my_concern";

@interface ProfileFollowersChildController ()<UITableViewDelegate, UITableViewDataSource>

/* tableFrame */
@property(nonatomic, assign)CGRect frame;
/* followType */
@property(nonatomic, assign)ProfileFollowType followType;
/* tableView */
@property(nonatomic, strong)UITableView *tableView;
/* 数据源 */
@property(nonatomic, strong)NSMutableArray *dataSource;
/* 页码 */
@property(nonatomic, assign)NSInteger pageNum;
/* 是否继续加载更多 */
@property(nonatomic, assign)BOOL isContinue;
/* 缺省 */
@property(nonatomic, strong)UIView *defaultView;

@end

@implementation ProfileFollowersChildController

- (instancetype)initWithTableFrame:(CGRect)frame followType:(ProfileFollowType)followType
{
    _pageNum = 1;
    _isContinue = YES;
    _frame = frame;
    _followType = followType;
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
}

- (void)initData
{
    [self requestFollowData];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - network
- (void)requestFollowData
{
    if (!self.isContinue) return;
    NSString *url = myfansRequestURL;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum] forKey:@"pageNum"];
    
    if (_followType == ProfileFollowTypeFollowing)
    {
        url = myconcernRequestURL;
        [md setValue:self.userId forKey:@"userId"];
    }
    else
    {
        [md setValue:self.userId forKey:@"targetUserId"];
    }
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:url parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                ProfileFollowModel *model = [[ProfileFollowModel alloc] initWithDict:responseObject[@"object"]];
                [weakSelf.dataSource addObjectsFromArray:model.followItemArray];
                [weakSelf.tableView reloadData];
                weakSelf.isContinue = model.hasNextPage;
                if (!weakSelf.isContinue)
                {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    if (weakSelf.pageNum == 1) weakSelf.tableView.mj_footer = nil;
                }
                else if (weakSelf.pageNum == 1)
                {
                    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(requestFollowData)];
                }
                weakSelf.pageNum++;
            }
        }
        [weakSelf handlerRequestData];
    } failure:^(NSError *error) {
        [weakSelf handlerRequestData];
    }];
}

- (void)handlerRequestData
{
    self.tableView.hidden = NO;
    if (self.dataSource.count == 0) self.tableView.hidden = YES;
}

#pragma mark - tableview - datesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self.tableView.mj_footer endRefreshing];
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileFollowersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileFollowersTableCell"];
    if (!cell) {
        cell = [[ProfileFollowersTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileFollowersTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [[UIView alloc] initWithFrame:self.frame];
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame)-30)/2, CGRectGetWidth(self.frame), 30)];
        msgLabel.text = @"暂无数据";
        msgLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        msgLabel.font = [UIFont systemFontOfSize:16];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:msgLabel];
    }
    return _defaultView;
}

@end
