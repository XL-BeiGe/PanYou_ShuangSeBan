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
#import "XLNoteViewController.h"
#import "XLquestionViewController.h"
#import "XLSettingViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "AppDelegate.h"
#import "XL_Header.h"
#import "Color+Hex.h"
#import "XLHomeViewController.h"
#import "XLLearingViewController.h"

@interface XLMainViewController ()

@end

@implementation XLMainViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = true;
    [self tongzhi];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tongzhi) name:@"111" object:nil];
    
    NSString *ok = [[NSUserDefaults standardUserDefaults] objectForKey:@"shifoutankuang"];
    if ([ok isEqualToString:@"1"]) {
        [self alart];
    }
    self.title  =@"盘优";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//通知
-(void)tongzhi{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    NSString*xiaohongdian=[[NSUserDefaults standardUserDefaults] objectForKey:@"xiaohongdian"];
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    if ([xiaohongdian isEqualToString:@"1"]) {
        [btn setImage:[UIImage imageNamed:@"通知2.png"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"通知1.png"] forState:UIControlStateNormal];
    }
    
    [btn addTarget:self action:@selector(Note:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btnn setImage:[UIImage imageNamed:@"设置.png"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(setttt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem =left;
    
}
-(void)alart{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有新的消息，请注意查看" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self Note:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}
-(void)setttt:(UIButton *)button{
    XLSettingViewController*xx;
    [self tiaoye:xx mingzi:@"set"];
}


-(void)Note:(UIButton *)button{
    
    XLNoteViewController*xx;
    [self tiaoye:xx mingzi:@"note"];
}

//出勤
- (IBAction)Attend:(id)sender {
    XLAttendanceViewController*xx;
    [self tiaoye:xx mingzi:@"attendance"];
   
}
//答题
- (IBAction)Answer:(id)sender {
    XLquestionViewController*xx;
    [self tiaoye:xx mingzi:@"question"];
}

- (IBAction)PanDian:(id)sender {
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"isDanji"] isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:QianWaiWangIP forKey:@"JuYuWai"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isPandian"];
        XLHomeViewController*xx;
        [self tiaoye:xx mingzi:@"home"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isPandian"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"rukou"];
        XLLogin_ViewController*xx;
        [self tiaoye:xx mingzi:@"login"];
    }
}
//设置
- (IBAction)Set:(id)sender {
   XLLearingViewController*xx;
    [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"btntag"];
    [self tiaoye:xx mingzi:@"learns"];
}
//收银
- (IBAction)CashierDesk:(id)sender {
    XLCheckstandViewController*xx;
    [self tiaoye:xx mingzi:@"checkstand"];
}

-(void)tiaoye:(UIViewController*)controller mingzi:(NSString*)ming{
    controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:ming];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
