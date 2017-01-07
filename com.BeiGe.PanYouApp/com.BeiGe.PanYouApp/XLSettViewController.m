//
//  XLSettViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/25.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLSettViewController.h"
#import "XLMainViewController.h"
#import "XLChangepassViewController.h"
#import "XLShowViewController.h"
#import "XLEditAttViewController.h"
@interface XLSettViewController ()

@end

@implementation XLSettViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeback];
    self.title = @"设置";
    // Do any additional setup after loading the view.
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLMainViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xlmain"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BJKaoQin:(id)sender {
    XLEditAttViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editatt"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (IBAction)ChangePas:(id)sender {
    XLChangepassViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"changepass"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (IBAction)Explain:(id)sender {
    XLShowViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"show"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
@end
