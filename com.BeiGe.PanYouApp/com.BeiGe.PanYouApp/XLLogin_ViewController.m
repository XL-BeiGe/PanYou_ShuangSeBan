//
//  XLLogin_ViewController.m
//  PanDianDanJi
//
//  Created by 小狼 on 16/9/6.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLLogin_ViewController.h"
#import "WarningBox.h"
#import "XL_Header.h"
#import "XL_WangLuo.h"
#import "XLHomeViewController.h"
#import "XLMainViewController.h"
#import "ViewController.h"
@interface XLLogin_ViewController (){
    CGFloat cha;
    int pan;
}
@end

@implementation XLLogin_ViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = true;
    if (NULL !=[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]) {
        _Name.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
        _Password.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
    }
    
    if (NULL != JuyuwangIP) {
        if ([JuyuwangIP rangeOfString:@"www."].location !=NSNotFound) {
            
        }else{
            NSArray*Fenge=[JuyuwangIP componentsSeparatedByString:@"."];
            NSArray*fe2=[[Fenge lastObject] componentsSeparatedByString:@":"];
            _NetText1.text=[NSString stringWithFormat:@"%@",Fenge[0]];
            _NetText2.text=[NSString stringWithFormat:@"%@",Fenge[1]];
            _NetText3.text=[NSString stringWithFormat:@"%@",Fenge[2]];
            _NetText4.text=[NSString stringWithFormat:@"%@",fe2[0]];
            _NetText5.text=[NSString stringWithFormat:@"%@",fe2[1]];
        }
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = false;
}
-(void)comeback{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    // UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"rukou"] isEqualToString:@"0"]) {
        //跳回首页登录
        ViewController *view=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"llogin"];
        [ self presentViewController:view animated: NO completion:nil];
        
    }else{
        XLMainViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xlmain"];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[xln class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self delegate];
    [self registerForKeyboardNotifications];
    [self comeback];
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
        CGRect rect = CGRectMake(_LoginOutlet.frame.origin.x, _LoginOutlet.frame.origin.y, _LoginOutlet.frame.size.width,_LoginOutlet.frame.size.height);
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
    
    _NetText1.delegate=self;
    _NetText2.delegate=self;
    _NetText3.delegate=self;
    _NetText4.delegate=self;
    _NetText5.delegate=self;
    
    _NetText1.keyboardType=UIKeyboardTypeNumberPad;
    _NetText2.keyboardType=UIKeyboardTypeNumberPad;
    _NetText3.keyboardType=UIKeyboardTypeNumberPad;
    _NetText4.keyboardType=UIKeyboardTypeNumberPad;
    _NetText5.keyboardType=UIKeyboardTypeNumberPad;
    
    _NetText1.textAlignment=NSTextAlignmentRight;
    _NetText2.textAlignment=NSTextAlignmentRight;
    _NetText3.textAlignment=NSTextAlignmentRight;
    _NetText4.textAlignment=NSTextAlignmentRight;
    
    
    
    _Name.delegate=self;
    _Password.delegate=self;
    _Name.keyboardType=UIKeyboardTypeASCIICapable;
    _Name.autocorrectionType = UITextAutocorrectionTypeNo;
    [_Name setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_Password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_Password setSecureTextEntry:YES];
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if ( textField != _Name) {
//        _Password.keyboardType=UIKeyboardTypeNamePhonePad;
//    }
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self huanhang:@"" :textField];
    if (textField ==_Name) {
        [_Name resignFirstResponder];
        [_Password becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
        [self Login:nil];
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![string isEqualToString:@""]) {
        if (textField == _NetText5) {
            if (textField.text.length>=5) {
                return NO;
            }
        }else{
            if(textField.text.length>=3){
                if(textField==_Name||textField==_Password){
                
                }else{
                 [self huanhang:string :textField];
                return NO;
                }
                
                
               
                
            }
        }
    }
    
    return YES;
}
-(void)huanhang:(NSString *)str :(UITextField*)textField{
    if (textField == _NetText1) {
        _NetText2.text =str;
        [_NetText2 becomeFirstResponder];
    }else if (textField == _NetText2) {
        _NetText3.text =str;
        [_NetText3 becomeFirstResponder];
    }else if (textField == _NetText3) {
        _NetText4.text =str;
        [_NetText4 becomeFirstResponder];
    }else if (textField == _NetText4) {
        _NetText5.text =str;
        [_NetText5 becomeFirstResponder];
    }else {
        //        [self SaveNetwork:nil];
    }
}


#pragma mark ----Login_Action
- (IBAction)Login:(UIButton *)sender {
    //[self ceshi];
    if (_NetText5.text.length>0&&_NetText4.text.length>0&&_NetText3.text.length>0&&_NetText2.text.length>0&&_NetText1.text.length>0) {
        NSString*Pinjie=[NSString stringWithFormat:@"%@.%@.%@.%@:%@",_NetText1.text,_NetText2.text,_NetText3.text,_NetText4.text,_NetText5.text];
        NSUserDefaults *shuju=[NSUserDefaults standardUserDefaults];
        [shuju setObject:Pinjie forKey:@"JuYuWang"];
        if ([_Name.text isEqual:@""]||[_Password.text isEqual:@""]) {
            [WarningBox warningBoxModeText:@"请填写好账号信息哟~" andView:self.view];
        }else if (NULL ==JuyuwangIP){
            [WarningBox warningBoxModeText:@"请先设置网络连接" andView:self.view];
        }else{
            
            [WarningBox warningBoxModeIndeterminate:@"登录中..." andView:self.view];
            NSString *fangshi=@"/sys/login";
            NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:[_Name.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"loginName",[_Password.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"password", nil];
            //自己写的网络请求    请求外网地址
            [XL_WangLuo WaiwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
                [WarningBox warningBoxHide:YES andView:self.view];
                NSLog(@"%@",responseObject);
                
                @try {
                
                    if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                        [user setObject:[NSString stringWithFormat:@"%@",_Name.text] forKey:@"Name"];
                        [user setObject:[NSString stringWithFormat:@"%@",_Password.text] forKey:@"Password"];
                        [user setObject:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"office"] objectForKey:@"id"]] forKey:@"mendian"];
                        [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data" ] objectForKey:@"accessToken"]] forKey:@"accessToken"];
                        [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"mac"]] forKey:@"Mac"];
                        [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"userId"]] forKey:@"UserID"];
                        [user setObject:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"office"] objectForKey:@"id"]] forKey:@"mendian"];
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
            }];
        }
        
        
    }else{
        [WarningBox warningBoxModeText:@"请填写全部信息" andView:self.view];
    }
}





//拖拽  传值方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"tuozhuai"/*与拖拽出来的线的定义*/]) {
        [self.view endEditing:YES];
    }
}

-(void)jumpHome{
    XLHomeViewController *home=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
    home.biaoji=@"1";
    [self.navigationController pushViewController:home animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
