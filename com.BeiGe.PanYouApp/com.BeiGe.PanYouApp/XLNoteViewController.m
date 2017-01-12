//
//  XLNoteViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/4.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLNoteViewController.h"
#import "XLNoteInfoViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "XLMainViewController.h"
@interface XLNoteViewController ()
{
    
    NSMutableArray *pushList;
    NSString* zhT;
}
@end

@implementation XLNoteViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"通知";
    [self tableviewdelegate];
    [self refrish];
    [self comeback];
    _segment.layer.cornerRadius = 0;
    _segment.layer.masksToBounds = NO;
    zhT=@"2";
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([zhT isEqualToString:@"3"]){
        _segment.selectedSegmentIndex = 1;
        [self tongzhijiekou:@"3"];
    }else if ([zhT isEqualToString:@"4"]){
        _segment.selectedSegmentIndex = 2;
        [self tongzhijiekou:@"4"];
    }else{
        _segment.selectedSegmentIndex = 0;
        [self tongzhijiekou:@""];
    }
}

-(void)tongzhijiekou:(NSString*)zhuangtai{
    //push/pushList
    NSString *fangshi=@"/push/pushList";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",zhuangtai,@"progressStatus", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            pushList = [NSMutableArray array];
            if(![zhuangtai isEqualToString:@""]){
                pushList=[[responseObject objectForKey:@"data"] objectForKey:@"pushList"];
            }else{
                NSArray *ssa = [NSArray array];
                ssa =[[responseObject objectForKey:@"data"] objectForKey:@"pushList"];
                for (int i=0; i<ssa.count; i++) {
                    if([[ssa[i]objectForKey:@"progressStatus"]isEqualToString:@"1"]||[[ssa[i]objectForKey:@"progressStatus"]isEqualToString:@"2"]){
                        
                        [pushList addObject:ssa[i]];
                        NSLog(@"-------------------%@",pushList);
                    }
                }
            }
            if(pushList.count==0){
                _table.hidden=YES;
            }else{
                _table.hidden=NO;
            }
            
            [_table reloadData];
            [WarningBox warningBoxHide:YES andView:self.view];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
    
}
- (IBAction)ChangeV:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex==0){
        zhT=@"1";
        [self tongzhijiekou:@""];
        NSLog(@"未接受");
    }else if (sender.selectedSegmentIndex==1){
        zhT=@"3";
        [self tongzhijiekou:@"3"];
        NSLog(@"执行中");
    }else if(sender.selectedSegmentIndex==2){
        zhT=@"4";
        [self tongzhijiekou:@"4"];
        NSLog(@"已完成");
    }
}
#pragma mark--刷新方法
-(void)refrish{
    NSLog(@"setupRefresh -- 下拉刷新");
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];
    
}
- (void)refreshClick:(UIRefreshControl *)refreshControl {
    
    [refreshControl beginRefreshing];
    
    NSLog(@"refreshClick: -- 刷新触发");
    // 此处添加刷新tableView数据的代码
     [self tongzhijiekou:zhT];
    [refreshControl endRefreshing];
    
   
    //[self.table reloadData];// 刷新tableView即可
}
#pragma mark---tableview
-(void)tableviewdelegate{
    _table.dataSource = self;
    _table.delegate = self;
    _table.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return pushList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"tabcell";
    UITableViewCell *cell=[self.table dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    //    for (UIView *v in [cell.contentView subviews]) {
    //        [v removeFromSuperview];
    //    }
    UILabel *titl =(UILabel*)[cell viewWithTag:201];
    UILabel *mess =(UILabel*)[cell viewWithTag:202];
    UILabel *time =(UILabel*)[cell viewWithTag:203];
    UIImageView *icoimg = (UIImageView*)[cell viewWithTag:200];
    UIImageView *img = (UIImageView*)[cell viewWithTag:204];
    
    if(nil==[pushList[indexPath.row] objectForKey:@"title"]){
    titl.text =@"";
    }else{
     titl.text = [NSString stringWithFormat:@"%@",[pushList[indexPath.row] objectForKey:@"title"]];
    }
    if(nil==[pushList[indexPath.row] objectForKey:@"context"]){
         mess.text =@"";
    }else{
     mess.text = [NSString stringWithFormat:@"%@",[pushList[indexPath.row] objectForKey:@"context"] ];
    }
   
    if(nil==[pushList[indexPath.row] objectForKey:@"tcreateTime"]){
    time.text = @"";
    }else{
        NSString *ss =[NSString stringWithFormat:@"%@",[pushList[indexPath.row] objectForKey:@"tcreateTime"]];
        NSTimeInterval ti=[ss doubleValue]/ 1000;
        NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:ti];
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        time.text = [dateFormatter stringFromDate:detaildate];
    }
    
    
   
    
    icoimg.image = [UIImage imageNamed:@"通知列表小标.png"];
    
    
    if([[pushList[indexPath.row]objectForKey:@"progressStatus"]isEqualToString:@"1"]){
        img.image = [UIImage imageNamed:@"新消息提示-2.png"];
    }else{
        img.image = [UIImage imageNamed:@""];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLNoteInfoViewController *xl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"noteinfo"];
    xl.pushInfoId=[NSString stringWithFormat:@"%@",[pushList[indexPath.row] objectForKey:@"pushInfoId"]];
    xl.zhT= [NSString stringWithFormat:@"%@",[pushList[indexPath.row] objectForKey:@"progressStatus"]];
    
    [xl returnText:^(NSString *showText) {
        zhT=showText;
    }];
    
    [self.navigationController pushViewController:xl animated:YES];
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLMainViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xlmain"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
@end
