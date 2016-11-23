//
//  XLanswerViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 16/11/15.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLanswerViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "Color+Hex.h"
@interface XLanswerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    //答案的个数
    NSMutableArray*muarr;
    //题目的个数
    NSArray*_timuarr;
    //第几个题目
    int iii;
    //答对了还是打错了
    int duicuo;
    //需要提交的数组
    NSMutableArray*tijiaodaan;
    //单选题不能点击多个答案
    int dianjicishu;
    
    //多选题选项判断；
    int panA,panB,panC,panD,panE;
    //多选题答案
    NSString*duodaan;
    //多选题的确定按钮
    UIButton *button;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *beijing;
@property (weak, nonatomic) IBOutlet UILabel *wenti;
@property (weak, nonatomic) IBOutlet UILabel *wentizhuti;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation XLanswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tijiaodaan=[[NSMutableArray alloc] init];
    iii=0;
    duicuo=1;
    dianjicishu=0;
    NSDictionary *d1=[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"answer",@"1",@"id",@"你说我选啥",@"optionA",@"选啥就撒的空间哈哈哈哈哈哈哈",@"optionB",@"么么哒",@"optionC",@"",@"optionD",@"",@"optionE",@"问点啥呢",@"quesion",@"1",@"quesionType", nil];
    NSDictionary *d2=[NSDictionary dictionaryWithObjectsAndKeys:@"c",@"answer",@"3",@"id",@"go come",@"optionA",@"我是错的",@"optionB",@"我对",@"optionC",@"这是单选？",@"optionD",@"嗯，是",@"optionE",@"狗不理包子",@"quesion",@"1",@"quesionType", nil];
    NSDictionary *d3=[NSDictionary dictionaryWithObjectsAndKeys:@"ac",@"answer",@"3",@"id",@"go come",@"optionA",@"我是错的",@"optionB",@"我对",@"optionC",@"这是单选？",@"optionD",@"嗯，是",@"optionE",@"我是一个多选题吗？",@"quesion",@"2",@"quesionType", nil];
    _timuarr=[NSArray arrayWithObjects:d1,d2,d3, nil];
    [self quxuanxiang:_timuarr[iii]];
    [self chuangjiantable];
    
}
-(void)chuangjiantable{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    button=[[UIButton alloc] initWithFrame:CGRectMake(80, height-100, width-160, 44)];
    button.backgroundColor=[UIColor colorWithHexString:@"2fb870"];
    button.layer.cornerRadius=10;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.tintColor=[UIColor whiteColor];
    [button addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    button.hidden=YES;
    [self.view addSubview:button];
    
    _beijing.frame=CGRectMake(0, 64, width, height/3);
    _beijing.backgroundColor=[UIColor blackColor];
    _wenti.frame=CGRectMake(20, CGRectGetMaxY(_beijing.frame), 200, 30);
    _wentizhuti.frame=CGRectMake(40, CGRectGetMaxY(_wenti.frame)+5, width-40, 30);
    _tableview.frame=CGRectMake(20, CGRectGetMaxY(_wentizhuti.frame)+10, width-40, height-CGRectGetMaxY(_wentizhuti.frame)-54);
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.scrollEnabled =NO;
    _tableview.backgroundColor=[UIColor colorWithHexString:@"ededed"];
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)quxuanxiang :(NSDictionary*)a1{
    if ([_str isEqual:@"1"]) {
        self.navigationItem.title=[NSString stringWithFormat:@"%d/%lu",iii+1,(unsigned long)_timuarr.count];
    }else{
        self.navigationItem.title=[NSString stringWithFormat:@"%d/%lu",iii+1,(unsigned long)_timuarr.count];
    }
    dianjicishu=0;
    muarr=[[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        NSString*str;
        if (i==0) {
            str=[a1 objectForKey:@"optionA"];
        }else if (i==1){
            str=[a1 objectForKey:@"optionB"];
        }else if (i==2){
            str=[a1 objectForKey:@"optionC"];
        }else if (i==3){
            str=[a1 objectForKey:@"optionD"];
        }else if (i==4){
            str=[a1 objectForKey:@"optionE"];
        }
        if (![str isEqual:@""]) {
            [muarr addObject:str];
        }
    }
    if ([[_timuarr[iii] objectForKey:@"quesionType"]isEqualToString:@"2"]) {
        button.hidden=NO;
        _wenti.text=@"(多选)问题:";
    }else{
        button.hidden=YES;
        _wenti.text=@"问题:";
    }
    _wentizhuti.text=[_timuarr[iii] objectForKey:@"quesion"];
    [_tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return muarr.count;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"dati";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    
    UIImageView *imageview=[cell viewWithTag:101];
    UIImage*image=[self image:indexPath :duicuo];
    imageview.image=image;
    UILabel *xuanxiang=[cell viewWithTag:102];
    xuanxiang.text=[NSString stringWithFormat:@"%@",muarr[indexPath.row]];
    cell.backgroundColor=[UIColor colorWithHexString:@"ededed"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIImage*)image:(NSIndexPath *)indexPath :(int)ll{
    UIImage*image;
    if (indexPath.row==0) {
        image=[UIImage imageNamed:[NSString stringWithFormat:@"A%d.png",ll]];
    }else if (indexPath.row==1) {
        image=[UIImage imageNamed:[NSString stringWithFormat:@"B%d.png",ll]];
    }else if (indexPath.row==2) {
        image=[UIImage imageNamed:[NSString stringWithFormat:@"C%d.png",ll]];
    }else if (indexPath.row==3) {
        image=[UIImage imageNamed:[NSString stringWithFormat:@"D%d.png",ll]];
    }else if (indexPath.row==4) {
        image=[UIImage imageNamed:[NSString stringWithFormat:@"E%d.png",ll]];
    }
    return image;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // －20    左右距两边各为10;
    CGFloat labelWidth = self.tableview.bounds.size.width - 20;
    
    NSAttributedString *test = [self attributedBodyTextAtIndexPath:indexPath];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
    
    CGRect rect = [test boundingRectWithSize:CGSizeMake(labelWidth, 0) options:options context:nil];
    
    return (CGFloat)(ceil(rect.size.height) + 20);
    
}

-(NSAttributedString *)attributedBodyTextAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSString *text = muarr[indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    //[UIFont fontWithName:@"Arial-BoldItalicMT" size:17];
    
    NSDictionary *testDic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:testDic];
    
    return string;
    
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(duicuo==1){
        //设置Cell的动画效果为3D效果
        //设置x和y的初始值为0.1；
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        //x和y的最终值为1
        [UIView animateWithDuration:1 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[_timuarr[iii] objectForKey:@"quesionType"]isEqualToString:@"1"])
    {
        if (dianjicishu!=0) {
            
        }else{
            dianjicishu++;
            
            NSString* dada=[[NSString alloc] init];
            if (indexPath.row==0) {
                dada=@"A";
            }else if (indexPath.row==1){
                dada=@"B";
            }else if (indexPath.row==2){
                dada=@"C";
            }else if (indexPath.row==3){
                dada=@"D";
            }else if (indexPath.row==4){
                dada=@"E";
            }
            NSString*zhengda= [[NSString stringWithFormat:@"%@",[_timuarr[iii] objectForKey:@"answer"]] uppercaseString];
            if ([dada isEqualToString:zhengda]) {
                duicuo=2;
                NSDictionary*dd=[NSDictionary dictionaryWithObjectsAndKeys:[_timuarr[iii] objectForKey:@"id"],@"examId",@"1",@"quesionType",@"1",@"isRight", nil];
                [tijiaodaan addObject:dd];
            }else{
                NSDictionary*dd=[NSDictionary dictionaryWithObjectsAndKeys:[_timuarr[iii] objectForKey:@"id"],@"examId",@"1",@"quesionType",@"2",@"isRight", nil];
                [tijiaodaan addObject:dd];
                duicuo=3;
            }
            
            
            int ui=(int)indexPath.row;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ui inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_timuarr.count==iii+1) {
                    NSLog(@"提交答题结果");
                }else{
                    iii++;
                    duicuo=1;
                    [self quxuanxiang:_timuarr[iii]];
                }
            });
        }
        NSLog(@"\n已选的答案:%@",tijiaodaan);
    }
    
    //多选题的判断
    else{
        
        if (indexPath.row==0) {
            if (panA==0) {
                panA=1;
                duicuo=4;
                if (duodaan.length==0) {
                    duodaan=@"A";
                }else{
                    duodaan=[duodaan stringByAppendingString:@"A"];
                }
            }else{
                duicuo=5;
                panA=0;
                duodaan=[duodaan stringByReplacingOccurrencesOfString:@"A" withString:@""];
            }
            
            
        }else if (indexPath.row==1){
            if (panB==0) {
                panB=1;
                duicuo=4;
                if (duodaan.length==0) {
                    duodaan=@"B";
                }else{
                    duodaan=[duodaan stringByAppendingString:@"B"];
                }
            }else{
                duicuo=5;
                panB=0;
                duodaan=[duodaan stringByReplacingOccurrencesOfString:@"B" withString:@""];
            }
        }else if (indexPath.row==2){
            if (panC==0) {
                panC=1;
                duicuo=4;
                if (duodaan.length==0) {
                    duodaan=@"C";
                }else{
                    duodaan=[duodaan stringByAppendingString:@"C"];
                }
            }else{
                panC=0;
                duicuo=5;
                duodaan=[duodaan stringByReplacingOccurrencesOfString:@"C" withString:@""];
            }
        }else if (indexPath.row==3){
            if (panD==0) {
                panD=1;
                duicuo=4;
                if (duodaan.length==0) {
                    duodaan=@"D";
                }else{
                    duodaan=[duodaan stringByAppendingString:@"D"];
                }
            }else{
                panD=0;
                duicuo=5;
                duodaan=[duodaan stringByReplacingOccurrencesOfString:@"D" withString:@""];
            }
        }else if (indexPath.row==4){
            if (panE==0) {
                panE=1;
                duicuo=4;
                if (duodaan.length==0) {
                    duodaan=@"E";
                }else{
                    duodaan=[duodaan stringByAppendingString:@"E"];
                }
            }else{
                panE=0;
                duicuo=5;
                duodaan=[duodaan stringByReplacingOccurrencesOfString:@"E" withString:@""];
            }
        }
        NSLog(@"%@",duodaan);
        int ui=(int)indexPath.row;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ui inSection:0];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
//判断多选题的答案是否正确
-(void)queding{
    NSLog(@"我是确定按钮");
    NSString*zhengda= [[NSString stringWithFormat:@"%@",[_timuarr[iii] objectForKey:@"answer"]] uppercaseString];
    if (duodaan.length == zhengda.length) {
        
    }else{
        //答错了   爆红  哭脸
    }
    
}
-(void)tijiaodaan{
    if([_str isEqualToString:@"1"]){
        [self tijiaoquanbu];
    }else if([_str isEqualToString:@"2"]){
        [self tijiaocuowu];
    }
}
-(void)tijiaoquanbu{
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@"正在提交答案..."] andView:self.view];
    NSString *fangshi=@"/exam/answerAll";
    //    NSDictionary*d1=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"examId",@"1",@"quesionType",@"1",@"isRight",nil];
    //    NSDictionary*d2=[NSDictionary dictionaryWithObjectsAndKeys:@"9",@"examId",@"1",@"quesionType",  @"2",@"isRight",nil];
    //    NSDictionary*d3=[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"examId",@"1",@"quesionType",@"1",@"isRight",nil];
    //    NSDictionary*d4=[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"examId",@"1",@"quesionType",@"2",@"isRight",nil];
    //    NSDictionary*d5=[NSDictionary dictionaryWithObjectsAndKeys:@"5",@"examId",@"1",@"quesionType",@"1",@"isRight",nil];
    //    NSArray*examList=[NSArray arrayWithObjects:d1,d2,d3,d4,d5, nil];
    //
    
    
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"userId",_mobanID,@"templateId",tijiaodaan,@"examList", nil];
    NSLog(@"%@",rucan);
    //自己写的网络请求    请求外网地址
    
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            [WarningBox warningBoxModeText:@"提交答案成功" andView:self.view];
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"错了吧～  哈哈哈哈" andView:self.view];
        NSLog(@"%@",error);
    }];
    
}
-(void)tijiaocuowu{
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@"正在提交重做答案..."] andView:self.view];
    NSString *fangshi=@"/exam/answerError";
    
    
    NSDictionary*d2=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"examId",@"1",@"isRight",nil];
    
    NSDictionary*d4=[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"examId",@"1",@"isRight",nil];
    
    NSArray*examList=[NSArray arrayWithObjects:d2,d4, nil];
    
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"userId",_mobanID,@"templateId",examList,@"examList", nil];
    NSLog(@"%@",rucan);
    
    //自己写的网络请求    请求外网地址
    
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            [WarningBox warningBoxModeText:@"提交重做答案成功" andView:self.view];
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"错了吧～  哈哈哈哈" andView:self.view];
        NSLog(@"%@",error);
    }];
    
}
@end
