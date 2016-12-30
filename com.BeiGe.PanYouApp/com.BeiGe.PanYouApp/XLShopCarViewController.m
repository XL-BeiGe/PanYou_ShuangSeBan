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

#define gouwulei [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"id",@"text",@"num",@"text",@"type",@"text",@"price",@"text",@"name", nil]
@interface XLShopCarViewController ()<ZYCustomKeyboardTypeNumberViewDelegate>
{
    XL_FMDB  *XL;//数据库调用者
    FMDatabase *db;//数据库
    
    NSArray  *shoparr;
    UITextField* number ;
}
@end

@implementation XLShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    [self shujuku];
    [self tableviewdelegate];
   
    _coupon.delegate = self;
    _couprice.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)wangluo{
//网络请求
    
     [self updatefmdb];
    
    shoparr = [XL DataBase:db selectKeyTypes:gouwulei fromTable:@"gouwu"];
    
    for (int i=0;i<shoparr.count;i++) {
        [shoparr[i]removeObjectForKey:@"price"];
        [shoparr[i]removeObjectForKey:@"name"];
    }

    //NSDictionary*d1=[NSDictionary dictionaryWithObjectsAndKeys:@"1003",@"drugId",@"1086",@"drugCount",@"2",@"drugPriceType", nil];
    NSArray*arr=[NSArray arrayWithObjects:shoparr, nil];
   
    
    NSString *fangshi=@"/drug/shoppingCart";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"operateUserId",_scno,@"no",_sctype,@"type",_coupon.text,@"coupon",_couprice.text,@"couponPrice",arr,@"drugList", nil];
    NSLog(@"%@",rucan);
    [WarningBox warningBoxModeIndeterminate:@"正在计算总价..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if([[responseObject objectForKey:@"code"]isEqualToString:@"0000"]){
            NSString *drugAmount=[[responseObject objectForKey:@"data"] objectForKey:@"drugAmount"];
            NSString *consumptionInfoId=[[responseObject objectForKey:@"data"] objectForKey:@"consumptionInfoId"];
            
            [XL clearDatabase:db from:@"gouwu"];
            
        XLSetAccountViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"setacc"];
            shop.drugAmount=drugAmount;
            shop.consumptionInfoId=consumptionInfoId;
        [self.navigationController pushViewController:shop animated:YES];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
    
//    XLSetAccountViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"setacc"];
//    
//    [self.navigationController pushViewController:shop animated:YES];
    
   
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
    //    for (UIView *v in [cell.contentView subviews]) {
    //        [v removeFromSuperview];
    //    }
    
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
     pricete.text = [NSString stringWithFormat:@"%@",[shoparr[indexPath.row]objectForKey:@"price"]];
    
     number.delegate = self;
   
     [ZYCustomKeyboardTypeNumberView customKeyboardViewWithServiceTextField:number Delegate:self];
     number.textAlignment = NSTextAlignmentCenter;
     number.adjustsFontSizeToFitWidth = YES;
    // number.keyboardType = UIKeyboardTypeNumberPad;
     number.tag = 600+indexPath.row;
    
 
    //药品数量
     number.text = [NSString stringWithFormat:@"%@",[shoparr[indexPath.row]objectForKey:@"num"]];
    
    [subtrace setTitle:@"-" forState:UIControlStateNormal];
    [sum setTitle:@"+" forState:UIControlStateNormal];
    [sum setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [subtrace setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    
    
    [number addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [number addTarget:self action:@selector(NumberLength:) forControlEvents:UIControlEventEditingChanged];
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
 //删除方法
   
    [self updatefmdb];
    //删除某一条数据
    NSDictionary *ddic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[indexPath.row] objectForKey:@"id"],@"id", nil];
    shoparr  =[XL DataBase:db deleteKeyTypes:gouwulei fromTable:@"gouwu" whereCondition:ddic];
    shoparr = [XL DataBase:db selectKeyTypes:gouwulei fromTable:@"gouwu"];
    [_tabel reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"*-*-*-*-*%ld",(long)indexPath.row);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



//限制数量长度
-(void)NumberLength:(UITextField *)theTextField
{
    UITableViewCell *cell=(UITableViewCell*)[[theTextField superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    
   
    int MaxLen = 4;
    NSString* szText = [oo text];
    if ([oo.text length]> MaxLen)
    {
    oo.text = [szText substringToIndex:MaxLen];
    }
       NSLog(@"限制长度");
    
}
//修改数量
-(void)textFieldDidChange :(UITextField *)theTextField
{
    UITableViewCell *cell=(UITableViewCell*)[[theTextField superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    
    oo.text=[NSString stringWithFormat:@"%d",[oo.text intValue]];
    
    NSString*qw=oo.text;
    NSLog(@"修改数量");
    [shoparr[index.row] setObject:qw forKey:@"num"];
    
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
   [shoparr[index.row] setObject:qw forKey:@"num"];

  
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
    [shoparr[index.row] setObject:qw forKey:@"num"];
  
}

//键盘退下
-(void)customKeyboardTypeNumberView_shrinkKeyClicked{
}
//键盘确定按钮
-(void)customKeyboardTypeNumberView_confirmKeyClicked{
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
    if (textField==number){
        [self textFieldDidChange:textField];
        [self NumberLength:textField];
        [self animateTextField:-160 up:YES];
    }else{
    
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==number){
        [self textFieldDidChange:textField];
        [self NumberLength:textField];
        [self animateTextField:-160 up:NO];
    }else{
    
    }
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)SetAccounts:(id)sender {
    //网络请求
    [self wangluo];
   
}
#pragma mark--修改数据库
-(void)updatefmdb{

    //将数组里的都更新到数据库中
    NSDictionary *updic;
    NSDictionary *udic;
    for (int i=0; i<shoparr.count; i++) {
        updic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[i] objectForKey:@"num"],@"num", nil];
        udic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[i] objectForKey:@"id"],@"id", nil];
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
