//
//  XLquestionViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 16/11/15.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLquestionViewController.h"
#import "XLanswerViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"

@interface XLquestionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray*tempLateList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation XLquestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor=[UIColor blackColor];
    [self delegate];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self jiekou];
}
-(void)delegate{
    
    _tableview.delegate=self;
    _tableview.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets = NO;;
    self.tableview.showsVerticalScrollIndicator = NO;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tempLateList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"abcd";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    UIView *yanse    =[cell viewWithTag:10];
    UILabel*taoti    =[cell viewWithTag:1];
    UILabel*state    =[cell viewWithTag:2];
    UILabel*daci     =[cell viewWithTag:3];
    UILabel*shengci  =[cell viewWithTag:4];
    UILabel*cuoci    =[cell viewWithTag:5];
    UILabel*datian   =[cell viewWithTag:6];
    UILabel*shengtian=[cell viewWithTag:7];
    //state: 已完成，未完成，进行中，待进行；
    
    
    taoti.text=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"examTemplateName"]];
    
    daci.text =[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"answerTimes"]];
    shengci.text=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"surplusAnswerTimes"]];
    cuoci.text=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"errorAnswerTimes"]];
    datian.text=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"answerDay"]];
    shengtian.text=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"surplusAnswerDay"]];
    //是否可以回答, 1能，2 不能；
    NSString*isAnswser=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"isAnswser"]];
    //是否是正常答题,  1是，2不是
    NSString*isNormal =[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"isNormal"]];
    if ([shengci.text isEqualToString:@"0"]&&[isAnswser isEqualToString:@"2"]) {
        state.text=@"已完成";
        yanse.backgroundColor=[UIColor colorWithHexString:@"4ada9c"];
    }else if ([isAnswser isEqualToString:@"2"]&&![shengci.text isEqualToString:@"0"]&&[shengtian.text isEqualToString:@"0"]){
        state.text=@"未完成";
        yanse.backgroundColor=[UIColor colorWithHexString:@"ff5757"];
    }else if ([isAnswser isEqualToString:@"1"]&&![shengtian.text isEqualToString:@"0"]){
        state.text=@"进行中";
        yanse.backgroundColor=[UIColor colorWithHexString:@"fac539"];
    }else if ([isAnswser isEqualToString:@"2"]&&![shengtian.text isEqualToString:@"0"]){
        state.text=@"待进行";
        yanse.backgroundColor=[UIColor colorWithHexString:@"53b9f9"];
    }
    cell.selectionStyle=UITableViewCellAccessoryNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*isAnswser=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"isAnswser"]];
    NSString*shengtian=[NSString stringWithFormat:@"%@", [tempLateList[indexPath.section] objectForKey:@"surplusAnswerDay"]];
    if ([isAnswser isEqualToString:@"1"]&&![shengtian isEqualToString:@"0"]) {
        XLanswerViewController*xla=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"answer"];
        xla.timuarr=[tempLateList[indexPath.section] objectForKey:@"examList"];
        NSLog(@"%@",tempLateList[indexPath.section]);
        xla.mobanID=[tempLateList[indexPath.section] objectForKey:@"examTempLateId"];
        NSLog(@"%@",[tempLateList[indexPath.section] objectForKey:@"examTempLateId"]);
        xla.str=[NSString stringWithFormat:@"%@",[tempLateList[indexPath.section] objectForKey:@"isNormal"]];
        xla.xunhuan=[NSString stringWithFormat:@"%@",[tempLateList[indexPath.section] objectForKey:@"errorAnswerTimes"]];
        xla.templateAssignId=[NSString stringWithFormat:@"%@",[tempLateList[indexPath.section] objectForKey:@"templateAssignId"]];
        if (xla.timuarr.count==0) {
            [WarningBox warningBoxModeText:@"现在还没有题哟～" andView:self.view];
        }else
        [self.navigationController pushViewController:xla animated:YES];
    }else{
        [WarningBox warningBoxModeText:@"挖哈哈哈哈fsfsdfdsfdsfsdfsdfsdfdsfsdfsdfdsfdsfdsfdsfdsfdsfdssdsadsadasdihfiguhfdnvidhhvisnfvjdsuihfdcj nzkchsiuhdijnajfbhsjkdbfhdsghfui哈哈" andView:self.view];
    }

    
}

-(void)jiekou{
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@"页面加载中..."] andView:self.view];
    NSString *fangshi=@"/exam/getExamList";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId", nil];
    //自己写的网络请求    请求外网地址
    
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            NSDictionary* data=[responseObject objectForKey:@"data"];
            tempLateList=[data objectForKey:@"tempLateList"];
            
            [_tableview reloadData];
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        NSLog(@"%@",error);
    }];

}

@end
