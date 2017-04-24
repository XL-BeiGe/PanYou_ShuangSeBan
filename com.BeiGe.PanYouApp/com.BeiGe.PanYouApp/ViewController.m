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
#import "XLmemedaViewController.h"
#import "XL_FMDB.h"
@interface ViewController ()<UITextFieldDelegate>
{
    XL_FMDB  *XL;//数据库调用者
    FMDatabase *db;//数据库
    CGFloat cha;
    int pan;
}
- (IBAction)danji:(id)sender;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    if (NULL !=[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
        _username.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        _password.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
}
-(void)shujuku{
    XL = [XL_FMDB tool];
    [XL_FMDB allocWithZone:NULL];
    db = [XL getDBWithDBName:@"pandian.sqlite"];
    //新建同步表，里边是同步数据信息
    [XL DataBase:db createTable:TongBuBiaoMing keyTypes:TongBuShiTiLei];
    //新建下载表，里边是本次盘点数据
    [XL DataBase:db createTable:XiaZaiBiaoMing keyTypes:XiaZaiShiTiLei];
    //新建上传表，里边是需要上传的盘点数据
    [XL DataBase:db createTable:ShangChuanBiaoMing keyTypes:ShangChuanShiTiLei];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self delegate];
    [self registerForKeyboardNotifications];
    [self shujuku];
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
    _username.keyboardType=UIKeyboardTypeASCIICapable;
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
        
        if (NULL == [[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
            [self dengdegndengdeng:@"0"];
        }else{
            if([_username.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]]){
                [self dengdegndengdeng:@"0"];
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请确认上一账号已经提交完盘点结果，更换账号将清空以前数据！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dengdegndengdeng:@"1"];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}
-(void)dengdegndengdeng:(NSString*)deng{
    [WarningBox warningBoxModeIndeterminate:@"登录中..." andView:self.view];
    NSString *fangshi=@"/sys/login";
    NSDictionary*rucan=[NSDictionary dictionaryWithObjectsAndKeys:_username.text,@"loginName",_password.text,@"password", nil];
    //自己写的网络请求    请求外网地址
    [XL_WangLuo QianWaiwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try {//DD000101    admin
            if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                
                //账号密码
                [user setObject:_username.text forKey:@"name"];
                [user setObject:_password.text forKey:@"password"];
                //其他接口必须用
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data" ] objectForKey:@"accessToken"]] forKey:@"accesstoken"];
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data" ] objectForKey:@"accessToken"]] forKey:@"accessToken"];
                //1弹    2不弹
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"status"]] forKey:@"shifoutankuang"];
                //平台机器码
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"mac"]] forKey:@"Mac"];
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"mac"]] forKey:@"mac"];
                //给两个平台的userId 赋值
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"userId"]] forKey:@"userId"];
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"userId"]] forKey:@"UserID"];
                //给推送用的门店Id 赋值
                [user setObject:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"office"] objectForKey:@"id"]] forKey:@"mendian"];
                //收银台需要显示的名称
                [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"name"]] forKey:@"CZname"];
                //1是网络盘点   2是单机盘点
                [user setObject:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"office"] objectForKey:@"edition"]] forKey:@"isDanji"];
                if(NULL ==[[NSUserDefaults standardUserDefaults] objectForKey:@"JuYuWang"]){
                    [[NSUserDefaults standardUserDefaults] setObject:@"www.yaopandian.com" forKey:@"JuYuWang"];
                }
                if ([deng isEqual:@"1"]) {
                    [XL clearDatabase:db from:ShangChuanBiaoMing];
                    [XL clearDatabase:db from:XiaZaiBiaoMing];
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
    }];
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
    }];
}

- (IBAction)LLogin:(id)sender {
    [self denglu];
}
- (IBAction)danji:(id)sender {
    
    if(NULL ==[[NSUserDefaults standardUserDefaults] objectForKey:@"JuYuWang"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"www.yaopandian.com" forKey:@"JuYuWang"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isPandian"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"rukou"];
    XLmemedaViewController *home=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"memeda"];
    [self presentViewController:home animated:YES completion:^{
    }];
}
@end
