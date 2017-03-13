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
#import "XLquestionViewController.h"
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
    //当前错题循环次数
    int qqq;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *beijing;
@property (weak, nonatomic) IBOutlet UILabel *wenti;
@property (weak, nonatomic) IBOutlet UILabel *wentizhuti;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *tishi;
@property (weak, nonatomic) IBOutlet UIView *tishiview;
@property (weak, nonatomic) IBOutlet UIImageView *tishiimage;

@end

@implementation XLanswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    qqq=0;
    tijiaodaan=[[NSMutableArray alloc] init];
    iii=0;
    duicuo=1;
    dianjicishu=0;
    //NSLog(@"%@",_timuarr);
    //以下两个的顺序千万不要反
    [self chuangjiantable];
    [self quxuanxiang:_timuarr[iii]];
    [self comeback];
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhuii)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhuii{
    XLquestionViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"question"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
-(void)chuangjiantable{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    button=[[UIButton alloc] initWithFrame:CGRectMake(80, height-144, width-160, 44)];

    button.backgroundColor=[UIColor colorWithHexString:@"2fb870"];
    button.layer.cornerRadius=10;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.tintColor=[UIColor whiteColor];
    [button addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    button.hidden=YES;
    [self.view addSubview:button];
    _beijing.contentMode=UIViewContentModeScaleAspectFit;
    _beijing.frame=CGRectMake(0, 0, width, height/3-45);
        if (self.view.bounds.size.width == 375)
        {
            _beijing.frame=CGRectMake(0, 0, width, height/3-41);
        }
        else if (self.view.bounds.size.width == 320)
        {
           _beijing.frame=CGRectMake(0, 0, width, height/3-35);
        }
    _beijing.backgroundColor=[UIColor blackColor];
    _wenti.frame=CGRectMake(20, CGRectGetMaxY(_beijing.frame), 200, 30);
    
    
    _wentizhuti.frame=CGRectMake(40, CGRectGetMaxY(_wenti.frame)+5, width-40, 30);
    
    
    _tableview.frame=CGRectMake(20, CGRectGetMaxY(_wentizhuti.frame)+10, width-40, height-CGRectGetMaxY(_wentizhuti.frame)-54);
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.scrollEnabled =NO;
    if (self.view.bounds.size.width == 320)
    {
        _tableview.scrollEnabled =YES;
    }
    _tableview.backgroundColor=[UIColor colorWithHexString:@"ededed"];
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tishiimage bringSubviewToFront:_tableview];
    [_tishiimage bringSubviewToFront:_tishiview];
    _tishi.hidden=YES;
    _tishiview.hidden=YES;
    _tishiimage.hidden=YES;
}
-(void)quxuanxiang :(NSDictionary*)a1{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if ([_str isEqual:@"1"]) {
        self.navigationItem.title=[NSString stringWithFormat:@"当前答题进度:%d/%lu",iii+1,(unsigned long)_timuarr.count];
    }else{
        self.navigationItem.title=[NSString stringWithFormat:@"循环进度:%d/%@  答题进度:%d/%lu",qqq+1,_xunhuan,iii+1,(unsigned long)_timuarr.count];
    }
    _tishi.hidden=YES;
    _tishiview.hidden=YES;
    _tishiimage.hidden=YES;
    button.hidden=YES;
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
    [_wentizhuti setNumberOfLines:0];
    _wentizhuti.text=[_timuarr[iii] objectForKey:@"quesion"];
    //初始化段落，设置段落风格
    NSMutableParagraphStyle *paragraphstyle=[[NSMutableParagraphStyle alloc]init];
    paragraphstyle.lineBreakMode=NSLineBreakByCharWrapping;
    //设置label的字体和段落风格
    NSDictionary *dic=@{NSFontAttributeName:_wentizhuti.font,NSParagraphStyleAttributeName:paragraphstyle.copy};
    
    CGRect rect=[_wentizhuti.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-80, self.view.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];

    _wentizhuti.frame=CGRectMake(40, CGRectGetMaxY(_wenti.frame)+5, rect.size.width,rect.size.height);
    _tableview.frame = CGRectMake(20, CGRectGetMaxY(_wentizhuti.frame)+10, width-40, height-CGRectGetMaxY(_wentizhuti.frame)-54);
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
    CGFloat labelWidth = self.tableview.bounds.size.width - 40;
    
    NSAttributedString *test = [self attributedBodyTextAtIndexPath:indexPath];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
    
    CGRect rect = [test boundingRectWithSize:CGSizeMake(labelWidth, 0) options:options context:nil];
    
    return (CGFloat)(ceil(rect.size.height) + 20);
    
}

-(NSAttributedString *)attributedBodyTextAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSString *text = muarr[indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
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
                if ([_str isEqualToString:@"1"]) {
                    [tijiaodaan addObject:dd];
                }else{
                    if (qqq+1 == [_xunhuan intValue]) {
                        [tijiaodaan addObject:dd];
                    }
                }
                [self huidaduicuo:1];
            }else{
            NSDictionary*dd=[NSDictionary dictionaryWithObjectsAndKeys:[_timuarr[iii] objectForKey:@"id"],@"examId",@"1",@"quesionType",@"2",@"isRight", nil];
                if ([_str isEqualToString:@"1"]) {
                    [tijiaodaan addObject:dd];
                }else{
                    if (qqq+1 == [_xunhuan intValue]) {
                        [tijiaodaan addObject:dd];
                    }
                }
                duicuo=3;
                [self huidaduicuo:2];
            }
            int ui=(int)indexPath.row;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ui inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_timuarr.count==iii+1) {
                    if ([_str isEqual:@"1"]) {
                        [self tankuang];
                    }else{
                        if (qqq+1 == [_xunhuan intValue]) {
                            [self tankuang];
                        }else{
                            qqq++;
                            iii=0;
                            duicuo=1;
                            [self quxuanxiang:_timuarr[iii]];
                        }
                    }
                }else{
                    iii++;
                    duicuo=1;
                    [self quxuanxiang:_timuarr[iii]];
                }
            });
        }
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
        int ui=(int)indexPath.row;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ui inSection:0];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(void)huidaduicuo:(int)it{
    UIImage*image=[[UIImage alloc] init];
    NSString*tishiyu=[[NSString alloc] init];
    NSString*yanse=[[NSString alloc] init];
    if (it==1) {
        image=[UIImage imageNamed:@"回答正确.png"];
        tishiyu=@"恭喜!回答正确";
        yanse=@"45b7fe";
    }else{
        image=[UIImage imageNamed:@"回答错误.png"];
        tishiyu=@"哎呀!回答错啦";
        yanse=@"ff4d67";

    }
    
    _tishi.text=tishiyu;
    _tishiimage.image=image;
    _tishiview.backgroundColor=[UIColor colorWithHexString:yanse];
    _tishiview.hidden=NO;
    _tishiimage.hidden=NO;
    _tishi.hidden=NO;
}
//判断多选题的答案是否正确
-(void)queding{
    
    if (duodaan.length!=0)
    {
        button.hidden=YES;
   // NSLog(@"我是确定按钮");
    NSString*zhengda= [[NSString stringWithFormat:@"%@",[_timuarr[iii] objectForKey:@"answer"]] uppercaseString];
    if (duodaan.length == zhengda.length) {
        NSMutableArray *stringArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < duodaan.length; i ++) {
            NSRange range;
            range.location = i;
            range.length = 1;
            NSString *tempString = [duodaan substringWithRange:range];
            [stringArray addObject:tempString];
        }        int q=0;
        for (NSString*ss in stringArray) {
           // NSLog(@"%@-----%@",zhengda,ss);
            if (![zhengda containsString:[NSString stringWithFormat:@"%@",ss]]) {
                
                q=1;
            }
        }
        if (q==1) {
            //答错了   爆红  哭脸
            
            [self huidaduicuo:2];
            
            NSDictionary*dd=[NSDictionary dictionaryWithObjectsAndKeys:[_timuarr[iii] objectForKey:@"id"],@"examId",@"2",@"quesionType",@"2",@"isRight", nil];
            if ([_str isEqualToString:@"1"]) {
                [tijiaodaan addObject:dd];
            }else{
                if (qqq+1 == [_xunhuan intValue]) {
                    [tijiaodaan addObject:dd];
                }
            }
        }else{
            //答对了   爆绿  笑脸
            [self huidaduicuo:1];
            
            
            NSDictionary*dd=[NSDictionary dictionaryWithObjectsAndKeys:[_timuarr[iii] objectForKey:@"id"],@"examId",@"2",@"quesionType",@"1",@"isRight", nil];
            if ([_str isEqualToString:@"1"]) {
                [tijiaodaan addObject:dd];
            }else{
                if (qqq+1 == [_xunhuan intValue]) {
                    [tijiaodaan addObject:dd];
                }
            }
        }
    }else{
        //答错了   爆红  哭脸
        [self huidaduicuo:2];
        
        NSDictionary*dd=[NSDictionary dictionaryWithObjectsAndKeys:[_timuarr[iii] objectForKey:@"id"],@"examId",@"2",@"quesionType",@"2",@"isRight", nil];
        if ([_str isEqualToString:@"1"]) {
            [tijiaodaan addObject:dd];
        }else{
            if (qqq+1 == [_xunhuan intValue]) {
                [tijiaodaan addObject:dd];
            }
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_timuarr.count==iii+1) {
            if ([_str isEqual:@"1"]) {
                [self tankuang];
            }else{
                if (qqq+1 == [_xunhuan intValue]) {
                    [self tankuang];
                }else{
                    qqq++;
                    iii=0;
                    duicuo=1;
                    [self quxuanxiang:_timuarr[iii]];
                }
            }
        }else{
            iii++;
            duicuo=1;
            [self quxuanxiang:_timuarr[iii]];
        }
    });
    }
    else
    {
        [WarningBox warningBoxModeText:@"请先选择答案" andView:self.view];
    }
}
-(void)tankuang{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提交提示" message:@"本次题目已全部答完，是否提交成绩?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self tijiaodaananniu];
    
    }];
    UIAlertAction*action2=[UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self fanhui];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:^{
    }];
    
}
-(void)tijiaodaananniu{
    if([_str isEqualToString:@"1"]){
        [self tijiaoquanbu];
    }else if([_str isEqualToString:@"2"]){
        [self tijiaocuowu];
    }
}
-(void)tijiaoquanbu{
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@"正在提交答案..."] andView:self.view];
    NSString *fangshi=@"/exam/answerAll";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",_mobanID,@"templateId",tijiaodaan,@"examList",_templateAssignId,@"templateAssignId",  nil];
    //NSLog(@"%@",rucan);
    //自己写的网络请求    请求外网地址
    
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            [WarningBox warningBoxModeText:@"提交答案成功" andView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fanhui];
            });
        }else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
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
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",_mobanID,@"templateId",tijiaodaan,@"examList",_templateAssignId,@"templateAssignId", nil];
    //NSLog(@"%@",rucan);
    
    //自己写的网络请求    请求外网地址
    
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
       // NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            [WarningBox warningBoxModeText:@"提交重做答案成功" andView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fanhui];
            });
            
        }else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
        else{
            [WarningBox warningBoxModeText:@"提交重做答案失败，请重试!" andView:self.view];
        }
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败!" andView:self.view];
        NSLog(@"%@",error);
    }];
    
}
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
