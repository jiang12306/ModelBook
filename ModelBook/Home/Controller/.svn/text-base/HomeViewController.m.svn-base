//
//  HomeViewController.m
//  ModelBook
//
//  Created by 唐先生 on 2017/8/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "HomeViewController.h"
#import "MJRefresh.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "TestViewController.h"
#import "NetworkManager.h"
#import "UserInfoManager.h"
#import "HomeTableViewCell.h"
#import "UIColor+Ext.h"
#import "CustomHudView.h"
#import "ProfileViewController.h"
#import <KSPhotoBrowser.h>
#import <KSPhotoItem.h>

// 评论键盘
#import "UIKeyboardBar.h"
#import "UIView+Methods.h"

#import "NSString+imgURL.h"
@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,UIKeyboardBarDelegate>
{
    NSString * _commTargetUserID;
    NSString * _commTargetName;
    CGFloat _lastContentOffset; // 滚动时的起点
}
// 评论键盘
@property (nonatomic) UIKeyboardBar *keyboardBar;

@property (strong,nonatomic)NSMutableArray<UserModel *> *modelArr;

@property (strong,nonatomic)NSMutableArray<UserModel *> *modelArr_MakeUp;
@property (strong,nonatomic)NSMutableArray<UserModel *> *modelArr_woman;
@property (strong,nonatomic)NSMutableArray<UserModel *> *modelArr_KOL;
@property (strong,nonatomic)NSMutableDictionary *typeDic;
@property (assign,nonatomic)CGSize itemSize;
@property (assign,nonatomic)CGSize tableCellSize;
//----

@property (nonatomic, assign)UserType userType;
@property (nonatomic,assign)BOOL showTableViewMode;//
@property (assign)BOOL isLastPage;
@property (assign)int pageNum;//请求第几页

@end

static NSString *CellID = @"collectionCell";
static NSString *tableCellID = @"tableCell";

@implementation HomeViewController

//MARK: 摄影化妆师 按钮响应
- (IBAction)Classfication:(id)sender {
    [self BtnSelectedInUserType:UserTypePAndMakeUp];
    self.ClassficationBtn.selected = YES;
    self.ModelBtn.selected = NO;
    self.KOLBtn.selected = NO;
}
//MARK: 模特 按钮响应
- (IBAction)Model:(id)sender {
    [self BtnSelectedInUserType:UserTypeModel];
    self.ClassficationBtn.selected = NO;
    self.ModelBtn.selected = YES;
    self.KOLBtn.selected = NO;
}
//MARK: 网红 按钮响应
- (IBAction)KOL:(id)sender {
    [self BtnSelectedInUserType:UserTypeKOL];
    self.ClassficationBtn.selected = NO;
    self.ModelBtn.selected = NO;
    self.KOLBtn.selected = YES;
}

//MARK: 设置选择后的类型
-(void)BtnSelectedInUserType:(UserType)type
{
    if(self.userType == type) return;
    self.userType = type;
    if ([self.typeDic[@(type)] intValue]==1) {
        [self getTheLastestImgWithType];
    }else
    {
        //直接从缓存里取
        self.showTableViewMode?[self.mode2TableView reloadData]:[self.ContentCollectionView reloadData];
    }
}

//MARK: 显示隐藏三个分类按钮
-(void)hideTopBtn:(BOOL)hide
{
//    self.ClassficationBtn.hidden = hide;
//    self.ModelBtn.hidden = hide;
//    self.KOLBtn.hidden = hide;
    if (hide) {
        self.buttonH.constant = Adapter_Y(0);
    }
    else {
        self.buttonH.constant = Adapter_Y(55);
    }
}

#pragma mark -
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [self hideTopBtn:NO];
    
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

}

#pragma mark - 评论键盘
- (UIKeyboardBar *)keyboardBar{
    if (_keyboardBar == nil) {
        _keyboardBar = [[UIKeyboardBar alloc]initWithFrame:CGRectZero];
        _keyboardBar.expressionBundleName = @"FaceExpression";
        _keyboardBar.barDelegate = self;
        _keyboardBar.KeyboardMoreImages = @[@"ToolVieMoreKeyboardCamera@2x",@"ToolVieMoreKeyboardPhotos@2x"];
        _keyboardBar.KeyboardMoreTitles = @[@"拍照",@"相册"];
        //keyboardTypes 可随意添加删除，但有一点UIKeyboardChatTypeKeyboard是默认有的
        _keyboardBar.keyboardTypes = @[@(UIKeyboardChatTypeVoice),@(UIKeyboardChatTypeFace)];
        //        _keyboardBar.keyboardTypes = @[@(UIKeyboardChatTypeKeyboard),@(UIKeyboardChatTypeVoice),@(UIKeyboardChatTypeFace),@(UIKeyboardChatTypeMore)];
    }
    return _keyboardBar;
}

#pragma mark - 获取模型数组
-(NSMutableArray *)modelArr
{
    if(self.userType==UserTypePAndMakeUp)
    {
        return [NSMutableArray arrayWithArray: self.modelArr_MakeUp];
    }
    if(self.userType==UserTypeModel)
    {
        return [NSMutableArray arrayWithArray: self.modelArr_woman];
        
    }
    if(self.userType==UserTypeKOL)
    {
        return [NSMutableArray arrayWithArray: self.modelArr_KOL];
        
    }
    return [NSMutableArray array];
}

#pragma mark - 获取数据
-(void)getTheLastestImgWithType
{
    self.pageNum = [self.typeDic[@(self.userType)] intValue];
    CGFloat userId = [UserInfoManager userID];
    NSDictionary *dic = @{@"currentUserId":@(userId),@"fileType":@0,@"pageNum":@(self.pageNum),@"userType":@(self.userType)};
    [self networkWithPath:@"user/search/basic" parameters:dic success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            
            [CustomHudView showWithTip:NSLocalizedString(@"Server return error", nil)];
            return;
        }
        NSDictionary *responDic = (NSDictionary*)responseObject;
        NSString *msg = responseObject[@"msg"];
        if (!msg) {
            msg = NSLocalizedString(@"Server return error", nil);
        }
        int code = [responDic[@"code"] intValue];
        NSDictionary *objDic = (NSDictionary*)responDic[@"object"];
        if (code!=0) {
            [CustomHudView showWithTip:msg];
            return;
        }
        if (objDic==nil||![objDic[@"list"] isKindOfClass:[NSArray class]]) {
            self.showTableViewMode?[self.mode2TableView reloadData]:[self.ContentCollectionView reloadData];
            return;//没有数据 或者数据格式错误
        }
        self.isLastPage = [objDic[@"hasNextPage"] boolValue];
        self.pageNum++;
        self.typeDic[@(self.userType)] = @(self.pageNum);
        // 获取数据后，如果是第一页请求，清空数组再重新加数据
        if (self.pageNum == 1) {
            [self reloadFromServer];
        }
        
        for (NSDictionary *dataDic in objDic[@"list"]) {
            UserModel *model = [[UserModel alloc]initWithDic:dataDic];
            //孙越修改
            if(self.userType==UserTypePAndMakeUp)
            {
              [self.modelArr_MakeUp addObject:model];
            }
            if(self.userType==UserTypeModel)
            {
                [self.modelArr_woman addObject:model];
            }
            if(self.userType==UserTypeKOL)
            {
                [self.modelArr_KOL addObject:model];
            }
            //-----
        }
        //------
        self.showTableViewMode?[self.mode2TableView reloadData]:[self.ContentCollectionView reloadData];
    } failure:^(NSError *error) {
        [CustomHudView showWithTip:error.localizedDescription];
    }];
    
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelArr = [NSMutableArray array];
    
    //孙越修改
    self.modelArr_MakeUp=[NSMutableArray array];
    self.modelArr_woman = [NSMutableArray array];
    self.modelArr_KOL = [NSMutableArray array];
    //-----
    
    self.pageNum = 1;
    self.userType = UserTypeModel;
    self.typeDic = [@{@(UserTypePhoto):@1,@(UserTypeMakeUp):@1,@(UserTypeModel):@1,@(UserTypeKOL):@1,@(UserTypePAndMakeUp):@1} mutableCopy];
    [self setUpUI];
    
    self.ContentCollectionView.delegate = self;
    self.ContentCollectionView.dataSource = self;
    self.ContentCollectionView.backgroundColor = [UIColor whiteColor];
    self.mode2TableView.dataSource = self;
    self.mode2TableView.delegate = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 1;
    layout.itemSize = CGSizeMake((screenWidth-2)/3, (self.ContentCollectionView.height - self.tabBarController.tabBar.height - 2)/4);
    self.itemSize = layout.itemSize;
    layout.minimumInteritemSpacing = 1;
    self.ContentCollectionView.collectionViewLayout = layout;
    [self.ContentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
    
    
    //MARK: 设置上下拉刷新
    MJWeakSelf;
    self.ContentCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addDataFormServer];
        [weakSelf.ContentCollectionView.mj_footer setState:MJRefreshStateIdle];
    }];   // Do any additional setup after loading the view.
    
    self.ContentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.typeDic[@(self.userType)] = @(1);
        [self getTheLastestImgWithType];
        [weakSelf.ContentCollectionView.mj_header setState:MJRefreshStateIdle];
    }];
    
    self.mode2TableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.typeDic[@(self.userType)] = @(1);
        [self getTheLastestImgWithType];
        [weakSelf.mode2TableView.mj_footer setState:MJRefreshStateIdle];
    }];
    self.mode2TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.typeDic[@(self.userType)] = @(1);
        [self getTheLastestImgWithType];
        [weakSelf.mode2TableView.mj_header setState:MJRefreshStateIdle];
    }];
    self.tableCellSize = CGSizeMake(screenWidth, Adapter_Y(390));
    //孙越修改
    [self getTheLastestImgWithType];
    //------
    
    // 评论键盘
    [self.view addSubview:self.keyboardBar];
}

#pragma mark - 清空数组
-(void)reloadFromServer
{
    if(self.userType==UserTypeModel)
    {
        [self.modelArr_woman removeAllObjects];
    }else if(self.userType==UserTypeKOL)
    {
        [self.modelArr_KOL removeAllObjects];
    }else
    {
       [self.modelArr_MakeUp removeAllObjects];
    }
}

#pragma mark - 下拉响应
-(void)addDataFormServer
{
    [self getTheLastestImgWithType];
}

#pragma mark - 配置UI
-(void)setUpUI
{
    self.buttonH.constant = Adapter_Y(55);
    [self setUpBtnAppearence:self.ClassficationBtn andName:NSLocalizedString(@"P&MakeUp", nil) andImage:@"home_list" andSelectedImage:@"home_list_clicked"];
    [self setUpBtnAppearence:self.ModelBtn andName:NSLocalizedString(@"Model", nil) andImage:@"home_women" andSelectedImage:@"home_women_clicked"];
    [self setUpBtnAppearence:self.KOLBtn andName:NSLocalizedString(@"KOL", nil) andImage:@"home_kol" andSelectedImage:@"home_kol_clicked"];
    self.ModelBtn.selected = YES;
    self.mode2TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)setUpBtnAppearence:(UIButton *)btn andName:(NSString *)name andImage:(NSString *)imgName andSelectedImage:(NSString *)selectedImgName
{
    [btn setTitle:name forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitleColor:[UIColor colorWithHexString:@"#e2e2e2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
    btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}
- (IBAction)changeMode:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.ContentCollectionView.hidden = sender.selected;
    self.mode2TableView.hidden = !sender.selected;
    self.showTableViewMode = sender.selected;
    self.showTableViewMode?[self.mode2TableView reloadData]:[self.ContentCollectionView reloadData];
    NSIndexPath *indexP1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexP2 = [NSIndexPath indexPathForItem:0 inSection:0];
    self.showTableViewMode? [self.mode2TableView scrollToRowAtIndexPath:indexP1 atScrollPosition:UITableViewScrollPositionTop animated:NO]:[self.ContentCollectionView scrollToItemAtIndexPath:indexP2 atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}
//滑动过程delegate

#pragma mark - scrollView 代理
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self hideTopBtn:YES];
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self hideTopBtn:NO];
//}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self hideTopBtn:NO];
//}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < _lastContentOffset) {
        [self hideTopBtn:NO];
        
    }
    else if (scrollView.contentOffset.y > _lastContentOffset) {
        [self hideTopBtn:YES];
    }
}

#pragma mark - CollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UserModel *model = self.modelArr[indexPath.row];
    UserModel *model = self.modelArr[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    CGSize itemSize = self.showTableViewMode?self.tableCellSize:self.itemSize;
    BOOL hasImage = NO;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:[model.headPic imgURLWithSize:itemSize]] placeholderImage:nil];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.layer.masksToBounds = YES;
            hasImage = YES;
            break;
        }
    }
    if (!hasImage) {
        UIImageView *view = [[UIImageView alloc]init];
            [view sd_setImageWithURL:[NSURL URLWithString:[model.headPic imgURLWithSize:itemSize]] placeholderImage:nil];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:view];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.modelArr.count)
    {
        UserModel *model = self.modelArr[indexPath.row];
        ProfileViewController *aboutMeVC = [[ProfileViewController alloc] initWithUserId:model.userId];
        aboutMeVC.initialTabPage = InitialTabPageJobs;
        aboutMeVC.pushFromMySelf = YES;
        [self.navigationController pushViewController:aboutMeVC animated:YES];
    }
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellID];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell" owner:nil options:nil]firstObject];
    }
    if (indexPath.row>=self.modelArr.count) {
        return cell;
    }
    UserModel *model = self.modelArr[indexPath.row];
    cell.model = model;
    
    WS(weakSelf);
    // 点击头像
    [cell setClickAvatarHandle:^{
        ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:model.userId];
        profileVC.initialTabPage = InitialTabPageAboutMe;
        [weakSelf.navigationController pushViewController:profileVC animated:YES];
    }];
    // 点击内容
    [cell setClickContentHandle:^(UIImageView *contentImageView) {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:contentImageView imageUrl:[NSURL URLWithString:model.headPic]];
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces = NO;
        [browser showFromViewController:weakSelf];
    }];
    // 点击喜欢按钮
    __block __typeof(cell)blockCell = cell;
    [cell setClickLikeBtnHandle:^(BOOL isLike) {
        //MARK: 需要接口更新数据
        if (isLike) {
            model.likes++;
            model.isLiked = YES;
        }
        else {
            model.likes--;
            model.isLiked = NO;
        }
        blockCell.model = model;
    }];
    // 点击评论按钮
    [cell setClickCommentHandle:^(NSString *userID, NSString *nickName) {
        _commTargetUserID = userID;
        _commTargetName = nickName;
        // [weakSelf.keyboardBar setTextViewFirstResponder:YES];  暂有问题
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row<self.modelArr.count)
//    {
//        UserModel *model = self.modelArr[indexPath.row];
//        ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:model.userId];
//        profileVC.initialTabPage = InitialTabPageAboutMe;
//        [self.navigationController pushViewController:profileVC animated:YES];
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

#pragma mark - UIKeyboardBarDelegate 评论键盘 代理
- (void)keyboardBar:(UIKeyboardBar *)keyboard didChangeFrame:(CGRect)frame{
}

- (void)keyboardBar:(UIKeyboardBar *)keyboard moreHandleAtItemIndex:(NSInteger)index{
    NSLog(@"--------- \n选择更多操作 index = %ld",(long)index);
}

- (void)keyboardBar:(UIKeyboardBar *)keyboard sendContent:(NSString *)message{
    NSLog(@"--------- \n发送文本 message = %@",message);
}

- (void)keyboardBar:(UIKeyboardBar *)keyboard sendVoiceWithFilePath:(NSString *)path seconds:(NSTimeInterval)seconds{
    NSLog(@"--------- \n发送录制语音 path = %@,语音时长 = %lf",path,seconds);
}

#pragma mark -键盘通知
// 键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect KBFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self.contentTableView setFrame:CGRectMake(0, 0, MainScreenSizeWidth, frame.origin.y)];
        UIView * shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenSizeWidth, CGRectGetMaxY(self.keyboardBar.frame))];
        shadowView.backgroundColor = [UIColor blackColor];
        shadowView.alpha = 0.3;
        shadowView.tag = 10086;
        [self.view addSubview:shadowView];
        [self.view bringSubviewToFront:shadowView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
        [shadowView addGestureRecognizer:tap];
    });
    
}

// 关闭键盘
- (void)keyboardWillHide:(NSNotification *)notification
{
    UIView * shadowView = [self.view viewWithTag:10086];
    if (shadowView) {
        NSArray *targets = [shadowView gestureRecognizers]; // 所有手势
        for (UIGestureRecognizer *recognizer in targets) {
            [shadowView removeGestureRecognizer: recognizer];
        }
        [shadowView removeFromSuperview];
        shadowView = nil;
    }
}

- (void)closeKeyBoard {
    if (self.keyboardBar.inputing) {
        [self.keyboardBar endInput];
    }
}

@end
