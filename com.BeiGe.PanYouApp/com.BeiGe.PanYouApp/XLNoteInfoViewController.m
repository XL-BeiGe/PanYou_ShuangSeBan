//
//  XLNoteInfoViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/4.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLNoteInfoViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "XL_Header.h"
#import "XLNoteViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "XLSizeForLabel.h"
#import "XLImageShow.h"
@interface XLNoteInfoViewController ()<UITextViewDelegate>
{
    UILabel *placeor;
    NSDictionary*pushTemplate;
    int caca;
    CGFloat cha;
    int pan;
}
@property (weak, nonatomic) IBOutlet UIButton *renwuanniu;
@end

@implementation XLNoteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_zhT);
    caca=0;
  [self registerForKeyboardNotifications];
    
    
    _backimg.hidden= YES;
    [self xiangqingjiekou];
    [self navigation];
    if([_zhT isEqualToString:@"1"]){
        _zhT=@"2";
        [self anniujiekou:_zhT];
    }
    
    if([_zhT isEqualToString:@"1"]||[_zhT isEqualToString:@"2"]){
        _imp.hidden= YES;
    }else if ([_zhT isEqualToString:@"3"]){
        _imp.hidden= NO;
    }else{
        _imp.hidden= NO;
        caca=1;
        _textview.userInteractionEnabled = NO;
    }
    
    
    self.title = @"通知详情";
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
 
    [self Imageshows];
    
}
-(void)Imageshows{
    _Image.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    
    [_Image addGestureRecognizer:tap];
}

- (void)magnifyImage
{
    NSLog(@"局部放大");
    [XLImageShow showImage:_Image];//调用方法
}

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
    [self.textview setInputAccessoryView:topView];
    
    
}
-(void)wancheng{
    [_textview resignFirstResponder];
}

-(void)jiemian{
    if ([pushTemplate isEqual:@""]) {
        _renwuanniu.hidden=YES;
        _imp.hidden=YES;
        return;
    }
    if([pushTemplate objectForKey:@"image"]!=nil){
        //_Image.contentMode = UIViewContentModeScaleAspectFill;
        _Image.contentMode = UIViewContentModeScaleAspectFit;
        _Image.clipsToBounds  = YES;//是否剪切掉超出 UIImageView 范围的图片
        [_Image setContentScaleFactor:[[UIScreen mainScreen] scale]];//缩放图片的分辨率
        NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",Scheme,QianWaiWangIP,[pushTemplate objectForKey:@"image"]]];
        [_Image sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"icon_02_07.png"]];
     
    }
    if(nil==[pushTemplate objectForKey:@"context"]){
    _neror.text =@"";
    }else{
    _neror.text = [NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"context"]];
    }
   // _neror.adjustsFontSizeToFitWidth =YES;
  //CGSize digestHeight = [XLSizeForLabel labelRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width - 20, MAXFLOAT) LabelText:_neror.text Font:[UIFont systemFontOfSize:15.0f]];
    
    //_neror.frame = CGRectMake([[UIScreen mainScreen]bounds].origin.x,[[UIScreen mainScreen]bounds].origin.y,[[UIScreen mainScreen]bounds].size.width - 20,[digestHeight float]);
    if(nil==[pushTemplate objectForKey:@"title"]){
    _titlle.text =@"";
    }else{
     _titlle.text =[NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"title"]];
    }
    
    if(nil==[pushTemplate objectForKey:@"pushSrc"]){
       _compary.text =@"";
    }else{
       _compary.text = [NSString stringWithFormat:@"来源:%@",[pushTemplate objectForKey:@"pushSrc"]];
    }
    
    if(nil==[pushTemplate objectForKey:@"createTime"]){
       _shij.text =@"";
    }else{
        NSString *ss =[NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"createTime"]];
        NSString *sss = [ss substringToIndex:10];
        _shij.text =sss;
    }
    
   
    //_neror.text = [NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"context"]];
    
  
    
    
    _textview.delegate = self;
    [self tobar];
    _textview.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 15);
    placeor = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    
    placeor.text = @"请输入您的建议...";
    placeor.textColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:218.0/255 alpha:1.0];
    placeor.font =[UIFont systemFontOfSize:14];
    placeor.backgroundColor = [UIColor clearColor];
    if (caca!=1) {
        [_textview addSubview:placeor];
    }
    if ([_zhT isEqualToString:@"2"]) {
        _renwuanniu.titleLabel.text=@"执行任务";
    }else if ([_zhT isEqualToString:@"3"]){
        _renwuanniu.titleLabel.text=@"完成任务";
    }else{
        _textview.text=[NSString stringWithFormat:@"%@",[pushTemplate objectForKey:@"remarks"]];
        _renwuanniu.hidden=YES;
    }
}
-(void)xiangqingjiekou{
    NSString *fangshi=@"/push/pushDetail";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_pushInfoId,@"pushInfoId", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            pushTemplate=[[responseObject objectForKey:@"data"] objectForKey:@"pushTemplate"];
            NSLog(@"-------%@",pushTemplate);
            
            if([pushTemplate isEqual:@""]){
                _view1.hidden=YES;
                _view2.hidden=YES;
                _imp.hidden =YES;
                _renwuanniu.hidden = YES;
                _backimg.hidden =NO;
                NSLog(@"应该都隐藏");
            }else{
                _view1.hidden=NO;
                _view2.hidden=NO;
               // _imp.hidden =NO;
                _renwuanniu.hidden =NO;
                _backimg.hidden =YES;
              [self jiemian];
                NSLog(@"应该都显示");
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.textview resignFirstResponder];
}
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length==0) {
        placeor.text = @"请输入您的建议...";
    }
    else {
        placeor.text = @" ";
    }
}
- (IBAction)victory:(id)sender {
    NSString*str;
    if ([_zhT isEqualToString:@"2"]) {
        str=@"3";
    }else if ([_zhT isEqualToString:@"3"]){
        str=@"4";
    }
    
    [self anniujiekou:str];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
}



-(void)anniujiekou:(NSString*)str{
    NSString *fangshi=@"/push/progress";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString*remarks=[NSString string];
    if ([str isEqual:@"4"]) {
        remarks=_textview.text;
    }
    
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_pushInfoId,@"pushId",UserID,@"userId",str,@"progressStatus",remarks,@"remarks", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            if([str isEqualToString:@"2"]){
                [WarningBox warningBoxHide:YES andView:self.view];
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
//block传值 方法
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
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
        CGRect rect = CGRectMake(_renwuanniu.frame.origin.x, _renwuanniu.frame.origin.y, _renwuanniu.frame.size.width,_renwuanniu.frame.size.height);
        CGFloat kongjian=rect.origin.y+rect.size.height;
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
