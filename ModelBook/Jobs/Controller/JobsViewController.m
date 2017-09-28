//
//  JobsViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "JobsViewController.h"
#import "JobListModel.h"
#import "JobListCell.h"
#import "JobDetailViewController.h"
#import "JobCreateViewController.h"
#import "UIView+Alert.h"
#import "MyJobsListModel.h"
#import "MBProfileMyJobsDetailController.h"
#import "MBCommentViewController.h"

@interface JobsViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (weak, nonatomic) UIButton *leftButton;

@property (weak, nonatomic) UIButton *midButton;

@property (weak, nonatomic) UIButton *rightButton;

@property(nonatomic,assign)int page;

@property(nonatomic,assign)int pageSize;

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *jobName;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation JobsViewController

+ (BaseNavigationViewController *)instantiateNavigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jobs" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"JobNavSBID"];
}
+ (JobsViewController *)instantiateJobsViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jobs" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"JobVCSBID"];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

static NSString *const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTopView];
    [self setupSearchBar];
    
    self.createButton.layer.cornerRadius = 3.f;
    self.createButton.layer.masksToBounds = YES;
    [self.createButton setTitle:NSLocalizedString(@"Create Job", nil) forState:UIControlStateNormal];
    self.createButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:18.f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.tableView addGestureRecognizer:tap];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.midButton.selected = YES;
    self.type = @"3";
    
    self.pageSize = 10;
    
    [self loadNewData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JobListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadJob) name:@"reloadJobs" object:nil];
}

- (void)setupTopView
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton = leftButton;
    leftButton.tag = 1;
    [leftButton setImage:[UIImage imageNamed:@"home_list"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"home_list_clicked"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:leftButton];
    [leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView.mas_left).offset(Adapter_X(65.f));
        make.top.equalTo(self.topView.mas_top);
        make.size.mas_equalTo(CGSizeMake(43.f, 40.f));
    }];
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = NSLocalizedString(@"P&MakeUp", nil);
    leftLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    leftLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.topView addSubview:leftLabel];
    [leftLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftButton);
        make.top.equalTo(leftButton.mas_bottom);
    }];
    
    UIButton *midButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.midButton = midButton;
    midButton.tag = 2;
    [midButton setImage:[UIImage imageNamed:@"home_women"] forState:UIControlStateNormal];
    [midButton setImage:[UIImage imageNamed:@"home_women_clicked"] forState:UIControlStateSelected];
    [midButton addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:midButton];
    [midButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [midButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView.mas_centerX);
        make.top.equalTo(self.topView.mas_top);
        make.size.mas_equalTo(CGSizeMake(43.f, 40.f));
    }];
    UILabel *midLabel = [UILabel new];
    midLabel.text = NSLocalizedString(@"Model", nil);
    midLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    midLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.topView addSubview:midLabel];
    [midLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(midButton);
        make.top.equalTo(midButton.mas_bottom);
    }];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton = rightButton;
    rightButton.tag = 3;
    [rightButton setImage:[UIImage imageNamed:@"home_kol"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"home_kol_clicked"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(typeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:rightButton];
    [rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView.mas_right).offset(Adapter_X(-65.f));
        make.top.equalTo(self.topView.mas_top);
        make.size.mas_equalTo(CGSizeMake(43.f, 40.f));
    }];
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = NSLocalizedString(@"KOL", nil);
    rightLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    rightLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.topView addSubview:rightLabel];
    [rightLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightButton);
        make.top.equalTo(rightButton.mas_bottom);
    }];
}

- (void)setupSearchBar
{
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.showsCancelButton = NO;
    _searchBar.tintColor = [UIColor colorWithHex:0x999999];
    _searchBar.delegate = self;
    
    for (UIView *subView in _searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                UITextField *textField = [subView.subviews objectAtIndex:0];
                //设置输入框边框的颜色
                textField.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
                textField.layer.cornerRadius = 3.f;
                textField.layer.borderWidth = 0.5f;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                //设置默认文字颜色
                [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search", nil)
                                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                 NSFontAttributeName:[UIFont fontWithName:pageFontName size:15.f]}]];
            }
        }
    }
}

#pragma mark - 网络请求

- (void)loadNewData
{
    self.page = 1;
    [self loadData];
}

- (void)loadMoreData
{
    self.page++;
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentUserId"] = @([UserInfoManager userID]);
    params[@"userType"] = self.type;
    params[@"jobName"] = self.jobName;
    params[@"pageNum"] = @(self.page);
    params[@"pageSize"] = @(self.pageSize);
    [self networkWithPath:@"job/query/list" parameters:params success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0) {
            NSArray *objArray = [MTLJSONAdapter modelsOfClass:[JobListModel class] fromJSONArray:responseObject[@"object"] error:nil];
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:objArray];
            [self.tableView reloadData];
        }else {
            [CustomHudView showWithTip:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        if (self.dataSource.count < self.pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        if (self.page > 1) {
            self.page--;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Event

- (void)typeButtonEvent:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            self.leftButton.selected = YES;
            self.midButton.selected = NO;
            self.rightButton.selected = NO;
            self.type = @"1";
            break;
        case 2:
            self.leftButton.selected = NO;
            self.midButton.selected = YES;
            self.rightButton.selected = NO;
            self.type = @"3";
            break;
        case 3:
            self.leftButton.selected = NO;
            self.midButton.selected = NO;
            self.rightButton.selected = YES;
            self.type = @"4";
            break;
        default:
            break;
    }
    [self loadNewData];
}

- (IBAction)createButtonEvent:(UIButton *)sender {
//    MBCommentViewController *controller = [[MBCommentViewController alloc] init];
//    controller.commentType = MBCommentTypeComplete;
//    [self.navigationController pushViewController:controller animated:YES];
    
    BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    BaseNavigationViewController *selectedController = (BaseNavigationViewController *)[controller showMainTabBarController:SectionTypeJobs];
    [selectedController setViewControllers:@[[JobCreateViewController instantiateJobCreateViewController]]];
}

- (void)tapEvent:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    self.jobName = searchBar.text;
    [self loadNewData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.jobName = searchBar.text;
    if (searchBar.text.length == 0) {
        [self.view endEditing:YES];
    }
    [self loadNewData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    JobListModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.applyBlock = ^(JobListCell *cell){
        [self networkWithPath:@"job/apply"
                   parameters: @{
                                 @"userId" : @([UserInfoManager userID]),
                                 @"jobId" : @(cell.model.jobId)
                                 }
                      success:^(id responseObject) {
                          NSNumber *code = responseObject[@"code"];
                          if (code.intValue == 0) {
                              [self loadNewData];
                              [[NSNotificationCenter defaultCenter] postNotificationName:reloadMyJobsNotification object:nil];
                          }
                          [CustomHudView showWithTip:responseObject[@"msg"]];
                      }
                      failure:^(NSError *error) {
                          NSLog(@"-----");
                      }];
    };
    cell.cancleBlock = ^(JobListCell *cell){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to cancle job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                [self networkWithPath:@"job/apply/cancel"
                           parameters: @{
                                         @"recordId" : cell.model.recordId
                                         }
                              success:^(id responseObject) {
                                  NSNumber *code = responseObject[@"code"];
                                  if (code.intValue == 0) {
                                      [self loadNewData];
                                  }
                                  [CustomHudView showWithTip:responseObject[@"msg"]];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
            }else {
                cell.stateButton.on = YES;
            }
        }];
    };
    cell.coverBlock = ^(JobListCell *cell){
        if (cell.model.showState.intValue != 1) { // 我发起的
            JobDetailViewController *detail = [JobDetailViewController instantiateJobDetailViewController];
            detail.idStr = [NSString stringWithFormat:@"%ld",cell.model.jobId];
            detail.cf = ControllerFromJob;
            
            [self.navigationController pushViewController:detail animated:YES];
            
//            BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            BaseNavigationViewController *selectedController = (BaseNavigationViewController *)[controller showMainTabBarController:SectionTypeJobs];
//            [selectedController setViewControllers:@[detail]];
        }else {
            jobInfo *info = [[jobInfo alloc] init];
            info.jobId = [NSString stringWithFormat:@"%ld",cell.model.jobId];
            info.userId = [NSString stringWithFormat:@"%ld",[UserInfoManager userID]];
            info.recordId = [NSString stringWithFormat:@"%@",cell.model.recordId];
            info.recordState = @"0";
            info.showState = [NSString stringWithFormat:@"%@",cell.model.showState];
            MBProfileMyJobsDetailController *jobsDetailVC = [[MBProfileMyJobsDetailController alloc] init];
            jobsDetailVC.jobInfo = info;
            
            [self.navigationController pushViewController:jobsDetailVC animated:YES];
            
//            BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            BaseNavigationViewController *selectedController = (BaseNavigationViewController *)[controller showMainTabBarController:SectionTypeJobs];
//            [selectedController setViewControllers:@[jobsDetailVC]];
        }
        
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (void)reloadJob
{
    [self loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
