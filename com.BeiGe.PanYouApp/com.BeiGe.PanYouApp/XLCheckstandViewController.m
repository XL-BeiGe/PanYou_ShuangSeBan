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
@interface XLCheckstandViewController ()
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
   
    _vipnum.delegate = self;
    _checkyp.delegate = self;
    _queding.layer.borderWidth = 1;
    _queding.layer.borderColor = [[UIColor colorWithHexString:@"32CC96"] CGColor];
  type=@"3";
    [self navagation];
    [self clear];
    [self shujuku];
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

-(void)clear{
    _ypname.text = @"";
    _sccomp.text = @"";
    _scday.text = @"";
    _price.text =[NSString stringWithFormat:@""];
    _number.text =[NSString stringWithFormat:@""];
    _subtract.hidden = YES;
    _sum.hidden = YES;
}
-(void)navagation{
    self.title = @"收银台";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 20)];
    [btn setImage:[UIImage imageNamed:@"downloads.png"] forState:UIControlStateNormal];
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
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"315",@"userid", nil];
    [WarningBox warningBoxModeIndeterminate:@"数据下载中..." andView:self.view];
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        
//        NSArray *list=[[responseObject objectForKey:@"data"] objectForKey:@"list"];
//        NSMutableDictionary * dd=[NSMutableDictionary dictionaryWithDictionary:list];
       // [XL  DataBase:db insertKeyValues:dd intoTable:ChaXunBiaoMing];
        
        [WarningBox warningBoxModeText:@"数据已下载!" andView:self.view];
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];

}

- (IBAction)Finding:(id)sender {
 
    NSArray *arr = [XL DataBase:db selectKeyTypes:ChaXunShiTiLei fromTable:ChaXunBiaoMing];
    if (arr.count==0){
    [WarningBox warningBoxModeText:@"请同步药品信息" andView:self.view];
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_checkyp.text,@"product_code",_checkyp.text,@"bar_code",_checkyp.text,@"pycode", nil];
        findarr =[XL DataBase:db selectKeyTypes:ChaXunShiTiLei fromTable:ChaXunBiaoMing whereConditionz:dic];
        NSLog(@"findarr---------%@",findarr);
        
        if (findarr.count==0){
            [WarningBox warningBoxModeText:@"未找到药品" andView:self.view];
        }else{
            [self xianshi];
        }
    }
 
}
-(void)xianshi{
    _ypname.text =[NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"productName"]] ;
    _sccomp.text = [NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"manufacturer"]];
    _scday.text = [NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"approvalNumber"]];
    
    _number.text =[NSString stringWithFormat:@"0"];
    _subtract.hidden = NO;
    _sum.hidden = NO;
    
    
    if([type isEqualToString:@"1"]){
    _price.text =[NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"vipPrice"]];//价格
    }else{
    _price.text =[NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"salePrice"]];//价格
    }
    
    
    
}


- (IBAction)Sure:(id)sender {
    int typ;
    NSString *Ss;
    if(sender){
        typ=1;
        //非会员价
        Ss = [NSString stringWithFormat:@"%@",[findarr[0]objectForKey:@"salePrice"]];
    }else if (sender) {
        typ=2;
        //会员价
        Ss = [NSString stringWithFormat:@"%@",[findarr[0]objectForKey:@"vipPrice"]];
    }else{
        typ=3;
        //促销价
        Ss = [NSString stringWithFormat:@"%@",[findarr[0]objectForKey:@"costPrice"]];
    }
   
//    NSString *ss= [NSString stringWithFormat:@"%@",[findarr[0]objectForKey:@"price"]];
//    float sss = [ss floatValue];
//    float sumpri= [_number.text floatValue]*sss;
   NSString *sss= [NSString stringWithFormat:@"%@",[findarr[0] objectForKey:@"id"]];
   NSString *ssr= [NSString stringWithFormat:@"%@",_number.text];
  
  // NSDictionary *dd = [NSDictionary dictionaryWithObjectsAndKeys:sss,@"id",typ,@"type",ssr,@"num",Ss,@"price", nil];
   // [XL DataBase:db insertKeyValues:dd intoTable:@"gouwu"];
    [self clear];
    
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
//    NSArray *cis = [XL DataBase:db selectKeyTypes:[NSDictionary dictionaryWithObjectsAndKeys:@"text",@"id",@"text",@"num",@"text",@"type",@"text",@"price", nil] fromTable:@"gouwu"];
//    
//    if (cis.count==0){
//     [WarningBox warningBoxModeText:@"请添加药品" andView:self.view];
//    }else{
    
    XLShopCarViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shopcar"];
    shop.scno=_vipnum.text;
    
    shop.sctype=type;
    [self.navigationController pushViewController:shop animated:YES];
   // }
}


-(void)shujuku{
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
    //新建查询表，里边是收银台药品数据信息
    [XL DataBase:db createTable:ChaXunBiaoMing keyTypes:ChaXunShiTiLei];
    
    [XL DataBase:db createTable:@"gouwu" keyTypes:[NSDictionary dictionaryWithObjectsAndKeys:@"text",@"id",@"text",@"num",@"text",@"type",@"text",@"price", nil]];
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}




#pragma mark----会员查询
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField==_vipnum){
        [self huiyuanchaxun];
    }
}
-(void)huiyuanchaxun{
    NSString *fangshi=@"/drug/vipQuery";
    type=[self isMobileNumber:_vipnum.text]?@"2":@"1";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_vipnum.text,@"no",type,@"type", nil];
    
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
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
