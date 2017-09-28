//
//  JobDetailViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "JobDetailViewController.h"
#import "JobModel.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "PhotoWallView.h"
#import "ProfileViewController.h"
#import "KSPhotoBrowser.h"
#import "UIView+Alert.h"

@interface JobDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) UIButton *joinButton;

@property (strong, nonatomic) JobModel *job;

@property (weak, nonatomic) UIImageView *headImageView;

@property (weak, nonatomic) UILabel *createUserNameLabel;

@property (weak, nonatomic) UILabel *nameContentLabel;
@property (weak, nonatomic) UILabel *locationContentLabel;
@property (weak, nonatomic) UILabel *beginContentLabel;
@property (weak, nonatomic) UILabel *endContentLabel;
@property (weak, nonatomic) UILabel *priceContentLabel;
@property (weak, nonatomic) UILabel *desContentLabel;
@property (weak, nonatomic) UILabel *numContentLabel;
@property (weak, nonatomic) UIImageView *leftImageView;
@property (weak, nonatomic) UIImageView *midImageView;
@property (weak, nonatomic) UIImageView *rightImageView;
@property (weak, nonatomic) UIButton *chatButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomCons;

@property (strong, nonatomic) PhotoWallView *photoView;

@end

@implementation JobDetailViewController

+ (JobDetailViewController *)instantiateJobDetailViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jobs" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"JobDetailVCSBID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.font = [UIFont fontWithName:pageFontName size:16.f];
    tLabel.text = NSLocalizedString(@"tabBar-titleB", nil);
    
    self.navigationItem.titleView = tLabel;
    
    [self setupBackItem];
    
    [self setupContent];
    
    
    //    if (self.cf == ControllerFromJob) {
    [self loadData];
    //    }else {
    //        [self loadDetail];
    //    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupContent
{
    CGFloat space = 30.f;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    self.headImageView = headImageView;
    [self.scrollView addSubview:headImageView];
    [headImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(20.f);
        make.left.equalTo(self.scrollView.mas_left).offset(40.f);
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
    }];
    
    UILabel *createUserNameLabel = [UILabel new];
    createUserNameLabel.font = [UIFont fontWithName:pageFontName size:14.f];
    createUserNameLabel.textColor = [UIColor blackColor];
    self.createUserNameLabel = createUserNameLabel;
    [self.scrollView addSubview:createUserNameLabel];
    [createUserNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [createUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImageView.mas_centerY);
        make.left.equalTo(headImageView.mas_right).offset(20.f);
    }];
    
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatButton = chatButton;
    [chatButton setTitle:NSLocalizedString(@"profileChat", nil) forState:UIControlStateNormal];
    chatButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:14.f];
    [chatButton setTitleColor:[UIColor colorWithHex:0x00baff] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:chatButton];
    [chatButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImageView.mas_centerY);
        make.left.equalTo(self.scrollView.mas_left).offset(Adapter_X(300));
        make.width.mas_equalTo(50.f);
        make.height.mas_equalTo(25.f);
    }];
    
    UILabel *nameContentLabel = [UILabel new];
    self.nameContentLabel = nameContentLabel;
    nameContentLabel.numberOfLines = 0;
    nameContentLabel.font = [UIFont fontWithName:pageFontName size:14.f];
    nameContentLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:nameContentLabel];
    [nameContentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nameContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.top.equalTo(headImageView.mas_bottom).offset(40.f);
        make.height.mas_equalTo(30.f);
    }];
    
    UILabel *locationLabel = [UILabel new];
    locationLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.text = NSLocalizedString(@"Location", nil);
    [self.scrollView addSubview:locationLabel];
    [locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameContentLabel.mas_bottom);
        make.left.equalTo(headImageView.mas_left);
        make.height.equalTo(nameContentLabel.mas_height);
    }];
    UILabel *locationContentLabel = [UILabel new];
    self.locationContentLabel = locationContentLabel;
    locationContentLabel.numberOfLines = 0;
    locationContentLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    locationContentLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:locationContentLabel];
    [locationContentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [locationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(-space);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 + space - 35);
        make.height.equalTo(nameContentLabel.mas_height);
    }];
    
    
    UILabel *beginLabel = [UILabel new];
    beginLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    beginLabel.textColor = [UIColor blackColor];
    beginLabel.text = NSLocalizedString(@"Start", nil);
    [self.scrollView addSubview:beginLabel];
    [beginLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationLabel.mas_bottom);
        make.left.equalTo(locationLabel.mas_left);
        make.height.equalTo(locationLabel.mas_height);
    }];
    UILabel *beginContentLabel = [UILabel new];
    self.beginContentLabel = beginContentLabel;
    beginContentLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    beginContentLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:beginContentLabel];
    [beginContentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [beginContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(beginLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(-space);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 + space - 35);
        make.height.equalTo(nameContentLabel.mas_height);
    }];
    
    UILabel *endLabel = [UILabel new];
    endLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    endLabel.textColor = [UIColor blackColor];
    endLabel.text = NSLocalizedString(@"End", nil);
    [self.scrollView addSubview:endLabel];
    [endLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginLabel.mas_bottom);
        make.left.equalTo(beginLabel.mas_left);
        make.height.equalTo(beginLabel.mas_height);
    }];
    UILabel *endContentLabel = [UILabel new];
    self.endContentLabel = endContentLabel;
    endContentLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    endContentLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:endContentLabel];
    [endContentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [endContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(endLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(-space);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 + space - 35);
        make.height.equalTo(nameContentLabel.mas_height);
    }];
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.text = NSLocalizedString(@"Rating", nil);
    [self.scrollView addSubview:priceLabel];
    [priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endLabel.mas_bottom);
        make.left.equalTo(endLabel.mas_left);
        make.height.equalTo(endLabel.mas_height);
    }];
    UILabel *priceContentLabel = [UILabel new];
    self.priceContentLabel = priceContentLabel;
    priceContentLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    priceContentLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:priceContentLabel];
    [priceContentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [priceContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(-space);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 + space - 35);
        make.height.equalTo(nameContentLabel.mas_height);
    }];
    
    UILabel *numLabel = [UILabel new];
    numLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    numLabel.textColor = [UIColor blackColor];
    numLabel.text = NSLocalizedString(@"Numbers", nil);
    [self.scrollView addSubview:numLabel];
    [numLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom);
        make.left.equalTo(priceLabel.mas_left);
        make.height.equalTo(priceLabel.mas_height);
    }];
    UILabel *numContentLabel = [UILabel new];
    self.numContentLabel = numContentLabel;
    numContentLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    numContentLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:numContentLabel];
    [numContentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [numContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(-space);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5 + space - 35);
        make.height.equalTo(nameContentLabel.mas_height);
    }];
    
    UILabel *desLabel = [UILabel new];
    desLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    desLabel.textColor = [UIColor blackColor];
    desLabel.text = NSLocalizedString(@"Description", nil);
    [self.scrollView addSubview:desLabel];
    [desLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numLabel.mas_bottom);
        make.left.equalTo(numLabel.mas_left);
        make.height.equalTo(numLabel.mas_height);
    }];
    UILabel *desContentLabel = [UILabel new];
    self.desContentLabel = desContentLabel;
    desContentLabel.numberOfLines = 0;
    desContentLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    desContentLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:desContentLabel];
    [desContentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [desContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desLabel.mas_left);
        make.top.equalTo(desLabel.mas_bottom);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) - 40 * 2);
        make.height.mas_equalTo([desContentLabel.text sizeWithFont:[UIFont fontWithName:pageFontName size:13.f] maxW:CGRectGetWidth([UIScreen mainScreen].bounds) - 40 * 2].height);
    }];
    
    UILabel *photoLabel = [UILabel new];
    photoLabel.font = [UIFont fontWithName:pageFontName size:14.f];
    photoLabel.textColor = [UIColor colorWithHex:0x999999];
    photoLabel.text = NSLocalizedString(@"Photos of Event", nil);
    [self.scrollView addSubview:photoLabel];
    [photoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.top.equalTo(desContentLabel.mas_bottom);
        make.height.mas_equalTo(40.f);
    }];
    
    CGFloat padding = 10;
    CGFloat itemW = (CGRectGetWidth([UIScreen mainScreen].bounds) - padding * 4) / 3;
    
    self.photoView = [[PhotoWallView alloc] init];
    [self.scrollView addSubview:self.photoView];
    [self.photoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoLabel.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left).offset(10.f);
        make.height.mas_equalTo(itemW);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds));
    }];
    
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinButton = joinButton;
    self.joinButton.layer.cornerRadius = 3.f;
    self.joinButton.layer.masksToBounds = YES;
    self.joinButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:16.f];
    [self.scrollView addSubview:joinButton];
    self.joinButton.backgroundColor = [UIColor colorWithHex:0xA7D7FF];
    [self.joinButton addTarget:self action:@selector(joinButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_bottom).offset(40.f);
        make.left.equalTo(self.scrollView.mas_left).offset(35.f);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 35 * 2, 50));
    }];
    
    UITapGestureRecognizer *tapone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
    UITapGestureRecognizer *taptwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
    headImageView.userInteractionEnabled = YES;
    nameContentLabel.userInteractionEnabled = YES;
    [headImageView addGestureRecognizer:tapone];
    [nameContentLabel addGestureRecognizer:taptwo];
    
}

#pragma mark - Event

- (void)chatButtonEvent:(UIButton *)sender {
    //    if (self.cf == ControllerFromJob) { // 申请加入
    NSDictionary *params = @{@"userId":@([UserInfoManager userID]),
                             @"targetUserId":self.job.createUserId,
                             @"chatType":@"jobs"
                             };
    [self networkWithPath:@"chat/insert" parameters:params success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0 || code.intValue == 60402) {
            ChatViewController *controller = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%@", self.job.createUserId]];
            controller.title = self.job.createUsername;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failure:^(NSError *error) {
        [CustomHudView showWithTip:@"网络异常,稍后重试"];
    }];
    //    }else {
    //
    //    }
}

- (void)joinButtonEvent:(UIButton *)sender {
    if (self.job.showState.intValue == 0) {
        [self networkWithPath:@"job/apply"
                   parameters: @{
                                 @"userId":@([UserInfoManager userID]),
                                 @"jobId":@(self.job.jobId)
                                 }
                      success:^(id responseObject) {
                          NSNumber *code = responseObject[@"code"];
                          if (code.intValue == 0) {
                              //                              if (self.cf == ControllerFromJob) {
                              [self loadData];
                              //                              }else {
                              //                                  [self loadDetail];
                              //                              }
                              [[NSNotificationCenter defaultCenter] postNotificationName:reloadMyJobsNotification object:nil];
                          }
                          [CustomHudView showWithTip:responseObject[@"msg"]];
                      }
                      failure:^(NSError *error) {
                          
                      }];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm Prompt", nil) message:NSLocalizedString(@"Sure you want to cancle job?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                [self networkWithPath:@"job/apply/cancel"
                           parameters: @{
                                         @"recordId" : self.job.recordId
                                         }
                              success:^(id responseObject) {
                                  NSNumber *code = responseObject[@"code"];
                                  if (code.intValue == 0) {
                                      //                              if (self.cf == ControllerFromJob) {
                                      [self loadData];
                                      //                              }else {
                                      //                                  [self loadDetail];
                                      //                              }
                                  }
                                  [CustomHudView showWithTip:responseObject[@"msg"]];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
            }
        }];
    }
}

- (void)backItemOnClick:(UIBarButtonItem *)item{
    if (self.cf == ControllerFromJob) {
        BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [controller showMainTabBarController:SectionTypeJobs];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 网络请求

- (void)loadData
{
    [self networkWithPath:@"job/query/getbyid"
               parameters:@{
                            @"jobId":self.idStr,
                            @"userId":@([UserInfoManager userID])
                            }
                  success:^(id responseObject) {
                      NSNumber *code = responseObject[@"code"];
                      if (code.intValue == 0) {
                          self.job = [MTLJSONAdapter modelOfClass:[JobModel class] fromJSONDictionary:responseObject[@"object"] error:nil];
                      }
                  }
                  failure:^(NSError *error) {
                      NSLog(@"");
                  }];
}

- (void)setJob:(JobModel *)job {
    _job = job;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:job.createUserHeadpic]];
    
    self.createUserNameLabel.text = job.createUsername;
    
    self.nameContentLabel.text = job.jobName;
    
    self.locationContentLabel.text = job.jobAddress;
    
    self.beginContentLabel.text = job.beginTime;
    
    self.endContentLabel.text = job.endTime;
    
    if (job.chargeType.intValue == 1) {
        self.priceContentLabel.text = [NSString stringWithFormat:@"%@元/天",job.chargePrice];
    }else {
        self.priceContentLabel.text = [NSString stringWithFormat:@"%@元/时",job.chargePrice];
    }
    
    self.numContentLabel.text =[NSString stringWithFormat:@"%@",job.userNumber];
    
    self.desContentLabel.text = job.jobContent;
    [self.desContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self.desContentLabel.text sizeWithFont:[UIFont fontWithName:pageFontName size:13.f] maxW:CGRectGetWidth([UIScreen mainScreen].bounds) - 40 * 2].height);
    }];
    
    __weak typeof(self) weakSelf = self;
    NSArray *imageArray = [job.jobImage componentsSeparatedByString:@","];
    self.photoView.dataSource = imageArray;
    self.photoView.didSelectItemBlock = ^(NSInteger row){
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < imageArray.count; i++) {
            PhotoWallCell *cell = (PhotoWallCell *)[weakSelf.photoView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:cell.imageURL]];
            [items addObject:item];
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:row];
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces = NO;
        [browser showFromViewController:weakSelf];
    };
    
    CGFloat padding = 10;
    CGFloat itemW = (CGRectGetWidth([UIScreen mainScreen].bounds) - padding * 4) / 3;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 110.f + 8 * 30.f + [self.desContentLabel.text sizeWithFont:[UIFont fontWithName:pageFontName size:13.f] maxW:CGRectGetWidth([UIScreen mainScreen].bounds) - 35 * 2].height + 40.f + itemW + 50 + 20);
    
    if (self.job.canChat.intValue == 1) {
        self.chatButton.hidden = NO;
    }else {
        self.chatButton.hidden = YES;
    }
    
    if (self.job.showState) {
        switch (self.job.showState.intValue) {
            case 0: // 没有任何关系
                [self.joinButton setTitle:NSLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
                [self setButtonNormal];
                break;
            case 1: // 我发起
                self.joinButton.hidden = YES;
                break;
            case 2: // 被邀请
                [self.joinButton setTitle:NSLocalizedString(@"Cancel Apply", nil) forState:UIControlStateNormal];
                [self setButtonNormal];
                break;
            case 3: // 被邀请已确认
                [self.joinButton setTitle:NSLocalizedString(@"Cancel Apply", nil) forState:UIControlStateNormal];
                [self setButtonNormal];
                break;
            case 4: // 被邀请已取消
                [self.joinButton setTitle:@"被邀请已取消" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 5: // 我申请等待
                [self.joinButton setTitle:NSLocalizedString(@"Cancel Apply", nil) forState:UIControlStateNormal];
                [self setButtonNormal];
                break;
            case 6: // 我申请拒绝
                [self.joinButton setTitle:@"我申请已拒绝" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 7: // 我申请确认
                [self.joinButton setTitle:NSLocalizedString(@"Cancel Apply", nil) forState:UIControlStateNormal];
                [self setButtonNormal];
                break;
            case 8: // 进行中
                [self.joinButton setTitle:NSLocalizedString(@"Cancel Apply", nil) forState:UIControlStateNormal];
                [self setButtonNormal];
                break;
            case 9: // 已完成
                [self.joinButton setTitle:@"已完成" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 10: // 已支付
                [self.joinButton setTitle:@"已支付" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 11: // 已评价
                [self.joinButton setTitle:@"已评价" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 12: // 已过期
                [self.joinButton setTitle:@"已过期" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 13: // 已隐藏
                [self.joinButton setTitle:@"已隐藏" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 14: // 我申请取消待处理
                [self.joinButton setTitle:@"已取消" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            case 15: // 对方申请取消待处理
                [self.joinButton setTitle:@"对方取消待客服处理" forState:UIControlStateNormal];
                [self setButtonnCancle];
                break;
            default:
                break;
        }
    }
}

#pragma mark - tap

- (void)tapEvent
{
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@",self.job.createUserId]];
    profileVC.initialTabPage = InitialTabPageAboutMe;
    profileVC.controllerFrom = @"jobdetail";
    
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)setButtonnCancle
{
    self.joinButton.backgroundColor = [UIColor colorWithHex:0x999999];
    self.joinButton.userInteractionEnabled = NO;
}

- (void)setButtonNormal
{
    self.joinButton.backgroundColor = [UIColor colorWithHex:0xA7D7FF];
    self.joinButton.userInteractionEnabled = YES;
}

@end
