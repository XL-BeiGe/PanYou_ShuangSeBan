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
@interface XLShopCarViewController ()
{
    XL_FMDB  *XL;//数据库调用者
    FMDatabase *db;//数据库
    
    NSArray  *shoparr;
}
@end

@implementation XLShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    [self shujuku];
    [self tableviewdelegate];
    // Do any additional setup after loading the view.
}

-(void)wangluo{
//网络请求
    NSDictionary*d1=[NSDictionary dictionaryWithObjectsAndKeys:@"1003",@"drugId",@"1086",@"drugCount",@"2",@"drugPriceType", nil];
    NSArray*arr=[NSArray arrayWithObjects:d1, nil];
    
    
    NSString *fangshi=@"/drug/shoppingCart";
    
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"315",@"operateUserId",_scno,@"no",_sctype,@"type",_coupon.text,@"coupon",_couprice.text,@"couponPrice",arr,@"drugList", nil];
    NSLog(@"%@",rucan);
    [WarningBox warningBoxModeIndeterminate:@"正在计算总价..." andView:self.view];
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if([[responseObject objectForKey:@"code"]isEqualToString:@"0000"]){
            NSString *drugAmount=[[responseObject objectForKey:@"data"] objectForKey:@"drugAmount"];
            NSString *consumptionInfoId=[[responseObject objectForKey:@"data"] objectForKey:@"consumptionInfoId"];
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
    
    
    
   
}

-(void)tableviewdelegate{
    _tabel.dataSource = self;
    _tabel.delegate = self;
    _tabel.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"shopcell";
    UITableViewCell *cell=[self.tabel dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    //    for (UIView *v in [cell.contentView subviews]) {
    //        [v removeFromSuperview];
    //    }
    UILabel *name =(UILabel*)[cell viewWithTag:100];
    UILabel *price =(UILabel*)[cell viewWithTag:300];
    UILabel *namete =(UILabel*)[cell viewWithTag:200];
    UILabel *pricete =(UILabel*)[cell viewWithTag:400];
    UITextField* number =(UITextField*)[cell viewWithTag:600];
    UIButton *subtrace = (UIButton*)[cell viewWithTag:500];
    UIButton *sum = (UIButton*)[cell viewWithTag:700];
     name.text = @"药品名称:";
     price.text = @"药品价格:";
     namete.text = [NSString stringWithFormat:@"%ld",indexPath.row+600];
     pricete.text = [NSString stringWithFormat:@"￥1235.0"];
    number.delegate = self;
   
    sum.tag =700+indexPath.row;
    number.tag = 600+indexPath.row;
    subtrace.tag = 500+indexPath.row;
     number.text = [NSString stringWithFormat:@"12"];
    [number addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [number addTarget:self action:@selector(NumberLength:) forControlEvents:UIControlEventEditingChanged];
    [sum addTarget:self action:@selector(sum:) forControlEvents:UIControlEventTouchUpInside];
    [subtrace addTarget:self action:@selector(subtrace:) forControlEvents:UIControlEventTouchUpInside];

    //    [cell.contentView addSubview:titl];
    //    [cell.contentView addSubview:mess];
    //    [cell.contentView addSubview:time];
    //    [cell.contentView addSubview:icoimg];
    //    [cell.contentView addSubview:img];
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
   
    //将数组里的都更新到数据库中
    NSDictionary *updic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[indexPath.row] objectForKey:@"num"],@"num", nil];
    NSDictionary *udic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[indexPath.row] objectForKey:@"id"],@"id", nil];
    [XL DataBase:db updateTable:@"gouwu" setKeyValues:updic whereCondition:udic];
    
    //删除某一条数据
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"id",@"text",@"num",@"text",@"type",@"text",@"price", nil];
    NSDictionary *ddic = [NSDictionary dictionaryWithObjectsAndKeys:[shoparr[indexPath.row] objectForKey:@"id"],@"id", nil];
  shoparr  =[XL DataBase:db deleteKeyTypes:dic fromTable:@"gouwu" whereCondition:ddic];
    [_tabel reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"*-*-*-*-*%ld",(long)indexPath.row);
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
    
}
//修改数量
-(void)textFieldDidChange :(UITextField *)theTextField
{
    UITableViewCell *cell=(UITableViewCell*)[[theTextField superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    
    oo.text=[NSString stringWithFormat:@"%d",[oo.text intValue]];
    
    NSString*qw=oo.text;
    
    //[yikaishi[index.row] setObject:qw forKey:@"shuliang"];
    
}

-(void)sum:(UIButton*)btn{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[btn superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    NSLog(@"------%ld",(long)index.row);
    NSLog(@"******%lu",oo.tag);
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    
    qw =[NSString stringWithFormat:@"%d", wq+1];
    
    oo.text=qw;
    
    //  存入jieshou数组中
   // [yikaishi[index.row] setObject:qw forKey:@"shuliang"];
    NSLog(@"加");
}

-(void)subtrace:(UIButton*)btn{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[btn superview] superview ];
    
    NSIndexPath *index=[self.tabel indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+600];
    NSLog(@"------%ld",(long)index.row);
    NSLog(@"******%lu",oo.tag);
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    
    if ([oo.text intValue]==1||[oo.text intValue]==0) {
        qw=@"1";
    }else
        qw =[NSString stringWithFormat:@"%d", wq-1];
    
    oo.text=qw;
    //  存入jieshou数组中
    //[yikaishi[index.row] setObject:qw forKey:@"shuliang"];
    NSLog(@"减");
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
    [self animateTextField:-150.0 up:YES];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
[self animateTextField:-150.0 up:NO];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)SetAccounts:(id)sender {
    //网络请求
    [self wangluo];
   
}


-(void)shujuku{
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
   
}


@end
