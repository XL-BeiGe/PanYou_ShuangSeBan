//
//  XLNoteViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/4.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLNoteViewController.h"
#import "XLNoteInfoViewController.h"
@interface XLNoteViewController ()
{
    NSArray *titlearr;
    NSArray *messarr;
    NSArray *timearr;
}
@end

@implementation XLNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"通知";
    [self tableviewdelegate];
    
    titlearr = [NSArray arrayWithObjects:@"测试标题1",@"测试标题2",@"测试标题3",@"测试标题4",@"测试标题5",@"测试标题6",@"测试标题7",@"测试标题8",@"测试标题9",@"测试标题10", nil];
    messarr = [NSArray arrayWithObjects:@"测试文字1",@"测试文字2",@"测试文字3",@"测试文字4",@"测试文字5",@"测试文字6",@"测试文字7",@"测试文字8",@"测试文字9",@"测试文字10", nil];
    timearr = [NSArray arrayWithObjects:@"12:11",@"12:12",@"12:13",@"12:14",@"12:15",@"12:16",@"12:17",@"12:18",@"12:19",@"12:20", nil];
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

//- (IBAction)Changed:(id)sender {
//    UISegmentedControl *cc = (UISegmentedControl*)sender;
//    int index = (int)cc.selectedSegmentIndex;
//    if (index==0){
//        NSLog(@"0");
//    }else if (index==1){
//     NSLog(@"1");
//    }else {
//     NSLog(@"2");
//    }
//    if ([[sender.selectedSegmentIndex ]intValue]==0){
//    
//    }
//}


- (IBAction)ChangeV:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex==0){
        NSLog(@"未接受");

    }else if (sender.selectedSegmentIndex==1){
        NSLog(@"执行中");

    }else{
        NSLog(@"已完成");

    }
}

-(void)tableviewdelegate{
    _table.dataSource = self;
    _table.delegate = self;
    _table.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
    titl.text = titlearr[indexPath.row];
    mess.text = messarr[indexPath.row];
    time.text = timearr[indexPath.row];
    icoimg.image = [UIImage imageNamed:@"通知列表小标.png"];
    img.image = [UIImage imageNamed:@"通知列表小标.png"];
    
//    [cell.contentView addSubview:titl];
//    [cell.contentView addSubview:mess];
//    [cell.contentView addSubview:time];
//    [cell.contentView addSubview:icoimg];
//    [cell.contentView addSubview:img];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLNoteInfoViewController *xl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"noteinfo"];
    [self.navigationController pushViewController:xl animated:YES];
}
@end
