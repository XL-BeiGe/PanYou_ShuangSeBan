//
//  XLEditAttViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLEditAttViewController.h"
#import "XLSettViewController.h"
@interface XLEditAttViewController ()

@end

@implementation XLEditAttViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeback];
    self.title = @"编辑考勤";
    // Do any additional setup after loading the view.
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLSettViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sett"];
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

- (IBAction)OnTim:(id)sender {
}

- (IBAction)OffTim:(id)sender {
}

- (IBAction)Day:(id)sender {
}

- (IBAction)AttMen:(id)sender {
}

- (IBAction)AttPlace:(id)sender {
}

- (IBAction)Delete:(id)sender {
}
@end
