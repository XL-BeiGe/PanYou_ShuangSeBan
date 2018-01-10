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
//  @"WeiZhi" 用于跳页后弹出应为数组中的第几个
//  @"KG"  0 = 关 ; 1 = 开,开时，会自动弹出。
//  @"SHU" 同步库存时变为0，每添加一个，+1，
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
    customSearchBar = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewBounds)/2-((CGRectGetWidth(mainViewBounds)-140)/2), CGRectGetMinY(mainViewBounds)+22, CGRectGetWidth(mainViewBounds)-120, 40)];
    customSearchBar.tag = 1001111;
    customSearchBar.placeholder = @" 🔍请输入编号或条码";
    [ZYCustomKeyboardTypeNumberView customKeyboardViewWithServiceTextField:customSearchBar Delegate:self];
    [self.navigationController.view addSubview: customSearchBar];
    UISwitch * swi = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"KG"] isEqual:@"1"]) {
        swi.on = NO;
    }else{
        swi.on = YES;
    }
    [swi addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:swi];
    [self.navigationItem setRightBarButtonItem:right];
}
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults *ss = [NSUserDefaults standardUserDefaults];
    //KG   0 = 关 ; 1 = 开
    if (isButtonOn) {
        [WarningBox warningBoxModeText:@"排序-开" andView:self.view];
        [ss setObject:@"1" forKey:@"KG"];
        if (_biaoqian.selectedSegmentIndex == 0) {
            listarray =[self table_array:0];
        }else if(_biaoqian.selectedSegmentIndex == 1){
            listarray =[self table_array:1];
        }
        [_tableview reloadData];
        NSLog(@"开");
    }else {
        [ss setObject:@"0" forKey:@"KG"];
        [WarningBox warningBoxModeText:@"排序-关" andView:self.view];
        if (_biaoqian.selectedSegmentIndex == 0) {
            listarray =[self table_array:0];
        }else if(_biaoqian.selectedSegmentIndex == 1){
            listarray =[self table_array:1];
        }
        [_tableview reloadData];
        NSLog(@"关");
    }
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
    huowei.textAlignment=NSTextAlignmentCenter;
    if (NULL == [listarray[indexPath.row] objectForKey:@"oldpos"]) {
        huowei.text=@"";
    }else{
        huowei.text=[NSString stringWithFormat:@"%@",[listarray[indexPath.row] objectForKey:@"oldpos"]];
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
    if (customSearchBar.text.length > 0) {
        pandian.souTiao = @"1";
    }else{
        pandian.souTiao = @"0";
    }
//    if (NULL ==[listarray[indexPath.row] objectForKey:@"barCode"]) {
        pandian.jieshouzhi=[listarray[indexPath.row] objectForKey:@"productCode"];
//    }else{
//        pandian.jieshouzhi=[listarray[indexPath.row] objectForKey:@"barCode"];
//    }
    switch (_biaoqian.selectedSegmentIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"WeiZhi"];
            pandian.wei = @"0";
            break;
        case 1:
            pandian.wei = @"1";
            break;
        default:
            break;
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
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"KG"] isEqual:@"1"]) {
        return aa;
    }
    NSArray* hah=[self paixu:aa];
    return hah;
}
-(NSArray*)paixu:(NSArray*)aar{
    
    NSArray *sortedArray = [aar sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *p1, NSDictionary *p2){
        if ([p1 objectForKey:@"f3"]  ==nil || NULL == [p1 objectForKey:@"f3"] ||[[p1 objectForKey:@"f3"] isEqual:[NSNull null]]||[[p1 objectForKey:@"f3"] isEqualToString:@""]) {
            [p1 setValue:@"98889898988889" forKey:@"f3"];
        }
        if ([p2 objectForKey:@"f3"]  ==nil || NULL == [p2 objectForKey:@"f3"] ||[[p2 objectForKey:@"f3"] isEqual:[NSNull null]]||[[p2 objectForKey:@"f3"] isEqualToString:@""]) {
            [p2 setValue:@"98889898988889" forKey:@"f3"];
        }
        if ([[p1 objectForKey:@"f3"] longLongValue]<[[p2 objectForKey:@"f3"] longLongValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];

    return sortedArray;
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
