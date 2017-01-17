//
//  XLDateCompare.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/1/17.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XLDateCompare.h"

@implementation XLDateCompare
#pragma mark--时间比较
+ (int)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    int aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;

    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

@end
