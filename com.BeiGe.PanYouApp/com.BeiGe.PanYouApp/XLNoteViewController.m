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
@interface XLNoteViewController ()
{
    
    NSArray *pushList;
    NSString* zhT;
}
@end

@implementation XLNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"通知";
    [self tableviewdelegate];
    [self tongzhijiekou:@"1"];
    zhT=@"1";
}

-(void)tongzhijiekou:(NSString*)zhuangtai{
    //push/pushList
    NSString *fangshi=@"/push/pushList";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"userId",zhuangtai,@"progressStatus", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            pushList=[[responseObject objectForKey:@"data"] objectForKey:@"pushList"];
            
            [_table reloadData];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];

}
- (IBAction)ChangeV:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex==0){
        [self tongzhijiekou:@"1"];
        zhT=@"1";
        NSLog(@"未接受");

    }else if (sender.selectedSegmentIndex==1){
        [self tongzhijiekou:@"2"];
        zhT=@"2";
        NSLog(@"执行中");

    }else{
        [self tongzhijiekou:@"3"];
        zhT=@"3";
        NSLog(@"已完成");

    }
}

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
    titl.text = [pushList[indexPath.row] objectForKey:@"title"];
    mess.text = [pushList[indexPath.row] objectForKey:@"context"];
    time.text = [pushList[indexPath.row] objectForKey:@"createTime"];
    icoimg.image = [UIImage imageNamed:@"通知列表小标.png"];
    img.image = [UIImage imageNamed:@"通知列表小标.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLNoteInfoViewController *xl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"noteinfo"];
    xl.pushInfoId=[NSString stringWithFormat:@"%@",[pushList[indexPath.row] objectForKey:@"pushInfoId"]];
    xl.zhT=zhT;
    [self.navigationController pushViewController:xl animated:YES];
}
@end
