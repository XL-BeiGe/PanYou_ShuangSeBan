//
//  XLLeaveViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLLeaveViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *beginTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;


@property (weak, nonatomic) IBOutlet UILabel *leaveType;//请假类型
@property (weak, nonatomic) IBOutlet UITextView *reason;//原因
- (IBAction)BeginTim:(id)sender;
- (IBAction)EndTim:(id)sender;
- (IBAction)LeaveTyp:(id)sender;
- (IBAction)Present:(id)sender;

@end
