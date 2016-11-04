//
//  XLAttendanceViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 16/11/2.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLAttendanceViewController.h"

@interface XLAttendanceViewController (){
    //签到标识
    int dao;
    //签退标识
    int tui;
}

@end

@implementation XLAttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dao=0;
    tui=0;
    [self riqixianshi];
    [self wangluolianjie];
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
    _week.text=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:weeks]];
}
-(void)wangluolianjie{
    
}
- (IBAction)QianDao:(id)sender {
    if (dao==0) {
        //灰色图标＋不可点击；
        
    }else{
        //橙色图标＋可点击
    }
}

- (IBAction)QianTui:(id)sender {
    if (tui==0) {
        //灰色图标＋不可点击；
    }else{
        //橙色图标＋可点击
    }
}

- (IBAction)WaiQin:(id)sender {
}

- (IBAction)QingJia:(id)sender {
}

- (IBAction)TongJi:(id)sender {
}
@end
