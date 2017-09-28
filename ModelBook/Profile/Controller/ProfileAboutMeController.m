//
//  ProfileAboutMeController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileAboutMeController.h"
#import "ProfileUserInfoModel.h"
#import "ProfileAboutMeHeaderView.h"
#import "ProfileAboutMePhotoCell.h"
#import "ProfileAboutMeCommentCell.h"
#import "ProfileCommentImageModel.h"
#import "ProfileCommentModel.h"
#import "Handler.h"
#import "ProfileEditInfoController.h"
#import "ProfilePersonalAuthorizeViewController.h"//Chiang
#import "ProfileEnterpriseAuthorizeViewController.h"//Chiang

static NSString * const commentImageRequestURL = @"http://39.108.152.114/modeltest/job/query/comment_user_images_why";
static NSString * const commentDataRequestURL = @"http://39.108.152.114/modeltest/job/query/comment_user";

@interface ProfileAboutMeController ()<UITableViewDelegate, UITableViewDataSource>

/* tableView */
@property(nonatomic, strong)UITableView *tableView;
/* frame */
@property(nonatomic, assign)CGRect frame;
/* headerView */
@property(nonatomic, strong)ProfileAboutMeHeaderView *headerView;
/* 评论数据源 */
@property(nonatomic, strong)NSMutableArray *dataSource;
/* 评论图片数据 */
@property(nonatomic, strong)NSMutableArray<ProfileCommentImageItem *> *commentImageArray;
/* titleArray */
@property(nonatomic, strong)NSArray *titleArray;

@end

@implementation ProfileAboutMeController

- (instancetype)initWithTableFrame:(CGRect)frame
{
    _frame = frame;
    self = [super init];
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
}

- (void)initData
{
    [self requestCommentData];
    [self requestCommentImagesData];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - network
- (void)requestCommentImagesData
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:self.userId forKey:@"userId"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:commentImageRequestURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                ProfileCommentImageModel *model = [[ProfileCommentImageModel alloc] initWithDict:responseObject[@"object"]];
                [weakSelf.commentImageArray addObjectsFromArray:model.commentInfo];
                [weakSelf.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

- (void)requestCommentData
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:self.userId forKey:@"userId"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:commentDataRequestURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                NSArray *objectArray = responseObject[@"object"];
                if ([objectArray isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary *dic in objectArray) {
                        ProfileCommentModel *model = [[ProfileCommentModel alloc] initWithDict:dic];
                        [weakSelf.dataSource addObject:model];
                    }
                }
                [weakSelf.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

#pragma mark - tableview - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.commentImageArray.count>0) return 1;
        return 0;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ProfileAboutMePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileAboutMePhotoCell"];
        if (!photoCell) {
            photoCell = [[ProfileAboutMePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileAboutMePhotoCell"];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        photoCell.imageArray = self.commentImageArray;
        return photoCell;
    }
    else
    {
        ProfileAboutMeCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileAboutMeCommentCell"];
        if (!commentCell) {
            commentCell = [[ProfileAboutMeCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileAboutMeCommentCell"];
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row<self.dataSource.count)
        {
            ProfileCommentModel *model = self.dataSource[indexPath.row];
            [commentCell handlerCellWithModel:model];
        }
        WS(weakSelf);
        commentCell.unfoldActionBlock = ^{
            [weakSelf.tableView reloadData];
        };
        return commentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return photoCellHeight;
    if (indexPath.section == 1)
    {
        if (indexPath.row<self.dataSource.count)
        {
            ProfileCommentModel *model = self.dataSource[indexPath.row];
            if (!model.isUnfold) return 80;
            CGFloat nickNameWidth = [Handler widthForString:[NSString stringWithFormat:@"%@：",model.user.nickname] width:100 FontSize:[UIFont fontWithName:pageFontName size:14]];
            return 80-20+[Handler heightForString:model.commentContent width:screenWidth-90-nickNameWidth FontSize:[UIFont fontWithName:pageFontName size:14]];
        }
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((section == 0 && self.commentImageArray.count>0) || (section == 1 && self.dataSource.count>0)) return 30;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((section == 0 && self.commentImageArray.count>0) || (section == 1 && self.dataSource.count>0))
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
        label.textColor = [UIColor blackColor];
        label.text = self.titleArray[section];
        label.font = [UIFont fontWithName:pageFontName size:12];
        [headerView addSubview:label];
        return headerView;
    }
    return [UIView new];
}

#pragma mark - action
- (void)pushToEditingAction
{
    ProfileEditInfoController *editVC = [[ProfileEditInfoController alloc] init];
    editVC.userInfoModel = self.userInfoModel;
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - setting方法
- (void)setUserInfoModel:(ProfileUserInfoModel *)userInfoModel
{
    _userInfoModel = userInfoModel;
    self.headerView.userInfoModel = _userInfoModel;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 15)];
    }
    return _tableView;
}

- (ProfileAboutMeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[ProfileAboutMeHeaderView alloc] init];
        _headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToEditingAction)];
        tap.numberOfTapsRequired = 2;
        [_headerView addGestureRecognizer:tap];
        
        //Chiang
        [_headerView clickedSelectAuthorizeType:^(NSInteger authorizeIndex) {
            if (authorizeIndex == 1) {//个人认证
                [self pushToPersonalAuthorizeViewControllerAnimated:YES];
            }else if (authorizeIndex == 2) {//企业认证
                [self pushToEnterpriseAuthorizeViewControllerAnimated:YES];
            }
        }];
    }
    return _headerView;
}
//Chiang 跳转至个人认证界面
-(void)pushToPersonalAuthorizeViewControllerAnimated:(BOOL ) animated {
    ProfilePersonalAuthorizeViewController* personVC = [[ProfilePersonalAuthorizeViewController alloc]init];
    [self.navigationController pushViewController:personVC animated:animated];
}
//Chiang 跳转至企业认证界面
-(void)pushToEnterpriseAuthorizeViewControllerAnimated:(BOOL ) animated {
    ProfileEnterpriseAuthorizeViewController* enterpriseVC = [[ProfileEnterpriseAuthorizeViewController alloc]init];
    [self.navigationController pushViewController:enterpriseVC animated:animated];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)commentImageArray
{
    if (!_commentImageArray) {
        _commentImageArray = [NSMutableArray array];
    }
    return _commentImageArray;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[NSLocalizedString(@"profilepastjobs", nil),NSLocalizedString(@"profilepastjobscomments", nil)];
    }
    return _titleArray;
}

@end
