//
//  ViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 16/11/2.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *LoginShuXing;

- (IBAction)LLogin:(id)sender;



@end

