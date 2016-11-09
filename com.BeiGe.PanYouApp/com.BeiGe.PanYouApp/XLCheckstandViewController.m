//
//  XLCheckstandViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLCheckstandViewController.h"
#import "XLShopCarViewController.h"
#import "Color+Hex.h"
#import "XL_Header.h"
#import "XL_FMDB.h"
@interface XLCheckstandViewController ()
{
    XL_FMDB  *XL;//数据库调用者
    FMDatabase *db;//数据库
}
@end

@implementation XLCheckstandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    _queding.layer.borderWidth = 1;
    _queding.layer.borderColor = [[UIColor colorWithHexString:@"32CC96"] CGColor];
  
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
-(void)xianshi{
  _ypname.text =[NSString stringWithFormat:@"测试药品测试测试"] ;
  _sccomp.text = [NSString stringWithFormat:@"这里是测试生产厂家"];
  _scday.text = [NSString stringWithFormat:@"2016年10月20日"];
  _price.text =[NSString stringWithFormat:@"￥25.53元/个"];
  _number.text =[NSString stringWithFormat:@"0"];
    _subtract.hidden = NO;
    _sum.hidden = NO;
    
}
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [btn setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Download:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)Download:(UIButton *)button{
    NSLog(@"下载药品信息");
}

- (IBAction)Finding:(id)sender {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_checkyp.text,@"product_code",_checkyp.text,@"bar_code",_checkyp.text,@"pycode", nil];
    NSArray *arr =[XL DataBase:db selectKeyTypes:ChaXunShiTiLei fromTable:ChaXunBiaoMing whereConditionz:dic];
    NSLog(@"%@",arr);
    [self xianshi];
}
- (IBAction)Sure:(id)sender {
    [self clear];
    
}
- (IBAction)Sum:(id)sender {
    int num =[_number.text intValue];
    _number.text = [NSString stringWithFormat:@"%d",num+1];
}

- (IBAction)Subtract:(id)sender {
    int num =[_number.text intValue];
    _number.text = [NSString stringWithFormat:@"%d",num-1];
    if (num==0){
    _number.text = [NSString stringWithFormat:@"0"];
    }
}



- (IBAction)Shopping:(id)sender {
    XLShopCarViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shopcar"];
    [self.navigationController pushViewController:shop animated:YES];
    
}
-(void)shujuku{
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
    //新建查询表，里边是收银台药品数据信息
    [XL DataBase:db createTable:ChaXunBiaoMing keyTypes:ChaXunShiTiLei];
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
