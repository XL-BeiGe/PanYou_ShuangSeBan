//
//  XLtongxiangqingViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 2016/11/28.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLtongxiangqingViewController.h"
#import "Color+Hex.h"
#import "XLStatisticsViewController.h"
@interface XLtongxiangqingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

/*
 没测呢，后台不给我开服务器！！！
 
 
 */
@implementation XLtongxiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self delegate];
    [self comeback];
    self.title =@"统计详情";
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
     UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLStatisticsViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"statistics"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}



-(void)delegate{
    _tableview.delegate=self;
    _tableview.dataSource=self;
    self.tableview.tableFooterView=[[UIView alloc] init];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_ll isEqualToString:@"0"]) {
        return 3;
    }else if ([_ll isEqualToString:@"1"]){
        return 2;
    }else
        return 4;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"heheda";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    UIView*shuxian=[[UIView alloc] initWithFrame:CGRectMake(20, 0, 1, cell.frame.size.height)];
    if (indexPath.row==0) {
        UIImageView*imageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, (cell.frame.size.height-20)/2-5, 20, 20)];
        UIImage*image=[[UIImage alloc] init];
        UILabel*qjlabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(imageview.frame)+20, 6,90, 20)];
        
        UILabel*lable=[[UILabel alloc] initWithFrame:CGRectMake(self.tableview.frame.size.width-169, 3, 180, 20)];
        qjlabel.font= [UIFont systemFontOfSize:15];
        lable.font= [UIFont systemFontOfSize:15];
        if ([_ll isEqualToString:@"0"]) {
            image=[UIImage imageNamed:@"统计-工作天数.png"];
            shuxian.backgroundColor=[UIColor colorWithHexString:@"3c94ff"];
        }else if ([_ll isEqualToString:@"1"]){
            lable.frame =CGRectMake(CGRectGetWidth(imageview.frame)+10, 6, 350, 20);
            lable.text=[_arr[indexPath.section] objectForKey:@"createTime"];
            image=[UIImage imageNamed:@"统计-外出天数.png"];
            shuxian.backgroundColor=[UIColor colorWithHexString:@"3d94ff"];
        }else{
            qjlabel.text =@"请假时间:";
            lable.text=[_arr[indexPath.section] objectForKey:@"createTime"];
            image=[UIImage imageNamed:@"统计-请假次数.png"];
            shuxian.backgroundColor=[UIColor colorWithHexString:@"fd8f30"];
        }
        imageview.image=image;
        [cell addSubview:qjlabel];
        [cell addSubview:shuxian];
        [cell addSubview:lable];
        [cell addSubview:imageview];
    }
    else{
        UILabel*llable=[[UILabel alloc] initWithFrame:CGRectMake(40,3, 150, 20)];
        UILabel*shijian=[[UILabel alloc] initWithFrame:CGRectMake(self.tableview.frame.size.width-200, 3, 180, 20)];
        llable.font =[UIFont systemFontOfSize:15];
        shijian.font =[UIFont systemFontOfSize:15];
        shijian.textAlignment=NSTextAlignmentRight;
        if ([_ll isEqualToString:@"0"]) {
            shuxian.backgroundColor=[UIColor colorWithHexString:@"3c94ff"];
            llable.textColor=[UIColor colorWithHexString:@"3c94ff"];
            if (indexPath.row==1) {
                llable.text=@"已签到";
                if(nil==[_arr[indexPath.section] objectForKey:@"beginTime"]){
                shijian.text=@"未签到";
                }else{
                shijian.text=[_arr[indexPath.section] objectForKey:@"beginTime"];
                }
            }else{
                llable.text=@"已签退";
                if(nil==[_arr[indexPath.section] objectForKey:@"endTime"]){
                shijian.text=@"未签退";
                }else{
                shijian.text=[_arr[indexPath.section] objectForKey:@"endTime"];
                }
            }
        }
        else if ([_ll isEqualToString:@"1"]){
            shuxian.backgroundColor=[UIColor colorWithHexString:@"3c94ff"];
            llable.textColor=[UIColor colorWithHexString:@"3c94ff"];
            llable.text=@"外勤";
        }
        else{
            shuxian.backgroundColor=[UIColor colorWithHexString:@"fd8f30"];
           
            if (indexPath.row==1){
                llable.text=@"开始时间:";
                shijian.text=[_arr[indexPath.section] objectForKey:@"beginTime"];
            }else if (indexPath.row==2){
                llable.text=@"结束时间:";
                shijian.text=[_arr[indexPath.section] objectForKey:@"endTime"];
            }else{
           NSArray*arr=[NSArray arrayWithObjects:@"病假",@"产假",@"婚假",@"工伤假",@"事假",@"丧假",@"调休",@"年假",@"其他", nil];
                
              int i= [[_arr[indexPath.section] objectForKey:@"fieldType"]intValue];
            
                llable.textColor=[UIColor colorWithHexString:@"fd8f30"];
                llable.text=@"请假原因";
                shijian.text=arr[i-1];
               
            }
        
            
        }
        [cell addSubview:shuxian];
        [cell addSubview:llable];
        [cell addSubview:shijian];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}
@end
