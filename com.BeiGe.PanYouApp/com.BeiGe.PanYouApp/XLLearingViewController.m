//
//  XLLearingViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/2/9.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XLLearingViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "XLLearnInfoViewController.h"
#import "Color+Hex.h"

@interface XLLearingViewController ()
{
    float width;
    float heigh;
    NSMutableArray*arr;
    NSMutableArray *arr1;
    int xxxxx;
    int fanpan;
    NSUserDefaults *def;
    UIButton  *btnn;
}
@end

@implementation XLLearingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableviewdelegat];
    width =[UIScreen mainScreen].bounds.size.width;
    heigh =[UIScreen mainScreen].bounds.size.height;
    _table.hidden = YES;
    self.title =@"知识学习";
    def =[NSUserDefaults standardUserDefaults];
    [self navigatio];
    [self refrish];
    // Do any additional setup after loading the view.
}
-(void)navigatio{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
    
}
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self jiekou];
    
    
}
-(void)typs:(UIButton*)btn{
    
    NSString*ss =[NSString stringWithFormat:@"%ld",btn.tag];
    [[NSUserDefaults standardUserDefaults]setObject:ss forKey:@"btntag"];
    for (UIButton * vv in _scrollview.subviews) {
        if (vv.tag==btn.tag) {
            [vv setTitleColor:[UIColor colorWithHexString:@"34C083"] forState:UIControlStateNormal];
        }
        else{
            [vv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    xxxxx=(int)btn.tag-100;
    [self jiekou1];
}

-(void)Scrollv{
    for (int i=0; i<arr.count; i++) {
        btnn =[[UIButton alloc]init];
        [btnn setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"knowledgeTypeName"]] forState:UIControlStateNormal];
        [btnn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnn.titleLabel.font =[UIFont systemFontOfSize:15];
        btnn.tag =100+i;
        [btnn addTarget:self action:@selector(typs:) forControlEvents:UIControlEventTouchUpInside];
        
        btnn.frame =CGRectMake(1+(width/3)*i,0,width/3-10, 40);
        btnn.titleLabel.adjustsFontSizeToFitWidth =YES;
        [_scrollview addSubview:btnn];
    }
    _scrollview.delegate= self;
    //设置scrollview的滚动范围（内容大小）
    _scrollview.contentSize = CGSizeMake((width/3)*arr.count,40);
    // 隐藏水平滚动条
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    // 用来记录scrollview滚动的位置(****)
    //_scrollview.contentOffset = CGPointMake(width, 0);
    //去掉弹簧效果
    _scrollview.bounces = NO;
    // 增加额外的滚动区域（逆时针，上、左、下、右）
    //_scrollview.contentInset = UIEdgeInsetsMake(0,0,0,0);
    //设置是否可以进行画面切换
    //_scrollview.pagingEnabled =YES;
    for (UIButton * vv in _scrollview.subviews) {
        if (vv.tag==[[def objectForKey:@"btntag"] intValue]) {
            [vv setTitleColor:[UIColor colorWithHexString:@"34C083"] forState:UIControlStateNormal];
        }
        else{
            [vv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
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

#pragma mark--刷新方法
-(void)refrish{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];
    
}
- (void)refreshClick:(UIRefreshControl *)refreshControl {
    
    [refreshControl beginRefreshing];
    
    // 此处添加刷新tableView数据的代码
    [self jiekou1];
 
    
    [refreshControl endRefreshing];
    
    
    //[self.table reloadData];// 刷新tableView即可
}


-(void)tableviewdelegat{
    _table.dataSource =self;
    _table.delegate =self;
    _table.backgroundColor = [UIColor clearColor];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr1.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"cell1";
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(10,10, 40, 40)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, width-80, 20)];
    UILabel *laa = [[UILabel alloc]initWithFrame:CGRectMake(60, 33,width-80, 20)];
    [img.layer setCornerRadius:10];
    
    lab.font =[UIFont systemFontOfSize:15];
    laa.font =[UIFont systemFontOfSize:15];
    laa.textColor =[UIColor lightGrayColor];
    img.image= [UIImage imageNamed:@"zixun.png"];
    lab.text =[NSString stringWithFormat:@"%@",[arr1[indexPath.row] objectForKey:@"title"]];
    laa.text =[NSString stringWithFormat:@"资讯类别:%@",[arr[xxxxx]objectForKey:@"knowledgeTypeName"]];
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0,_table.frame.size.width, 60)];
    backview.backgroundColor =[UIColor whiteColor];
    backview.layer.cornerRadius =10;
    
    [backview addSubview:img];
    [backview addSubview:lab];
    [backview addSubview:laa];
    [cell.contentView addSubview:backview];
    
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    XLLearnInfoViewController *xl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"learninfo"];
    xl.idid=[NSString stringWithFormat:@"%@",[arr1[indexPath.row] objectForKey:@"knowledgeInfoId"]];
    
    
    
    [self.navigationController pushViewController:xl animated:YES];
}


-(void)jiekou{
    arr = [NSMutableArray array];
    
    NSString *fangshi=@"/knowledge/typeInfo";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            arr=[[responseObject objectForKey:@"data"] objectForKey:@"knowledgeTypeInfoList"];
            
            [self Scrollv];
            if ([[def objectForKey:@"btntag"] isEqualToString:@"100"]) {
                [self jiekou1];
            }
            [WarningBox warningBoxHide:YES andView:self.view];
        }
        else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
    }];
    
}
-(void)jiekou1{
    if (arr.count == 0) {
        
    }else{
        arr1 = [NSMutableArray array];
        NSString *fangshi=@"/knowledge/title";
        NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *KnowID=[NSString stringWithFormat:@"%@",[arr[xxxxx] objectForKey:@"knowledgeTypeId"]];
        NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",KnowID,@"knowledgeTypeId",nil];
        [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
        [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                arr1=[[responseObject objectForKey:@"data"] objectForKey:@"knowledgeInfoList"];
                [_table reloadData];
                _table.hidden =NO;
                [WarningBox warningBoxHide:YES andView:self.view];
            }
            else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
                //账号在其他手机登录，请重新登录。
                [XL_WangLuo sigejiu:self];
            }
        } failure:^(NSError *error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        }];
    }
}
@end
