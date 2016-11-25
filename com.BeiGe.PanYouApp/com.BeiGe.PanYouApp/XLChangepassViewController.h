//
//  XLChangepassViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/25.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLChangepassViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldpass;
@property (weak, nonatomic) IBOutlet UITextField *newpass;
@property (weak, nonatomic) IBOutlet UITextField *renpass;
- (IBAction)Sure:(id)sender;

@end
