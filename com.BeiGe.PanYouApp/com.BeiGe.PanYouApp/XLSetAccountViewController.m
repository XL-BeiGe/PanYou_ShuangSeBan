//
//  XLSetAccountViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLSetAccountViewController.h"
#import "XLAccSuccessViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
@interface XLSetAccountViewController ()

@end

@implementation XLSetAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结账";
    _fumoney.delegate = self;
    
    _accmoney.text = [NSString stringWithFormat:@"￥%@",_drugAmount];
  
}

- (IBAction)Sure:(id)sender {
    //网络请求
    [self quedingwangluo];
   
}
-(void)quedingwangluo{
    NSString *fangshi=@"/drug/postDrug";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_consumptionInfoId,@"consumptionInfoId",_fumoney.text,@"drugAmountReceive",@"1",@"drugAmountType",_zlmoney.text,@"drugAmountBack", nil];
    [WarningBox warningBoxModeIndeterminate:@"正在结账..." andView:self.view];
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        [WarningBox warningBoxHide:YES andView:self.view];
        
        if ( [[responseObject objectForKey:@"code"]isEqualToString:@"0000"]) {
            
            NSDate*date=[NSDate date];
            NSDateFormatter*dateFormatter=[[NSDateFormatter alloc] init];
            // 为日期格式器设置格式字符串
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            // 使用日期格式器格式化日期、时间
            NSString *destDateString = [dateFormatter stringFromDate:date];
            NSString *message =  [NSString stringWithFormat:
                                  @"%@", destDateString];
           
            
            XLAccSuccessViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"accsuc"];
            shop.zonge=_drugAmount;
            shop.shijian=message;
            [self.navigationController pushViewController:shop animated:YES];
        }
        
        
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *zc = [_accmoney.text substringFromIndex:1];
    float zong = [zc floatValue];
    NSLog(@"%@",string);
    float fu;
   
    if (string.length ==0 ) {
        fu= [[textField.text substringFromIndex:textField.text.length-1]  floatValue];
    }else
    fu= [[textField.text stringByAppendingString:string]  floatValue];
    
    if (fu-zong<0){
        _zlmoney.text =@"还不够哟";
    }else{
        _zlmoney.text = [NSString stringWithFormat:@"￥%.2f",fu-zong];
    }

    
    return YES;
}

@end
