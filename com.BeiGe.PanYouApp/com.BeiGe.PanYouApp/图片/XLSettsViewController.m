//
//  XLSettsViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/1/23.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XLSettsViewController.h"
#import "XLExplainViewController.h"
#import "XLRelationViewController.h"
#import "XLChangeViewController.h"
@interface XLSettsViewController ()

@end

@implementation XLSettsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigation];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--返回按钮
-(void)navigation{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
//返回到固定页
-(void)fanhui{
    
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)change:(id)sender {
    
    XLChangeViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"change"];
  
    [self.navigationController pushViewController:shop animated:YES];
}

- (IBAction)xlia:(id)sender {
    XLRelationViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"relation"];
    
    [self.navigationController pushViewController:shop animated:YES];
}

- (IBAction)exl:(id)sender {
    XLExplainViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"explain"];
    
    [self.navigationController pushViewController:shop animated:YES];
}
@end
