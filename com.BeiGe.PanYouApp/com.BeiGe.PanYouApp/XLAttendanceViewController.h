//
//  XLAttendanceViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 16/11/2.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAttendanceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *week;//星期
@property (weak, nonatomic) IBOutlet UILabel *day;//年月日
@property (weak, nonatomic) IBOutlet UIButton *qiandao;
@property (weak, nonatomic) IBOutlet UIButton *qiantui;
@property (weak, nonatomic) IBOutlet UILabel *shangban;
@property (weak, nonatomic) IBOutlet UILabel *xiaban;


- (IBAction)QianDao:(id)sender;
- (IBAction)QianTui:(id)sender;
- (IBAction)WaiQin:(id)sender;
- (IBAction)QingJia:(id)sender;
- (IBAction)TongJi:(id)sender;


@end
