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
#import "XLSettViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "AppDelegate.h"
#import "XLHomeViewController.h"

@interface XLMainViewController ()

@end

@implementation XLMainViewController
-(void)viewWillAppear:(BOOL)animated{
   
   // [[NSUserDefaults standardUserDefaults] setObject:@"192.168.1.110:8090" forKey:@"JuYuWang"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  =@"盘优";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self tongzhi];
    
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//通知
-(void)tongzhi{
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 20)];
    [btn setImage:[UIImage imageNamed:@"downloads.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Download:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)Download:(UIButton *)button{
    
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
    /*
     UIAlertControllerStyleActionSheet: UIActionSheet样式
     UIAlertControllerStyleAlert: UIAlertView样式
     */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"请选择盘点方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    /*按钮样式选择:
     UIAlertActionStyleDefault 默认
     UIAlertActionStyleCancel 取消
     UIAlertActionStyleDestructive 确认毁灭性的操作
     */
    //添加取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"网络盘点" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //具体实现逻辑代码
        NSLog(@"网络盘点");
        XLHomeViewController*xx;
        [self tiaoye:xx mingzi:@"home"];
        
    }];
    [alert addAction:cancel];
    
    UIAlertAction *bendi = [UIAlertAction actionWithTitle:@"本地盘点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"本地盘点");
        XLLogin_ViewController*xx;
        [self tiaoye:xx mingzi:@"login"];
    }];
    [alert addAction:bendi];
    
    //添加确定按钮
    UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //具体实现逻辑代码
    }];
    [alert addAction:destructive];
    
    //显示提示框
    [self presentViewController:alert animated:YES completion:nil];

}
//设置
- (IBAction)Set:(id)sender {
    XLSettViewController*xx;
    [self tiaoye:xx mingzi:@"sett"];
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
