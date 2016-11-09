//
//  XLShopCarViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLShopCarViewController.h"
#import "XLSetAccountViewController.h"
@interface XLShopCarViewController ()

@end

@implementation XLShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    [self tableviewdelegate];
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

-(void)tableviewdelegate{
    _tabel.dataSource = self;
    _tabel.delegate = self;
    _tabel.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
    UILabel *number =(UILabel*)[cell viewWithTag:600];
    UIButton *subtrace = (UIButton*)[cell viewWithTag:500];
    UIButton *sum = (UIButton*)[cell viewWithTag:700];
     name.text = @"药品名称";
     price.text = @"药品价格";
     namete.text = @"测试名称";
     pricete.text = [NSString stringWithFormat:@"￥1235.0"];
     number.text = [NSString stringWithFormat:@"12"];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


-(void)sum:(UIButton*)btm{
    NSLog(@"加");
}
-(void)subtrace:(UIButton*)btm{
    NSLog(@"减");
}

- (IBAction)SetAccounts:(id)sender {
    XLSetAccountViewController *shop = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"setacc"];
    [self.navigationController pushViewController:shop animated:YES];
}
@end
