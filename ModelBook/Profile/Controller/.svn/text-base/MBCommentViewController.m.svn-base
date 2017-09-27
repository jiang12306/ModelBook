//
//  MBCommentViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/9/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBCommentViewController.h"
#import "ProfileUserInfoModel.h"
#import "NSString+imgURL.h"
#import "UIImageView+WebCache.h"
#import "Handler.h"
#import <HCSStarRatingView.h>
#import "SZTextView.h"
#import "PhotoWallView.h"
#import "PhotoPickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UpYunFormUploader.h"
#import "MBProfileMyJobsDetailController.h"
#import "ProfileJobCommentModel.h"
#import "ProfileCommentModel.h"
#import "KSPhotoBrowser.h"

@interface MBCommentViewController () <PhotoPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UIImageView *headImageView;

@property (weak, nonatomic) UILabel *nameLabel;

@property (weak, nonatomic) UILabel *timeDesLabel;

@property (weak, nonatomic) UILabel *dateLabel;

@property (weak, nonatomic) SZTextView *textView;

@property (strong, nonatomic) PhotoWallView *photoView;

@property (strong, nonatomic) NSMutableArray *commentButtonArray;

@property (strong, nonatomic)  UIImagePickerController *imagePickerController;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) HCSStarRatingView *starView;

@property (copy, nonatomic) NSString *starValue;

@property (assign, nonatomic) int picCount;

@property(nonatomic, strong)ProfileJobCommentModel *commentModel;

@property (weak, nonatomic) UIButton *reportButton;

@property (weak, nonatomic) UIButton *completeButton;

@end

@implementation MBCommentViewController

- (NSMutableArray *)commentButtonArray
{
    if (!_commentButtonArray) {
        _commentButtonArray = [NSMutableArray array];
    }
    return _commentButtonArray;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Comment", nil);
    
    [self.commentButtonArray removeAllObjects];
    
    [self setupLayout];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.scrollView addGestureRecognizer:tap];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    self.starValue = @"5";
    
    if (self.isShowComment) {
        [self getCommentInfo];
    }
}

- (void)getCommentInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"recordId"] = _recordModel.recordId;
    params[@"currentUserId"] = [NSString stringWithFormat:@"%ld",[UserInfoManager userID]];
    [self networkWithPath:@"job/comment/getinfo" parameters:params success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0) {
            NSDictionary *object = responseObject[@"object"];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                self.commentModel = [[ProfileJobCommentModel alloc] initWithDict:object];
                [self reloadView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupLayout
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    self.headImageView = headImageView;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[self.recordModel.user.headpic imgURLWithSize:CGSizeMake(70.f, 70.f)]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    [scrollView addSubview:headImageView];
    [headImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top).offset(30.f);
        make.left.equalTo(scrollView.mas_left).offset(Adapter_X(50.f));
        make.size.mas_equalTo(CGSizeMake(70.f, 70.f));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    nameLabel.textColor = [UIColor colorWithHex:0x666666];
    nameLabel.text = self.recordModel.user.nickname;
    self.nameLabel = nameLabel;
    [scrollView addSubview:nameLabel];
    [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top);
        make.left.equalTo(headImageView.mas_right).offset(15.f);
        make.height.mas_equalTo(20.f);
        
    }];
    
    UILabel *timeDesLabel = [[UILabel alloc] init];
    self.timeDesLabel = timeDesLabel;
    timeDesLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    timeDesLabel.textColor = [UIColor blackColor];
    [scrollView addSubview:timeDesLabel];
    [timeDesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [timeDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(nameLabel.mas_left);
        make.height.mas_equalTo(20.f);
    }];
    CGFloat hour = [self calcTime:self.recordModel.beginTime endTime:self.recordModel.endTime];
    timeDesLabel.text = [NSString stringWithFormat:@"Booked for %ld hours",(long)ceilf(hour)];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.text = [Handler dateStrFromCstampTime:_recordModel.recordCreateTime withDateFormat:@"yyyy-MM-dd"];
    self.dateLabel = dateLabel;
    [scrollView addSubview:dateLabel];
    [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeDesLabel.mas_bottom);
        make.left.equalTo(timeDesLabel.mas_left);
        make.height.mas_equalTo(20.f);
    }];
    
    UILabel *starDesLabel = [[UILabel alloc] init];
    starDesLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    starDesLabel.textColor = [UIColor colorWithHex:0x666666];
    starDesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Give a Rating", nil)];
    [scrollView addSubview:starDesLabel];
    [starDesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [starDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).offset(20.f);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.height.mas_equalTo(20.f);
    }];
    
    HCSStarRatingView *starView = [[HCSStarRatingView alloc] init];
    self.starView = starView;
    starView.spacing = 1.f;
    starView.maximumValue = 5;
    starView.minimumValue = 0;
    starView.value = 0;
    starView.allowsHalfStars = NO;
    starView.emptyStarImage = [UIImage imageNamed:@"star_n"];
    starView.filledStarImage = [UIImage imageNamed:@"star"];
    [starView addTarget:self action:@selector(starDidChange:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:starView];
    [starView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starDesLabel.mas_bottom).offset(20.f);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.width.mas_equalTo(125.f);
        make.height.mas_equalTo(30.f);
    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    button1.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    button1.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    button1.tag = 1;
    [self.commentButtonArray addObject:button1];
    [button1 addTarget:self action:@selector(commentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button1];
    [button1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starView.mas_bottom).offset(20.f);
        make.right.equalTo(scrollView.mas_centerX).offset(-15.f);
        make.size.mas_equalTo(CGSizeMake(110.f, 30.f));
    }];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    button2.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    button2.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    button2.tag = 2;
    [self.commentButtonArray addObject:button2];
    [button2 addTarget:self action:@selector(commentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button2];
    [button2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button1.mas_top);
        make.left.equalTo(button1.mas_right).offset(30.f);
        make.size.equalTo(button1);
    }];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    button3.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    button3.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    button3.tag = 3;
    [self.commentButtonArray addObject:button3];
    [button3 addTarget:self action:@selector(commentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button3];
    [button3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button1.mas_bottom).offset(10.f);
        make.left.equalTo(button1.mas_left);
        make.size.equalTo(button1);
    }];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    button4.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    button4.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    button4.tag = 4;
    [self.commentButtonArray addObject:button4];
    [button4 addTarget:self action:@selector(commentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button4];
    [button4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button3.mas_top);
        make.left.equalTo(button3.mas_right).offset(30.f);
        make.size.equalTo(button3);
    }];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button5 setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    button5.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    button5.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    button5.tag = 5;
    [self.commentButtonArray addObject:button5];
    [button5 addTarget:self action:@selector(commentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button5];
    [button5 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button3.mas_bottom).offset(10.f);
        make.left.equalTo(button1.mas_left);
        make.size.equalTo(button1);
    }];
    
    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button6 setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [button6 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    button6.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    button6.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    button6.tag = 6;
    [self.commentButtonArray addObject:button6];
    [button6 addTarget:self action:@selector(commentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button6];
    [button6 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button5.mas_top);
        make.left.equalTo(button5.mas_right).offset(30.f);
        make.size.equalTo(button1);
    }];
    
    UILabel *commentDesLabel = [[UILabel alloc] init];
    commentDesLabel.text = @"Comment";
    commentDesLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    commentDesLabel.textColor = [UIColor colorWithHex:0x666666];
    [scrollView addSubview:commentDesLabel];
    [commentDesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [commentDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView.mas_centerX);
        make.top.equalTo(button6.mas_bottom).offset(20.f);
        make.height.mas_equalTo(20.f);
    }];
    
    SZTextView *textView = [[SZTextView alloc] init];
    self.textView = textView;
    textView.font = [UIFont fontWithName:pageFontName size:13.f];
    textView.textColor = [UIColor blackColor];
    textView.placeholder = NSLocalizedString(@"Write a comment ...", nil);
    textView.layer.borderColor = [UIColor colorWithHex:0x99999 alpha:0.3].CGColor;
    textView.layer.borderWidth = 0.5f;
    [scrollView addSubview:textView];
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentDesLabel.mas_bottom).offset(20.f);
        make.left.equalTo(scrollView.mas_left).offset(20.f);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) - 40.f);
        make.height.mas_equalTo(100.f);
    }];
    
    switch (self.commentType) {
        case MBCommentTypeDefault:
        {
            [button1 setTitle:@"Professional" forState:UIControlStateNormal];
            [button2 setTitle:@"Terrible" forState:UIControlStateNormal];
            [button3 setTitle:@"Mean" forState:UIControlStateNormal];
            [button4 setTitle:@"UnProfessional" forState:UIControlStateNormal];
            [button5 setTitle:@"Rude" forState:UIControlStateNormal];
            [button6 setTitle:@"Good" forState:UIControlStateNormal];
            
            commentDesLabel.text = @"Comment";
            
            [self setupCompleteState];
            
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 500 + 100 + 100);
        }
            break;
        case MBCommentTypeComplete:
        {
            [button1 setTitle:@"Professional" forState:UIControlStateNormal];
            [button2 setTitle:@"Terrible" forState:UIControlStateNormal];
            [button3 setTitle:@"Mean" forState:UIControlStateNormal];
            [button4 setTitle:@"UnProfessional" forState:UIControlStateNormal];
            [button5 setTitle:@"Rude" forState:UIControlStateNormal];
            [button6 setTitle:@"Good" forState:UIControlStateNormal];
            
            commentDesLabel.text = @"Comment";
            
            [self setupCompleteState];
            
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 500 + 100 + 100);
        }
            break;
        case MBCommentTypeReport:
        {
            [button1 setTitle:@"Terrible Service" forState:UIControlStateNormal];
            [button2 setTitle:@"Late" forState:UIControlStateNormal];
            [button3 setTitle:@"Fake Photos" forState:UIControlStateNormal];
            [button4 setTitle:@"UnProfessional" forState:UIControlStateNormal];
            [button5 setTitle:@"No Show" forState:UIControlStateNormal];
            [button6 setTitle:@"Good" forState:UIControlStateNormal];
            
            commentDesLabel.text = NSLocalizedString(@"Report a complaint", nil);
            
            [self setupReportState];
            
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 500 + 100 + 40);
        }
            break;
        default:
            break;
    }
    
    if (self.isShowComment) {
        textView.userInteractionEnabled = NO;
        starView.userInteractionEnabled = NO;
        button1.userInteractionEnabled = NO;
        button2.userInteractionEnabled = NO;
        button3.userInteractionEnabled = NO;
        button4.userInteractionEnabled = NO;
        button5.userInteractionEnabled = NO;
        button6.userInteractionEnabled = NO;
        self.reportButton.hidden = YES;
        self.completeButton.hidden = YES;
    }
    
}

- (void)setupReportState
{
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reportButton = reportButton;
    reportButton.layer.cornerRadius = 3.f;
    reportButton.layer.masksToBounds = YES;
    reportButton.backgroundColor = [UIColor colorWithHex:0xE44B27];
    reportButton.titleLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    [reportButton setTitle:NSLocalizedString(@"Report Job", nil) forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportButton addTarget:self action:@selector(reportEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:reportButton];
    [reportButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(20.f);
        make.left.equalTo(self.scrollView.mas_left).offset(20.f);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) - 40);
        make.height.mas_equalTo(50.f);
    }];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.completeButton = completeButton;
    completeButton.layer.cornerRadius = 3.f;
    completeButton.layer.masksToBounds = YES;
    completeButton.backgroundColor = [UIColor colorWithHex:0xA7D7FF];
    completeButton.titleLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    [completeButton setTitle:NSLocalizedString(@"Complete", nil) forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(completeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:completeButton];
    [completeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reportButton.mas_bottom).offset(20.f);
        make.left.equalTo(reportButton.mas_left);
        make.right.equalTo(reportButton.mas_right);
        make.height.equalTo(reportButton.mas_height);
    }];
}

- (void)setupCompleteState
{
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"upload_camer"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonEvnet:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:cameraButton];
    [cameraButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(20.f);
        make.left.equalTo(self.scrollView.mas_left).offset(20.f);
        make.size.mas_equalTo(CGSizeMake(100.f, 100.f));
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(addButtonEvnet:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    [self.scrollView addSubview:addButton];
    [addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_top);
        make.right.equalTo(self.textView.mas_right);
        make.size.equalTo(cameraButton);
    }];
    
    self.photoView = [[PhotoWallView alloc] init];
    self.photoView.modeltype = ModelTypeImage;
    self.photoView.controllerFrom = @"comment";
    self.photoView.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    if (self.isShowComment) {
        self.photoView.didSelectItemBlock = ^(NSInteger row){
            NSMutableArray *items = @[].mutableCopy;
            for (int i = 0; i < self.dataSource.count; i++) {
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
    }else {
        self.photoView.didSelectItemBlock = ^(NSInteger row){
            [weakSelf.dataSource removeObjectAtIndex:row];
            weakSelf.photoView.dataSource = weakSelf.dataSource;
        };
    }
    [self.scrollView addSubview:self.photoView];
    [self.photoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.isShowComment) {
            make.top.equalTo(cameraButton.mas_top);
            make.left.equalTo(cameraButton.mas_left);
            make.right.equalTo(addButton.mas_right);
            make.height.equalTo(cameraButton.mas_height);
        }else {
            make.top.equalTo(cameraButton.mas_top);
            make.left.equalTo(cameraButton.mas_right);
            make.right.equalTo(addButton.mas_left);
            make.height.equalTo(cameraButton.mas_height);
        }
        
    }];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.completeButton = completeButton;
    completeButton.layer.cornerRadius = 3.f;
    completeButton.layer.masksToBounds = YES;
    completeButton.backgroundColor = [UIColor colorWithHex:0xA7D7FF];
    completeButton.titleLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    [completeButton setTitle:@"Complete" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(completeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:completeButton];
    [completeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_bottom).offset(20.f);
        make.left.equalTo(self.scrollView.mas_left).offset(20.f);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) - 40);
        make.height.mas_equalTo(50.f);
    }];
}

- (void)starDidChange:(HCSStarRatingView*)sender{
    self.starValue = [NSString stringWithFormat:@"%f",sender.value];
}

- (void)tapEvent:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}


- (void)reportEvent:(UIButton *)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = @([UserInfoManager userID]);
    params[@"recordId"] = self.recordModel.recordId;
    params[@"commentContent"] = self.textView.text.length == 0 ? @"差评" : self.textView.text;
    params[@"state"] = @"1";
    
    [self networkWithPath:@"job/comment/insert" parameters:params success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0) {
            // 举报成功
        }
        [CustomHudView showWithTip:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        
    }];
}

- (void)completeEvent:(UIButton *)sender
{
    // 评论选项
    NSString *commentContent = @"";
    for (UIButton *button in self.commentButtonArray) {
        if (button.isSelected) {
            commentContent = [NSString stringWithFormat:@"%@,%@",commentContent, button.titleLabel.text];
        }
    }
    
    // 又拍云
    if (self.dataSource.count > 0) {
        __block NSString *picStr = @"";
        for (int i = 0; i < self.dataSource.count; i++) {
            //生成文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
            NSString *random= [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",random];
            
            UIImage *image = self.dataSource[i];
            
            UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
            [up uploadWithBucketName:@"modelbook1" operator:@"modelbook" password:@"m12345678" fileData:[self imageCompress:image] fileName:nil saveKey:fileName otherParameters:nil success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
                NSString *urlStr = responseBody[@"url"];
                picStr = [NSString stringWithFormat:@"%@,%@",picStr, urlStr];
                self.picCount++;
                if (self.picCount == self.dataSource.count) {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"userId"] = @([UserInfoManager userID]);
                    params[@"recordId"] = self.recordModel.recordId;
                    params[@"point"] = self.starValue;
                    params[@"commentTag"] = commentContent.length > 1 ? [commentContent substringFromIndex:1] : @"";
                    params[@"commentImage"] = [picStr substringFromIndex:1];
                    params[@"commentContent"] = self.textView.text.length == 0 ? @"好评" : self.textView.text;
                    params[@"state"] = @"0";
                    
                    [self networkWithPath:@"job/comment/insert" parameters:params success:^(id responseObject) {
                        NSNumber *code = responseObject[@"code"];
                        if (code.intValue == 0) {
                            for (UIViewController *vc in self.navigationController.childViewControllers) {
                                if ([vc isKindOfClass:[MBProfileMyJobsDetailController class]]) {
                                    [self.navigationController popToViewController:vc animated:YES];
                                    if (self.commentSuccessBlock) self.commentSuccessBlock();
                                }
                            }
                        }
                        [CustomHudView showWithTip:responseObject[@"msg"]];
                    } failure:^(NSError *error) {
                        
                    }];
                }
            } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
                NSLog(@"error-----");
            } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
                //NSLog(@"-----%lld",completedBytesCount/totalBytesCount);
            }];
        }
    }else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = @([UserInfoManager userID]);
        params[@"recordId"] = self.recordModel.recordId;
        params[@"point"] = self.starValue;
        params[@"commentTag"] = commentContent.length > 1 ? [commentContent substringFromIndex:1] : @"";
        params[@"commentContent"] = self.textView.text.length == 0 ? @"好评" : self.textView.text;
        params[@"state"] = @"0";
        
        [self networkWithPath:@"job/comment/insert" parameters:params success:^(id responseObject) {
            NSNumber *code = responseObject[@"code"];
            if (code.intValue == 0) {
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[MBProfileMyJobsDetailController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        if (self.commentSuccessBlock) self.commentSuccessBlock();
                    }
                }
            }
            [CustomHudView showWithTip:responseObject[@"msg"]];
        } failure:^(NSError *error) {
            
        }];
    }
    
}

-(NSData*)imageCompress:(UIImage*)image
{
    
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    float size=[imageData length]/1024;
    if (size<=200)
    {
        return UIImageJPEGRepresentation(image, 1) ;
    }
    else if (size>=200&&size<=1000)
    {
        return UIImageJPEGRepresentation(image, 0.5) ;
    }
    else if(size>1000)
    {
        return UIImageJPEGRepresentation(image, 0.05) ;
    }
    return nil;
}

- (void)commentButtonEvent:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

- (void)cameraButtonEvnet:(UIButton *)sender
{
    [self openCameraWithType:UIImagePickerControllerSourceTypeCamera tag:10];
}

- (void)addButtonEvnet:(UIButton *)sender
{
    PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] initWithMaxCount:9 selectArray:[NSMutableArray array]];
    picker.resourceType = SelectResourceTypePhoto;
    picker.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - PhotoPickerViewControllerDelegate

- (void)PhotoPickerViewControllerDidSelectPhoto:(NSMutableArray<AssetModel  *> *)selectArray
{
    if (selectArray.count == 0) {
        //        UIImage *image = [UIImage imageNamed:@"addImage"];
        //        self.photoView.dataSource = @[image];
    }else {
        NSMutableArray *imageArray = [NSMutableArray array];
        for (AssetModel *model in selectArray)
        {
            UIImage *image = [UIImage imageWithCGImage:[model.asset.defaultRepresentation fullScreenImage]];
            NSData *data = UIImagePNGRepresentation(image);
            if (data)
            {
                [imageArray addObject:image];
            }
        }
        [self.dataSource addObjectsFromArray:imageArray];
        self.photoView.dataSource = self.dataSource;
    }
}

#pragma mark - 开启摄像机

- (void)openCameraWithType:(UIImagePickerControllerSourceType)type tag:(NSInteger)tag
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"设备不支持摄像头"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles: nil];
        [alertView show];
        
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"此应用程序对您的相机没有访问权限"
                                  message:@"您可以在隐私设置中启用访问权限"
                                  delegate:nil
                                  cancelButtonTitle:@"关闭"
                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    [cameraUI.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [cameraUI.navigationBar setShadowImage:[UIImage new]];
    cameraUI.navigationBar.translucent = NO;
    [cameraUI.navigationBar setBarTintColor:[UIColor colorWithHex:0xe1554e]];
    [cameraUI.navigationBar setTintColor:[UIColor whiteColor]];
    [cameraUI.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    cameraUI.view.tag = tag;
    
    cameraUI.sourceType = type;
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (10 == picker.view.tag) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.dataSource addObject:image];
        self.photoView.dataSource = self.dataSource;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]]
        && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)reloadView
{
    CGFloat hour = [self calcTime:self.commentModel.beginTime endTime:self.commentModel.endTime];
    self.timeDesLabel.text = [NSString stringWithFormat:@"Booked for %ld hours",(NSInteger)ceilf(hour)];
    
    NSArray *imageArray = [self.commentModel.jobComment.commentImage componentsSeparatedByString:@","];
    if (imageArray.count > 0) {
        [self.dataSource addObjectsFromArray:imageArray];
    }
    
    self.textView.text = self.commentModel.jobComment.commentContent.length > 0 ? self.commentModel.jobComment.commentContent : @"暂无评价";
    
    self.starView.value = self.commentModel.jobComment.point.floatValue;
    
    NSArray *textArray = [self.commentModel.jobComment.commentTag componentsSeparatedByString:@","];
    for (UIButton *button in self.commentButtonArray) {
        if ([textArray containsObject:button.titleLabel.text]) {
            button.selected = YES;
        }
    }
}

- (CGFloat)calcTime:(NSString *)beginTime endTime:(NSString *)endTime
{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH";
    NSDate *endDate = [dateFomatter dateFromString:endTime];
    NSDate *beginDate = [dateFomatter dateFromString:beginTime];
    NSTimeInterval value = [endDate timeIntervalSinceDate:beginDate];
    CGFloat hourf = value / 3600;
    return hourf;
}

@end
