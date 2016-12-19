//
//  XLAccSuccessViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLAccSuccessViewController.h"
#import "XLMainViewController.h"
@interface XLAccSuccessViewController ()

@end

@implementation XLAccSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结账结果";
    _fkmoney.text = [NSString stringWithFormat:@"￥%@",_zonge];
    _someone.text = [NSString stringWithFormat:@"测试人员"];
    _sytime.text = [NSString stringWithFormat:@"%@",_shijian];
    
    // Do any additional setup after loading the view.
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

- (IBAction)ComeBack:(id)sender {
}
@end
