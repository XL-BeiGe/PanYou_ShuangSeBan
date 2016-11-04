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
@interface XLAttendanceViewController (){
    //签到标识
    int dao;
    //签退标识
    int tui;
}

@end
/*
    现缺少两个网络接口
 
 */
@implementation XLAttendanceViewController

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
-(void)qiandao_tui:(int)nage{
    
}

@end
