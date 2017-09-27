//
//  EvaluateController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "EvaluateController.h"
#import "ProfileJobCommentModel.h"
#import "ProfileCommentModel.h"
#import "Macros.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import <UIImageView+WebCache.h>
#import "Handler.h"
#import "PhotoPickerViewController.h"
#import "ProgressHUD.h"
#import "KSPhotoItem.h"
#import "MBJobDetailModel.h"
#import "KSPhotoBrowser.h"
#import "ProfileUserInfoModel.h"
#import "MBProfileMyJobsDetailController.h"
#import "UpYunFormUploader.h"
#import "NSString+imgURL.h"

static NSString *const jobCommentURL = @"http://39.108.152.114/modeltest/job/comment/insert";

#define imageEdge (IS_IPHONE320?40:70)
#define buttonWidth (IS_IPHONE320?300:335)
#define commentImageWidth (IS_IPHONE320?90:110)

@interface EvaluateController ()<PhotoPickerViewControllerDelegate,UITextViewDelegate>

/* UIScrollView */
@property(nonatomic, strong)UIScrollView *scrollView;
/* 是否可以编辑 */
@property(nonatomic, assign)BOOL isCanEdit;
/* infoView */
@property(nonatomic, strong)UIView *infoView;
/* rateView */
@property(nonatomic, strong)UIView *rateView;
/* tagView */
@property(nonatomic, strong)UIView *tagView;
/* commentView */
@property(nonatomic, strong)UIView *commentView;
/* imageView */
@property(nonatomic, strong)UIView *imageView;
/* bottomView */
@property(nonatomic, strong)UIView *submitView;
/* tagArray */
@property(nonatomic, strong)NSArray *tagArray;
/* 评分视图 */
@property(nonatomic, strong)UIView *starView;
/* 图片背景视图 */
@property(nonatomic, strong)UIView *imageCoverView;
/* 当前评分 */
@property(nonatomic, assign)NSInteger star;
/* tagArray */
@property(nonatomic, strong)NSMutableArray *selectTagArray;
/* 评论图片 */
@property(nonatomic, strong)NSMutableArray *selectImgArray;
/* 评论框 */
@property(nonatomic, strong)UITextView *textView;
/* 评论模型 */
@property(nonatomic, strong)ProfileJobCommentModel *commentModel;

@end

@implementation EvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
    if (_isShowComment) [self requestCommentInfo];
}

- (void)requestCommentInfo
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:_recordModel.recordId forKey:@"recordId"];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"currentUserId"];
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/job/comment/getinfo" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *object = responseObject[@"object"];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    weakSelf.commentModel = [[ProfileJobCommentModel alloc] initWithDict:object];
                    [weakSelf reloadView];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initLayout
{
    self.navigationItem.title = NSLocalizedString(@"profilepastjobsComment", nil);
    if (_type == MBEvaluateTypeReport) self.navigationItem.title = NSLocalizedString(@"profilepastjobsReport", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.rateView];
    [self.scrollView addSubview:self.tagView];
    [self.scrollView addSubview:self.commentView];
    [self.scrollView addSubview:self.imageView];
    if (_isCanEdit)
    {
        [self.scrollView addSubview:self.submitView];
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitView.frame));
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.imageView.frame)+15);
    }
    /** 键盘退出通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(theKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    /** 键盘弹出通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)reloadView
{
    NSArray *imgArray = [_commentModel.jobComment.commentImage componentsSeparatedByString:@","];
    if (imgArray.count>0) [self.selectImgArray addObjectsFromArray:imgArray];
    NSArray *tagArray = [_commentModel.jobComment.commentTag componentsSeparatedByString:@","];
    if (tagArray.count>0) [self.selectTagArray addObjectsFromArray:tagArray];
    /* 评论内容 */
    _textView.text = _commentModel.jobComment.commentContent;
    /* 图片 */
    for (int i = 0; i<imgArray.count; i++) {
        UIImageView *imgView = [_imageView viewWithTag:i+1];
        if ([imgView isKindOfClass:[UIImageView class]]) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:[self.selectImgArray[i] imgURLWithSize:imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
        }
    }
    /* 星级 */
    for (int i = 0; i<[_commentModel.jobComment.point integerValue]; i++) {
        UIImageView *star = [_starView viewWithTag:i+1];
        if ([star isKindOfClass:[UIImageView class]]) {
            star.image = [UIImage imageNamed:@"star"];
        }
    }
    /* tag */
    for (UIButton *tagBtn in _tagView.subviews) {
        if ([tagBtn isKindOfClass:[UIButton class]]) {
            if ([self.selectTagArray containsObject:tagBtn.titleLabel.text])
            {
                tagBtn.selected = YES;
                tagBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
            }
        }
    }
}

- (void)initData
{
    _star = 5;
    _isCanEdit = !_isShowComment;
}

#pragma mark - action
- (void)reportAction:(UIButton *)sender
{
    EvaluateController *vc = [[EvaluateController alloc] init];
    vc.recordModel = _recordModel;
    vc.isShowComment = NO;
    vc.type = MBEvaluateTypeReport;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imageStarTapAction:(UITapGestureRecognizer *)tap
{
    if (!_isCanEdit) return;
    [self.view endEditing:YES];
    NSInteger tag = tap.view.tag;
    _star = tag;
    for (UIImageView *imgView in _starView.subviews) {
        imgView.image = [UIImage imageNamed:@"star_n"];
        if (imgView.tag <= tag) {
            imgView.image = [UIImage imageNamed:@"star"];
        }
    }
}

- (void)tagTapAction:(UIButton *)sender
{
    if (!_isCanEdit) return;
    [self.view endEditing:YES];
    if (!sender.selected)
    {
        sender.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [self.selectTagArray addObject:sender.titleLabel.text];
    }
    else
    {
        sender.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [self.selectTagArray removeObject:sender.titleLabel.text];
    }
    sender.selected = !sender.selected;
}

- (void)imageTapAction:(UIGestureRecognizer *)tap
{
    if (!_isCanEdit)
    {
        if (_selectImgArray.count == 0) return;
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < _selectImgArray.count; i++)
        {
            UIImageView *imageView = [_imageView viewWithTag:i+1];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_selectImgArray[i]]];
            [items addObject:item];
        }
        NSInteger curIndex = tap.view.tag-1;
        if (curIndex>=items.count) curIndex = items.count-1;
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:curIndex];
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces = NO;
        [browser showFromViewController:self];
        return;
    }
    [self.view endEditing:YES];
    PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] initWithMaxCount:9 selectArray:self.selectImgArray];
    picker.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)submitAction:(UIButton *)sender
{
    if (!_isCanEdit) return;
    [self.view endEditing:YES];
    NSString *msg = NSLocalizedString(@"profilepastjobsComment", nil);
    if (_type == MBEvaluateTypeReport) msg = NSLocalizedString(@"profilepastjobsReport", nil);
    NSString *urseId = [NSString stringWithFormat:@"%ld",[UserInfoManager userID]];
    NSString *commentTag;
    if (urseId.length == 0 || [urseId isEqualToString:@"(null)"])
    {
        [ProgressHUD showText:@"用户ID不存在!"];
        return;
    }
    if (self.recordModel.recordId.length == 0 || [self.recordModel.recordId isEqualToString:@"(null)"])
    {
        [ProgressHUD showText:@"任务ID不存在!"];
        return;
    }
    if (_selectTagArray.count == 0)
    {
        [ProgressHUD showText:@"请选择一个标签!"];
        return;
    }
    else
    {
        for (NSString *tag in _selectTagArray) {
            if (commentTag.length == 0)
            {
                commentTag = tag;
            }
            else
            {
                commentTag = [NSString stringWithFormat:@"%@,%@",commentTag,tag];
            }
        }
    }
    if (_textView.text.length == 0 || [_textView.text isEqualToString:NSLocalizedString(@"Write a comment ...", nil)])
    {
        [ProgressHUD showText:[NSString stringWithFormat:@"请填写%@内容!",msg]];
        return;
    }
    [ProgressHUD showLoadingText:@"正在提交"];
    
    __block NSInteger count = 0;
    __block NSString *picStr = @"";
    WS(weakSelf);
    if (self.selectImgArray.count>0)
    {
        for (int i = 0; i<self.selectImgArray.count; i++) {
            AssetModel *model = self.selectImgArray[i];
            UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
            [up uploadWithBucketName:@"modelbook1" operator:@"modelbook" password:@"m12345678" fileData:[Handler imageCompress:[UIImage imageWithCGImage:model.asset.defaultRepresentation.fullScreenImage]] fileName:nil saveKey:[NSString stringWithFormat:@"%f_%d.png",[[NSDate date] timeIntervalSince1970],i] otherParameters:nil success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
                NSString *urlStr = responseBody[@"url"];
                picStr = [NSString stringWithFormat:@"%@,%@",picStr, urlStr];
                count++;
                if (count == weakSelf.selectImgArray.count)
                {
                    [weakSelf commentRequest:[picStr substringFromIndex:1] commentTag:commentTag userId:urseId msg:msg];
                }
            } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
                [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
            } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
                //NSLog(@"-----%lld",completedBytesCount/totalBytesCount);
            }];
        }
    }
    else
    {
        [self commentRequest:@"" commentTag:commentTag userId:urseId msg:msg];
    }
}

- (void)commentRequest:(NSString *)commentImage commentTag:(NSString *)commentTag userId:(NSString *)userId msg:(NSString *)msg
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:userId forKey:@"userId"];
    [md setValue:_recordModel.recordId forKey:@"recordId"];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)_star] forKey:@"point"];
    [md setValue:commentTag forKey:@"commentTag"];
    [md setValue:commentImage forKey:@"commentImage"];
    [md setValue:_textView.text forKey:@"commentContent"];
    [md setValue:[NSString stringWithFormat:@"%ld",(long)_type] forKey:@"state"];
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:jobCommentURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:[NSString stringWithFormat:@"%@成功!",msg] block:^{
                    for (UIViewController *vc in weakSelf.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:[MBProfileMyJobsDetailController class]]) {
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                            if (weakSelf.commentSuccessBlock) weakSelf.commentSuccessBlock();
                        }
                    }
                }];
            }
            else
            {
                [ProgressHUD showText:[NSString stringWithFormat:@"%@失败!",msg]];
            }
        }
        else
        {
            [ProgressHUD showText:[NSString stringWithFormat:@"%@失败!",msg]];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:[NSString stringWithFormat:@"%@失败!",msg]];
    }];
}

#pragma mark - PhotoPickerViewControllerDelegate
- (void)PhotoPickerViewControllerDidSelectPhoto:(NSMutableArray<AssetModel *> *)selectArray
{
    for (UIImageView *imageView in self.imageCoverView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            imageView.image = [UIImage imageNamed:@"addImage"];
        }
    }
    for (int i = 0; i<selectArray.count; i++) {
        AssetModel *model = selectArray[i];
        UIImage *image = [UIImage imageWithCGImage:[model.asset.defaultRepresentation fullScreenImage]];
        UIImageView *imageView = [self.imageCoverView viewWithTag:i+1];
        imageView.image = image;
    }
    [self.selectImgArray removeAllObjects];
    [self.selectImgArray addObjectsFromArray:selectArray];
}

#pragma mark - textView - delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@"Write a comment ...", nil)])
    {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        textView.text = NSLocalizedString(@"Write a comment ...", nil);
    }
}

#pragma mark - notification
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    CGRect begin = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect end = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(begin.size.height>0 && (begin.origin.y- end.origin.y >0))
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, end.size.height + 15, 0);
        }];
    }
}

- (void)theKeyboardWillHide:(NSNotification *)notification
{
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEdit];
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

#pragma mark - lazy
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-topBarHeight)];
    }
    return _scrollView;
}

- (UIView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 130)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
        [_infoView addGestureRecognizer:tap];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageEdge, 40, 74, 74)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[_recordModel.user.headpic imgURLWithSize:imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        [_infoView addSubview:imgView];
        
        UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+15, CGRectGetMinY(imgView.frame)+2, CGRectGetWidth(self.view.frame)-2*imageEdge-74-15, 20)];
        nickNameLabel.font = [UIFont fontWithName:pageFontName size:12];
        nickNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        nickNameLabel.text = _recordModel.user.nickname;
        [_infoView addSubview:nickNameLabel];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickNameLabel.frame), CGRectGetMaxY(nickNameLabel.frame), CGRectGetWidth(nickNameLabel.frame), 16)];
        infoLabel.font = [UIFont fontWithName:pageFontName size:12];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.text = @"Booked for 2 hours";
        [_infoView addSubview:infoLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickNameLabel.frame), CGRectGetMaxY(infoLabel.frame), CGRectGetWidth(nickNameLabel.frame), 16)];
        timeLabel.font = [UIFont fontWithName:pageFontName size:12];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.text = [Handler dateStrFromCstampTime:_recordModel.recordCreateTime withDateFormat:@"yyyy-MM-dd"];
        [_infoView addSubview:timeLabel];
        
        UIButton *reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickNameLabel.frame), CGRectGetMaxY(imgView.frame)-18, 50, 18)];
        [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
        [reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        reportBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:12];
        reportBtn.backgroundColor = [UIColor colorWithRed:247/255.0 green:231/255.0 blue:93/255.0 alpha:1];
        reportBtn.layer.cornerRadius = 3;
        [reportBtn addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        if (_type == MBEvaluateTypeReport) reportBtn.hidden = YES;
        [_infoView addSubview:reportBtn];
    }
    return _infoView;
}

- (UIView *)rateView
{
    if (!_rateView) {
        _rateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame), CGRectGetWidth(self.view.frame), 90)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
        [_rateView addGestureRecognizer:tap];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_rateView.frame), 40)];
        titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLabel.text = NSLocalizedString(@"Give a Rating", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rateView addSubview:titleLabel];
        
        UIView *starCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_rateView.frame)-CGRectGetMaxY(titleLabel.frame))];
        [_rateView addSubview:starCoverView];
        
        _starView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(starCoverView.frame)-35*5)/2, (CGRectGetHeight(starCoverView.frame)-35)/2, 35*5, 35)];
        [starCoverView addSubview:_starView];
        
        CGFloat offset_x = 0;
        NSInteger count = 5;
        if (count>5) count = 5;
        if (count == 0) count = 1;
        for (int i = 0; i<5; i++) {
            offset_x = i*35;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset_x, 0, 35, 35)];
            imageView.image = [UIImage imageNamed:@"star_n"];
            if (i<count) imageView.image = [UIImage imageNamed:@"star"];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+1;
            [_starView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageStarTapAction:)];
            [imageView addGestureRecognizer:tap];
        }
    }
    return _rateView;
}

- (UIView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.rateView.frame), CGRectGetWidth(self.view.frame), 155)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
        [_tagView addGestureRecognizer:tap];
        
        CGFloat leftEdge = (CGRectGetWidth(self.view.frame)-200-25)/2;
        CGFloat offset_x = 0;
        CGFloat offset_y = 0;
        for (int i = 0; i<self.tagArray.count; i++) {
            NSString *tag = self.tagArray[i];
            offset_x = i%2*125+leftEdge;
            offset_y = i/2*(30+12)+10;;
            UIButton *tagBtn = [[UIButton alloc] initWithFrame:CGRectMake(offset_x, offset_y, 100, 30)];
            [tagBtn setTitle:tag forState:UIControlStateNormal];
            [tagBtn setTitle:tag forState:UIControlStateSelected];
            [tagBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.titleLabel.font = [UIFont fontWithName:pageFontName size:12];
            tagBtn.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
            tagBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [tagBtn addTarget:self action:@selector(tagTapAction:) forControlEvents:UIControlEventTouchUpInside];
            [_tagView addSubview:tagBtn];
        }
    }
    return _tagView;
}

- (UIView *)commentView
{
    if (!_commentView) {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagView.frame), CGRectGetWidth(self.view.frame), 125)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
        [_commentView addGestureRecognizer:tap];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
        titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLabel.text = NSLocalizedString(@"Report a complaint", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_commentView addSubview:titleLabel];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(self.view.frame)-100, CGRectGetHeight(_commentView.frame)-CGRectGetMaxY(titleLabel.frame))];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.text = NSLocalizedString(@"Write a comment ...", nil);
        _textView.delegate = self;
        if (!_isCanEdit) _textView.editable = NO;
        [_commentView addSubview:_textView];
    }
    return _commentView;
}

- (UIView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.commentView.frame), CGRectGetWidth(self.view.frame), 70+commentImageWidth)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
        [_imageView addGestureRecognizer:tap];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
        titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLabel.text = NSLocalizedString(@"Photos off Comment", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_imageView addSubview:titleLabel];
        
        _imageCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_imageView.frame)-CGRectGetHeight(titleLabel.frame))];
        [_imageView addSubview:_imageCoverView];
        
        CGFloat edge = (CGRectGetWidth(self.view.frame)-(commentImageWidth*3+20))/2;
        CGFloat offset_x = 0;
        CGFloat offset_y = (CGRectGetHeight(_imageView.frame)-CGRectGetHeight(titleLabel.frame)-commentImageWidth)/2;
        
        for (int i = 0; i<3; i++) {
            offset_x = edge+i*(commentImageWidth+10);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset_x, offset_y, commentImageWidth, commentImageWidth)];
            imageView.image = [UIImage imageNamed:@"addImage"];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+1;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            [imageView addGestureRecognizer:tap];
            
            [_imageCoverView addSubview:imageView];
        }
    }
    return _imageView;
}

- (UIView *)submitView
{
    if (!_submitView) {
        _submitView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), CGRectGetWidth(self.view.frame), 90)];
        
        UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-buttonWidth)/2, (CGRectGetHeight(_submitView.frame)-50)/2, buttonWidth, 50)];
        submitBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        submitBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [submitBtn setTitle:NSLocalizedString(@"profilepastjobsfrozen", nil) forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = 3;
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitView addSubview:submitBtn];
    }
    return _submitView;
}

- (NSArray *)tagArray
{
    if (!_tagArray) {
        _tagArray = @[NSLocalizedString(@"Terrible Service", nil),NSLocalizedString(@"Late", nil),NSLocalizedString(@"Fake photos", nil),NSLocalizedString(@"Unprofessional", nil),NSLocalizedString(@"No Show", nil),NSLocalizedString(@"Good", nil)];
    }
    return _tagArray;
}

- (NSMutableArray *)selectTagArray
{
    if (!_selectTagArray) {
        _selectTagArray = [NSMutableArray array];
    }
    return _selectTagArray;
}

- (NSMutableArray *)selectImgArray
{
    if (!_selectImgArray) {
        _selectImgArray = [NSMutableArray array];
    }
    return _selectImgArray;
}

@end
