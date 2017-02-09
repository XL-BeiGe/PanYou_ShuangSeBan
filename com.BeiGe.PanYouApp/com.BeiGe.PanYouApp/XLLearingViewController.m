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
@interface XLLearingViewController ()
{
    float width;
    float heigh;
    NSMutableArray*arr;
    NSMutableArray *arr1;
    int xxxxx;
}
@end

@implementation XLLearingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableviewdelegat];
    width =[UIScreen mainScreen].bounds.size.width;
    heigh =[UIScreen mainScreen].bounds.size.height;
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self jiekou];
    
}
-(void)typs:(UIButton*)btn{
    
    xxxxx=(int)btn.tag-100;
    [self jiekou1];
}

-(void)Scrollv{
    for (int i=0; i<arr.count; i++) {
        UIButton  *btn =[[UIButton alloc]initWithFrame:CGRectMake(0+(width/3)*i, 0,width/3, 40)];
        [btn setTitle:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"knowledgeTypeName"]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag =100+i;
        [btn addTarget:self action:@selector(typs:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollview addSubview:btn];
    }
    _scrollview.delegate= self;
    //设置scrollview的滚动范围（内容大小）
    _scrollview.contentSize = CGSizeMake(width*3,40);
    
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
-(void)tableviewdelegat{
    _table.dataSource =self;
    _table.delegate =self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr1.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"cell1";
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, width-80, 20)];
    UILabel *laa = [[UILabel alloc]initWithFrame:CGRectMake(60, 28,width-80, 20)];
    [img.layer setCornerRadius:10];
    [img.layer setBorderWidth:1];
    lab.font =[UIFont systemFontOfSize:15];
    laa.font =[UIFont systemFontOfSize:15];
    img.image= [UIImage imageNamed:@"首页2_01.png"];
    laa.text =[NSString stringWithFormat:@"%@",[arr1[indexPath.row] objectForKey:@"title"]];
    lab.text =[NSString stringWithFormat:@"%@",[arr1[indexPath.row] objectForKey:@"title"]];
    
    
    [cell.contentView addSubview:img];
    [cell.contentView addSubview:lab];
    [cell.contentView addSubview:laa];
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
       // NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
           arr=[[responseObject objectForKey:@"data"] objectForKey:@"knowledgeTypeInfoList"];
            NSLog(@"%@",arr);
            [self Scrollv];
            [WarningBox warningBoxHide:YES andView:self.view];
        }
        else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];

}
-(void)jiekou1{
    arr1 = [NSMutableArray array];
    NSString *fangshi=@"/knowledge/title";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *KnowID=[NSString stringWithFormat:@"%@",[arr[xxxxx] objectForKey:@"knowledgeTypeId"]];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",KnowID,@"knowledgeTypeId",nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
         NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            arr1=[[responseObject objectForKey:@"data"] objectForKey:@"knowledgeInfoList"];
            //NSLog(@"%@",arr);
            [_table reloadData];
            [WarningBox warningBoxHide:YES andView:self.view];
        }
        else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];

}
@end
