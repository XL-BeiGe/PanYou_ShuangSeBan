//
//  XLAttendanceViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 16/11/2.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLAttendanceViewController.h"
#import "XLOutsideViewController.h"
#import "XLLeaveViewController.h"
#import "XLStatisticsViewController.h"
#import "Color+Hex.h"
#import <CoreLocation/CoreLocation.h>
@interface XLAttendanceViewController ()<CLLocationManagerDelegate>
{
    //签到标识
    int dao;
    //签退标识
    int tui;
    //经纬度
    NSString*jing;NSString*wei;
}
@property (nonatomic, strong) CLLocationManager* locationManager;
@end
/*
    现缺少两个网络接口
 
 */
@implementation XLAttendanceViewController
-(void)viewWillAppear:(BOOL)animated{
    [self dingwei];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dao=0;
    tui=0;
    [self riqixianshi];
    [self wangluolianjie];
    [self anniupanduan];
}
-(void)anniupanduan{
    //需要在接口返回时判断
    if (dao==0) {
        //灰色图标＋不可点击；ff9900
        _qiandao.backgroundColor=[UIColor lightGrayColor];
        _qiandao.userInteractionEnabled=NO;
    }else{
        //橙色图标＋可点击 black
        _qiandao.backgroundColor=[UIColor colorWithHexString:@"ff9900"];
        _qiantui.userInteractionEnabled=YES;
    }
    if (tui==0) {
        //灰色图标＋不可点击；
        _qiantui.backgroundColor=[UIColor lightGrayColor];
        _qiantui.userInteractionEnabled=NO;
    }else{
        //橙色图标＋可点击
        _qiantui.backgroundColor=[UIColor colorWithHexString:@"ff9900"];
        _qiantui.userInteractionEnabled=YES;
    }

}
-(void)riqixianshi{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger weeks = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger days = [comps day];
    _day.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,month,days];
    _week.text=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:(weeks-1)]];
}
-(void)wangluolianjie{
    
}
- (IBAction)QianDao:(id)sender {
    [self qiandao_tui:1];
}

- (IBAction)QianTui:(id)sender {
    [self qiandao_tui:2];
}

- (IBAction)WaiQin:(id)sender {
    XLOutsideViewController*ss;
    [self tiaoye:ss mingzi:@"outside"];
}

- (IBAction)QingJia:(id)sender {
    XLLeaveViewController*ss;
    [self tiaoye:ss mingzi:@"leave"];
}

- (IBAction)TongJi:(id)sender {
    //tiaoye
    XLStatisticsViewController*ss;
    [self tiaoye:ss mingzi:@"statistics"];
}
-(void)tiaoye:(UIViewController*)controller mingzi:(NSString*)ming{
    controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:ming];
    [self.navigationController pushViewController:controller animated:YES];
}
//签到签退接口；
-(void)qiandao_tui:(int)nage{
    
}
-(void)dingwei{
    [self initializeLocationService];
}
- (void)initializeLocationService {
    
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    [_locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //将经度显示到label上
    jing = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    wei = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    NSLog(@"%@,%@",jing ,wei);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
//            CLPlacemark *placemark = [array objectAtIndex:0];
            
//            sheng=[NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"State"]];
//            
//            
//            //获取城市
//            NSString *city = placemark.locality;
//            
//            if (city) {
//                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                city = placemark.administrativeArea;
//                
//                //市
//                
//                shi=[NSString stringWithFormat:@"%@",placemark.locality];
//                //区
//                qu=[NSString stringWithFormat:@"%@",placemark.subLocality];
//            }
            
        }
        else if (error == nil && [array count] == 0)
        {
        }
        else if (error != nil)
        {
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

@end
