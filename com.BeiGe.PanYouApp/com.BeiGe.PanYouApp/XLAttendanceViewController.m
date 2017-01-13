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
#import "XL_WangLuo.h"
#import "WarningBox.h"
#import "XLMainViewController.h"
@interface XLAttendanceViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate>
{
    //签到显示标识
    int dao;
    //签退显示标识
    int tui;
    //点击签到／签退判断
    int nage;
    //经纬度
    NSString*jing,*wei;
    //地址
    NSString *LonlatPlace;
}
@property(strong,nonatomic) UIImage *image1;
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation XLAttendanceViewController
-(void)viewWillAppear:(BOOL)animated{
    [self dingwei];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dao=2;
    tui=2;
    nage=99;
    [self riqixianshi];
    [self wangluolianjie];
    [self anniupanduan];
    [self comeback];
    self.title = @"考勤";
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLMainViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xlmain"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
-(void)anniupanduan{
    //需要在接口返回时判断
    if (dao!=1) {
        //灰色图标＋不可点击；ff9900
        _qiandao.backgroundColor=[UIColor lightGrayColor];
        _qiandao.userInteractionEnabled=NO;
    }else{
        //橙色图标＋可点击 black
        _qiandao.backgroundColor=[UIColor colorWithHexString:@"ff9900"];
        _qiandao.userInteractionEnabled=YES;
    }
    if (tui!=1) {
        //灰色图标＋不可点击；
        _qiantui.backgroundColor=[UIColor lightGrayColor];
        _qiantui.userInteractionEnabled=NO;
    }else{
        //橙色图标＋可点击
        _qiantui.backgroundColor=[UIColor colorWithHexString:@"ff9900"];
        _qiantui.userInteractionEnabled=YES;
    }

}

-(void)wangluolianjie{
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@""] andView:self.view];
    NSString *fangshi=@"/attendance/index";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId", nil];
    //自己写的网络请求    请求外网地址
    
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            NSDictionary* data=[responseObject objectForKey:@"data"];
            dao=[[data objectForKey:@"isSign"] intValue];
            tui=[[data objectForKey:@"isSignOut"] intValue];
            NSLog(@"%d----%d",dao,tui);
            [self anniupanduan];
        }
        else if([[responseObject objectForKey:@"code"]isEqual:@"1007"]){
//            [WarningBox warningBoxModeText:@"请重新进入该页面！" andView:self.view];
        }else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
        }

        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
    }];

}
- (IBAction)QianDao:(id)sender {
    [self xiangji];
    nage=1;
}

- (IBAction)QianTui:(id)sender {
    [self xiangji];
    nage=2;
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
-(void)qiandao_tui:(int)haha{
//    方法名：attendance/sign
//入参为：(用户ID):@"userId" (jing,wei):@"Lonlat"(_image):@"backgroundImage"(haha):@"type"
    
    NSString *fangshi=@"/attendance/sign";
    NSString *jingwei=[NSString stringWithFormat:@"%@,%@",jing,wei];
    NSString *type=[NSString stringWithFormat:@"%d",haha];
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    
    
    NSUserDefaults * shuju=[NSUserDefaults standardUserDefaults];//非登录接口用
    NSString *userID=[shuju objectForKey:@"userId"];//登陆不用传
    NSString *accessToken=[shuju objectForKey:@"accessToken"];//登陆不用传
    
    
    
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:accessToken,@"accessToken",userID,@"userid",UserID,@"userId",jingwei,@"Lonlat",type,@"type",LonlatPlace,@"LonlatPlace", nil];
    NSLog(@"%@",rucan);
    //自己写的网络请求    请求外网地址
    NSString *str;
    if (haha==1) {
        str=@"到";
    }else{
        str=@"退";
    }
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@"正在签%@...",str] andView:self.view];
    [XL_WangLuo ShangChuanTuPianwithBizMethod:fangshi Rucan:rucan type:Post image:_image1 key:@"backgroundImage" success:^(id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if([[responseObject objectForKey:@"code"] isEqualToString:@"0000"]){
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"签%@成功!",str] andView:self.view];
        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1006"]){
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"已经签%@，不用重复提交",str] andView:self.view];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误，请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
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
            
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            LonlatPlace=[placemark.addressDictionary objectForKey:@"FormattedAddressLines"][0];
            
//
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
//直接打开相机
-(void)xiangji{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    [picker dismissViewControllerAnimated:NO completion:^{}];
    
    _image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存图片至本地，方法见下文
    
    //按时间为图片命名
    NSDateFormatter *forr=[[NSDateFormatter alloc] init];
    
    [forr setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *name=[NSString stringWithFormat:@"qian.png"];
    
    [self saveImage:_image1 withName:name];
    
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
    _image1=[UIImage imageWithData:imageData];
    [self qiandao_tui:nage];
}
@end
