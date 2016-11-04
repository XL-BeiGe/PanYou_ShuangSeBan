//
//  XLAccSuccessViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAccSuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *fkmoney;//付款金额
@property (weak, nonatomic) IBOutlet UILabel *someone;//收银姓名
@property (weak, nonatomic) IBOutlet UILabel *sytime;//收银时间
- (IBAction)ComeBack:(id)sender;

@end
