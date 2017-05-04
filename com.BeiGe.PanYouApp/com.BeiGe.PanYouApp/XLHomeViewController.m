//
//  XLHomeViewController.m
//  PanDianDanJi
//
//  Created by 小狼 on 16/9/8.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLHomeViewController.h"
#import "WarningBox.h"
#import "XLSettsViewController.h"
#import "XL_Header.h"
#import "XL_WangLuo.h"
#import "XL_FMDB.h"
#import "XL_PanDianViewController.h"
#import "XLquanbushitilei.h"

@interface XLHomeViewController (){
    XL_FMDB  *XL;//数据库调用者
    FMDatabase *db;//数据库
    
    NSMutableArray *quanbulist;
    NSMutableArray *xiazailist;
}

@end

@implementation XLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationDeShezhi];
    [self shujuku];
}
-(void)shujuku{
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
    //新建同步表，里边是同步数据信息
    [XL DataBase:db createTable:TongBuBiaoMing keyTypes:TongBuShiTiLei];
    //新建下载表，里边是本次盘点数据
    [XL DataBase:db createTable:XiaZaiBiaoMing keyTypes:XiaZaiShiTiLei];
    //新建上传表，里边是需要上传的盘点数据
    [XL DataBase:db createTable:ShangChuanBiaoMing keyTypes:ShangChuanShiTiLei];
}
-(void)NavigationDeShezhi{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(huilaojia)];
    [self.navigationItem setLeftBarButtonItem:left];
    
    if([_biaoji isEqual:@"1"]){
        
        
        UIButton *btnn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btnn setImage:[UIImage imageNamed:@"设置.png"] forState:UIControlStateNormal];
        [btnn addTarget:self action:@selector(set:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:btnn];
        self.navigationItem.rightBarButtonItem = right;
        [self.navigationItem setRightBarButtonItem:right];
    }
}
-(void)huilaojia{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//同步全部库存
- (IBAction)KuCun_Button:(id)sender {
    
    NSArray  *arr= [XL DataBase:db selectKeyTypes:ShangChuanShiTiLei fromTable:ShangChuanBiaoMing];
    if (arr.count!=0){
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"同步提示" message:@"同步全部库存将会清空本次盘点未提交的数据，确定要同步全部库存吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhuangtai"];
            [self tongbushuju];
            [self xiazaishuju:@"全部库存" :@"9"];
            
        }];
        UIAlertAction*action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhuangtai"];
        [self tongbushuju];
        
        [self xiazaishuju:@"全部库存" :@"9"];
        
    }
}

//同步异常数据
- (IBAction)ShuJu_Button:(id)sender {
    
    NSArray *arr = [XL DataBase:db selectKeyTypes:ShangChuanShiTiLei fromTable:ShangChuanBiaoMing];
    if (arr.count!=0){
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"同步提示" message:@"同步异常数据将会清空本次盘点未提交的数据，确定要同步异常数据吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"zhuangtai"];
            [self xiazaishuju:@"异常数据" :@"8"];
        }];
        UIAlertAction*action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"zhuangtai"];
        [self xiazaishuju:@"异常数据" :@"8"];
    }
}
//提交盘点结果
- (IBAction)TiJian_Button:(id)sender {
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定要提交盘点结果吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shangchuanshujujiexi];
    }];
    UIAlertAction*action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
-(void)shangchuanshujujiexi{
    
    NSArray *list1 = [XL DataBase:db selectKeyTypes:ShangChuanShiTiLei fromTable:ShangChuanBiaoMing];
    NSMutableArray*list = [[NSMutableArray alloc] init];
    for (NSDictionary*dd in list1) {
        if (![[dd objectForKey:@"checkNum"] isEqualToString:@"0"]) {
            [list addObject:dd];
        }
    }
    if (list.count==0) {
        [WarningBox warningBoxModeText:@"请先盘点数据!" andView:self.view];
    }else{
        [WarningBox warningBoxModeIndeterminate:@"正在提交盘点结果...." andView:self.view];
        NSUserDefaults *isPandian=[NSUserDefaults standardUserDefaults];
        NSDictionary*rucan;
        if ([[isPandian objectForKey:@"isPandian"] isEqualToString:@"0"]) {
            rucan=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"Mac"],@"mac",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],@"checker",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhuangtai"],@"state",list,@"list",nil];
        }else{
            NSString * officeId=[isPandian objectForKey:@"mendian"];
            rucan=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"Mac"],@"mac",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],@"checker",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhuangtai"],@"state",list,@"list",officeId,@"officeId",nil];
        }
        [self shangchuan:rucan];
    }
    
}
//盘点药品
- (IBAction)PanDian_Button:(id)sender {
    /*需要加判断*/
    NSArray *xxx=[XL DataBase:db selectKeyTypes:XiaZaiShiTiLei fromTable:XiaZaiBiaoMing];
    if (xxx.count==0) {
        [WarningBox warningBoxModeText:@"请先同步全部库存!" andView:self.view];
    }else{
        XL_PanDianViewController *pandian=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"pandian"];
        [self.navigationController pushViewController:pandian animated:YES];
    }
}

//跳转设置
-(void)set:(UIButton*)sender{
    XLSettsViewController *shezhi=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"setts"];
    [self.navigationController pushViewController:shezhi animated:YES];
}
-(void)tongbushuju{
    NSString *fangshi=@"/sys/products";
    NSUserDefaults *isPandian=[NSUserDefaults standardUserDefaults];
    NSDictionary*rucan;
    if ([[isPandian objectForKey:@"isPandian"] isEqualToString:@"0"]) {
        rucan=nil;
    }else{
        NSString * officeId=[isPandian objectForKey:@"mendian"];
        rucan=[NSDictionary dictionaryWithObjectsAndKeys:officeId,@"officeId", nil];
    }
    //自己写的网络请求    请求外网地址
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        @try {
            if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                quanbulist =[[NSMutableArray alloc] initWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"list"]];
                //清空数据
                [XL clearDatabase:db from:TongBuBiaoMing];
                
                NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(hehe) object:nil];
                [thread start];
            }else{
                [WarningBox warningBoxModeText:@"同步库存失败，请与管理员联系！" andView:self.view];
            }
        } @catch (NSException *exception) {
            
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络请求失败" andView:self.view];
    }];
    
}
-(void)hehe{
    NSDate *startTime = [NSDate date];
    [db beginTransaction];
    BOOL isRollBack = NO;
    @try
    {
        for (int i=0; i<quanbulist.count; i++) {
            XLquanbushitilei *shiti=[[XLquanbushitilei alloc] initWithDict:quanbulist[i]];
            
            NSDictionary*dd=[XLquanbushitilei ModeltoDic:shiti];
            [XL DataBase:db insertKeyValues:dd intoTable:TongBuBiaoMing];
        }
        NSDate *endTime = [NSDate date];
        NSTimeInterval a = [endTime timeIntervalSince1970] - [startTime timeIntervalSince1970];
        NSLog(@"使用事务------------插入数据用时%.3f秒",a);
    }
    @catch (NSException *exception)
    {
        isRollBack = YES;
        [db rollback];
    }
    @finally
    {
        if (!isRollBack)
        {
            [db commit];
        }
    }
}
-(void)xiazaishuju:(NSString *)str :(NSString *)ss{
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@"正在同步%@",str] andView:self.view];
    NSString *fangshi=@"/sys/download";
    NSUserDefaults *isPandian=[NSUserDefaults standardUserDefaults];
    NSDictionary*rucan;
    if ([[isPandian objectForKey:@"isPandian"] isEqualToString:@"0"]) {
        rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"checkId",ss,@"status", nil];
    }else{
        NSString * officeId=[isPandian objectForKey:@"mendian"];
        rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"checkId",ss,@"status",officeId,@"officeId", nil];
    }
    //自己写的网络请求    请求外网地址
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try {
            //             NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                NSDictionary*dataa=[responseObject objectForKey:@"data"];
                
                if (NULL == [dataa objectForKey:@"megBatchNoFlag"]||[[dataa objectForKey:@"megBatchNoFlag"] isEqual:[NSNull null]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"megBatchNoFlag"];
                }else{
                    NSString*hebing=[dataa objectForKey:@"megBatchNoFlag"];
                    [[NSUserDefaults standardUserDefaults] setObject:hebing forKey:@"megBatchNoFlag"];
                }
                xiazailist=[dataa objectForKey:@"list"];
                if(xiazailist.count == 0){
                    [WarningBox warningBoxModeText:@"后台数据为空，请联系管理员添加数据......" andView:self.view];
                }else{
                    [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@同步成功%lu条数据!",str,(unsigned long)xiazailist.count] andView:self.view];
                    [[NSUserDefaults standardUserDefaults] setObject:[xiazailist[0] objectForKey:@"checkId"] forKey:@"checkId"];
                    [XL clearDatabase:db from:ShangChuanBiaoMing];
                    [XL clearDatabase:db from:XiaZaiBiaoMing];
                    
                    NSDate *startTime = [NSDate date];
                    [db beginTransaction];
                    BOOL isRollBack = NO;
                    @try
                    {
                        for (int i=0; i<xiazailist.count; i++) {
                            //向下载表中插入数据
                            
                            [XL DataBase:db insertKeyValues:xiazailist[i] intoTable:XiaZaiBiaoMing];
                        }
                        NSDate *endTime = [NSDate date];
                        NSTimeInterval a = [endTime timeIntervalSince1970] - [startTime timeIntervalSince1970];
                        NSLog(@"使用事务插入数据用时%.3f秒",a);
                        
                    }
                    @catch (NSException *exception)
                    {
                        isRollBack = YES;
                        [db rollback];
                    }
                    @finally
                    {
                        if (!isRollBack)
                        {
                            [db commit];
                        }
                    }
                }
            }
            else if ([[responseObject objectForKey:@"code"]isEqual:@"0007"]){
                [WarningBox warningBoxModeText:@"后台已计算，请同步异常数据!" andView:self.view];
            }
            else if ([[responseObject objectForKey:@"code"]isEqual:@"0008"]){
                [WarningBox warningBoxModeText:@"后台已提交，请等待下次盘点!" andView:self.view];
            }else if ([[responseObject objectForKey:@"code"]isEqual:@"0006"]){
                [WarningBox warningBoxModeText:@"请先同步全部库存进行盘点!" andView:self.view];
            }else if ([[responseObject objectForKey:@"code"]isEqual:@"0005"]){
                [WarningBox warningBoxModeText:@"后台已计算，若要盘点异常，请在后台点击“重盘异常数据”！" andView:self.view];
            }

        } @catch (NSException *exception) {
            [WarningBox warningBoxModeText:@"请仔细检查您的网络" andView:self.view];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络请求失败" andView:self.view];
    }];
}

-(void)shangchuan:(NSDictionary*)rucan{
    NSString *fangshi=@"/sys/upload";
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"] isEqual:@"0000"]) {
            NSString *ss = [NSString stringWithFormat:@"已盘点%lu条数据，成功提交%lu条数据请等待后台处理",[[rucan objectForKey:@"list"]count],[[rucan objectForKey:@"list"]count]];
            [WarningBox warningBoxModeText:ss andView:self.view];
        }else if ([[responseObject objectForKey:@"code"] isEqual:@"0009"]){
            [WarningBox warningBoxModeText:@"后台已计算，请同步异常数据!" andView:self.view];
        }else
            [WarningBox warningBoxModeText:@"提交盘点结果失败!" andView:self.view];
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络请求失败" andView:self.view];
    }];
    
}

@end
