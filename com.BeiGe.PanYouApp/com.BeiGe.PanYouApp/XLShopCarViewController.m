//
//  XLShopCarViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLShopCarViewController.h"
#import "XLSetAccountViewController.h"
#import "XL_Header.h"
#import "XL_FMDB.h"
#import "XL_WangLuo.h"
#import "WarningBox.h"
#import "Color+Hex.h"
#import "ZYCustomKeyboardTypeNumberView.h"
#import "DSKyeboard.h"
#import "XLCheckstandViewController.h"
#define gouwulei [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"drugId",@"text",@"drugCount",@"text",@"drugPriceType",@"text",@"salePrice",@"text",@"vipPrice",@"text",@"name",@"text",@"qtmd", nil]

@interface XLShopCarViewController ()<ZYCustomKeyboardTypeNumberViewDelegate>
{
    XL_FMDB  *XL;//数据库调用者
    FMDatabase *db;//数据库
    BOOL updata;
    NSArray  *shoparr;
    UITextField* number ;
}
@end

@implementation XLShopCarViewController

-(void)viewWillAppear:(BOOL)animated{
    [self shujuku];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    updata=NO;
    [self tableviewdelegate];
    
    [ZYCustomKeyboardTypeNumberView customKeyboardViewWithServiceTextField:_couprice Delegate:self];
    _coupon.delegate=self;
    
    [self comeback];
}

//自定义键盘
- (void)setupCustomedKeyboard:(UITextField*)tf {
    tf.inputView = [DSKyeboard keyboardWithTextField:tf];
    
    
    [(DSKyeboard *)tf.inputView dsKeyboardTextChangedOutputBlock:^(NSString *fakePassword) {
        
        tf.text = fakePassword;
    } loginBlock:^(NSString *password) {
        [tf resignFirstResponder];
    }];
}

-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
     UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhuii)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhuii{
    //[self dismissViewControllerAnimated:YES completion:^{}];
    XLCheckstandViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"checkstand"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            if(updata==NO){
             [self updatefmdb];
            }else{
                updata=NO;
            }
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
-(void)wangluo{
    //网络请求
   
    NSString *fangshi=@"/drug/shoppingCart";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *consumptionDetailNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"consumptionDetailNo"];
    
    if(_coupon.text.length==0&&_couprice.text.length!=0){
    [WarningBox warningBoxModeText:@"请输入优惠券" andView:self.view];
    }else if (_coupon.text.length!=0&&_couprice.text.length==0){
    [WarningBox warningBoxModeText:@"请输入优惠券金额" andView:self.view];
    }else{
        
        [self updatefmdb];
        shoparr = [XL DataBase:db selectKeyTypes:gouwulei fromTable:@"gouwu"];
        for (int i=0;i<shoparr.count;i++) {
            [shoparr[i]removeObjectForKey:@"vipPrice"];
            [shoparr[i]removeObjectForKey:@"salePrice"];
            [shoparr[i]removeObjectForKey:@"name"];
            [shoparr[i]removeObjectForKey:@"qtmd"];
        }
        
        NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"operateUserId",_scno,@"no",_sctype,@"type",_coupon.text,@"coupon",_couprice.text,@"couponPrice",shoparr,@"drugList",consumptionDetailNo,@"consumptionDetailNo", nil];
        
        [WarningBox warningBoxModeIndeterminate:@"正在计算总价..." andView:self.view];
        [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            [WarningBox warningBoxHide:YES andView:self.view];
            if([[responseObject objectForKey:@"code"]isEqualToString:@"0000"]){
                NSString *drugAmount=[[responseObject objectForKey:@"data"] objectForKey:@"drugAmount"];
                NSString *consumptionInfoId=[[responseObject objectForKey:@"data"] objectForKey:@"consumptionInfoId"];
                [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"consumptionDetailNo"] forKey:@"consumptionDetailNo"];
                XLSetAccountViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"setacc"];
                shop.drugAmount=drugAmount;
                shop.consumptionInfoId=consumptionInfoId;
                [self.navigationController pushViewController:shop animated:YES];
            }else if ([[responseObject objectForKey:@"code"]isEqual:@"1009"]){
                [WarningBox warningBoxModeText:[responseObject objectForKey:@"msg"] andView:self.view];
            }
            else if ([[responseObject objectForKey:@"code"]isEqual:@"1008"]){
                [WarningBox warningBoxModeText:[responseObject objectForKey:@"msg"] andView:self.view];
            }
            else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
                //账号在其他手机登录，请重新登录。
                [XL_WangLuo sigejiu:self];
            }
            updata=YES;
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        }];
    }
    
}

-(void)tableviewdelegate{
    _tabel.dataSource = self;
    _tabel.delegate = self;
    _tabel.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return shoparr.count;
    //return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"cell1";
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    UILabel *name =[[UILabel alloc]initWithFrame:CGRectMake(15,12,80,25)];
    UILabel *price =[[UILabel alloc]initWithFrame:CGRectMake(15,45,80,25)];
    UILabel *namete =[[UILabel alloc]initWithFrame:CGRectMake(100,12,self.view.frame.size.width-120,25)];
    UILabel *pricete =[[UILabel alloc]initWithFrame:CGRectMake(100,45,100,25)];
    
    UIButton *sum =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50,45,25,25)];
    number =[[UITextField alloc]initWithFrame:CGRectMake(sum.frame.origin.x-40,45,40,25)];
    UIButton *subtrace = [[UIButton alloc]initWithFrame:CGRectMake(number.frame.origin.x-25,45,25,25)];
    name.text = @"药品名称:";
    price.text = @"药品价格:";
    pricete.textColor = [UIColor colorWithHexString:@"FF6534" alpha:1];
    // 药品名称
    namete.text = [NSString stringWithFormat:@"%@",[shoparr[indexPath.row]objectForKey:@"name"]];
    //药品价格
    if([_sctype isEqualToString:@"3"]){
     pricete.text = [NSString stringWithFormat:@"%@",[shoparr[indexPath.row]objectForKey:@"salePrice"]];
    }else{
     pricete.text = [NSString stringWithFormat:@"%@",[shoparr[indexPath.row]objectForKey:@"vipPrice"]];
    }
    number.delegate = self;
    number.textAlignment = NSTextAlignmentCenter;
    number.adjustsFontSizeToFitWidth = YES;
    // number.keyboardType = UIKeyboardTypeNumberPad;
    number.tag = 600+indexPath.row;
    [ZYCustomKeyboardTypeNumberView customKeyboardViewWithServiceTextField:number Delegate:self];
    
    //药品数量
    number.text = [NSString stringWithFormat:@"%@",[shoparr[indexPath.row]objectForKey:@"drugCount"]];
    
    [subtrace setTitle:@"-" forState:UIControlStateNormal];
    [sum setTitle:@"+" forState:UIControlStateNormal];
    [sum setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [subtrace setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [number addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [sum addTarget:self action:@selector(sum:) forControlEvents:UIControlEventTouchUpInside];
    [subtrace addTarget:self action:@selector(subtrace:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:price];
    [cell.contentView addSubview:namete];
    [cell.contentView addSubview:sum];
    [cell.contentView addSubview:number];
    [cell.contentView addSubview:subtrace];
    [cell.contentView addSubview:pricete];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updatefmdb];
    
    //删除某一条数据
    NSDictionary *ddic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[indexPath.row] objectForKey:@"qtmd"],@"qtmd", nil];
    [XL DataBase:db deleteKeyTypes:gouwulei fromTable:@"gouwu" whereCondition:ddic];
    shoparr = [XL DataBase:db selectKeyTypes:gouwulei fromTable:@"gouwu"];
    [_tabel reloadData];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//限制数量长度
-(BOOL)NumberLength:(UILabel *)theTextField
{
    int MaxLen = 4;
    NSString* szText = [theTextField text];
    if ([theTextField.text length]> MaxLen)
    {
        theTextField.text = [szText substringToIndex:MaxLen];
        return NO;
    }
    return YES;
}
//修改数量
-(BOOL)textFieldDidChange :(UITextField *)theTextField
{
    
    UITableViewCell *cell=(UITableViewCell*)[[theTextField superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    
    oo.text=[NSString stringWithFormat:@"%d",[oo.text intValue]];
    
    [self NumberLength:oo];
    NSString*qw=oo.text;
    
    NSUInteger mm=theTextField.tag-600;
    
    if ([self NumberLength:oo]) {
        [shoparr[mm] setObject:qw forKey:@"drugCount"];
        return YES;
    }else{
        return NO;
    }
    return YES;
}

-(void)sum:(UIButton*)btn{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[btn superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    
    qw =[NSString stringWithFormat:@"%d", wq+1];
    
    oo.text=qw;
    
    //  存入jieshou数组中
    [shoparr[index.row] setObject:qw forKey:@"drugCount"];
}

-(void)subtrace:(UIButton*)btn{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[btn superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    
    if ([oo.text intValue]==1||[oo.text intValue]==0) {
        qw=@"1";
    }else
        qw =[NSString stringWithFormat:@"%d", wq-1];
    
    oo.text=qw;
    
    //  存入jieshou数组中
    [shoparr[index.row] setObject:qw forKey:@"drugCount"];
    
}

//键盘退下
-(void)customKeyboardTypeNumberView_shrinkKeyClicked{
}
//键盘确定按钮
-(void)customKeyboardTypeNumberView_confirmKeyClicked{
}
-(void)customKeyboardTypeNumberView_changeTextFieldWithText:(UITextField *)string{
    if (string.tag>=600&&string.tag<700) {
        [self textFieldDidChange:string];
    }
}
//视图上移的方法
- (void) animateTextField: (CGFloat) textField up: (BOOL) up
{
    
    //设置视图上移的距离，单位像素
    const int movementDistance = textField; // tweak as needed
    //三目运算，判定是否需要上移视图或者不变
    int movement = (up ? movementDistance : -movementDistance);
    //设置动画的名字
    [UIView beginAnimations: @"Animation" context: nil];
    //设置动画的开始移动位置
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置动画的间隔时间
    [UIView setAnimationDuration: 0.20];
    //设置视图移动的位移
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    //设置动画结束
    [UIView commitAnimations];
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ( textField == _coupon) {
        [self setupCustomedKeyboard:textField];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)SetAccounts:(id)sender {
    //网络请求
    [self wangluo];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField==_coupon){
        [_couprice becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)navigation{
    
    UIBarButtonItem*right=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    [self.navigationItem setRightBarButtonItem:right];
}
-(void)fanhui{
    [_couprice resignFirstResponder];
}
#pragma mark--修改数据库
-(void)updatefmdb{
    
    //将数组里的都更新到数据库中
    NSDictionary *updic;
    NSDictionary *udic;
    for (int i=0; i<shoparr.count; i++) {
        updic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[i] objectForKey:@"drugCount"],@"drugCount", nil];
        udic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[i] objectForKey:@"qtmd"],@"qtmd", nil];
        [XL DataBase:db updateTable:@"gouwu" setKeyValues:updic whereCondition:udic];
    }
    
    
    
}
-(void)shujuku{
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
    shoparr =[XL DataBase:db selectKeyTypes:gouwulei fromTable:@"gouwu"];
}


@end
