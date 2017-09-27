//
//  ProfileChildMyJobsController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileChildMyJobsController.h"
#import "Const.h"
#import "ProfileMyJobListCell.h"
#import "NetworkManager.h"
#import <MJRefresh.h>
#import "MyJobsListModel.h"
#import "MBProfileMyJobsDetailController.h"
#import "ProgressHUD.h"
#import "UIView+Alert.h"
#import "ProfileMyJobClassCell.h"
#import "JobListClassifyModel.h"

static NSString * const myjobListURL = @"http://39.108.152.114/modeltest/job/query/mylist";

@interface ProfileChildMyJobsController ()<UITableViewDelegate, UITableViewDataSource>

/* 视图frame */
@property(nonatomic, assign)CGRect frame;
/* tableview */
@property(nonatomic, strong)UITableView *tableView;
/* 页码 */
@property(nonatomic, assign)NSInteger pageNum;
/* 数据源 */
@property(nonatomic, strong)NSMutableArray *dataSource;
/* 是否可以继续上啦加载 */
@property(nonatomic, assign)BOOL isContinue;
/* 缺省 */
@property(nonatomic, strong)UIView *defaultView;
/* 分类字典数组 */
@property(nonatomic, strong)NSMutableArray *classArray;
/* 图片数组 */
@property(nonatomic, strong)NSArray *imageArray;
/* 分类index，-1则未分类 */
@property(nonatomic, assign)NSInteger classIndex;

@end

@implementation ProfileChildMyJobsController

- (instancetype)initWithTableFrame:(CGRect)frame
{
    _classIndex = -1;
    _isContinue = YES;
    _pageNum = 1;
    _frame = frame;
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initData
{
    [self requestJobClassesRequest];
}

- (void)reloadData
{
    if (_classIndex == -1)
    {
        [self.tableView reloadData];
        [self requestJobClassesRequest];
    }
    else
    {
        [_dataSource removeAllObjects];
        [self.tableView reloadData];
        _isContinue = YES;
        _pageNum = 1;
        [self requestMyJobsList];
    }
}

- (void)initLayout
{
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:reloadMyJobsNotification object:nil];
}

- (void)switchToClassifyState
{
    self.classIndex = -1;
    [self reloadData];
}

#pragma mark - network
- (void)requestMyJobsList
{
    if (!self.isContinue) return;
    NSString *targetUserId = self.userId;
    if ([self.userId isEqualToString:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]]) targetUserId = nil;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"currentUserId"];
//    [md setValue:@"35" forKey:@"currentUserId"];
    [md setValue:targetUserId forKey:@"targetUserId"];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)_classIndex] forKey:@"recordClassify"];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum] forKey:@"pageNum"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:myjobListURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                MyJobsListModel *model = [[MyJobsListModel alloc] initWithDict:responseObject[@"object"]];
                [weakSelf.dataSource addObjectsFromArray:model.jobInfo];
                [weakSelf.tableView reloadData];
                weakSelf.isContinue = model.hasNextPage;
                weakSelf.pageNum++;
            }
        }
        [weakSelf handlerRequestData];
    } failure:^(NSError *error) {
        [weakSelf handlerRequestData];
    }];
}

- (void)requestJobClassesRequest
{
    NSString *targetUserId = self.userId;
    if ([self.userId isEqualToString:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]]) targetUserId = nil;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"currentUserId"];
//    [md setValue:@"35" forKey:@"currentUserId"];
    [md setValue:targetUserId forKey:@"targetUserId"];
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/job/query/myJobListClassify" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                NSArray *array = responseObject[@"object"];
                [weakSelf.classArray removeAllObjects];
                for (NSDictionary *dic in array) {
                    JobListClassifyModel *model = [[JobListClassifyModel alloc] initWithDict:dic];
                    [weakSelf.classArray addObject:model];
                }
                [weakSelf handlerClassifyData];
            }
        }
    } failure:^(NSError *error) {
        [weakSelf handlerClassifyData];
    }];
}

- (void)handlerClassifyData
{
    self.tableView.mj_footer = nil;
    [self.tableView.mj_header endRefreshing];
    self.tableView.hidden = NO;
    if (self.classArray.count == 0) self.tableView.hidden = YES;
    [self.tableView reloadData];
}

- (void)handlerRequestData
{
    [self.tableView.mj_header endRefreshing];
    if (self.isContinue)
    {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMyJobsList)];
    }
    else
    {
        if (self.pageNum == 2)
        {
            self.tableView.mj_footer = nil;
        }
        else
        {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
    self.tableView.hidden = NO;
    if (self.dataSource.count == 0) self.tableView.hidden = YES;
}

- (void)deleteJobRecordRequest:(NSString *)recordID
{
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/jobrecord/delete" parameters:@{@"jobrecordid":recordID} constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:NSLocalizedString(@"Delete Success", nil)];
                [weakSelf reloadData];
            }
            else
            {
                [ProgressHUD showText:responseObject[@"msg"]];
            }
        }
        else
        {
            [ProgressHUD showText:NSLocalizedString(@"Delete Failure", nil)];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:NSLocalizedString(@"Delete Failure", nil)];
    }];
}

- (void)hiddenJobRecordRequest:(NSString *)recordID
{
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/jobrecord/hide" parameters:@{@"jobrecordid":recordID} constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:NSLocalizedString(@"Hidden Success", nil)];
                [weakSelf reloadData];
            }
            else
            {
                [ProgressHUD showText:responseObject[@"msg"]];
            }
        }
        else
        {
            [ProgressHUD showText:NSLocalizedString(@"Hidden Failure", nil)];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:NSLocalizedString(@"Hidden Failure", nil)];
    }];
}

- (void)cancelHiddenJobRecordRequest:(NSString *)recordID
{
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/jobrecord/hide/cancel" parameters:@{@"jobrecordid":recordID} constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:NSLocalizedString(@"Cancel Hidden Success", nil)];
                [weakSelf reloadData];
            }
            else
            {
                [ProgressHUD showText:responseObject[@"msg"]];
            }
        }
        else
        {
            [ProgressHUD showText:NSLocalizedString(@"Cancel Hidden Failure", nil)];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:NSLocalizedString(@"Cancel Hidden Failure", nil)];
    }];
}

#pragma mark - tableview - datesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_classIndex == -1)
    {
        return self.classArray.count;
    }
    else
    {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classIndex == -1)
    {
        ProfileMyJobClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMyJobClassCell"];
        if (!cell) {
            cell = [[ProfileMyJobClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileMyJobClassCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row<self.classArray.count)
        {
            JobListClassifyModel *model = self.classArray[indexPath.row];
            [cell handlerCellWithImage:self.imageArray[[model.recordClassify integerValue]] title:myJobListClassifyDicStr(model.recordClassify) count:[model.requestNum integerValue]];
        }
        return cell;
    }
    else
    {
        ProfileMyJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMyJobListCell"];
        if (!cell) {
            cell = [[ProfileMyJobListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileMyJobListCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row<self.dataSource.count)
        {
            jobInfo *model = self.dataSource[indexPath.row];
            [cell handlerCellWithModel:model];
        }
//        WS(weakSelf);
//        cell.backClassActionBlock = ^{
//            weakSelf.classIndex = -1;
//            [weakSelf reloadData];
//        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classIndex == -1) return myJobClassHeight;
    return myJobListHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classIndex == -1)
    {
//        JobListClassifyModel *model = self.classArray[indexPath.row];
//        if ([model.requestNum integerValue] == 0) return;
        _classIndex = indexPath.row;
        [self reloadData];
    }
    else
    {
        if (indexPath.row < self.dataSource.count)
        {
            jobInfo *model = self.dataSource[indexPath.row];
            MBProfileMyJobsDetailController *jobsDetailVC = [[MBProfileMyJobsDetailController alloc] init];
            jobsDetailVC.jobInfo = model;
            jobsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:jobsDetailVC animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classIndex == -1) return NO;
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    jobInfo *model = self.dataSource[indexPath.row];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if (indexPath.row < self.dataSource.count)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to delete this job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 1)
                {
                    [weakSelf.tableView setEditing:NO animated:YES];
                    [weakSelf deleteJobRecordRequest:model.recordId];
                }
            }];
        }
    }];
    if (!model.isHide)
    {
        UITableViewRowAction *hiddenAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"Hidden", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to hidden this job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 1)
                {
                    [weakSelf.tableView setEditing:NO animated:YES];
                    [weakSelf hiddenJobRecordRequest:model.recordId];
                }
            }];
        }];
        hiddenAction.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        return @[deleteRowAction, hiddenAction];
    }
    else
    {
        UITableViewRowAction *cancelHiddenAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"cancelHidden", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to cancel hidden this job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex == 1)
                {
                    [weakSelf.tableView setEditing:NO animated:YES];
                    [weakSelf cancelHiddenJobRecordRequest:model.recordId];
                }
            }];
        }];
        cancelHiddenAction.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        return @[deleteRowAction, cancelHiddenAction];
    }
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
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
        msgLabel.text = NSLocalizedString(@"Temporarily no data", nil);
        msgLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        msgLabel.font = [UIFont systemFontOfSize:16];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:msgLabel];
    }
    return _defaultView;
}

- (NSMutableArray *)classArray
{
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}

- (NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[[UIImage imageNamed:@"request"],[UIImage imageNamed:@"progress"],[UIImage imageNamed:@"mypost"],[UIImage imageNamed:@"completed"],[UIImage imageNamed:@"cancel"],[UIImage imageNamed:@"request"],[UIImage imageNamed:@"request"],[UIImage imageNamed:@"cancel"],[UIImage imageNamed:@"request"],[UIImage imageNamed:@"request"],[UIImage imageNamed:@"cancel"],[UIImage imageNamed:@"request"],[UIImage imageNamed:@"request"]];
    }
    return _imageArray;
}

@end
