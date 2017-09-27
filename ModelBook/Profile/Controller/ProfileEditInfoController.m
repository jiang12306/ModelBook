//
//  ProfileEditInfoController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileEditInfoController.h"
#import <UIImageView+WebCache.h>
#import "ProfileEditInfoCell.h"
#import "WalletViewController.h"
#import "PhotoPickerViewController.h"
#import "ProgressHUD.h"
#import "ResourceUploadModel.h"
#import "ProfileViewController.h"
#import "UpYunFormUploader.h"
#import "Handler.h"
#import "NSString+imgURL.h"
#import "MBProfileHeaderPicController.h"

#define footerBtnWidth (IS_IPHONE320?300:360)

static NSString *uploadHeaderPicURL = @"http://39.108.152.114/modeltest/user/upload/headpic/upyun";
static NSString *updateUserInfoURL = @"http://39.108.152.114/modeltest/user/update";

@interface ProfileEditInfoController ()<UITableViewDelegate, UITableViewDataSource, ProfileEditInfoCellDelegate,PhotoPickerViewControllerDelegate>

/* topView */
@property(nonatomic, strong)UIView *topView;
/* 头像 */
@property(nonatomic, strong)UIImageView *imgView;
/* footerView */
@property(nonatomic, strong)UIView *footerView;
/* tableView */
@property(nonatomic, strong)UITableView *tableView;
/* 标题数组 */
@property(nonatomic, strong)NSArray *titleArray;
/* value */
@property(nonatomic, strong)NSArray *valueArray;
/* 图片数组 */
@property(nonatomic, strong)NSArray *imageArray;
/* 单位数组 */
@property(nonatomic, strong)NSArray *unitArray;

@end

@implementation ProfileEditInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initLayout
{
    self.rightBtn.hidden = NO;
    [self.rightBtn setImage:[UIImage imageNamed:@"wallet"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"wallet"] forState:UIControlStateSelected];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"ProfileEdit", nil);
    [self.view addSubview:self.tableView];
    /** 键盘退出通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(theKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    /** 键盘弹出通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserPhoto) name:reloadProfileInfoNotification object:nil];
}

- (void)reloadUserPhoto
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[[UserInfoManager headpic] imgURLWithSize:_imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
}

- (void)updateUserInfoRequest:(NSMutableDictionary *)md
{
    [ProgressHUD showLoadingText:NSLocalizedString(@"Being updated", nil)];
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:updateUserInfoURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:NSLocalizedString(@"Update successful", nil) block:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:reloadProfileInfoNotification object:nil];
            }
            else
            {
                [ProgressHUD showText:NSLocalizedString(@"Update failed", nil)];
            }
        }
        else
        {
            [ProgressHUD showText:NSLocalizedString(@"Update failed", nil)];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:NSLocalizedString(@"Update failed", nil)];
    }];
}

#pragma mark - action
- (void)rightBtnAction:(UIButton *)btn
{
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    [self.navigationController pushViewController:walletVC animated:YES];
}

- (void)editEdit
{
    [self.view endEditing:YES];
}

- (void)doneAction:(UIButton *)sender
{
    NSString *address = blank;
    NSString *height = blank;
    NSString *weight = blank;
    NSString *hourRate = blank;
    NSString *dayRate = blank;
    NSString *phone = blank;
    for (int i = 0; i < _titleArray.count; i++)
    {
        ProfileEditInfoCell *cell = (ProfileEditInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *title = _titleArray[i];
        NSString *value = _valueArray[i];
        if ([title isEqualToString:NSLocalizedString(@"ProfileAddress", nil)])
        {
            if (![value isEqualToString:cell.textField.text]) address = cell.textField.text;
        }
        if ([title isEqualToString:NSLocalizedString(@"ProfileHeight", nil)])
        {
            if (![value isEqualToString:cell.textField.text]) height = cell.textField.text;
        }
        if ([title isEqualToString:NSLocalizedString(@"ProfileWeight", nil)])
        {
            if (![value isEqualToString:cell.textField.text]) weight = cell.textField.text;
        }
        if ([title isEqualToString:NSLocalizedString(@"ProfileMy Hour Rate", nil)])
        {
            if (![value isEqualToString:cell.textField.text]) hourRate = cell.textField.text;
        }
        if ([title isEqualToString:NSLocalizedString(@"ProfileMy Day Rate", nil)])
        {
            if (![value isEqualToString:cell.textField.text]) dayRate = cell.textField.text;
        }
        if ([title isEqualToString:NSLocalizedString(@"contact number", nil)]||[title isEqualToString:NSLocalizedString(@"phone number", nil)])
        {
            if (![value isEqualToString:cell.textField.text]) phone = cell.textField.text;
        }
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
    if (address.length>0) [md setValue:address forKey:@"address"];
    if (height.length>0) [md setValue:height forKey:@"height"];
    if (weight.length>0) [md setValue:weight forKey:@"weight"];
    if (hourRate.length>0) [md setValue:hourRate forKey:@"hourRate"];
    if (dayRate.length>0) [md setValue:dayRate forKey:@"dayRate"];
    if (phone.length>0) [md setValue:phone forKey:@"phone"];
    if ([md allKeys].count == 1)
    {
        [ProgressHUD showText:NSLocalizedString(@"Please fill out the changes", nil)];
    }
    else
    {
        [self updateUserInfoRequest:md];
    }
}

#pragma mark - network
- (void)uploadResourceRequest:(SelectResourceType)resourceType uploadData:(NSMutableArray<ResourceUploadModel *> *)uploadData isVideo:(BOOL)isVideo
{
    if (uploadData.count == 0) return;
    
    ResourceUploadModel *model = [uploadData firstObject];
    WS(weakSelf);
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    [up uploadWithBucketName:@"modelbook1" operator:@"modelbook" password:@"m12345678" fileData:[Handler imageCompress:model.image] fileName:nil saveKey:model.fileName otherParameters:nil success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
        NSString *urlStr = responseBody[@"url"];
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
        [md setValue:urlStr forKey:@"headpic"];
        [[NetworkManager sharedManager] requestWithHTTPPath:uploadHeaderPicURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([code isEqualToString:@"0"])
                {
                    [ProgressHUD showText:NSLocalizedString(@"Avatar uploaded successfully", nil)];
                    /* 重新设置头像 */
                    NSString *headpic = responseObject[@"object"];
                    [UserInfoManager setHeadpic:headpic];
                    /* 替换本地头像 */
                    [weakSelf.imgView sd_setImageWithURL:[NSURL URLWithString:[headpic imgURLWithSize:weakSelf.imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:reloadProfileInfoNotification object:nil];
                }
                else
                {
                    [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
                }
            }
            else
            {
                [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
            }
        } failure:^(NSError *error) {
            [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
        }];
    } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
        [ProgressHUD showText:NSLocalizedString(@"Upload Failure", nil)];
    } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
        //NSLog(@"-----%lld",completedBytesCount/totalBytesCount);
    }];
}

#pragma mark - PhotoPickerViewControllerDelegate
- (void)PhotoPickerViewControllerDidSelectPhoto:(NSMutableArray<AssetModel *> *)selectArray
{
    if (selectArray.count == 0) return;
    [ProgressHUD showText:NSLocalizedString(@"To upload", nil)];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (AssetModel *model in selectArray)
    {
        UIImage *image = [UIImage imageWithCGImage:[model.asset.defaultRepresentation fullScreenImage]];
        if (image)
        {
            ResourceUploadModel *uploadModel = [[ResourceUploadModel alloc] init];
            uploadModel.image = image;
            uploadModel.fileName = model.asset.defaultRepresentation.filename;
            [imageArray addObject:uploadModel];
        }
    }
    [self uploadResourceRequest:SelectResourceTypePhoto uploadData:imageArray isVideo:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileEditInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileEditInfoCell"];
    if (!cell)
    {
        cell = [[ProfileEditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileEditInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row<self.titleArray.count)
    {
        [cell handlerCellWithImage:[UIImage imageNamed:self.imageArray[indexPath.row]] title:self.titleArray[indexPath.row] value:self.valueArray[indexPath.row] index:indexPath.row unit:self.unitArray[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ProfileEditInfoCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mmark - ProfileEditInfoCellDelegate
- (BOOL)textFieldBeginEditing:(NSInteger)index
{
    BOOL result = YES;
    NSString *title = self.titleArray[index];
    if ([title isEqualToString:NSLocalizedString(@"Profilewaist", nil)])
    {
        result = NO;
    }
    if ([title isEqualToString:NSLocalizedString(@"ProfileProfile Photo", nil)])
    {
        MBProfileHeaderPicController *vc = [[MBProfileHeaderPicController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
//        PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] initWithMaxCount:1 selectArray:[NSMutableArray array]];
//        picker.delegate = self;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
//        [self presentViewController:nav animated:YES completion:nil];
        
        result = NO;
    }
    if ([title isEqualToString:NSLocalizedString(@"ProfileAbout me", nil)])
    {
        ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]];
        profileVC.initialTabPage = InitialTabPageAboutMe;
        [self.navigationController pushViewController:profileVC animated:YES];
        result = NO;
    }
    return result;
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
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, end.size.height + 15, 0);
        }];
    }
    
}

- (void)theKeyboardWillHide:(NSNotification *)notification
{
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.tableView.contentInset = UIEdgeInsetsZero;
    }];
}

#pragma mark - lazy
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 120)];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 20, 80, 80)];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[_userInfoModel.headpic imgURLWithSize:_imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        [_topView addSubview:_imgView];
        
        UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+40, CGRectGetMinY(_imgView.frame), CGRectGetWidth(self.view.frame)-(CGRectGetMaxX(_imgView.frame)+40+40), 30)];
        nickName.textColor = [UIColor blackColor];
        nickName.font = [UIFont fontWithName:pageFontName size:16];
        nickName.text = _userInfoModel.nickname;
        [_topView addSubview:nickName];
        
        UILabel *editLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickName.frame), CGRectGetMaxY(_imgView.frame)-20, CGRectGetWidth(nickName.frame), 20)];
        editLabel.textColor = [UIColor colorWithHex:0xa7d7ff];
        editLabel.font = [UIFont fontWithName:pageFontName size:14];
        editLabel.text = NSLocalizedString(@"ProfileEdit", nil);
        [_topView addSubview:editLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editEdit)];
        [_topView addGestureRecognizer:tap];
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-topBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.topView;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        NSArray *customArray = @[NSLocalizedString(@"ProfileAddress", nil),NSLocalizedString(@"Profilewaist", nil),NSLocalizedString(@"ProfileProfile Photo", nil),NSLocalizedString(@"ProfileAbout me", nil)];
        NSMutableArray *array = [NSMutableArray arrayWithArray:customArray];
        NSMutableArray *imageArray = [NSMutableArray arrayWithArray:@[@"login_pwd",@"login_card",@"login_load",@"login_pwd"]];
        NSMutableArray *valueArray = [NSMutableArray arrayWithArray:@[_userInfoModel.address?:@"",@"",@"",@""]];
        NSMutableArray *unitArray = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
        switch ([_userInfoModel.userTypeId integerValue]) {
            case 1:
            {
                /* 摄影师，化妆师 */
                [array addObjectsFromArray:@[NSLocalizedString(@"phone number", nil),NSLocalizedString(@"ProfileMy Hour Rate", nil),NSLocalizedString(@"ProfileMy Day Rate", nil)]];
                [imageArray addObjectsFromArray:@[@"login_card",@"login_rate",@"login_rate"]];
                [valueArray addObjectsFromArray:@[_userInfoModel.phone?:@"",_userInfoModel.hourRate?:@"",_userInfoModel.dayRate?:@""]];
                [unitArray addObjectsFromArray:@[@"",@"元/时",@"元/天"]];
                
            }
                break;
            case 5:
            {
                /* 公司 */
                [array addObject:NSLocalizedString(@"contact number", nil)];
                [imageArray addObject:@"login_card"];
                [valueArray addObject:_userInfoModel.phone?:@""];
                [unitArray addObjectsFromArray:@[@""]];
            }
                break;
            default:
            {
                /* 外模 */
                [array addObjectsFromArray:@[NSLocalizedString(@"phone number", nil),NSLocalizedString(@"ProfileHeight", nil),NSLocalizedString(@"ProfileWeight", nil),NSLocalizedString(@"ProfileMy Hour Rate", nil),NSLocalizedString(@"ProfileMy Day Rate", nil)]];
                [imageArray addObjectsFromArray:@[@"login_card",@"login_card",@"login_card",@"login_rate",@"login_rate"]];
                [valueArray addObjectsFromArray:@[_userInfoModel.phone?:@"",_userInfoModel.height?:@"",_userInfoModel.weight?:@"",_userInfoModel.hourRate?:@"",_userInfoModel.dayRate?:@""]];
                [unitArray addObjectsFromArray:@[@"",@"cm",@"kg",@"元/时",@"元/天"]];
            }
                break;
        }
        _titleArray = array;
        _imageArray = imageArray;
        _valueArray = valueArray;
        _unitArray = unitArray;
    }
    return _titleArray;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 120)];
        
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-footerBtnWidth)/2, 45, footerBtnWidth, 60)];
        doneBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        doneBtn.layer.cornerRadius = 3;
        [doneBtn setTitle:NSLocalizedString(@"ProfileEditDone", nil) forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:doneBtn];
    }
    return _footerView;
}

@end
