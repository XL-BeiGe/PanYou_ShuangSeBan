//
//  XL_tableViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 2017/5/18.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XL_tableViewController.h"
#import "XL_FMDB.h"
#import "WarningBox.h"
#import "XL_PanDianViewController.h"
#import "Color+Hex.h"
#import "XL_Header.h"
#import "ZYCustomKeyboardTypeNumberView.h"
@interface XL_tableViewController ()<ZYCustomKeyboardTypeNumberViewDelegate>
{
    XL_FMDB *XL;
    FMDatabase *db;
    
    NSArray*listarray;
    
    UITextField *customSearchBar;
    NSArray * arr;
}
@end

@implementation XL_tableViewController

-(void)viewWillAppear:(BOOL)animated{
    [self sousuoKuang];
    if (_biaoqian.selectedSegmentIndex == 0) {
        listarray =[self table_array:0];
    }else if(_biaoqian.selectedSegmentIndex == 1){
        listarray =[self table_array:1];
    }
    [_tableview reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    for (UIView *vv in self.navigationController.view.subviews) {
        if (vv.tag == 1001111) {
            [vv removeFromSuperview];
        }
    }
}
-(void)sousuoKuang{
    CGRect mainViewBounds = self.navigationController.view.bounds;
    UITextField *customSearchBar = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewBounds)/2-((CGRectGetWidth(mainViewBounds)-140)/2), CGRectGetMinY(mainViewBounds)+22, CGRectGetWidth(mainViewBounds)-120, 40)];
    customSearchBar.tag = 1001111;
    customSearchBar.placeholder = @" 🔍请输入编号或条码";
    [ZYCustomKeyboardTypeNumberView customKeyboardViewWithServiceTextField:customSearchBar Delegate:self];
    [self.navigationController.view addSubview: customSearchBar];
}
#pragma mark ------textfield
- (void)customKeyboardTypeNumberView_changeTextFieldWithText:(UITextField *)string{
    [self sousuo:string.text];
}
#pragma mark ------方法
-(void)sousuo:(NSString *)str{
    NSArray * wocalei = [NSArray array];
    switch (_biaoqian.selectedSegmentIndex) {
        case 0:
            wocalei = [self table_array:0];
            [self woyaosila:wocalei :str];
            break;
        case 1:
            wocalei = [self table_array:1];
            [self woyaosila:wocalei :str];
            break;
        default:
            break;
    }
}
-(void)woyaosila:(NSArray * )wocailei :(NSString *)str{
    if ([str isEqualToString:@""]) {
        listarray = wocailei;
        [_tableview reloadData];
    }else{
        NSMutableArray * hahah = [NSMutableArray array];
        for (NSDictionary * dd in wocailei) {
            if ([self congzuodaoyouPIPEI:[dd objectForKey:@"productCode"] :str] || [self congzuodaoyouPIPEI:[dd objectForKey:@"barCode"] :str]) {
                [hahah addObject:dd];
            }
        }
        listarray = hahah;
        [_tableview reloadData];
    }
}
-(BOOL)congzuodaoyouPIPEI:(NSString * )da :(NSString *)xiao{
    if ([da rangeOfString:@","].location != NSNotFound) {
        NSArray*uty=[da componentsSeparatedByString:@","];
        for (NSString * he in uty) {
//            NSLog(@"%lu",(unsigned long)xiao.length);
            if (he.length>0&&xiao.length<=he.length) {
                if ([[he substringToIndex:(int)(xiao.length)] isEqualToString:xiao]) {
                    return YES;
                }
            }
        }
    }else{
        
        if (da.length < xiao.length) {
            
        }else{
            NSString * ha = [da substringToIndex:(int)(xiao.length)];
            if ([xiao isEqualToString:ha]) {
                return YES;
            }
        }
    }
    return NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self tuijianpan];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self tuijianpan];
}
-(void)tuijianpan{
    [self.navigationController.view endEditing:YES];
    customSearchBar.layer.borderColor = [[UIColor blackColor]CGColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self shujuku];
    _tableview.delegate =self;
    _tableview.dataSource=self;
    [_biaoqian addTarget:self action:@selector(Action:) forControlEvents:UIControlEventValueChanged];
    _biaoqian.tintColor=[UIColor colorWithHexString:@"34C083"];
    _biaoqian.selectedSegmentIndex=0;
    listarray=[self table_array:0];
    [_tableview reloadData];
    //去除多余分割线
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}
-(void)Action:(UISegmentedControl *)segment{
    customSearchBar.text = @"";
    [self.navigationController.view endEditing:YES];
    if (segment.selectedSegmentIndex ==0) {
        listarray=[self table_array:0];
        [_tableview reloadData];
    }else{
        listarray=[self table_array:1];
        [_tableview reloadData];
    }
}
-(void)shujuku {
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"weipan";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    UILabel *huowei    =[cell viewWithTag:1000]; 
    UILabel *yaoming    =[cell viewWithTag:1001];    //weipan
    yaoming.textAlignment=NSTextAlignmentCenter;
    if (NULL == [listarray[indexPath.row] objectForKey:@"hwh"]) {
        huowei.text=@"";
    }else{
        huowei.text=[NSString stringWithFormat:@"%@",[listarray[indexPath.row] objectForKey:@"hwh"]];
    }
    if (nil ==[listarray[indexPath.row] objectForKey:@"productName"]) {
        yaoming.text=@"";
    }else{
        yaoming.text=[NSString stringWithFormat:@"%@",[listarray[indexPath.row] objectForKey:@"productName"]];
    }
    //点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XL_PanDianViewController *pandian = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"pandian"];
    pandian.rukou = @"1";//productCode
    if (NULL ==[listarray[indexPath.row] objectForKey:@"barCode"]) {
        pandian.jieshouzhi=[listarray[indexPath.row] objectForKey:@"productCode"];
    }else{
        pandian.jieshouzhi=[listarray[indexPath.row] objectForKey:@"barCode"];
    }
    [self.navigationController pushViewController:pandian animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listarray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSArray*)table_array:(int )i{
    NSArray* aa=[[NSArray alloc] init];
    NSDictionary*dd=[NSDictionary dictionaryWithObjectsAndKeys: @"0", @"checkNum",nil];
    if (i ==0) {
        aa=[XL DataBase:db selectKeyTypes:XiaZaiShiTiLei fromTable:XiaZaiBiaoMing where___Condition:dd];
    }else if (i == 1){
        aa=[XL DataBase:db selectKeyTypes:XiaZaiShiTiLei fromTable:XiaZaiBiaoMing where_Condition:dd];
    }
    return aa;
}
-(void)navigation{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
