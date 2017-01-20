//
//  XLKaoQinViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/1/18.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XLKaoQinViewController.h"
#import "DurgTableViewCell.h"
#import "TianTableViewCell.h"
@interface XLKaoQinViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    UITableView *remindTable;
    
    float width,height;
    
    UIView *back;
    
    NSTimer *ttm;
    
    int shu;
    
    int flagg;
    
    int sectionn;
    
    
    NSMutableArray *pathArray;   //读取plist文件里的内容
    int deleteInt;               //要删除第几个闹钟
    NSString *path;              //保存闹钟plist文件的路径
    int mm;   //判断是否发送通知
    
    UIView *popview;
    
    NSMutableArray *shuju;
    
    UIPickerView *pp;
    
}
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation XLKaoQinViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    
    flagg=0;
    
    shu=0;
    //时间数组
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        shuju=[[NSMutableArray alloc] init];

        [shuju addObject:@"0:00"];
        [shuju addObject:@"0:30"];
        [shuju addObject:@"1:00"];
        [shuju addObject:@"1:30"];
        [shuju addObject:@"2:00"];
        [shuju addObject:@"2:30"];
        [shuju addObject:@"3:00"];
        [shuju addObject:@"3:30"];
        [shuju addObject:@"4:00"];
        [shuju addObject:@"4:30"];
        [shuju addObject:@"5:00"];
        [shuju addObject:@"5:30"];
        [shuju addObject:@"6:00"];
        [shuju addObject:@"6:30"];
        [shuju addObject:@"7:00"];
        [shuju addObject:@"7:30"];
        [shuju addObject:@"8:00"];
        [shuju addObject:@"8:30"];
        [shuju addObject:@"9:00"];
        [shuju addObject:@"9:30"];
        [shuju addObject:@"10:00"];
        [shuju addObject:@"10:30"];
        [shuju addObject:@"11:00"];
        [shuju addObject:@"11:30"];
        [shuju addObject:@"12:00"];
        [shuju addObject:@"12:30"];
        [shuju addObject:@"13:00"];
        [shuju addObject:@"13:30"];
        [shuju addObject:@"14:00"];
        [shuju addObject:@"14:30"];
        [shuju addObject:@"15:00"];
        [shuju addObject:@"15:30"];
        [shuju addObject:@"16:10"];
        [shuju addObject:@"16:30"];
        [shuju addObject:@"17:00"];
        [shuju addObject:@"17:30"];
        [shuju addObject:@"18:00"];
        [shuju addObject:@"18:30"];
        [shuju addObject:@"19:00"];
        [shuju addObject:@"19:30"];
        [shuju addObject:@"20:00"];
        [shuju addObject:@"20:30"];
        [shuju addObject:@"21:00"];
        [shuju addObject:@"21:30"];
        [shuju addObject:@"22:00"];
        [shuju addObject:@"22:30"];
        [shuju addObject:@"23:00"];
        [shuju addObject:@"23:30"];
        //[shuju addObject:@"无"];
   
    //弹出的对话框
  
        width=[[UIScreen mainScreen] bounds].size.width;
        
        height=[[UIScreen mainScreen] bounds].size.height;
        
        self.title = @"考勤设置";
        
        popview=[[UIView alloc] initWithFrame:CGRectMake(0, height, width, 280)];
        popview.backgroundColor=[UIColor whiteColor];
        UILabel *text1=[[UILabel alloc] initWithFrame:CGRectMake(width/2-50, 4,100, 20)];
        text1.textColor=[UIColor blackColor];
        text1.textAlignment=NSTextAlignmentCenter;
        text1.text=@"提醒时间";
        [popview addSubview:text1];
        
        pp=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 24, width, 160)];
        pp.dataSource=self;
        pp.delegate=self;
        [pp selectRow:12 inComponent:0 animated:NO];
        [popview addSubview:pp];
        back=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        back.backgroundColor=[UIColor grayColor];
        back.alpha=0.0f;
        [self.view addSubview:back];
        
        
        
        UIButton *queding=[[UIButton alloc] initWithFrame:CGRectMake(0, 180, width, 44)];
        
        [queding setTitle:@"确定" forState:UIControlStateNormal];
        [queding setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        queding.backgroundColor=[UIColor colorWithRed:117.0/255 green:180.0/255 blue:100.0/255 alpha:1];
        
        [queding addTarget:self action:@selector(choossok) forControlEvents:UIControlEventTouchUpInside];
        
        [popview addSubview:queding];
        
        UIButton *queding1=[[UIButton alloc] initWithFrame:CGRectMake(0, 234, width, 44)];
        
        [queding1 setTitle:@"取消" forState:UIControlStateNormal];
        [queding1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [queding1 addTarget:self action:@selector(choossno) forControlEvents:UIControlEventTouchUpInside];
        
        queding1.backgroundColor=[UIColor grayColor];
        
        [popview addSubview:queding1];
  
    //tableview
   
        remindTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, width, height - 64)];
        
        remindTable.backgroundColor = [UIColor clearColor];
        remindTable.delegate = self;
        remindTable.dataSource = self;
        remindTable.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:remindTable];

    
    
    [self.view addSubview:popview];
    
    
    path = [NSHomeDirectory() stringByAppendingString:@"/Documents/durgRemindList.plist"];
    NSLog(@"%@",path);
    pathArray = [[NSMutableArray alloc]init];
    
    [self comeback];
    // Do any additional setup after loading the view.
}

-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhuii{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---设置提醒的确定
-(void)choossok{
    
    [UIView animateWithDuration:0.7 animations:^{
        
        popview.frame=CGRectMake(0, height, width, 280);
        
        back.alpha=0.0f;
        back.hidden=YES;
        
        
    }completion:nil];
    
    NSString *str1=shuju[[pp selectedRowInComponent:0]];
    
    int aa=0;
    
    NSMutableArray *asd=[[NSMutableArray alloc] init];
    
    if (![str1 isEqualToString:@"无"]){
        aa=1;
        
    }
    
    [asd addObject:str1];
    
    
    NSString *riqi=[asd componentsJoinedByString:@" "];
    
    int oo=aa;
    
    NSString *tit;
    
    switch (oo) {
        case 1:
            tit=@"考勤提醒";
            break;
            
        default:
            break;
    }
    
    NSDictionary *dic=@{@"title":tit,@"riqi":riqi,@"ison":@"0"};
    
    NSString *yhidString = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] intValue]];
    
    NSDictionary *asdd=@{@"yhid":yhidString,@"neirong":dic};
    
    if (flagg!=8) {
        
        NSMutableArray *arrasd=[[NSMutableArray alloc] initWithContentsOfFile:path];
        if (arrasd!=nil) {
            [arrasd addObject:asdd];
        }
        else
        {
            arrasd=[[NSMutableArray alloc] init];
            [arrasd addObject:asdd];
        }
        
        [arrasd writeToFile:path atomically:YES];
        
    }
    else{
        
        NSMutableArray *arrasd=[[NSMutableArray alloc] initWithContentsOfFile:path];
        
        [arrasd removeObjectAtIndex:sectionn];
        [arrasd insertObject:asdd atIndex:sectionn];
        
        [arrasd writeToFile:path atomically:YES];
        
        flagg=0;
        
    }
    
    [self readDurgRemindPlist];
    
    
    [remindTable reloadData];
    
    
}

#pragma mark---设置提醒的取消
-(void)choossno{
    
    
    [UIView animateWithDuration:0.7 animations:^{
        
        popview.frame=CGRectMake(0, height, width, 280);
        
        back.alpha=0.0f;
        back.hidden=YES;
        
        
        
    }completion:nil];
    
    flagg=0;
    
}
-(void)poppp
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)readDurgRemindPlist{
    
    
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
    
    //获取用户id
    
    NSString *yhidString = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] intValue]];
    
    [pathArray removeAllObjects];
    
    if (array !=nil && [array count]>0) {
        
        //获取某一个id的内容
        for (int i = 0 ; i < array.count; i++) {
            
            NSString *key1=[array[i] objectForKey:@"yhid"];
            
            BOOL flag=[key1 isEqualToString:yhidString];
            
            if (flag) {
                
                [pathArray addObject:[array[i] objectForKey:@"neirong"]];
                
            }
            
        }
    }
    
    else{
        
    }
    
}




#pragma mark--pickerview
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [shuju count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [shuju objectAtIndex:row];
}



- (void)viewWillAppear:(BOOL)animated
{
    
    [self readDurgRemindPlist];    //调用读文件的方法,判断是否显示提醒视图
    [remindTable reloadData];  //更新tableViee数据
    if (mm == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"轮回公子" object:nil];
    }
    
}
//



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return pathArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }
    else
        return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==pathArray.count) {
        return 60;
    }
    return 80;
    
}


#pragma mark----tableview点击弹出pickerview
- (void)tianjia{
    
    
    if (ttm!=nil)
        [ttm invalidate];
    
    ttm=nil;
    
    shu=0;
    
    [self.view bringSubviewToFront:back];
    [self.view bringSubviewToFront:popview];
    
    back.hidden=NO;
    
    ttm= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(bian) userInfo:nil repeats:YES];
    
    [UIView animateWithDuration:1 animations:^{
        
        popview.frame=CGRectMake(0, height-280, width, 280);
        
    }completion:nil];
    
}

- (void)bian{
    
    shu++;
    
    back.alpha=shu*0.1;
    
    if (shu==8) {
        
        [ttm invalidate];
        
        ttm=nil;
        
        shu=0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //cell.width1=width;
    
    if (indexPath.section==[pathArray count]) {
        
        
        TianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mmod"];
        
        if (!cell) {
            cell = [[TianTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mmod"];
        }
        
        cell.botline.frame= CGRectMake(0, 59, width, 1);
        cell.botline.backgroundColor=[UIColor lightGrayColor];
        cell.add.frame=CGRectMake(0, 0, width, 60);
        
        [cell.add setTitle:@"添加提醒" forState:UIControlStateNormal];
        
        [cell.add setTitleColor:[UIColor colorWithRed:117.0/255 green:180.0/255 blue:100.0/255 alpha:1] forState:UIControlStateNormal];
        
        
        cell.add.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        
        [cell.add addTarget:self action:@selector(tianjia) forControlEvents:UIControlEventTouchUpInside];
        
        //隐藏滑动条
        self.tableview.showsVerticalScrollIndicator =NO;
        return cell;
        
        
    }
    
    else{
        
        DurgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[DurgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.topline.frame=CGRectMake(0, 0, width, 1);
        cell.botline.frame=CGRectMake(0, 79, width, 1);
        cell.sw.frame=CGRectMake(width-66, 30, 30, 20);
        
        cell.ll1.text=[[pathArray objectAtIndex:indexPath.section] objectForKey:@"title"];
        
        NSString *asd= [[pathArray objectAtIndex:indexPath.section] objectForKey:@"riqi"];
        
        NSArray *mnb=[asd componentsSeparatedByString:@" "];
        NSMutableArray *rt=[[NSMutableArray alloc] init];
        
        for (NSString *ser in mnb) {
            
            if (![ser isEqualToString:@"无"])
                
                [rt addObject:ser];
        }
        
        
        
        cell.ll2.text=[rt componentsJoinedByString:@" "];
        
        BOOL kk=[[[pathArray objectAtIndex:indexPath.section] objectForKey:@"ison"] isEqualToString:@"0"];
        
        [cell.sw setOn:((kk)? NO :YES)];
        
        cell.sw.tag=100+indexPath.section;
        
        [cell.sw addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventValueChanged];
        
        //隐藏滑动条
        self.tableview.showsVerticalScrollIndicator =NO;
        return cell;
        
    }
    
}


-(void)qiehuan:(UISwitch *)ss{
    
    int mmm=(int)ss.tag-100;
    
    NSString *status;
    
    if (ss.isOn) {
        status=@"1";
    }
    else{
        status=@"0";
    }
    NSMutableArray *wqe=[[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary *dic=[wqe[mmm] objectForKey:@"neirong"];
    
    [dic setValue:status forKey:@"ison"];
    
    [wqe writeToFile:path atomically:YES];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"轮回公子" object:nil];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([pathArray count]>(int)indexPath.section) {
        
        
        flagg=8;
        
        DurgTableViewCell *cc=(DurgTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        cc.selectionStyle=UITableViewCellSelectionStyleNone;
        
        sectionn=(int)indexPath.section;
        
        NSMutableArray *fdata=[[NSMutableArray alloc] initWithContentsOfFile:path];
        NSDictionary *dfg=[fdata objectAtIndex:indexPath.section];
        
        NSArray *riri=[[[dfg objectForKey:@"neirong"] objectForKey:@"riqi"] componentsSeparatedByString:@" "];
        
        int mm1=(int)[shuju indexOfObject:riri[0]];
        
        
        [pp selectRow:mm1 inComponent:0 animated:YES];
        
        [self tianjia];
        
    }
    
    else{
        
        TianTableViewCell *ce=(TianTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        ce.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section!=[pathArray count])
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [remindTable setEditing:NO];
        
        [pathArray removeObjectAtIndex:indexPath.section];
        
        NSMutableArray *wew=[[NSMutableArray alloc] initWithContentsOfFile:path];
        
        
        [wew removeObjectAtIndex:indexPath.section];
        
        [wew writeToFile:path atomically:YES];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"轮回公子" object:nil];
        
        [remindTable reloadData];
        
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end

