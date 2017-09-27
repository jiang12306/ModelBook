//
//  PersonInfoAddressViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PersonInfoAddressViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "InfoAddressCell.h"
#import "InfoAddressModel.h"
#import "CustomHudView.h"

@interface PersonInfoAddressViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MBTextField *searchTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) CLGeocoder *geoC;
@property (strong, nonatomic) CLLocation *location;

@end

static NSString * const identifier = @"adressCell";

@implementation PersonInfoAddressViewController

+ (PersonInfoAddressViewController *)instantiatePersonInfoAddressViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"AddressVCSBID"];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupBackItem];
    
    self.title = NSLocalizedString(@"Address", nil);
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 15, 15)];
    left.image = [[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftView addSubview:left];
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    
    self.nextButton.layer.cornerRadius = 3.f;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setTitle:NSLocalizedString(@"Complete", nil) forState:UIControlStateNormal];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
}

#pragma mark - ButtonEvent

- (IBAction)nextButtonEvent:(UIButton *)sender {
    NSString *address = @"";
    for (InfoAddressModel *model in self.dataSource) {
        if (model.state == YES) {
            address = model.name;
        }
    }
    if (self.valueBlock) self.valueBlock(address);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)searchEvent:(UITextField *)sender {
    [self searchPOI];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    cell.changeBlock = ^(InfoAddressCell *currentCell){
        for (InfoAddressModel *info in self.dataSource) {
            if (currentCell.model != info && currentCell.model.state == YES) {
                info.state = !currentCell.model.state;
            }
        }
        [self.tableView reloadData];
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    self.location = [locations lastObject];
    
    [self searchPOI];
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}
- (void)searchPOI
{
    [self.geoC reverseGeocodeLocation:self.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            self.searchTextField.text=firstPlacemark.name;
            [self issueLocalSearchLookup:self.searchTextField.text usingPlacemarksArray:placemarks];
        }else
        {
            [CustomHudView showWithTip:@"地理反编码失败,稍后重试"];
        }
    }];
}

-(void)issueLocalSearchLookup:(NSString *)searchString usingPlacemarksArray:(NSArray *)placemarks {
    CLPlacemark *placemark = placemarks[0];
    CLLocation *location = placemark.location;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 100 * 1000, 100 * 1000);
    //初始化一个检索请求对象
    MKLocalSearchRequest * req = [[MKLocalSearchRequest alloc]init];
    //设置检索参数
    req.region=region;
    //兴趣点关键字
    req.naturalLanguageQuery=searchString;
    //初始化检索
    MKLocalSearch * ser = [[MKLocalSearch alloc]initWithRequest:req];
    //开始检索，结果返回在block中
    [ser startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        //兴趣点节点数组
        NSArray * array = [NSArray arrayWithArray:response.mapItems];
        [self.dataSource removeAllObjects];
        for (int i=0; i<array.count; i++) {
            MKMapItem * item=array[i];
            InfoAddressModel *model = [InfoAddressModel modelWithName:item.name State:NO];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
        
    }];
}

@end
