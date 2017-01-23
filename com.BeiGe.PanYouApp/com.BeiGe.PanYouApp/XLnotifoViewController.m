//
//  XLnotifoViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/1/22.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XLnotifoViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "XL_Header.h"
#import "XLNoteViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Color+Hex.h"
#import "XLImageShow.h"
@interface XLnotifoViewController ()<UITextViewDelegate>
{
    float width;
    float height;
    UILabel *titt;
    UILabel *mess;
    NSDictionary*pushTemplate;
    UIImageView *image;//网络图片
    UITextView *textview;//备注
    UIButton *renwuanniu;//完成按钮
    UIView *Mview;
    UILabel *placeor;
    int caca;
    CGFloat cha;
    int pan;
}
@end

@implementation XLnotifoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
   
    _tableview.delegate =self;
    _tableview.dataSource= self;
    [self xiangqingjiekou];
    [self navigation];
    [self registerForKeyboardNotifications];

    if([_zhT isEqualToString:@"1"]){
        _zhT=@"2";
        [self anniujiekou:_zhT];
    }
    
    self.title = @"通知详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-block传值
//block传值 方法
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

#pragma mark--接口
-(void)xiangqingjiekou{
    NSString *fangshi=@"/push/pushDetail";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_pushInfoId,@"pushInfoId", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            pushTemplate=[[responseObject objectForKey:@"data"] objectForKey:@"pushTemplate"];
            if ([pushTemplate isEqual:@""]) {
                _tableview.hidden =YES;
            }else{
            _tableview.hidden =NO;
            }
            
            
            
            [_tableview reloadData];
        }else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
    
}
-(void)anniujiekou:(NSString*)str{
    NSString *fangshi=@"/push/progress";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString*remarks=[NSString string];
    if ([str isEqual:@"4"]) {
        remarks=textview.text;
    }
    
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_pushInfoId,@"pushId",UserID,@"userId",str,@"progressStatus",remarks,@"remarks", nil];
//    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
//        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            
            if([str isEqualToString:@"2"]){
                
            }else{
                if (self.returnTextBlock != nil) {
                    self.returnTextBlock(str);
                }
                [self fanhui];
            }
           
        }else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
        
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 5;
    }
    else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0)
    {
        return 0;
    }
    else if (section == 1)
    {
        return 10;
    }
    else if (section == 2)
    {
        return 10;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
     if (indexPath.section ==0){
       if(indexPath.row==0){
            return 60;
        }
       else if(indexPath.row==1){
            //根据lable返回行高
           
            NSString* s=[[NSString alloc] init];
           if(nil==[pushTemplate objectForKey:@"title"]){
               s =@"";
           }else{
               s =[NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"title"]];
           }
            titt=[[UILabel alloc] init];
            UIFont *font = [UIFont fontWithName:@"Arial" size:20];
            titt.textAlignment =NSTextAlignmentCenter;
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]initWithString:s attributes:@{NSFontAttributeName: font}];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){width-40, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            
           
            titt.text=s;
            [titt setFrame:CGRectMake(20,4,width-40, rect.size.height)];
            return titt.frame.size.height+15>40? titt.frame.size.height+15:40;
            
       }
       else if (indexPath.row==2){
           return 150;
       }
       else if(indexPath.row==3){
           //根据lable返回行高
           NSString* ss=[[NSString alloc] init];
           if(nil==[pushTemplate objectForKey:@"title"]){
               ss =@"";
           }else{
               ss =[NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"context"]];
           }
      
          mess=[[UILabel alloc] init];
           UIFont *font = [UIFont fontWithName:@"Arial" size:15];
           NSAttributedString *attributedText =
           [[NSAttributedString alloc]initWithString:ss attributes:@{NSFontAttributeName: font}];
           CGRect rect = [attributedText boundingRectWithSize:(CGSize){width-40, CGFLOAT_MAX}
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
           
           mess.text=ss;
           [mess setFrame:CGRectMake(20,4, rect.size.width, rect.size.height)];
           
           return mess.frame.size.height+15>40? mess.frame.size.height+5:40;
       }
       else{
           return 40;
       }
       
    }
     else if (indexPath.section == 1){
         if([_zhT isEqualToString:@"1"]||[_zhT isEqualToString:@"2"]){
             return 0;
         }else{
          return 130;
         }
       
    }
    else if (indexPath.section == 2){
        if([_zhT isEqualToString:@"4"]){
            return 0;
        }else{
        return 50;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"tzxq";
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    if(indexPath.section==0){
        if(indexPath.row==0){
            UIView *sdid = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
            sdid.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
            UIImageView *images = [[UIImageView alloc]init];
            images.frame = CGRectMake(width/2-20,10,40,40);
            images.image =[UIImage imageNamed:@"通知详情.png"];
            [cell.contentView addSubview:sdid];
            [cell.contentView addSubview:images];
          
        }
        else if (indexPath.row==1){
            titt.numberOfLines=0;
         
            titt.font=[UIFont fontWithName:@"Arial" size:20];
            titt.textColor=[UIColor colorWithHexString:@"323232"];
             [cell.contentView addSubview:titt];
        }
        else if (indexPath.row==2){
            image = [[UIImageView alloc]init];
            image.frame = CGRectMake(0,0,width,150);
            if([pushTemplate objectForKey:@"image"]!=nil){
            //image.contentMode = UIViewContentModeScaleAspectFill;
            image.contentMode = UIViewContentModeScaleAspectFit;
            image.clipsToBounds  = YES;//是否剪切掉超出 UIImageView 范围的图片
            [image setContentScaleFactor:[[UIScreen mainScreen] scale]];//缩放图片的分辨率
            NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",Scheme,QianWaiWangIP,[pushTemplate objectForKey:@"image"]]];
            [image sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"icon_02_07.png"]];
           }
             [self Imageshows];
           [cell.contentView addSubview:image];
    
        }
        else if (indexPath.row==3){
            mess.numberOfLines=0;
            mess.font= [UIFont systemFontOfSize:14];
            mess.textColor=[UIColor colorWithHexString:@"323232"];
            [cell.contentView addSubview:mess];
         
        }
        else{
            UILabel *laiy= [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 20)];
            UILabel *time= [[UILabel alloc]initWithFrame:CGRectMake(width-145, 10, 130, 20)];
            laiy.textColor =[UIColor colorWithHexString:@"fd8f30"];
            time.textColor =[UIColor colorWithHexString:@"fd8f30"];
            laiy.font= [UIFont systemFontOfSize:14];
            time.font= [UIFont systemFontOfSize:14];
            laiy.textAlignment = NSTextAlignmentLeft;
            time.textAlignment = NSTextAlignmentRight;
            if(nil==[pushTemplate objectForKey:@"pushSrc"]){
                laiy.text =@"";
            }else{
                laiy.text = [NSString stringWithFormat:@"来源:%@",[pushTemplate objectForKey:@"pushSrc"]];
            }
            
            
            if(nil==[pushTemplate objectForKey:@"createTime"]){
                time.text =@"";
            }else{
                NSString *ss =[NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"createTime"]];
                NSString *sss = [ss substringToIndex:10];
                time.text =sss;
            }
   
            [cell.contentView addSubview:laiy];
            [cell.contentView addSubview:time];
            
        }
    
    }
    else if (indexPath.section==1){
        Mview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 130)];
        UILabel *beiz = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 40, 20)];
        beiz.textColor =[UIColor colorWithHexString:@"fd8f30"];
        beiz.font= [UIFont systemFontOfSize:14];
        beiz.text =@"备注:";
        textview = [[UITextView alloc]initWithFrame:CGRectMake(60, 5, width-85, 120)];
        textview.delegate =self;
        
      
        [self tobar];
        [Mview addSubview:beiz];
        [Mview addSubview:textview];
        [cell.contentView addSubview:Mview];

        if([_zhT isEqualToString:@"1"]||[_zhT isEqualToString:@"2"]){
            Mview.hidden= YES;
        }else if ([_zhT isEqualToString:@"3"]){
            Mview.hidden= NO;
        }else{
            Mview.hidden= NO;
            caca=1;
            textview.userInteractionEnabled = NO;
        }
        textview.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 15);
        placeor = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
        
        placeor.text = @"请输入您的建议...";
        placeor.textColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:218.0/255 alpha:1.0];
        placeor.font =[UIFont systemFontOfSize:14];
        placeor.backgroundColor = [UIColor clearColor];
        if (caca!=1) {
            [textview addSubview:placeor];
        }
      
    }else{
       renwuanniu =[[UIButton alloc]initWithFrame:CGRectMake(30, 5, width-60, 40)];
        [renwuanniu.layer setCornerRadius:5];
        //[renwuanniu setTitle:@"djdjd" forState:UIControlStateNormal];
        renwuanniu.backgroundColor =[UIColor colorWithHexString:@"34C083"];
        [renwuanniu addTarget:self action:@selector(vic:) forControlEvents:UIControlEventTouchUpInside];
        if ([_zhT isEqualToString:@"2"]) {
            [renwuanniu setTitle:@"执行任务" forState:UIControlStateNormal];
        }else if ([_zhT isEqualToString:@"3"]){
            [renwuanniu setTitle:@"完成任务" forState:UIControlStateNormal];
        }else{
            
            if(nil==[pushTemplate objectForKey:@"remarks"]){
            textview.text=@"";
            }else{
            textview.text=[NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"remarks"]];
            }
            renwuanniu.hidden=YES;
        }
        
        [cell.contentView addSubview:renwuanniu];
       
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (IBAction)vic:(id)sender {
    NSString*str;
    if ([_zhT isEqualToString:@"2"]) {
        str=@"3";
    }else if ([_zhT isEqualToString:@"3"]){
        str=@"4";
    }
    
    [self anniujiekou:str];
    
}

#pragma mark---图片点击放大
-(void)Imageshows{
   image.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    
    [image addGestureRecognizer:tap];
}

- (void)magnifyImage
{
    //NSLog(@"局部放大");
    [XLImageShow showImage:image];//调用方法
}
#pragma mark--textviw方法
-(void)tobar{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 30)];
    topView.backgroundColor = [UIColor clearColor];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(4, 5, 40, 25);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(wancheng) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [textview setInputAccessoryView:topView];
    
    
}
-(void)wancheng{
    [textview resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [textview resignFirstResponder];
    [self.view endEditing: YES];
}
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length==0) {
        placeor.text = @"请输入您的建议...";
    }
    else {
        placeor.text = @" ";
    }
}

#pragma mark--返回按钮
-(void)navigation{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
//返回到固定页
-(void)fanhui{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark----页面弹起
//视图上移的方法
- (void) animateTextField: (CGFloat) textField up: (BOOL) up
{
    
    //设置视图上移的距离，单位像素
    
    const int movementDistance = textField; // tweak as needed
    //三目运算，判定是否需要上移视图或者不变
    int movement = (up ? movementDistance : -movementDistance);
    //设置动画的名字
    [UIView beginAnimations: @"Animation" context: nil];
    //设置动画的开始移动位置
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置动画的间隔时间
    [UIView setAnimationDuration: 0.20];
    //设置视图移动的位移
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    //设置动画结束
    [UIView commitAnimations];
    
}
#pragma  mark ---注册通知
- (void) registerForKeyboardNotifications
{
    cha=0.0;
    pan=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qkeyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(qkeyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark ----通知实现
- (void) qkeyboardWasShown:(NSNotification *) notif
{
    if (pan==0) {
        NSDictionary *info = [notif userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGSize keyboardSize = [value CGRectValue].size;
        
        
        UITableViewCell *cell=(UITableViewCell*)[[Mview superview] superview ];
        
        NSIndexPath *index=[_tableview indexPathForCell:cell];
        CGRect rectInTableView = [_tableview rectForRowAtIndexPath:index];
        CGRect rect = [_tableview convertRect:rectInTableView toView:Mview];
        CGRect rectx = [_tableview convertRect:rectInTableView toView:[_tableview superview]];

        CGFloat kongjian=rectx.origin.y+rect.size.height;
        CGFloat viewK=[UIScreen mainScreen].bounds.size.height;
        CGFloat jianpan=keyboardSize.height;
        if (viewK > kongjian+ jianpan) {
            cha=0;
        }else{
            cha=viewK-kongjian-jianpan;
        }
        pan=1;
        [self animateTextField:cha  up: YES];
    }
}
- (void) qkeyboardWasHidden:(NSNotification *) notif
{
    pan=0;
    [self animateTextField:cha up:NO];
}
@end
