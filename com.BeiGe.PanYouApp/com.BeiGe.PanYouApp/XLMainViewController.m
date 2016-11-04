//
//  XLMainViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 16/11/2.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLMainViewController.h"
#import "XLAttendanceViewController.h"
#import "XLLogin_ViewController.h"
#import "XLCheckstandViewController.h"

@interface XLMainViewController ()

@end

@implementation XLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//通知
-(void)tongzhi{
    
}

//出勤
- (IBAction)Attend:(id)sender {
    
    XLAttendanceViewController *xl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"attendance"];
    [self.navigationController pushViewController:xl animated:YES];
}
//答题
- (IBAction)Answer:(id)sender {
    
}

- (IBAction)PanDian:(id)sender {
    XLLogin_ViewController *xll=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:xll animated:YES];
}
//设置
- (IBAction)Set:(id)sender {
    
}
//收银
- (IBAction)CashierDesk:(id)sender {
    XLCheckstandViewController *xxll=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"checkstand"];
    [self.navigationController pushViewController:xxll animated:YES];
}
@end
