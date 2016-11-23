//
//  XLSetAccountViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSetAccountViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *accmoney;//消费总额
@property (weak, nonatomic) IBOutlet UITextField *fumoney;//付款金额
@property (weak, nonatomic) IBOutlet UILabel *zlmoney;//找零金额
- (IBAction)Sure:(id)sender;
@property (strong, nonatomic) NSString*drugAmount;
@property (strong, nonatomic) NSString*consumptionInfoId;
@end
