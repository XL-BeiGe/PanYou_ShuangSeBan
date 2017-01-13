//
//  XLCheckstandViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLCheckstandViewController.h"
#import "XLShopCarViewController.h"
#import "XL_WangLuo.h"
#import "WarningBox.h"
#import "Color+Hex.h"
#import "XL_Header.h"
#import "XL_FMDB.h"
#import "XLMainViewController.h"
#import "ZYCustomKeyboardTypeNumberView.h"

#define gouwulei [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"drugId",@"text",@"drugCount",@"text",@"drugPriceType",@"text",@"price",@"text",@"name",@"text",@"qtmd", nil]

@interface XLCheckstandViewController ()<ZYCustomKeyboardTypeNumberViewDelegate>
{
    XL_FMDB  *XL;//数据库调用者
    FMDatabase *db;//数据库
    NSArray *findarr;
    NSString*type;
  
}
@end

@implementation XLCheckstandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [ZYCustomKeyboardTypeNumberView customKeyboardViewWithServiceTextField:_vipnum Delegate:self];
    _checkyp.delegate = self;
    _checkyp.keyboardType=UIKeyboardTypeAlphabet;
    _checkyp.keyboardType=UIKeyboardTypeNamePhonePad;
//    _checkyp.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _checkyp.autocorrectionType = UITextAutocorrectionTypeNo;
    _queding.layer.borderWidth = 1;
    _queding.layer.borderColor = [[UIColor colorWithHexString:@"32CC96"] CGColor];
    _queding.layer.cornerRadius=5.0;
    
    _sum.layer.borderWidth = 1;
    _sum.layer.borderColor = [[UIColor colorWithHexString:@"32CC96"] CGColor];
    _sum.layer.cornerRadius = 5.0;
    _subtract.layer.borderWidth = 1;
    _subtract.layer.borderColor = [[UIColor colorWithHexString:@"32CC96"] CGColor];
    _subtract.layer.cornerRadius = 5.0;
    [XL clearDatabase:db from:@"gouwu"];
    
    type=@"3";
    [self navagation];
    [self clear];
    [self shujuku];
    [self comeback];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"consumptionDetailNo"];
    // Do any additional setup after loading the view.
}
-(void)customKeyboardTypeNumberView_shrinkKeyClicked{
//    [self huiyuanchaxun];
    if (![_vipnum.text isEqualToString:@""]) {
        type=[self isMobileNumber:_vipnum.text]?@"2":@"1";
    }else{
        type=@"3";
    }
    
    [_checkyp becomeFirstResponder];
}
-(void)customKeyboardTypeNumberView_confirmKeyClicked{
//    [self huiyuanchaxun];
    if (![_vipnum.text isEqualToString:@""]) {
        type=[self isMobileNumber:_vipnum.text]?@"2":@"1";
    }else{
        type=@"3";
    }
    [_checkyp becomeFirstResponder];
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLMainViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xlmain"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [XL clearDatabase:db from:@"gouwu"];
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)clear{
    _checkyp.text= @"";
    _ypname.text = @"";
    _sccomp.text = @"";
    _scday.text = @"";
    _price.text =[NSString stringWithFormat:@""];
    _number.text =[NSString stringWithFormat:@""];
    _subtract.hidden = YES;
    _sum.hidden = YES;
}
-(void)navagation{
    // self.title = @"收银台";
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 20)];
    [btn setImage:[UIImage imageNamed:@"downloads@2x.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Download:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
}
//下载药品
-(void)Download:(UIButton *)button{
    [self xiazaijiekou];
}

-(void)xiazaijiekou{
    [XL clearDatabase:db from:ChaXunBiaoMing];
    NSString *fangshi=@"/drug/drugDataSync";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userid", nil];
    [WarningBox warningBoxModeIndeterminate:@"药品信息下载中..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"]isEqualToString:@"0000"]){
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        
        [XL clearDatabase:db from:ChaXunBiaoMing];
        [XL clearDatabase:db from:@"gouwu"];
        NSArray *list=[[responseObject objectForKey:@"data"] objectForKey:@"drugList"];
            NSLog(@"%lu",(unsigned long)list.count);
        if (list.count==0){
         [WarningBox warningBoxModeText:@"没有药品信息" andView:self.view];
        }else{
            for(int i=0;i<list.count;i++){
                
                NSMutableDictionary * dd=[NSMutableDictionary dictionaryWithDictionary:list[i]];
                [XL  DataBase:db insertKeyValues:dd intoTable:ChaXunBiaoMing];
            }
            
          [WarningBox warningBoxModeText:@"药品信息已下载 😊" andView:self.view];
        }
       
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];

}

- (IBAction)Finding:(id)sender {
    [self chazhao];
 
}
-(void)chazhao{
    [_checkyp resignFirstResponder];
    NSArray *arr = [XL DataBase:db selectKeyTypes:ChaXunShiTiLei fromTable:ChaXunBiaoMing];
    if (arr.count==0){
        [WarningBox warningBoxModeText:@"请先点击右上角，下载药品信息" andView:self.view];
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_checkyp.text,@"productCode",_checkyp.text,@"barCode",_checkyp.text,@"pycode", nil];
        findarr =[XL DataBase:db selectKeyTypes:ChaXunShiTiLei fromTable:ChaXunBiaoMing whereConditionz:dic];
    
        if (findarr.count==0){
            [WarningBox warningBoxModeText:@"未找到药品" andView:self.view];
            [self clear];
        }else{
            [self xianshi];
        }
    }
}

-(void)xianshi{
    _ypname.text =[NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"productName"]] ;
    _sccomp.text = [NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"manufacturer"]];
    _scday.text = [NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"approvalNumber"]];
    
    _number.text =[NSString stringWithFormat:@"1"];
    _subtract.hidden = NO;
    _sum.hidden = NO;
    
    
    if([type isEqualToString:@"1"]||[type isEqualToString:@"2"]){
       
    _price.text =[NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"vipPrice"]];//价格
    }else if([type isEqualToString:@"3"]){
      
    _price.text =[NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"salePrice"]];//价格
    }
    
    
}


- (IBAction)Sure:(id)sender {

    
    
  if([_number.text intValue]==0){
     [WarningBox warningBoxModeText:@"请添加药品数量" andView:self.view];
  }else{
      int typ;
    NSString *Ss;
     
    if([type isEqualToString:@"3"]){
        typ=1;//非会员
        Ss = [NSString stringWithFormat:@"%@",[findarr[0]objectForKey:@"salePrice"]];
    }else if ([type isEqualToString:@"1"]||[type isEqualToString:@"2"]) {
        typ=2; //会员
      
        Ss = [NSString stringWithFormat:@"%@",[findarr[0]objectForKey:@"vipPrice"]];
    }
   

   NSString *sss= [NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"id"]];
   NSString *ssq= [NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"productName"]];
    NSString *tt=  [NSString stringWithFormat:@"%d",typ];
   NSString *ssr= [NSString stringWithFormat:@"%@",_number.text];
      
    NSDate *senddate = [NSDate date];
  NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
 

      
   NSDictionary *dat = [NSDictionary dictionaryWithObjectsAndKeys:sss,@"drugId",tt,@"drugPriceType",ssr,@"drugCount",Ss,@"price",ssq,@"name",date2,@"qtmd", nil];

      
   [XL DataBase:db insertKeyValues:dat intoTable:@"gouwu"];
   
    [self clear];
      [_checkyp becomeFirstResponder];
    }
}

//加
- (IBAction)Sum:(id)sender {
    int num =[_number.text intValue];
    _number.text = [NSString stringWithFormat:@"%d",num+1];
   
}
//减
- (IBAction)Subtract:(id)sender {
    int num =[_number.text intValue];
    _number.text = [NSString stringWithFormat:@"%d",num-1];
    if (num==0){
    _number.text = [NSString stringWithFormat:@"0"];
    }
      }


//跳转购物车页面
- (IBAction)Shopping:(id)sender {
    [self.view endEditing:YES];
//    
    NSArray *cis = [XL DataBase:db selectKeyTypes:gouwulei fromTable:@"gouwu"];
    
    if (cis.count==0){
     [WarningBox warningBoxModeText:@"请添加药品" andView:self.view];
    }else{
    
    XLShopCarViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shopcar"];
    shop.scno=_vipnum.text;
    
    shop.sctype=type;
    [self.navigationController pushViewController:shop animated:YES];
    }
}


-(void)shujuku{
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
    //新建查询表，里边是收银台药品数据信息
    [XL DataBase:db createTable:ChaXunBiaoMing keyTypes:ChaXunShiTiLei];
    
    [XL DataBase:db createTable:@"gouwu" keyTypes:gouwulei];
    //[XL clearDatabase:db from:@"gouwu"];
    //[XL clearDatabase:db from:ChaXunBiaoMing];
    
   
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([_vipnum isFirstResponder]) {
//        [self huiyuanchaxun];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_vipnum isFirstResponder]) {
//        [self huiyuanchaxun];
        if ([_vipnum.text isEqualToString:@""]) {
            type=@"3";
        }else
        type=[self isMobileNumber:_vipnum.text]?@"2":@"1";
    }
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  
    if(textField==_vipnum){
        [_checkyp becomeFirstResponder];
    }
    
    if (textField==_checkyp){
        [self chazhao];
    }
    
    
    return YES;
}





#pragma mark----会员查询

-(void)huiyuanchaxun{
    NSString *fangshi=@"/drug/vipQuery";
    type=[self isMobileNumber:_vipnum.text]?@"2":@"1";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_vipnum.text,@"no",type,@"type",UserID,@"userId", nil];
    
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
          [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqualToString:@"0000"]) {
             NSDictionary*data=[responseObject objectForKey:@"data"];
            NSString*isvip=[data objectForKey:@"isvip"];
            if ([isvip intValue]==1) {
               
                _checkimg.image = [UIImage imageNamed:@"dui.png"];
            }else if ([isvip intValue]==2){
                _checkimg.image = [UIImage imageNamed:@"cuo.png"];
                type = @"3";
            }
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
    
}
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}
@end
