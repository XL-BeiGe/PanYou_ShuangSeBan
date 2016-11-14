//
//  XLLeaveViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLLeaveViewController.h"

@interface XLLeaveViewController ()<UITextFieldDelegate,UIActionSheetDelegate>{
    int kaijie;//开始结束判断;
    UIView *backview;//透明的
}
@property(strong,nonatomic) UIDatePicker *picker;
@end

@implementation XLLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self beijing];
    [self delegate];
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message =  [NSString stringWithFormat:
                          @"%@", destDateString];
    
    if (kaijie==1) {
        _beginTime.text=message;
    }else{
        _endTime.text=message;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    */
}
@end
