//
//  XLSetAccountViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLSetAccountViewController.h"
#import "XLAccSuccessViewController.h"
@interface XLSetAccountViewController ()

@end

@implementation XLSetAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结账";
    _fumoney.delegate = self;
    
    _accmoney.text = [NSString stringWithFormat:@"￥15643.00"];
    //_fumoney.text;//用户输入textfield
    //_zlmoney.text =[NSString stringWithFormat:@"￥13687.50元"];
    
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

- (IBAction)Sure:(id)sender {
    //网络请求
    XLAccSuccessViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"accsuc"];
    [self.navigationController pushViewController:shop animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *zc = [_accmoney.text substringFromIndex:1];
    float zong = [zc floatValue];
    float fu = [_fumoney.text floatValue];
    if (fu-zong<0){
        NSLog(@"不对劲 重新输入");
    }else{
    _zlmoney.text = [NSString stringWithFormat:@"￥%.2f",fu-zong];
    }
    
    //NSLog(@"%@===%@==%@",zc,_fumoney.text,_zlmoney.text);
}
@end
