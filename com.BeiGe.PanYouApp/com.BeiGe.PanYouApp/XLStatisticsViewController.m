//
//  XLStatisticsViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLStatisticsViewController.h"
#import "XL_WangLuo.h"
#import "WarningBox.h"
#import "XLtongxiangqingViewController.h"
#import "XLAttendanceViewController.h"
#import "Color+Hex.h"
@interface XLStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString*nian,*yue;
    NSString*ynian,*yyue;
    NSMutableArray*qiandaotuilist,*qingjialist,*waiqinlist;
}
@end

@implementation XLStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    qingjialist=[[NSMutableArray alloc] init];
    qiandaotuilist=[[NSMutableArray alloc] init];
    waiqinlist=[[NSMutableArray alloc] init];
    [self delegate];
    [self comeback];
    self.title =@"统计";
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
     UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLAttendanceViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"attendance"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


-(void)delegate{
    _tableview.delegate=self;
    _tableview.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets = NO;;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.tableFooterView=[[UIView alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    NSDate *selected = [NSDate date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *datefffff=[[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy"];
    [datefffff setDateFormat:@"MM"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    nian =  [NSString stringWithFormat:
             @"%@", destDateString];
    ynian=[NSString stringWithFormat:
           @"%@", destDateString];
    NSString *daterr=[datefffff stringFromDate:selected];
    yue=[NSString stringWithFormat:@"%@",daterr];
    yyue=[NSString stringWithFormat:@"%@",daterr];
    _month.text=[NSString stringWithFormat:@"%@年%@月",nian,yue];
    [self jiekou:[NSString stringWithFormat:@"%@-%@",nian,yue]];
    
    //右侧按钮变色，且不可点；
}



-(void)jiekou:(NSString*)date{
    qingjialist=[[NSMutableArray alloc] init];
    waiqinlist =[[NSMutableArray alloc] init];
    NSString *fangshi=@"/attendance/Statistics";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",date,@"currentDate", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            NSDictionary*data=[responseObject objectForKey:@"data"];
            qiandaotuilist=[data objectForKey:@"attendanceInfoList"];
            NSArray*waijia=[data objectForKey:@"fieldInfoList"];
            for (NSDictionary*dd in waijia) {
                if ([[dd objectForKey:@"type"]isEqual:@"1"]) {
                    [qingjialist addObject:dd];
                }else{
                    [waiqinlist addObject:dd];
                }
            }
            
           
           
            [_tableview reloadData];
        }
        else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }else{
            [_tableview reloadData];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"tongji";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    UIImageView *beijing    =[cell viewWithTag:100];
    UILabel*biaoti    =[cell viewWithTag:101];
    UILabel*tianshu    =[cell viewWithTag:102];
    UIImage*image=[[UIImage alloc] init];
    NSString*biao=[[NSString alloc] init];
    NSString*tian=[[NSString alloc] init];
    if (indexPath.row==0) {
        image=[UIImage imageNamed:@"统计-工作天数.png"];
        biao=@"工作班次";
        if(qiandaotuilist.count==0){
        tian=@"0";
        }else{
        tian=[NSString stringWithFormat:@"%lu",(unsigned long)qiandaotuilist.count];
        }
        
        
    }else if (indexPath.row==1){
        image=[UIImage imageNamed:@"统计-外出天数.png"];
        biao=@"外出次数";
        if(waiqinlist.count==0){
         tian=@"0";
        }else{
         tian=[NSString stringWithFormat:@"%lu",(unsigned long)waiqinlist.count];
        }
       
        
    }else if (indexPath.row==2){
       tianshu.textColor =[UIColor colorWithHexString:@"fd8f30"];
        image=[UIImage imageNamed:@"统计-请假次数.png"];
        biao=@"请假天数";
        //tian=[NSString stringWithFormat:@"%lu",(unsigned long)qingjialist.count];
        if(qingjialist.count==0){
        tian=@"0";
        }else{
            float jia=0;
            float jj=0;
            for (int i=0;i<qingjialist.count; i++) {
               jj=[[qingjialist[i]objectForKey:@"fieldDay"]floatValue];
                jia=jj+jia;
            }
            tian=[NSString stringWithFormat:@"%.1f",jia];
        }
     
        
    }
    beijing.image=image;
    biaoti.text=biao;
    tianshu.text=tian;
    
   cell.selectionStyle =UITableViewCellSelectionStyleNone; 
    return cell;
}
- (IBAction)Left:(id)sender {
    yue=[NSString stringWithFormat:@"%d",[yue intValue]-1];
    if(yue.length<2){
        yue=[NSString stringWithFormat:@"0%@",yue];
    }
    if ([yue isEqualToString:@"00"]) {
        yue=@"12";
        nian=[NSString stringWithFormat:@"%d",[nian intValue]-1];
    }
    _month.text=[NSString stringWithFormat:@"%@年%@月",nian,yue];
    [self jiekou:[NSString stringWithFormat:@"%@-%@",nian,yue]];
}

- (IBAction)Right:(id)sender {
    if ([nian isEqualToString:ynian]&&[yue isEqualToString:yyue]) {
        
    }else{
        yue=[NSString stringWithFormat:@"%d",[yue intValue]+1];
        if(yue.length<2){
            yue=[NSString stringWithFormat:@"0%@",yue];
        }
        if ([yue isEqualToString:@"13"]) {
            yue=@"01";
            nian=[NSString stringWithFormat:@"%d",[nian intValue]+1];
        }
        _month.text=[NSString stringWithFormat:@"%@年%@月",nian,yue];
        [self jiekou:[NSString stringWithFormat:@"%@-%@",nian,yue]];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLtongxiangqingViewController*xltjxq=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tongxiangqing"];
    if (indexPath.row==0) {
        xltjxq.ll=@"0";
        xltjxq.arr=qiandaotuilist;
    }else if (indexPath.row==1){
        xltjxq.ll=@"1";
        xltjxq.arr=waiqinlist;
    }else if (indexPath.row==2){
        xltjxq.ll=@"2";
        xltjxq.arr=qingjialist;
    }
    [self.navigationController pushViewController:xltjxq animated:YES];
    
}
@end
