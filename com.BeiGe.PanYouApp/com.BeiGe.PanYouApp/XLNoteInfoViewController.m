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
@interface XLNoteInfoViewController ()<UITextViewDelegate>
{
    UILabel *placeor;
    NSDictionary*pushTemplate;
}
@property (weak, nonatomic) IBOutlet UIButton *renwuanniu;
@end

@implementation XLNoteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_zhT);
    
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
        _textview.userInteractionEnabled = NO;
    }
    
    
    
    [self xiangqingjiekou];
    [self navigation];
    self.title = @"通知详情";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    //_Image.image =[UIImage imageNamed:@"icon_02_07.png"];
    
    
    
    if([pushTemplate objectForKey:@"image"]!=nil){
    NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",Scheme,QianWaiWangIP,[pushTemplate objectForKey:@"image"]]];
        [_Image sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"icon_02_07.png"]];
    
    }
    
    _titlle.text = [pushTemplate objectForKey:@"title"];
    _neror.text = [pushTemplate objectForKey:@"context"];
    _compary.text = [NSString stringWithFormat:@"来源:%@",[pushTemplate objectForKey:@"pushSrc"]];
    _shij.text = [NSString stringWithFormat:@"时间:%@",[pushTemplate objectForKey:@"createTime"]];
    
    _textview.delegate = self;
    [self tobar];
    _textview.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 15);
    placeor = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    placeor.text = @"请输入您的建议...";
    placeor.textColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:218.0/255 alpha:1.0];
    placeor.font =[UIFont systemFontOfSize:14];
    placeor.backgroundColor = [UIColor clearColor];
    [_textview addSubview:placeor];
    if ([_zhT isEqualToString:@"2"]) {
        _renwuanniu.titleLabel.text=@"执行任务";
    }else if ([_zhT isEqualToString:@"3"]){
        _renwuanniu.titleLabel.text=@"完成任务";
    }else{
        _renwuanniu.hidden=YES;
    }
}

-(void)navigation{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self  action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
}
-(void)fanhui{

    //[self.navigationController popToRootViewControllerAnimated:YES];
    XLNoteViewController *xln=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"note"];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[xln class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
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
            [self jiemian];
            
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

-(void)anniujiekou:(NSString*)str{
    NSString *fangshi=@"/push/progress";
    NSString* UserID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_pushInfoId,@"pushId",UserID,@"userId",str,@"progressStatus", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        
        
        
        NSLog(@"%@",responseObject);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
            if([str isEqualToString:@"2"]){
                [WarningBox warningBoxHide:YES andView:self.view];
            }else{
            
            XLNoteViewController *xln = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"note"];
         
            xln.typ=str;
            [self.navigationController pushViewController:xln animated:YES];
            }
        });
       
        [WarningBox warningBoxHide:YES andView:self.view];
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
}
@end
