//
//  XLtongxiangqingViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 2016/11/28.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLtongxiangqingViewController.h"
#import "Color+Hex.h"
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
}
-(void)delegate{
    _tableview.delegate=self;
    _tableview.dataSource=self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_ll isEqualToString:@"0"]) {
        return 3;
    }else
        return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
        UIImageView*imageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, (cell.frame.size.height-20)/2, 20, 20)];
        UIImage*image=[[UIImage alloc] init];
        UILabel*lable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(imageview.frame)+10, 11, 350, 20)];
        lable.text=[_arr[indexPath.section] objectForKey:@"beginTime"];
        if ([_ll isEqualToString:@"0"]) {
            image=[UIImage imageNamed:@"统计-工作天数.png"];
            shuxian.backgroundColor=[UIColor colorWithHexString:@""];
        }else if ([_ll isEqualToString:@"1"]){
            image=[UIImage imageNamed:@"统计-外出天数.png"];
            shuxian.backgroundColor=[UIColor colorWithHexString:@"3d94ff"];
        }else{
            image=[UIImage imageNamed:@"统计-请假次数.png"];
            shuxian.backgroundColor=[UIColor colorWithHexString:@"fd8f30"];
        }
        imageview.image=image;
        [cell addSubview:imageview];
    }else{
        UILabel*llable=[[UILabel alloc] initWithFrame:CGRectMake(40, 8, 150, 30)];
        UILabel*shijian=[[UILabel alloc] initWithFrame:CGRectMake(self.tableview.frame.size.width-200, 8, 180, 30)];
        shijian.textAlignment=NSTextAlignmentRight;
        if ([_ll isEqualToString:@"0"]) {
            llable.textColor=[UIColor colorWithHexString:@"3c94ff"];
            if (indexPath.row==1) {
                llable.text=@"已签到";
                shijian.text=[_arr[indexPath.section] objectForKey:@"beginTime"];
            }else{
                llable.text=@"已签退";
                shijian.text=[_arr[indexPath.section] objectForKey:@"endTime"];
            }
        }else if ([_ll isEqualToString:@"1"]){
            llable.textColor=[UIColor colorWithHexString:@"3c94ff"];
            llable.text=@"外勤";
        }else{
            llable.textColor=[UIColor colorWithHexString:@"fd8f30"];
            llable.text=@"请假";
            shijian.text=[_arr[indexPath.section] objectForKey:@"fieldReason"];
        }
    }
    [cell addSubview:shuxian];
    return cell;
}
@end
