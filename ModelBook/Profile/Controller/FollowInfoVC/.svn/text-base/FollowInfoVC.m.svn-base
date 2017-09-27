//
//  FollowInfoVC.m
//  ModelBook
//
//  Created by HZ on 2017/9/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "FollowInfoVC.h"
#import "YFViewPager.h"
#import "followInfoCell.h"
#import "FollowInfoModel.h"

#define kfollowInfoCell @"followInfoCell"
@interface FollowInfoVC ()<UITableViewDelegate, UITableViewDataSource>
{
    YFViewPager * _viewPager;   // 页面控制器
    
    UITableView * _myFocusTBV;      // 我关注的tableview
    UITableView * _focusOnMeTBV;    // 关注我的tableview
    UITableView * _mycollTBV;       // 我的收藏tableview
    UITableView * _shieldTBV;       // 我屏蔽的tableview
    
    NSMutableArray * _myFocusArray;      // 我关注的 数据数组
    NSMutableArray * _focusOnMeArray;    // 关注我的 数据数组
    NSMutableArray * _mycollArray;       // 我的收藏 数据数组
    NSMutableArray * _shieldArray;       // 我屏蔽的 数据数组
    NSArray        * _publicArray;       // 共享数组
}
@end

@implementation FollowInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的";
    
    _myFocusArray   = [NSMutableArray array];
    _focusOnMeArray = [NSMutableArray array];
    _mycollArray    = [NSMutableArray array];
    _shieldArray    = [NSMutableArray array];
    
    [self fakeData];
    [self ConfigUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 统一创建基本TableView
- (UITableView *)getTableView;
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.bounces = YES;
    [tableView registerNib:[UINib nibWithNibName:kfollowInfoCell bundle:nil]     forCellReuseIdentifier:kfollowInfoCell];
    return tableView;
}

#pragma mark - 假数据
- (void)fakeData {
    // 我关注的
    for (NSInteger i = 0; i < 3; i++) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"man0%ld", i] forKey:@"avatarStr"];
        [dic setObject:[NSString stringWithFormat:@"hello-%ld", i] forKey:@"nicknameStr"];
        [dic setObject:@"0" forKey:@"handleStr"];
        
        FollowInfoModel * model = [[FollowInfoModel alloc]initWithDictionary:dic error:nil];
        [_myFocusArray addObject:model];
    }
    // 关注我的
    for (NSInteger i = 3; i < 5; i++) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"man0%ld", i] forKey:@"avatarStr"];
        [dic setObject:[NSString stringWithFormat:@"hello-%ld", i] forKey:@"nicknameStr"];
        [dic setObject:@"1" forKey:@"handleStr"];
        
        FollowInfoModel * model = [[FollowInfoModel alloc]initWithDictionary:dic error:nil];
        [_focusOnMeArray addObject:model];
    }
    // 我收藏的
    for (NSInteger i = 5; i < 7; i++) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"man0%ld", i] forKey:@"avatarStr"];
        [dic setObject:[NSString stringWithFormat:@"hello-%ld", i] forKey:@"nicknameStr"];
        [dic setObject:@"2" forKey:@"handleStr"];
        
        FollowInfoModel * model = [[FollowInfoModel alloc]initWithDictionary:dic error:nil];
        [_mycollArray addObject:model];
    }
    // 我屏蔽的
    for (NSInteger i = 7; i < 8; i++) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"man0%ld", i] forKey:@"avatarStr"];
        [dic setObject:[NSString stringWithFormat:@"hello-%ld", i] forKey:@"nicknameStr"];
        [dic setObject:@"3" forKey:@"handleStr"];
        
        FollowInfoModel * model = [[FollowInfoModel alloc]initWithDictionary:dic error:nil];
        [_shieldArray addObject:model];
    }
}

#pragma mark - 配置视图
- (void)ConfigUI {
    _myFocusTBV     = [self getTableView];
    _focusOnMeTBV   = [self getTableView];
    _mycollTBV      = [self getTableView];
    _shieldTBV      = [self getTableView];
    
    NSArray *titles = [[NSArray alloc] initWithObjects:
                       @"我关注的",
                       @"关注我的",
                       @"我的收藏",
                       @"我屏蔽的",nil];
    
    NSArray *views = [[NSArray alloc] initWithObjects:
                      _myFocusTBV,
                      _focusOnMeTBV,
                      _mycollTBV,
                      _shieldTBV,nil];
    
    _viewPager = [[YFViewPager alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)
                                             titles:titles
                                              icons:nil
                                      selectedIcons:nil
                                              views:views];
    _viewPager.tabTitleColor    = [UIColor colorWithHexString:@"#666666"];
    _viewPager.tabArrowBgColor  = [UIColor colorWithHexString:@"#e2e2e2"];
    _viewPager.showVLine        = NO;
    _viewPager.showSelectedBottomLine = NO;
    [self.view addSubview:_viewPager];
    
    // 点击菜单时触发
    [_viewPager didSelectedBlock:^(id viewPager, NSInteger index) {
        switch (index) {
            case 0:     // 我关注的
            {
                _publicArray = _myFocusArray;
                [_myFocusTBV reloadData];
                break;
            }
            case 1:     // 关注我的
            {
                _publicArray = _focusOnMeArray;
                [_focusOnMeTBV reloadData];
                break;
            }
            case 2:     // 我的收藏
            {
                _publicArray = _mycollArray;
                [_mycollTBV reloadData];
                break;
            }
            case 3:     // 我屏蔽的
            {
                _publicArray = _shieldArray;
                [_shieldTBV reloadData];
                break;
            }
            default:
                break;
        }
    }];
    
    [_viewPager setSelectIndex:0];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _publicArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    followInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:kfollowInfoCell];
    cell.dataModel = _publicArray[indexPath.row];
    [cell setHandleBtnHandle:^(NSString *handleStr) {
        if ([handleStr isEqualToString:@"0"]) {
            [_myFocusArray removeObjectAtIndex:indexPath.row];
            _publicArray = _myFocusArray;
            [tableView reloadData];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if ([handleStr isEqualToString:@"1"]) {
            FollowInfoModel * model = [_focusOnMeArray objectAtIndex:indexPath.row];
            model.handleStr = @"0";
            [_myFocusArray insertObject:model atIndex:0];
            [_focusOnMeArray removeObjectAtIndex:indexPath.row];
            _publicArray = _focusOnMeArray;
            [tableView reloadData];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if ([handleStr isEqualToString:@"2"]) {
            [_mycollArray removeObjectAtIndex:indexPath.row];
            _publicArray = _mycollArray;
            [tableView reloadData];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if ([handleStr isEqualToString:@"3"]) {
            [_shieldArray removeObjectAtIndex:indexPath.row];
            _publicArray = _shieldArray;
            [tableView reloadData];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
