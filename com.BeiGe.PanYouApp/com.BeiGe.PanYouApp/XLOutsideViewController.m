//
//  XLOutsideViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLOutsideViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "XLAttendanceViewController.h"
@interface XLOutsideViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UIView *backview;//时间选择器背景;
    int waifan;//外出返回时间选择器判断;
    NSString* chuankai;
    NSString* chuanjie;
    
    CGFloat cha;
    int pan;
}

@property(strong,nonatomic) UIImage *image1;
@property(strong,nonatomic) UIDatePicker *picker;
@end

@implementation XLOutsideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self beijing];
    [self tupianfangfa];
    [self delegate];
    _textview.delegate =self;
    [self tobar];
    [self comeback];
    self.title =@"外勤";
}

-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    XLAttendanceViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"attendance"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
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


-(void)tupianfangfa{
    _imagev.userInteractionEnabled=YES;
    UITapGestureRecognizer *ss =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianji)];
    [_imagev addGestureRecognizer:ss];
    
}
#pragma  mark------时间选择器
-(void)shijianxuanze{
        //时间选择器
    _picker=[[UIDatePicker alloc] init];
    _picker.contentMode=UIViewContentModeCenter;
    _picker.datePickerMode=UIDatePickerModeDateAndTime;
}
-(void)buttt{
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [_picker date];
    // 创建一个日期格式器
    NSDateFormatter*datefff=[[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    [datefff setDateFormat:@"yyyy-MM-dd HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message =  [NSString stringWithFormat:
                          @"%@", destDateString];
    NSString*darr=[datefff stringFromDate:selected];
    NSString*msg=[NSString stringWithFormat:@"%@",darr];
    
    if (waifan==1) {
        _outTime.text=message;
        chuankai=msg;
    }else{
        _backTime.text=message;
        chuanjie=msg;
    }
    [self xiaoshi];
}
-(void)xiaoshi{
    [self.view endEditing:YES];
    backview.hidden=YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    backview.hidden=NO;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,width ,44)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width - 60, 7,60, 30)];
    [button addTarget:self action:@selector(buttt) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定"forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bar addSubview:button];
    textField.inputAccessoryView = bar;
    [self shijianxuanze];
    textField.inputView=_picker;
    textField.tintColor=[UIColor clearColor];
    return YES;
}
-(void)delegate{
    _outTime.delegate=self;
    _backTime.delegate=self;
    [self registerForKeyboardNotifications];
}
-(void)dianji{
    [self xiangji];
}
-(void)beijing{
    //背景
    float height=[[UIScreen mainScreen] bounds].size.height;
    float width =[[UIScreen mainScreen] bounds].size.width;
    backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    backview.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer *ss =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshi)];
    [backview addGestureRecognizer:ss];
    backview.hidden=YES;
    [self.view addSubview:backview];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma  mark---相机－－－－－－－
//直接打开相机
-(void)xiangji{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    [picker dismissViewControllerAnimated:NO completion:^{}];
    
    _image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存图片至本地，方法见下文
    
    //按时间为图片命名
    NSDateFormatter *forr=[[NSDateFormatter alloc] init];
    
    [forr setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *name=[NSString stringWithFormat:@"hehe.png"];
    
    [self saveImage:_image1 withName:name];
    
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
    
    _imagev.image=[UIImage imageWithData:imageData];
}
#pragma mark------按键
- (IBAction)OutTim:(id)sender {
    waifan=1;
    [_outTime becomeFirstResponder];
}

- (IBAction)BackTim:(id)sender {
    waifan=0;
    [_backTime becomeFirstResponder];
}

- (IBAction)TiJiao:(id)sender {
    
    if(nil!=_image1){
    [self tijiaojiekou];
    }
    else{
     [WarningBox warningBoxModeText:[NSString stringWithFormat:@"请添加照片!"] andView:self.view];
    }
    
    
    
    
    
}
-(void)tijiaojiekou{
    //方法：attendance/field
    /*入参:
     userId(long):用户ID,
     beginTime (String):开始时间,_outTime.text
     endTime (String):结束时间,_backTime.text
     fieldReason(String)：外勤原因,_textview.text
     backgroundImage (File):背景_image1

    */
    NSString *fangshi=@"/attendance/field";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    NSUserDefaults * shuju=[NSUserDefaults standardUserDefaults];//非登录接口用
    NSString *userID=[shuju objectForKey:@"userId"];//登陆不用传
    NSString *accessToken=[shuju objectForKey:@"accessToken"];//登陆不用传
    
    
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:accessToken,@"accessToken",userID,@"userid",UserID,@"userId",chuankai,@"beginTime",chuanjie,@"endTime",_textview.text,@"fieldReason", nil];
    NSLog(@"%@",rucan);
    //自己写的网络请求    请求外网地址
   
    [WarningBox warningBoxModeIndeterminate:[NSString stringWithFormat:@"正在打卡..."] andView:self.view];
    [XL_WangLuo ShangChuanTuPianwithBizMethod:fangshi Rucan:rucan type:Post image:_image1 key:@"backgroundImage" success:^(id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"打卡成功!"] andView:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WarningBox warningBoxModeText:@"打卡失败了哟～请重试..." andView:self.view];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误，请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];

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
        CGRect rect = CGRectMake(_TView.frame.origin.x, _TView.frame.origin.y, _TView.frame.size.width,_TView.frame.size.height);
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
@end
