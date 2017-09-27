//
//  MBProfileMyJobsDetailController.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/3.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBProfileMyJobsDetailController.h"
#import "MyJobsListModel.h"
#import "MBJobDetailModel.h"
#import <UIImageView+WebCache.h>
#import "Handler.h"
#import "Macros.h"
#import "MBJobDetailRecordView.h"
#import "ProgressHUD.h"
#import "MBOrderPayModel.h"
#import "MBOrderPayController.h"
#import "ProfileViewController.h"
#import <KSPhotoItem.h>
#import <KSPhotoBrowser.h>
#import "UIView+Alert.h"
#import "ProfileUserInfoModel.h"
#import "MBPayHandler.h"
#import "NSString+imgURL.h"
#import "MBEventPhotoView.h"
#import "MBCommentViewController.h"

static NSString * jobDetailURL = @"http://39.108.152.114/modeltest/job/query/detail";
static NSString * CreateJobDetailURL = @"http://39.108.152.114/modeltest/job/query/mycreation";
static NSString * cancelMyJobURL = @"http://39.108.152.114/modeltest/job/cancel";
static NSString * cancelJobURL = @"http://39.108.152.114/modeltest/job/apply/cancel";
static NSString * cancelOtherJobURL = @"http://39.108.152.114/modeltest/cancel_model";

@interface MBProfileMyJobsDetailController ()

/* uiscrollview */
@property(nonatomic, strong)UIScrollView *scrollView;
/* 用户信息视图 */
@property(nonatomic, strong)UIView *headerView;
/* job信息视图 */
@property(nonatomic, strong)UIView *jobInfoView;
/* 活动图片信息 */
@property(nonatomic, strong)MBEventPhotoView *eventPhotoView;
/* 模特信息视图 */
@property(nonatomic, strong)MBJobDetailRecordView *modelInfoView;
/* 按钮视图 */
@property(nonatomic, strong)UIView *footerView;
/* jobInfoModel */
@property(nonatomic, strong)MBJobDetailModel *jobDetailModel;
/* record数组 */
@property(nonatomic, strong)NSMutableArray<MBJobDetailRecordModel *> *recordArray;
/* 是否我创建的 */
@property(nonatomic, assign)BOOL isMySelf;
/* 确认按钮 */
@property(nonatomic, strong)UIButton *confirmBtn;
/* 取消按钮 */
@property(nonatomic, strong)UIButton *cancelBtn;
/* 选的record数组 */
@property(nonatomic, strong)NSMutableArray *selectRecordArray;
/* 按钮大 */
@property(nonatomic, assign)CGRect confirmBtnBigFrame;
/* 按钮小 */
@property(nonatomic, assign)CGRect confirmBtnNomalFrame;
/* 按钮小 */
@property(nonatomic, assign)CGRect cancelBtnNomalFrame;
/* 是否批量确认完成  NO则为批量同意 */
@property(nonatomic, assign)BOOL isCompute;
/* 当前job状态 */
@property(nonatomic, assign)MBJobState jobState;
/* 缺省 */
@property(nonatomic, strong)UILabel *msgLabel;
/* 当前订单号 */
@property(nonatomic, strong)NSString *tradeNO;
@property(nonatomic, strong)UIScrollView *imageScrollView;
/* 索引 */
@property(nonatomic, strong)NSMutableDictionary *recordDic;
/* 当前选中模型 */
@property(nonatomic, strong)NSMutableArray *selectRecordIDArray;
/* 是否正在支付定金 */
@property(nonatomic, assign)BOOL isPayDeposit;

@end

@implementation MBProfileMyJobsDetailController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderPaySuccessNotification:) name:alipayOrderPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceOrderPaySuccessNotification:) name:balanceOrderPaySuccessNotification object:nil];
}

- (void)initData
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Job details", nil);
    if ([_jobInfo.recordState isEqualToString:@"0"]) _isMySelf = YES;
    [self requestJobInfo];
    [self.view addSubview:self.msgLabel];
}

- (void)initLayout
{
    self.jobState = [_jobDetailModel.showState integerValue];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.jobInfoView];
    if (self.eventPhotoView) [self.scrollView addSubview:self.eventPhotoView];
    if (_isMySelf) [self.scrollView addSubview:self.modelInfoView];
    [self.scrollView addSubview:self.footerView];
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.footerView.frame))];
    if (self.scrollView.contentSize.height<=CGRectGetHeight(self.scrollView.frame))
    {
        CGFloat height = CGRectGetHeight(self.scrollView.frame)-CGRectGetMinY(self.footerView.frame);
        self.footerView.frame = CGRectMake(0, CGRectGetMinY(self.footerView.frame), CGRectGetWidth(self.scrollView.frame), height);
        _cancelBtnNomalFrame = CGRectMake(CGRectGetWidth(_footerView.frame)-113, height-31-38, 100, 38);
        _confirmBtnNomalFrame = CGRectMake(13, CGRectGetMinY(_cancelBtnNomalFrame), CGRectGetMinX(_cancelBtnNomalFrame)-7-13, 38);
        _confirmBtnBigFrame = CGRectMake(13, CGRectGetMinY(_cancelBtnNomalFrame), CGRectGetWidth(self.view.frame)-26, 38);
        self.cancelBtn.frame = _cancelBtnNomalFrame;
        self.confirmBtn.frame = _confirmBtnNomalFrame;
    }
    [self reloadBtnStatus:MBJobStateNomal];
    switch (self.jobState) {
        case MBJobStateInviteCancel:
        case MBJobStateApplyReject:
        case MBJobStateOverdue:
        case MBJobStateMyCancelWait:
        case MBJobStateCancelWait:
        {
            self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            self.eventPhotoView.collectionView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            self.modelInfoView.collectionView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            self.footerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
            break;
        case MBJobStateComplete:
        {
            if (self.recordArray.count>0)
            {
                self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
                self.eventPhotoView.collectionView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
                self.modelInfoView.collectionView.backgroundColor = [UIColor whiteColor];
                self.footerView.backgroundColor = [UIColor whiteColor];
                break;
            }
        }
        default:
        {
            self.view.backgroundColor = [UIColor whiteColor];
            self.eventPhotoView.collectionView.backgroundColor = [UIColor whiteColor];
            self.modelInfoView.collectionView.backgroundColor = [UIColor whiteColor];
            self.footerView.backgroundColor = [UIColor whiteColor];
        }
            break;
    }
}

- (void)reloadView
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initData];
}

- (void)handlerRecordArray
{
    //TODO 待注释
//    NSMutableArray *newarray = [NSMutableArray array];
//    for (MBJobDetailRecordModel *model in self.recordArray) {
//        int x = arc4random() % 15;
//        MBJobDetailRecordModel *newmodel = [[MBJobDetailRecordModel alloc] init];
//        newmodel.user = model.user;
//        newmodel.showState = [NSString stringWithFormat:@"%d",x+1];
//        [newarray addObject:newmodel];
//    }
    for (NSString *key in [jobStatusDic allKeys]) {
        NSMutableArray *array = [NSMutableArray array];
        for (MBJobDetailRecordModel *model in self.recordArray) {
            if ([model.showState isEqualToString:key])
            {
                [array addObject:model];
            }
        }
        [self.recordDic setValue:array forKey:key];
    }
}

- (void)reloadBtnStatus:(MBJobState)showState
{
    MBJobState state = showState;
    if (showState == MBJobStateNomal) state = _jobState;
    self.confirmBtn.frame = _confirmBtnBigFrame;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    self.confirmBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
    self.cancelBtn.hidden = YES;
    switch (state) {
        case MBJobStateCreate:
        {
            NSArray *array = self.recordDic[[NSString stringWithFormat:@"%ld",(long)MBJobStateCreate]];
            if (array.count>0)
            {
                /* 我发起的 */
                [self.confirmBtn setTitle:@"选择" forState:UIControlStateNormal];
            }
            else
            {
                self.confirmBtn.frame = _confirmBtnNomalFrame;
                [self.confirmBtn setTitle:@"完成工作" forState:UIControlStateNormal];
                self.cancelBtn.hidden = NO;
                [self.cancelBtn setTitle:@"取消工作" forState:UIControlStateNormal];
            }
        }
            break;
        case MBJobStateInvite:
        {
            /* 被邀请的 */
            [self.confirmBtn setTitle:@"加入" forState:UIControlStateNormal];
        }
            break;
        case MBJobStateInviteConfirm:
        {
            /* 被邀请已确认 */
            [self.confirmBtn setTitle:@"取消工作" forState:UIControlStateNormal];
        }
            break;
        case MBJobStateInviteCancel:
        {
            /* 被邀请已取消 */
            [self.confirmBtn setTitle:@"被邀请已取消" forState:UIControlStateNormal];
        }
            break;
        case MBJobStateApplyWait:
        {
            /* 我申请等待 */
            [self.confirmBtn setTitle:@"申请等待中" forState:UIControlStateNormal];
            if (self.selectRecordArray.count>0)
            {
                self.confirmBtn.frame = _confirmBtnNomalFrame;
                self.cancelBtn.hidden = NO;
                [self.confirmBtn setTitle:@"通过" forState:UIControlStateNormal];
            }
        }
            break;
        case MBJobStateApplyReject:
        {
            /* 我申请拒绝 */
            [self.confirmBtn setTitle:@"申请已拒绝" forState:UIControlStateNormal];
        }
            break;
        case MBJobStateApplyConfirm:
        {
            /* 我申请确认 */
            [self.confirmBtn setTitle:@"取消工作" forState:UIControlStateNormal];
            if (self.selectRecordArray.count>0)
            {
                self.confirmBtn.frame = _confirmBtnNomalFrame;
                self.cancelBtn.hidden = NO;
                [self.confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
            }
        }
            break;
        case MBJobStateProgress:
        {
            /* 进行中 */
            [self.confirmBtn setTitle:@"取消工作" forState:UIControlStateNormal];
            if (self.selectRecordArray.count>0)
            {
                self.confirmBtn.frame = _confirmBtnNomalFrame;
                self.cancelBtn.hidden = NO;
                [self.confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
            }
        }
            break;
        case MBJobStateComplete:
        {
            if (self.isMySelf)
            {
                if (showState == MBJobStateNomal)
                {
                    /* 已完成 */
                    [self.confirmBtn setTitle:@"已完成" forState:UIControlStateNormal];
                }
                else
                {
                    [self.confirmBtn setTitle:@"支付" forState:UIControlStateNormal];
                }
            }
            else
            {
                [self.confirmBtn setTitle:@"已完成" forState:UIControlStateNormal];
            }
        }
            break;
        case MBJobStatePaid:
        {
            if (self.isMySelf)
            {
                /* 已支付 */
                [self.confirmBtn setTitle:@"评价" forState:UIControlStateNormal];
            }
            else
            {
                [self.confirmBtn setTitle:@"已支付" forState:UIControlStateNormal];
            }
        }
            break;
        case MBJobStateEvaluate:
        {
            /* 已评价 */
            if (self.isMySelf)
            {
                [self.confirmBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            }
            else
            {
                [self.confirmBtn setTitle:@"已评价" forState:UIControlStateNormal];
            }
        }
            break;
        case MBJobStateOverdue:
        {
            /* 已过期 */
            [self.confirmBtn setTitle:@"已过期" forState:UIControlStateNormal];
        }
            break;
        case MBJobStateHidden:
        {
            /* 已隐藏 */
            [self.confirmBtn setTitle:@"已隐藏" forState:UIControlStateNormal];
        }
            break;
        case MBJobStateMyCancelWait:
        {
            /* 我申请取消待处理 */
            [self.confirmBtn setTitle:@"已取消" forState:UIControlStateNormal];
//            self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        }
            break;
        case MBJobStateCancelWait:
        {
            /* 对方申请取消待处理 */
            [self.confirmBtn setTitle:@"评价" forState:UIControlStateNormal];
        }
            break;
        default:
        {
            [self.confirmBtn setTitle:@"申请加入" forState:UIControlStateNormal];
//            self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        }
            break;
    }
}

/* 按钮状态 */
- (void)btnAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"取消工作"])
    {
        if (_isMySelf)
        {
            [self cancelMyJobRequest];
        }
        else
        {
            [self cancelJobRequest];
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"查看评价"])
    {
        if (self.selectRecordArray.count == 0)
        {
            [ProgressHUD showText:@"请选择一个对象"];
        }
        else
        {
            MBJobDetailRecordModel *model = [self.selectRecordArray firstObject];
            MBCommentViewController *vc = [[MBCommentViewController alloc] init];
            vc.isShowComment = YES;
            vc.commentType = MBCommentTypeComplete;
            vc.recordModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"评价"])
    {
        if (self.selectRecordArray.count == 0)
        {
            [ProgressHUD showText:@"请选择一个对象"];
        }
        else
        {
            MBJobDetailRecordModel *model = [self.selectRecordArray firstObject];
            MBCommentViewController *vc = [[MBCommentViewController alloc] init];
            vc.isShowComment = NO;
            vc.recordModel = model;
            WS(weakSelf);
            vc.commentSuccessBlock = ^{
                [weakSelf reloadJobInfo];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"完成"])
    {
        if (self.selectRecordArray.count>0)
        {
            /* 批量完成任务 */
            [self completeJobRequest];
        }
        else
        {
            [self reloadBtnStatus:MBJobStateNomal];
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"申请加入"])
    {
        [self applyJobRequest];
    }
    else if ([sender.titleLabel.text isEqualToString:@"加入"])
    {
        /* 确认加入 */
        [self confirmBookRequest];
    }
    else if ([sender.titleLabel.text isEqualToString:@"支付"])
    {
        [self.selectRecordIDArray removeAllObjects];
        for (MBJobDetailRecordModel *model in self.selectRecordArray) {
            [self.selectRecordIDArray addObject:model];
        }
        [self payMoney:NO];
    }
    else if ([sender.titleLabel.text isEqualToString:@"通过"])
    {
        /* 批量同意 */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Through the application need to pay a deposit, sure you want to agree with their application?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
        WS(weakSelf);
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            /* 支付定金 */
            [weakSelf payMoney:YES];
        }];
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消"])
    {
        if (self.selectRecordArray.count>0)
        {
            MBJobDetailRecordModel *model = [self.selectRecordArray firstObject];
            if ([model.showState integerValue] == MBJobStateApplyWait)
            {
                [self.selectRecordArray removeAllObjects];
                self.modelInfoView.selectedRecordArray = self.selectRecordArray;
                [self reloadBtnStatus:MBJobStateNomal];
            }
            else
            {
                [self cancelOtherJobRequest];
            }
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"完成工作"])
    {
        [self completeJobRequest];
    }
}

#pragma mark - action
/* 取消按钮事件 */
- (void)cancelAction:(UIButton *)sender
{
    [self btnAction:sender];
}

/* 请求job详情 */
- (void)requestJobInfo
{
    NSString *url = jobDetailURL;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    if (!_isMySelf)
    {
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
        [md setValue:_jobInfo.recordId forKey:@"recordId"];
    }
    else
    {
        [md setValue:_jobInfo.jobId forKey:@"jobId"];
        url = CreateJobDetailURL;
    }
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:url parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *object = responseObject[@"object"];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if (weakSelf.isMySelf)
                    {
                        NSDictionary *job = object[@"job"];
                        NSArray *recordArray = object[@"record"];
                        if ([job isKindOfClass:[NSDictionary class]])
                        {
                            weakSelf.jobDetailModel = [[MBJobDetailModel alloc] initWithDict:job];
                        }
                        if ([recordArray isKindOfClass:[NSArray class]])
                        {
                            for (NSDictionary *dic in recordArray) {
                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                    MBJobDetailRecordModel *record = [[MBJobDetailRecordModel alloc] initWithDict:dic];
                                    record.beginTime = weakSelf.jobDetailModel.beginTime;
                                    record.endTime = weakSelf.jobDetailModel.endTime;
                                    [weakSelf.recordArray addObject:record];
//                                    //TODO 待注释
//                                    for (int i = 0; i<6; i++) {
//                                        [weakSelf.recordArray addObjectsFromArray:weakSelf.recordArray];
//                                    }
                                }
                            }
                        }
                        [weakSelf handlerRecordArray];
                    }
                    else
                    {
                        weakSelf.jobDetailModel = [[MBJobDetailModel alloc] initWithDict:object];
                    }
                    [weakSelf initLayout];
                }
            }
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:@"请求失败，点击重试"];
        weakSelf.msgLabel.hidden = NO;
    }];
}

- (void)reloadJobInfo
{
    /* 刷新列表 */
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadMyJobsNotification object:nil];
    
    NSString *url = jobDetailURL;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    if (!_isMySelf)
    {
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
        [md setValue:_jobInfo.recordId forKey:@"recordId"];
    }
    else
    {
        [md setValue:_jobInfo.jobId forKey:@"jobId"];
        url = CreateJobDetailURL;
    }
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:url parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *object = responseObject[@"object"];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if (weakSelf.isMySelf)
                    {
                        NSDictionary *job = object[@"job"];
                        NSArray *recordArray = object[@"record"];
                        if ([job isKindOfClass:[NSDictionary class]])
                        {
                            weakSelf.jobDetailModel = [[MBJobDetailModel alloc] initWithDict:job];
                            weakSelf.jobState = [weakSelf.jobDetailModel.showState integerValue];
                            [weakSelf reloadBtnStatus:MBJobStateNomal];
                        }
                        [weakSelf.recordArray removeAllObjects];
                        if ([recordArray isKindOfClass:[NSArray class]])
                        {
                            for (NSDictionary *dic in recordArray) {
                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                    MBJobDetailRecordModel *record = [[MBJobDetailRecordModel alloc] initWithDict:dic];
                                    [weakSelf.recordArray addObject:record];
                                }
                            }
                        }
                        [weakSelf handlerRecordArray];
                        [weakSelf.selectRecordArray removeAllObjects];
                        weakSelf.modelInfoView.selectedRecordArray = weakSelf.selectRecordArray;
                        weakSelf.modelInfoView.recordDic = weakSelf.recordDic;
                    }
                    else
                    {
                        weakSelf.jobDetailModel = [[MBJobDetailModel alloc] initWithDict:object];
                        weakSelf.jobState = [weakSelf.jobDetailModel.showState integerValue];
                        [weakSelf reloadBtnStatus:MBJobStateNomal];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:@"请求失败，点击重试"];
        weakSelf.msgLabel.hidden = NO;
    }];
}

/* 取消我的工作 */
- (void)cancelMyJobRequest
{
    WS(weakSelf);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to cancel this job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            NSDictionary *md = @{@"recordId":_jobDetailModel.recordId};
            [[NetworkManager sharedManager] requestWithHTTPPath:cancelMyJobURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]])
                {
                    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    if ([code isEqualToString:@"0"])
                    {
                        [ProgressHUD showText:@"取消工作成功"];
                        [weakSelf reloadJobInfo];
                    }
                    else
                    {
                        [ProgressHUD showText:responseObject[@"msg"]];
                    }
                }
            } failure:^(NSError *error) {
                [ProgressHUD showText:@"取消失败"];
            }];
        }
    }];
}

/* 完成任务 */
- (void)completeJobRequest
{
    NSString *msg = NSLocalizedString(@"Sure you want to complete his this job?", nil);
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSString *recordId = @"";
    if (self.selectRecordArray.count>0)
    {
        for (int i = 0; i<self.selectRecordArray.count; i++) {
            MBJobDetailRecordModel *model = self.selectRecordArray[i];
            recordId = [NSString stringWithFormat:@"%@,%@",recordId,model.recordId];
        }
        if (recordId.length>0) recordId = [recordId substringFromIndex:1];
        
    }
    else
    {
        recordId = self.jobDetailModel.recordId;
        msg = NSLocalizedString(@"Sure you want to complete this job?", nil);
    }
    
    [md setValue:recordId forKey:@"recordId"];
    WS(weakSelf);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/job/complete" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]])
                {
                    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    if ([code isEqualToString:@"0"])
                    {
                        [weakSelf.selectRecordIDArray removeAllObjects];
                        for (MBJobDetailRecordModel *model in weakSelf.selectRecordArray) {
                            [weakSelf.selectRecordIDArray addObject:model];
                        }
                        [weakSelf reloadJobInfo];
                    }
                    else
                    {
                        [ProgressHUD showText:responseObject[@"msg"]];
                    }
                }
            } failure:^(NSError *error) {
                [ProgressHUD showText:@"确认失败"];
            }];
        }
    }];
}

- (void)agreeJobsRequest
{
    WS(weakSelf);
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSString *recordId = @"";
    for (int i = 0; i<self.selectRecordArray.count; i++) {
        MBJobDetailRecordModel *model = self.selectRecordArray[i];
        recordId = [NSString stringWithFormat:@"%@,%@",recordId,model.recordId];
    }
    if (recordId.length>0) recordId = [recordId substringFromIndex:1];
    [md setValue:recordId forKey:@"recordId"];
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/job/confirm_request" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [weakSelf reloadJobInfo];
                [ProgressHUD showText:@"确认成功"];
            }
            else
            {
                [ProgressHUD showText:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:@"确认失败"];
    }];
}

/* 乙方取消任务 */
- (void)cancelJobRequest
{
    WS(weakSelf);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to cancel this job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        NSDictionary *md = @{@"recordId":_jobDetailModel.recordId};
        [[NetworkManager sharedManager] requestWithHTTPPath:cancelJobURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"0"])
                {
                    [ProgressHUD showText:@"取消工作成功"];
                    [weakSelf reloadJobInfo];
                }
                else
                {
                    [ProgressHUD showText:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            [ProgressHUD showText:@"取消工作成功"];
        }];
    }];
}

- (void)applyJobRequest
{
    WS(weakSelf);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to applay this job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
        [md setValue:_jobInfo.jobId forKey:@"jobId"];
        
        [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/job/apply" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"0"])
                {
                    [ProgressHUD showText:@"申请成功"];
                    [weakSelf reloadJobInfo];
                }
                else
                {
                    [ProgressHUD showText:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            [ProgressHUD showText:@"申请失败"];
        }];
    }];
}

- (void)confirmBookRequest
{
    WS(weakSelf);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to join this job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        [md setValue:_jobInfo.recordId forKey:@"recordId"];
        
        [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/job/book/confirm" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"0"])
                {
                    [ProgressHUD showText:@"加入成功"];
                    [weakSelf reloadJobInfo];
                }
                else
                {
                    [ProgressHUD showText:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            [ProgressHUD showText:@"加入失败"];
        }];
    }];
}

- (void)cancelOtherJobRequest
{
    WS(weakSelf);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to cancel his job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        MBJobDetailRecordModel *model = [self.selectRecordArray firstObject];
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"currentUserId"];
        [md setValue:model.recordId forKey:@"recordId"];
        
        [[NetworkManager sharedManager] requestWithHTTPPath:cancelOtherJobURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"0"])
                {
                    [ProgressHUD showText:@"取消成功"];
                    [weakSelf reloadJobInfo];
                }
                else
                {
                    [ProgressHUD showText:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            [ProgressHUD showText:@"取消失败"];
        }];
    }];
}

/**
 付款

 @param isPayDeposit 是否是定金
 */
- (void)payMoney:(BOOL)isPayDeposit
{
    if (isPayDeposit) _isPayDeposit = YES;
    CGFloat totalPrice = 0;
    for (int i = 0; i<self.selectRecordArray.count; i++) {
        totalPrice += [self.jobDetailModel.chargePrice floatValue];
    }
    int time = [Handler handlerJobTime:self.jobDetailModel.beginTime endTime:self.jobDetailModel.endTime chargeType:self.jobDetailModel.chargeType];
    CGFloat ratio = 0.8;
    if (isPayDeposit) ratio = 0.2;
    CGFloat total = ratio*time*totalPrice;
    /* 跳转支付 */
    _tradeNO = [Handler generateTradeNO];
    MBOrderPayModel *orderModel = [[MBOrderPayModel alloc] init];
    orderModel.body = @"MB任务支付";
    orderModel.subject = self.jobInfo.job.jobName;
    orderModel.totalFee = total;
    orderModel.tradeNO = _tradeNO;
    MBOrderPayController *payVC = [[MBOrderPayController alloc] init];
    payVC.orderModel = orderModel;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)pushToUserInfo
{
    [self pushToUserInfo:_jobDetailModel.userId];
}

- (void)pushToUserInfo:(NSString *)userID
{
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:userID];
    profileVC.initialTabPage = InitialTabPageAboutMe;
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)imageTapAction:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    NSArray *imageArray = [_jobDetailModel.jobImage componentsSeparatedByString:@","];
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imgView = [_imageScrollView viewWithTag:i+1];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imgView imageUrl:[NSURL URLWithString:imageArray[i]]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index-1];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
}

- (NSMutableDictionary *)handlerMoneyAndReocrdID:(BOOL)isPayDeposit
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSString *recordId = @"";
    NSString *money = @"";
    CGFloat ratio = 0.8;
    if (isPayDeposit) ratio = 0.2;
    for (int i = 0; i<self.selectRecordIDArray.count; i++) {
        MBJobDetailRecordModel *model = self.selectRecordIDArray[i];
        int time = [Handler handlerJobTime:self.jobDetailModel.beginTime endTime:self.jobDetailModel.endTime chargeType:self.jobDetailModel.chargeType];
        recordId = [NSString stringWithFormat:@"%@,%@",recordId,model.recordId];
        money = [NSString stringWithFormat:@"%@,%@",money,[NSString stringWithFormat:@"%.2f",ratio*[self.jobDetailModel.chargePrice floatValue]*time]];
    }
    if (recordId.length>0) recordId = [recordId substringFromIndex:1];
    if (money.length>0) money = [money substringFromIndex:1];
    [md setValue:recordId forKey:@"recordId"];
    [md setValue:money forKey:@"money"];
    return md;
}

#pragma mark - private
- (NSString *)handlerShowTime:(NSString *)time
{
    NSString *newTime = [time substringToIndex:10];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:newTime];
    return [Handler datestrFromDate:date withDateFormat:@"MM-dd-yyyy"];
}

#pragma mark - notification
- (void)orderPaySuccessNotification:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    if ([[userInfo objectForKey:@"resultStatus"] isEqualToString:@"8000"] || [[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9000"] || [[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9999"])
    {
        /* 支付成功 */
        WS(weakSelf);
        /* 计算总金额 */
        CGFloat totalPrice = 0;
        for (int i = 0; i<self.selectRecordArray.count; i++) {
            totalPrice += [self.jobDetailModel.chargePrice floatValue];
        }
        int time = [Handler handlerJobTime:self.jobDetailModel.beginTime endTime:self.jobDetailModel.endTime chargeType:self.jobDetailModel.chargeType];
        CGFloat ratio = 0.8;
        if (_isPayDeposit) ratio = 0.2;
        CGFloat total = ratio*time*totalPrice;
        /* 通用属性 */
        NSString *dealMoneySource = @"0";
        if ([[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9999"]) dealMoneySource = @"1";
        NSMutableDictionary *md = [self handlerMoneyAndReocrdID:_isPayDeposit];
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"currentUserId"];
        [md setValue:[NSString stringWithFormat:@"%f",total] forKey:@"totalPrice"];
        [md setValue:_tradeNO forKey:@"tradeno"];
        [md setValue:dealMoneySource forKey:@"dealMoneySource"];
        
        if (_isPayDeposit)
        {
            [md setValue:@"同意申请定金支付" forKey:@"dealTypeContent"];
            /* 支付定金成功 */
            [MBPayHandler handlerPayRecord:md payState:payStateNomal comupted:^(BOOL success) {
            }];
            [self agreeJobsRequest];
        }
        else
        {
            /* 支付尾款成功 */
            [md setValue:@"完成任务尾款支付" forKey:@"dealTypeContent"];
            [MBPayHandler handlerPayRecord:md payState:payStateComplete comupted:^(BOOL success) {
                if (success)
                {
                    [weakSelf reloadJobInfo];
                }
            }];
        }
    }
    else
    {
        /* 支付失败 */
    }
    _isPayDeposit = NO;
}

- (void)balanceOrderPaySuccessNotification:(NSNotification *)noti
{
    [self reloadJobInfo];
}

#pragma mark - lazy
- (UIView *)jobInfoView
{
    if (!_jobInfoView) {
        _jobInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 250)];

        CGFloat edge = 20;
        
        NSString *jobName = _jobDetailModel.jobName;
        UILabel *titleNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_jobInfoView.frame), 70)];
        titleNameLab.text = jobName;
        titleNameLab.textAlignment = NSTextAlignmentCenter;
        titleNameLab.font = [UIFont fontWithName:pageFontName size:14];
        titleNameLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [_jobInfoView addSubview:titleNameLab];
        
        UILabel *beginTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(titleNameLab.frame), CGRectGetWidth(_jobInfoView.frame)/2-edge, 20)];
        beginTimeTitle.text = @"Start Time";
        beginTimeTitle.textAlignment = NSTextAlignmentCenter;
        beginTimeTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        beginTimeTitle.font = [UIFont fontWithName:pageFontName size:14];
        [_jobInfoView addSubview:beginTimeTitle];
        
        UILabel *beginTime = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(beginTimeTitle.frame), CGRectGetWidth(beginTimeTitle.frame), 13)];
        beginTime.text = [self handlerShowTime:_jobDetailModel.beginTime];
        beginTime.textAlignment = NSTextAlignmentCenter;
        beginTime.textColor = [UIColor colorWithHexString:@"#666666"];
        beginTime.font = [UIFont fontWithName:pageFontName size:10];
        [_jobInfoView addSubview:beginTime];
        
        UILabel *endTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(beginTimeTitle.frame), CGRectGetMinY(beginTimeTitle.frame), CGRectGetWidth(beginTimeTitle.frame), 20)];
        endTimeTitle.text = @"End Time";
        endTimeTitle.textAlignment = NSTextAlignmentCenter;
        endTimeTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        endTimeTitle.font = [UIFont fontWithName:pageFontName size:14];
        [_jobInfoView addSubview:endTimeTitle];
        
        UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(beginTime.frame), CGRectGetMaxY(beginTimeTitle.frame), CGRectGetWidth(beginTimeTitle.frame), 13)];
        endTime.text = [self handlerShowTime:_jobDetailModel.endTime];
        endTime.textAlignment = NSTextAlignmentCenter;
        endTime.textColor = [UIColor colorWithHexString:@"#666666"];
        endTime.font = [UIFont fontWithName:pageFontName size:10];
        [_jobInfoView addSubview:endTime];
        
        UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(endTime.frame)+10, CGRectGetWidth(_jobInfoView.frame), 23)];
        location.text = [NSString stringWithFormat:@"Location：%@",_jobDetailModel.jobAddress];
        location.textAlignment = NSTextAlignmentCenter;
        location.textColor = [UIColor colorWithHexString:@"#666666"];
        location.font = [UIFont fontWithName:pageFontName size:14];
        [_jobInfoView addSubview:location];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(location.frame), CGRectGetWidth(_jobInfoView.frame), 21)];
        price.text = [NSString stringWithFormat:@"Price：%@",[NSString stringWithFormat:@"%@ %@",_jobDetailModel.chargePrice?:@"",chargeTypeStr(_jobDetailModel.chargeType)]];
        price.textAlignment = NSTextAlignmentCenter;
        price.textColor = [UIColor colorWithHexString:@"#666666"];
        price.font = [UIFont fontWithName:pageFontName size:14];
        [_jobInfoView addSubview:price];
        
        UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(price.frame), CGRectGetWidth(_jobInfoView.frame), 16)];
        sex.text = [NSString stringWithFormat:@"Sex：%@",_jobDetailModel.sex];
        sex.textAlignment = NSTextAlignmentCenter;
        sex.textColor = [UIColor colorWithHexString:@"#666666"];
        sex.font = [UIFont fontWithName:pageFontName size:14];
        [_jobInfoView addSubview:sex];
        
        UILabel *descTitle = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(sex.frame)+20, CGRectGetWidth(_jobInfoView.frame)-2*edge, 27)];
        descTitle.text = @"Job Discription：";
        descTitle.textAlignment = NSTextAlignmentLeft;
        descTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        descTitle.font = [UIFont fontWithName:pageFontName size:10];
        [_jobInfoView addSubview:descTitle];
        
        NSString *content = _jobDetailModel.jobContent?:blank;
        CGFloat height = [Handler heightForString:content width:CGRectGetWidth(descTitle.frame) FontSize:[UIFont fontWithName:pageFontName size:10]];
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(descTitle.frame), CGRectGetMaxY(descTitle.frame), CGRectGetWidth(descTitle.frame), height)];
        desc.text = content;
        desc.numberOfLines = 0;
        desc.textColor = [UIColor colorWithHexString:@"#666666"];
        desc.font = [UIFont fontWithName:pageFontName size:10];
        [_jobInfoView addSubview:desc];
        
        _jobInfoView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(desc.frame)+20);
    }
    return _jobInfoView;
}

- (MBEventPhotoView *)eventPhotoView
{
    if (!_eventPhotoView)
    {
        NSArray *array = [_jobDetailModel.jobImage componentsSeparatedByString:@","];
        NSMutableArray *imgArray = [NSMutableArray array];
        for (NSString *str in array) {
            if (str.length>0) [imgArray addObject:str];
        }
        if (imgArray.count == 0) return nil;
        _eventPhotoView = [[MBEventPhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.jobInfoView.frame), CGRectGetWidth(self.view.frame), 120)];
        _eventPhotoView.dataSource = imgArray;
        _eventPhotoView.jobState = self.jobState;
    }
    return _eventPhotoView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        CGFloat frame_y = CGRectGetMaxY(self.jobInfoView.frame);
        if (self.eventPhotoView) frame_y = CGRectGetMaxY(self.eventPhotoView.frame);
        if (_isMySelf) frame_y = CGRectGetMaxY(self.modelInfoView.frame);
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame_y, CGRectGetWidth(self.view.frame), 100)];
        
        _cancelBtnNomalFrame = CGRectMake(CGRectGetWidth(_footerView.frame)-113, CGRectGetHeight(_footerView.frame)-31-38, 100, 38);
        _confirmBtnNomalFrame = CGRectMake(13, CGRectGetMinY(_cancelBtnNomalFrame), CGRectGetMinX(_cancelBtnNomalFrame)-7-13, 38);
        _confirmBtnBigFrame = CGRectMake(13, CGRectGetMinY(_cancelBtnNomalFrame), CGRectGetWidth(self.view.frame)-26, 38);
        
        _confirmBtn = [[UIButton alloc] initWithFrame:self.confirmBtnBigFrame];
        [_confirmBtn setTitle:@"取消工作" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [_confirmBtn setTitleColor:[UIColor colorWithRed:144/255.0 green:216/255.0 blue:233/255.0 alpha:1] forState:UIControlStateNormal];
        _confirmBtn.layer.borderColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1].CGColor;
        _confirmBtn.layer.borderWidth = 1;
        [_confirmBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_confirmBtn];
        
        _cancelBtn = [[UIButton alloc] initWithFrame:self.cancelBtnNomalFrame];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:242/255.0 green:166/255.0 blue:92/255.0 alpha:1] forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1].CGColor;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.hidden = YES;
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_cancelBtn];
    }
    return _footerView;
}

- (MBJobDetailRecordView *)modelInfoView
{
    if (!_modelInfoView) {
        CGFloat frame_y = CGRectGetMaxY(self.jobInfoView.frame);
        if (self.eventPhotoView) frame_y = CGRectGetMaxY(self.eventPhotoView.frame);
        _modelInfoView = [[MBJobDetailRecordView alloc] initWithFrame:CGRectMake(4, frame_y, CGRectGetWidth(self.view.frame)-8, 100) recordArray:self.recordArray recordDic:self.recordDic];
        _modelInfoView.selectedRecordArray = self.selectRecordArray;
        _modelInfoView.jobState = self.jobState;
        WS(weakSelf);
        _modelInfoView.didClickedRemarkBlock = ^(MBJobDetailRecordModel *recordModel) {
            switch (weakSelf.jobState) {
                case MBJobStateMyCancelWait:
                case MBJobStateOverdue:
                case MBJobStateHidden:
                {
                    /* 不可操作 */
                    return ;
                }
                    break;
                default:
                    break;
            }
            MBJobState state = [recordModel.showState integerValue];
            if ([weakSelf.selectRecordArray containsObject:recordModel])
            {
                [weakSelf.selectRecordArray removeObject:recordModel];
                weakSelf.modelInfoView.selectedRecordArray = weakSelf.selectRecordArray;
                if (weakSelf.selectRecordArray.count == 0)
                {
                    [weakSelf reloadBtnStatus:MBJobStateNomal];
                }
                return;
            }
            switch (state) {
                case MBJobStateApplyWait:
                {
                    switch (weakSelf.jobState) {
                        case MBJobStateEvaluate:
                        case MBJobStatePaid:
                        case MBJobStateComplete:
                        {
                            /* 不可在同意 */
                            return;
                        }
                            break;
                            
                        default:
                            break;
                    }
                    /* 我申请等待，同意/取消，可多选 */
                    if (weakSelf.selectRecordArray.count != 0)
                    {
                        MBJobDetailRecordModel *model = [weakSelf.selectRecordArray firstObject];
                        if (![model.showState isEqualToString:recordModel.showState])
                        {
                            [weakSelf.selectRecordArray removeAllObjects];
                        }
                    }
                    [weakSelf.selectRecordArray addObject:recordModel];
                    weakSelf.modelInfoView.selectedRecordArray = weakSelf.selectRecordArray;
                    [weakSelf reloadBtnStatus:state];
                }
                    break;
                case MBJobStateInviteConfirm:
                case MBJobStateApplyConfirm:
                case MBJobStateProgress:
                case MBJobStateComplete:
                case MBJobStatePaid:
                case MBJobStateEvaluate:
                case MBJobStateCancelWait:
                {
                    [weakSelf.selectRecordArray removeAllObjects];
                    [weakSelf.selectRecordArray addObject:recordModel];
                    weakSelf.modelInfoView.selectedRecordArray = weakSelf.selectRecordArray;
                    [weakSelf reloadBtnStatus:state];
                }
                    break;
                default:
                    break;
            }
        };
        _modelInfoView.didSelectedRecordBlock = ^(MBJobDetailRecordModel *recordModel) {
            /* 进入详情 */
            [weakSelf pushToUserInfo:recordModel.userId];
        };
    }
    return _modelInfoView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSMutableArray<MBJobDetailRecordModel *> *)recordArray
{
    if (!_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

- (NSMutableArray *)selectRecordArray
{
    if (!_selectRecordArray) {
        _selectRecordArray = [NSMutableArray array];
    }
    return _selectRecordArray;
}

- (UILabel *)msgLabel
{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.frame)-64-50)/2, CGRectGetWidth(self.view.frame), 50)];
        _msgLabel.text = @"数据请求失败，点击重试";
        _msgLabel.textColor = [UIColor blackColor];
        _msgLabel.font = [UIFont fontWithName:pageFontName size:18];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.hidden = YES;
        _msgLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestJobInfo)];
        [_msgLabel addGestureRecognizer:tap];
    }
    return _msgLabel;
}

- (NSMutableDictionary *)recordDic
{
    if (!_recordDic) {
        _recordDic = [NSMutableDictionary dictionary];
    }
    return _recordDic;
}

- (NSMutableArray *)selectRecordIDArray
{
    if (!_selectRecordIDArray) {
        _selectRecordIDArray = [NSMutableArray array];
    }
    return _selectRecordIDArray;
}

@end
