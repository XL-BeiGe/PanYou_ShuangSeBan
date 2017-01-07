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
#import "XLShopCarViewController.h"
@interface XLSetAccountViewController ()
{
  NSString  *chuannima;
}
@end

@implementation XLSetAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结账";
    _fumoney.delegate = self;
    
    _accmoney.text = [NSString stringWithFormat:@"￥%@",_drugAmount];
  
    chuannima=@"1";
    
    [self comeback];
    
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLShopCarViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shopcar"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (IBAction)FuTyp:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"付款类型：" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"现金",@"医保卡", nil];
    
    [sheet showInView:self.view];
}
-(NSArray*)jiaming{
    NSArray*arr=[NSArray arrayWithObjects:@"现金",@"医保卡", nil];
    return arr;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex<2){
        NSArray *jiaming = [self jiaming];
        _futype.text=[NSString stringWithFormat:@"%@",jiaming[buttonIndex]];
        chuannima=[NSString stringWithFormat:@"%ld",(long)buttonIndex+1];
    }
}


- (IBAction)Sure:(id)sender {
    //网络请求
    [self quedingwangluo];
   
}
-(void)quedingwangluo{
    NSString *fangshi=@"/drug/postDrug";
    
    NSLog(@"付款类型%@",chuannima);
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_consumptionInfoId,@"consumptionInfoId",_fumoney.text,@"drugAmountReceive",chuannima,@"drugAmountType",_zlmoney.text,@"drugAmountBack", nil];
    [WarningBox warningBoxModeIndeterminate:@"正在结账..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
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
   // NSLog(@"%@",string);
    float fu;
   
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    fu=[text floatValue];
//    if (string.length ==0 ) {
//        fu= [[textField.text substringFromIndex:textField.text.length-1]  floatValue];
//    }else
//    fu= [[textField.text stringByAppendingString:string]  floatValue];
    
    if (fu-zong<0){
        _zlmoney.text =@"还不够哟";
    }else{
        _zlmoney.text = [NSString stringWithFormat:@"￥%.2f",fu-zong];
    }

    
    return YES;
}

@end
