//
//  XLLeaveViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLLeaveViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "XLAttendanceViewController.h"
#import "XLDateCompare.h"
@interface XLLeaveViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UITextViewDelegate>{
    int kaijie;//开始结束判断;
    UIView *backview;//透明的
    NSString*kaishi;
    NSString*jieshi;
    NSString*chuannima;
    UILabel *placeor;
}
@property(strong,nonatomic) UIDatePicker *picker;
@end

@implementation XLLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self beijing];
    [self delegate];
    _reason.delegate = self;
    [self tobar];
    [self comeback];
    self.title =@"请假";
    [self tttttttttt];
}

-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
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
-(void)tttttttttt{
    
    _reason.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 15);
    placeor = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    placeor.text = @"备注:";
    [_reason addSubview:placeor];
    placeor.font =[UIFont systemFontOfSize:14];
    placeor.backgroundColor = [UIColor clearColor];
    placeor.textColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:218.0/255 alpha:1.0];
}
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length==0) {
        placeor.text = @"备注:";
    }
    else {
        placeor.text = @" ";
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
    [self.reason setInputAccessoryView:topView];
    
}
-(void)wancheng {
    [_reason resignFirstResponder];
}
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
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc] init];
    
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message =[NSString stringWithFormat:@"%@", destDateString];
    
//    NSDate *date = [NSDate date];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *nowdate =[dateForm stringFromDate:date];
    
    
    if (kaijie==1) {
//        int ixi =[XLDateCompare compareDate:message withDate:nowdate];
//        if (ixi==-1){
            _beginTime.text=message;
            kaishi=message;
//        }
//        else{
//            [WarningBox warningBoxModeText:@"开始时间应大于当前时间" andView:self.view];
//        }
    }else{
        int ixix =[XLDateCompare compareDate:_beginTime.text withDate:message];
        if (ixix==1){
            _endTime.text=message;
            jieshi=message;
        }else{
            [WarningBox warningBoxModeText:@"结束时间必须大于开始时间" andView:self.view];
        }
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
    textField.backgroundColor=[UIColor whiteColor];
    textField.inputView=_picker;
    textField.tintColor=[UIColor clearColor];
    return YES;
}
-(void)delegate{
    _beginTime.delegate=self;
    _endTime.delegate=self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BeginTim:(id)sender {
    kaijie=1;
    [_beginTime becomeFirstResponder];
}

- (IBAction)EndTim:(id)sender {
    kaijie=0;
    [_endTime becomeFirstResponder];
}

- (IBAction)LeaveTyp:(id)sender {
    [self tan];
}

- (IBAction)Present:(id)sender {
    [self.view endEditing:YES];
    [self tijiaojiekou];
}
-(NSArray*)jiaming{
    NSArray*arr=[NSArray arrayWithObjects:@"病假",@"产假",@"婚假",@"工伤假",@"事假",@"丧假",@"调休",@"年假",@"其他", nil];
    return arr;
}
-(void)tan{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"请假原因：" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"病假",@"产假",@"婚假",@"工伤假",@"事假",@"丧假",@"调休",@"年假",@"其他", nil];
    
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex<9){
        NSArray *jiaming = [self jiaming];
        _leaveType.text=[NSString stringWithFormat:@"%@",jiaming[buttonIndex]];
        chuannima=[NSString stringWithFormat:@"%ld",(long)buttonIndex+1];
        
    }
}
-(void)tijiaojiekou{
    //方式:t=attendance/leave
    /*
     用户ID
     _reason.text;    原因
     _endTime.text;   结束时间
     _beginTime.text; 开始时间
     _leaveType.text; 请假类型
     _reason.text;
     */
    NSString *fangshi=@"/attendance/leave";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",kaishi,@"beginTime",jieshi,@"endTime",chuannima,@"leaveType",_reason.text,@"leaveReason", nil];
    [WarningBox warningBoxModeIndeterminate:@"正在请假..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            [WarningBox warningBoxModeText:@"请假成功!" andView:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
    }];
    
}
@end
