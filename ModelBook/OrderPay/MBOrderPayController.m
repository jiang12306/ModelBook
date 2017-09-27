//
//  MBOrderPayController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/31.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBOrderPayController.h"
#import "MBOrderPayCell.h"
#import "RSADataSigner.h"
#import "MBOrderPayEnterPasswordController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "MBOrderPaySuccessController.h"
#import "ProgressHUD.h"

static NSString * const aliPaySignedURL = @"http://39.108.152.114/modeltest/alipay/create_order_1";

@interface MBOrderPayController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

/* tableView */
@property(nonatomic, strong)UITableView *tableView;
/* footerView */
@property(nonatomic, strong)UIView *footerView;
/* 标题数组 */
@property(nonatomic, strong)NSArray *titleArray;
/* 数据源 */
@property(nonatomic, strong)NSArray *detailArray;
/* 签名结果 */
@property(nonatomic, strong)NSString *signedString;
/* 余额 */
@property(nonatomic, assign)CGFloat balance;
/* 支付类型 */
@property(nonatomic, assign)payType payType;

@end

@implementation MBOrderPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
}

- (void)initData
{
    [self inquiryBalanceRequest];
    [self requestAlipaySignedString:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initLayout
{
    self.navigationItem.title = NSLocalizedString(@"Payment", nil);
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessNotification:) name:alipayOrderPaySuccessNotification object:nil];
}

- (void)comfirmAction:(UIButton *)sender
{
    if (_payType == payTypeAliPay)
    {
        [self payOrder];
    }
    else
    {
        MBOrderPayEnterPasswordController *vc = [[MBOrderPayEnterPasswordController alloc] init];
        vc.orderModel = self.orderModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)payOrder
{
    // NOTE: 如果加签成功，则继续执行支付
    if (_signedString != nil && _signedString.length > 0)
    {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"ModelBook";
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:_signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:alipayOrderPaySuccessNotification object:nil userInfo:@{@"resultStatus":[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]]}];
        }];
    }
    else
    {
        [self requestAlipaySignedString:YES];
    }
}

#pragma mark - network
- (void)requestAlipaySignedString:(BOOL)isManual
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = @"2088621612498263";
    order.sellerID = @"2088621612498263";
    order.outTradeNO = _orderModel.tradeNO; //订单ID（由商家自行制定）
    order.subject = _orderModel.subject.length>0?_orderModel.subject:@"MB订单"; //商品标题
    order.body = _orderModel.body; //商品描述
    //    order.totalFee = [NSString stringWithFormat:@"%.2f",_orderModel.totalFee]; //商品价格
    order.totalFee = @"0.01"; //商品价格
    order.notifyURL =  @"http://39.108.152.114/modeltest/dealrecord/insert";
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    order.appID = @"2017032306355906";
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:order.partner forKey:@"partner"];
    [md setValue:order.sellerID forKey:@"seller_id"];
    [md setValue:order.outTradeNO forKey:@"out_trade_no"];
    [md setValue:order.subject forKey:@"subject"];
    [md setValue:order.body forKey:@"body"];
    [md setValue:order.totalFee forKey:@"total_fee"];
    [md setValue:order.notifyURL forKey:@"notify_url"];
    [md setValue:order.service forKey:@"service"];
    [md setValue:order.paymentType forKey:@"payment_type"];
    [md setValue:order.inputCharset forKey:@"_input_charset"];
    [md setValue:order.itBPay forKey:@"it_b_pay"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:aliPaySignedURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                weakSelf.signedString = responseObject[@"object"];
                if (isManual)
                {
                    [weakSelf payOrder];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

/* 查询余额 */
- (void)inquiryBalanceRequest
{
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114//modeltest/user/getbalance" parameters:@{@"userId":[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]} constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                weakSelf.balance = [responseObject[@"object"] floatValue];
                if (weakSelf.balance>=_orderModel.totalFee)
                {
                    /* 可以余额支付 */
                    weakSelf.payType = payTypeBalance;
                }
                [weakSelf.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

#pragma mark - notification
- (void)paySuccessNotification:(NSNotification *)Noti
{
    NSDictionary *userInfo = Noti.userInfo;
    if ([[userInfo objectForKey:@"resultStatus"] isEqualToString:@"8000"] || [[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9000"] || [[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9999"])
    {
        /* 支付成功 */
        MBOrderPaySuccessController *paySuccessVC = [[MBOrderPaySuccessController alloc] init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }
    else
    {
        /* 支付失败 */
        [ProgressHUD showFailureText:@"支付失败!"];
    }
}

#pragma mark - tableView - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBOrderPayCell"];
    if (!cell) {
        cell = [[MBOrderPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MBOrderPayCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row<self.titleArray.count)
    {
        BOOL isShowNext = NO;
        if (self.balance>=self.orderModel.totalFee) isShowNext = YES;
        NSString *detail = self.detailArray[indexPath.row];
        if (isShowNext && self.payType == payTypeBalance && [detail isEqualToString:@"支付宝"])
        {
            detail = @"余额";
        }
        [cell handlerCellWithOrder:self.titleArray[indexPath.row] detail:detail isShowNext:((indexPath.row == 1) && isShowNext)];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.balance>=self.orderModel.totalFee && indexPath.row == 1)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"余额" otherButtonTitles:@"支付宝", nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            _payType = payTypeBalance;
            break;
        case 1:
            _payType = payTypeAliPay;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
        _tableView.tableHeaderView = headerView;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 28, screenWidth-40, 44)];
        confirmBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [confirmBtn setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.layer.cornerRadius = 3;
        confirmBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [confirmBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:confirmBtn];
    }
    return _footerView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"订单信息",@"支付方式",@"需付款"];
    }
    return _titleArray;
}

- (NSArray *)detailArray
{
    if (!_detailArray) {
        _detailArray = @[@"lalalal",@"支付宝",[NSString stringWithFormat:@"%.2f",_orderModel.totalFee]];
    }
    return _detailArray;
}

@end
