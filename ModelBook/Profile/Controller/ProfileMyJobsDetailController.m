//
//  ProfileMyJobsDetailController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileMyJobsDetailController.h"
#import "ProfileMyJobsDetailHeaderView.h"
#import "MyJobsListModel.h"
#import "MyJobsDetailRecordModel.h"
#import "ProfileMyJobsDetailCell.h"
#import "EvaluateController.h"
#import "ProfileJobCommentModel.h"
#import "ProfileViewController.h"
#import "ProfileCommentModel.h"
#import "ProgressHUD.h"

static CGFloat const headerViewHeight = 30;
static CGFloat const footerViewHeight = 90;
static CGFloat const bottomEdge = 27;
static CGFloat const buttonHeight = 45;

static NSString * const jobDetailLaunchURL = @"http://39.108.152.114/model/job/query/mycreation";
static NSString * const jobDetailSuccessURL = @"http://39.108.152.114/model/job/query/mycompleted";
static NSString * const jobRefuseURL = @"http://39.108.152.114/model/job/refuse_request";
static NSString * const jobComfirmURL = @"http://39.108.152.114/model/job/comfirm_request";

@interface ProfileMyJobsDetailController ()<UITableViewDelegate, UITableViewDataSource>

/* tableview */
@property(nonatomic, strong)UITableView *tableView;
/* headerView */
@property(nonatomic, strong)ProfileMyJobsDetailHeaderView *headerView;
/* job信息 */
@property(nonatomic, strong)jobItem *jobInfo;
/* 确认视图 */
@property(nonatomic, strong)UIView *footerView;
/* sectionHeaderView */
@property(nonatomic, strong)UIView *sectionHeaderView;
/* 数据源 */
@property(nonatomic, strong)NSMutableArray *dataSource;
/* 保存初始状态 */
@property(nonatomic, strong)NSMutableDictionary *recordStatusDic;
/* 编辑状态 */
@property(nonatomic, strong)NSMutableDictionary *editRecordStatusDic;

@end

@implementation ProfileMyJobsDetailController

- (void)dealloc
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)initData
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"profileTitle", nil);
    [self requestJobDetailData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestJobDetailData) name:reloadJobDetailNotification object:nil];
}

- (void)initLayout
{
    [self.view addSubview:self.tableView];
}

#pragma mark - network
- (void)requestJobDetailData
{
//    NSString *url = jobDetailLaunchURL;
//    if (_detailType == ProfileMyJobsDetailTypeSuccess) url = jobDetailSuccessURL;
//    
//    NSMutableDictionary *md = [NSMutableDictionary dictionary];
//    [md setValue:self.jobId forKey:@"jobId"];
//    
//    WS(weakSelf);
//    [[NetworkManager sharedManager] requestWithHTTPPath:url parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//            if ([code isEqualToString:@"0"])
//            {
//                NSDictionary *object = responseObject[@"object"];
//                if ([object isKindOfClass:[NSDictionary class]])
//                {
//                    if (weakSelf.jobInfo)
//                    {
//                        [weakSelf.tableView removeFromSuperview];
//                        weakSelf.tableView = nil;
//                    }
//                    weakSelf.jobInfo = [[jobItem alloc] initWithDict:object[@"job"]];
//                    NSArray *recordArray = object[@"record"];
//                    if (recordArray && [recordArray isKindOfClass:[NSArray class]] && recordArray.count>0)
//                    {
//                        for (NSDictionary *dic in recordArray) {
//                            if (weakSelf.detailType == ProfileMyJobsDetailTypeSuccess)
//                            {
//                                ProfileJobCommentModel *model = [[ProfileJobCommentModel alloc] initWithDict:dic];
//                                [weakSelf.dataSource addObject:model];
//                            }
//                            else if (weakSelf.detailType == ProfileMyJobsDetailTypeLaunch)
//                            {
//                                MyJobsDetailRecordModel *model = [[MyJobsDetailRecordModel alloc] initWithDict:dic];
//                                [weakSelf.dataSource addObject:model];
//                                /* 保存状态 */
//                                [weakSelf.recordStatusDic setValue:model.recordState forKey:model.recordId];
//                                [weakSelf.editRecordStatusDic setValue:model.recordState forKey:model.recordId];
//                            }
//                        }
//                    }
//                    [weakSelf initLayout];
//                }
//            }
//        }
//    } failure:^(NSError *error) {
//    }];
}

- (void)jobApplyRequest:(NSString *)recordId isRefuse:(BOOL)isRefuse
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:recordId forKey:@"recordId"];
    
    NSString *url = jobComfirmURL;
    if (isRefuse) url = jobRefuseURL;
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:url parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]] isEqualToString:@"0"])
        {
            if (isRefuse)
            {
                [ProgressHUD showText:@"拒绝成功！" block:^{
                    [weakSelf.recordStatusDic setValue:@"2" forKey:recordId];
                    [weakSelf.tableView reloadData];
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            else
            {
                [ProgressHUD showText:@"同意成功！" block:^{
                    [weakSelf.recordStatusDic setValue:@"3" forKey:recordId];
                    [weakSelf.tableView reloadData];
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        }
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

#pragma mark - action
- (void)confirmAction:(UIButton *)sender
{
    /* 筛选修改项 */
    for (NSString *key in [self.recordStatusDic allKeys]) {
        if (![self.recordStatusDic[key] isEqualToString:self.editRecordStatusDic[key]]) {
            BOOL isRefuse = YES;
            /* 同意申请 */
            if ([self.editRecordStatusDic[key] isEqualToString:@"3"]) isRefuse = NO;
            [self jobApplyRequest:key isRefuse:isRefuse];
        }
    }
}

#pragma mark - tableview - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileMyJobsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMyJobsDetailCell"];
    if (!cell) {
        cell = [[ProfileMyJobsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileMyJobsDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if (indexPath.row<self.dataSource.count)
//    {
//        if (self.detailType == ProfileMyJobsDetailTypeLaunch)
//        {
//            MyJobsDetailRecordModel *model = self.dataSource[indexPath.row];
//            NSString *recordState = self.editRecordStatusDic[model.recordId];
//            [cell handlerCellWithLaunchRecordUserModel:model recordState:recordState];
//            WS(weakSelf);
//            cell.didCahngedRecordState = ^(NSString *recordState) {
//                NSLog(@"recordState === %@",recordState);
//                [weakSelf.editRecordStatusDic setValue:recordState forKey:model.recordId];
//            };
//            cell.isCanApply = ^BOOL{
//                NSInteger count = 0;
//                NSArray *array = [weakSelf.editRecordStatusDic allValues];
//                for (NSString *record in array) {
//                    if ([record isEqualToString:@"3"]) count++;
//                }
//                if (count>[weakSelf.jobInfo.userNumber integerValue]) return NO;
//                return YES;
//            };
//        }
//        else if (self.detailType == ProfileMyJobsDetailTypeSuccess)
//        {
//            ProfileJobCommentModel *model = self.dataSource[indexPath.row];
//            [cell handlerCellWithSuccessRecordUserModel:model];
//            WS(weakSelf);
//            cell.didClickedCommentAction = ^{
//                ProfileJobCommentModel *model = weakSelf.dataSource[indexPath.row];
//                EvaluateController *vc = [[EvaluateController alloc] init];
//                vc.commentModel = model;
//                vc.jobID = weakSelf.jobInfo.jobId;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            };
//        }
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.dataSource.count)
    {
        if (self.detailType == ProfileMyJobsDetailTypeSuccess)
        {
            ProfileJobCommentModel *model = self.dataSource[indexPath.row];
            ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:model.jobComment.userId];
            [self.navigationController pushViewController:profileVC animated:YES];
        }
        else if (self.detailType == ProfileMyJobsDetailTypeLaunch)
        {
            MyJobsDetailRecordModel *model = self.dataSource[indexPath.row];
            ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:model.userId];
            [self.navigationController pushViewController:profileVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataSource.count == 0) return 0;
    return headerViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataSource.count == 0) return [UIView new];
    return self.sectionHeaderView;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        if (self.dataSource.count > 0 && self.detailType == ProfileMyJobsDetailTypeLaunch)
        {
            _tableView.tableFooterView = self.footerView;
        }
        else
        {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
            _tableView.tableFooterView = footerView;
        }
    }
    return _tableView;
}

- (ProfileMyJobsDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[ProfileMyJobsDetailHeaderView alloc] initWithJobInfoModel:self.jobInfo];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, footerViewHeight)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, 0, screenWidth-2*leftEdge, footerViewHeight-bottomEdge)];
        coverView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [_footerView addSubview:coverView];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageLeftEdge, CGRectGetHeight(coverView.frame)-buttonHeight-imageLeftEdge, CGRectGetWidth(coverView.frame)-2*imageLeftEdge, buttonHeight)];
        [confirmBtn setTitle:NSLocalizedString(@"profileconfirm", nil) forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        confirmBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        confirmBtn.layer.cornerRadius = 5;
        [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [coverView addSubview:confirmBtn];
    }
    return _footerView;
}

- (UIView *)sectionHeaderView
{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerViewHeight)];
        _sectionHeaderView.backgroundColor = [UIColor whiteColor];
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, 0, screenWidth-2*leftEdge, headerViewHeight)];
        coverView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [_sectionHeaderView addSubview:coverView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageLeftEdge, 10, 80, headerViewHeight-10)];
        titleLabel.text = @"参与者";
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        [coverView addSubview:titleLabel];
    }
    return _sectionHeaderView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableDictionary *)recordStatusDic
{
    if (!_recordStatusDic) {
        _recordStatusDic = [NSMutableDictionary dictionary];
    }
    return _recordStatusDic;
}

- (NSMutableDictionary *)editRecordStatusDic
{
    if (!_editRecordStatusDic) {
        _editRecordStatusDic = [NSMutableDictionary dictionary];
    }
    return _editRecordStatusDic;
}

@end
