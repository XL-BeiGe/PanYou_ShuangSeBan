//
//  ViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 16/11/2.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "ViewController.h"
#import "WarningBox.h"
#import "XL_WangLuo.h"
#import "XL_Header.h"
#import "AppDelegate.h"
#import "XLxixixihahaViewController.h"
@interface ViewController ()<UITextFieldDelegate>
{
    CGFloat cha;
    int pan;
}
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    if (NULL !=[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]) {
        _username.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
        _password.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self delegate];
    [self registerForKeyboardNotifications];
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
        CGRect rect = CGRectMake(_LoginShuXing.frame.origin.x, _LoginShuXing.frame.origin.y, _LoginShuXing.frame.size.width,_LoginShuXing.frame.size.height);
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
#pragma mark ----textFieldDelegate
-(void)delegate{
    _username.delegate=self;
    _password.delegate=self;
    _username.keyboardType=UIKeyboardTypeNamePhonePad;
    _username.autocorrectionType = UITextAutocorrectionTypeNo;
    [_username setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_password setSecureTextEntry:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ( textField != _username) {
        _password.keyboardType=UIKeyboardTypeNamePhonePad;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField ==_username) {
        [_username resignFirstResponder];
        [_password becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
        [self denglu];
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)denglu{
    if ([_username.text isEqual:@""]||[_password.text isEqual:@""]) {
        [WarningBox warningBoxModeText:@"请填写好账号信息哟~" andView:self.view];
    }else{
        [WarningBox warningBoxModeIndeterminate:@"登录中..." andView:self.view];
        NSString *fangshi=@"/sys/login";
        NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:_username.text,@"loginName",_password.text,@"password", nil];
        //自己写的网络请求    请求外网地址
        [XL_WangLuo QianWaiwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            NSLog(@"%@",responseObject);
            @try {//DD000101    admin
                if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    //账号密码
                    [user setObject:_username.text forKey:@"Name"];
                    [user setObject:_password.text forKey:@"Password"];
                    //其他接口必须用
                    [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data" ] objectForKey:@"accessToken"]] forKey:@"accessToken"];
                    
                    //平台机器码
                    [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"mac"]] forKey:@"Mac"];
                    //给两个平台的userId 赋值
                    [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"userId"]] forKey:@"userId"];
                    [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"userId"]] forKey:@"UserID"];
                    //给推送用的门店Id 赋值
                    [user setObject:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"office"] objectForKey:@"id"]] forKey:@"mendian"];
                    //收银台需要显示的名称
                    [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"name"]] forKey:@"CZname"];
                    if(NULL ==[[NSUserDefaults standardUserDefaults] objectForKey:@"JuYuWang"]){
                        [[NSUserDefaults standardUserDefaults] setObject:QianWaiWangIP forKey:@"JuYuWang"];
                    }
                    
                    
                    //登陆成功后重新注册一次极光的标签和别名
                    [[AppDelegate appDelegate] method];
                    [self jumpHome];
                }
                else{
                    [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
                }
            } @catch (NSException *exception) {
                [WarningBox warningBoxModeText:@"请仔细检查您的网络" andView:self.view];
            }
        } failure:^(NSError *error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:@"网络请求失败" andView:self.view];
            NSLog(@"%@",error);
        }];
    }
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
-(void)jumpHome{
    XLxixixihahaViewController *home=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xixixihaha"];
    [self presentViewController:home animated:YES completion:^{
        NSLog(@"么么哒");
    }];
}

- (IBAction)LLogin:(id)sender {
    [self denglu];
}
@end
