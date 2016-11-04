//
//  XLEditAttViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLEditAttViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ontim;//上班时间
@property (weak, nonatomic) IBOutlet UILabel *offtim;//下班时间
@property (weak, nonatomic) IBOutlet UIButton *onTime;//上班开关
@property (weak, nonatomic) IBOutlet UIButton *offTime;//下班开关
@property (weak, nonatomic) IBOutlet UILabel *weekday;//日期
@property (weak, nonatomic) IBOutlet UILabel *attMen;//考勤人员
@property (weak, nonatomic) IBOutlet UILabel *attplace;//考勤地点

- (IBAction)OnTim:(id)sender;
- (IBAction)OffTim:(id)sender;
- (IBAction)Day:(id)sender;
- (IBAction)AttMen:(id)sender;
- (IBAction)AttPlace:(id)sender;
- (IBAction)Delete:(id)sender;

@end
