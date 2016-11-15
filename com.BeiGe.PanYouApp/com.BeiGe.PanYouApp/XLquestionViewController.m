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

@interface XLquestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation XLquestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor=[UIColor blackColor];
    [self delegate];
}
-(void)delegate{
    _tableview.delegate=self;
    _tableview.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets = NO;;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
    UIView *yanse    =[cell viewWithTag:0];
    UILabel*taoti    =[cell viewWithTag:1];
    UILabel*state    =[cell viewWithTag:2];
    UILabel*daci     =[cell viewWithTag:3];
    UILabel*shengci  =[cell viewWithTag:4];
    UILabel*cuoci    =[cell viewWithTag:5];
    UILabel*datian   =[cell viewWithTag:6];
    UILabel*shengtian=[cell viewWithTag:7];
    
//    yanse.backgroundColor=[UIColor colorWithHexString:@""];
//    taoti.text=@"";
//    state.text=@"";
//    daci.text =@"";
//    shengci.text=@"";
//    cuoci.text=@"";
//    datian.text=@"";
//    shengtian.text=@"";
    cell.selectionStyle=UITableViewCellAccessoryNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"dianjile ");
    XLanswerViewController*xla=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"answer"];
    [self.navigationController pushViewController:xla animated:YES];
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

@end
