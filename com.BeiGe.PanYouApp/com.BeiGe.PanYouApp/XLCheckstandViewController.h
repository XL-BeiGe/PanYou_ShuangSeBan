//
//  XLCheckstandViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCheckstandViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *vipnum;//会员
@property (weak, nonatomic) IBOutlet UITextField *checkyp;//查药品
@property (weak, nonatomic) IBOutlet UIImageView *checkimg;//对错图片


@property (weak, nonatomic) IBOutlet UILabel *scday;//生产日期
@property (weak, nonatomic) IBOutlet UILabel *price;//价格
@property (weak, nonatomic) IBOutlet UIView *ypname;
@property (weak, nonatomic) IBOutlet UIView *sccomp;

@property (weak, nonatomic) IBOutlet UILabel *number;//数量
@property (weak, nonatomic) IBOutlet UIButton *subtract;
@property (weak, nonatomic) IBOutlet UIButton *sum;
@property (weak, nonatomic) IBOutlet UIView *vivivi;

@property (weak, nonatomic) IBOutlet UIButton *queding;//确定按钮

- (IBAction)Finding:(id)sender;
- (IBAction)Sum:(id)sender;
- (IBAction)Subtract:(id)sender;
- (IBAction)Sure:(id)sender;
- (IBAction)Shopping:(id)sender;

@end
