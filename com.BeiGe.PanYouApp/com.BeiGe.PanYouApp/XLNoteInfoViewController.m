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
#import "XLNoteViewController.h"
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
    
    [self xiangqingjiekou];
 
    self.title = @"通知详情";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)jiemian{
    _Image.image =[UIImage imageNamed:@"icon_02_07.png"];
    _titlle.text = [pushTemplate objectForKey:@"title"];
    _neror.text = [pushTemplate objectForKey:@"context"];
    _compary.text = [NSString stringWithFormat:@"来源:%@",[pushTemplate objectForKey:@"pushSrc"]];
    _shij.text = [NSString stringWithFormat:@"时间:%@",[pushTemplate objectForKey:@"createTime"]];
    
    _textview.delegate = self;
    _textview.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 15);
    placeor = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    placeor.text = @"请输入您的建议...";
    placeor.textColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:218.0/255 alpha:1.0];
    placeor.font =[UIFont systemFontOfSize:14];
    placeor.backgroundColor = [UIColor clearColor];
    [_textview addSubview:placeor];
    if ([_zhT isEqualToString:@"1"]) {
        _renwuanniu.titleLabel.text=@"执行任务";
    }else if ([_zhT isEqualToString:@"2"]){
        _renwuanniu.titleLabel.text=@"完成任务";
    }else{
        _renwuanniu.hidden=YES;
    }
}
-(void)xiangqingjiekou{
    NSString *fangshi=@"/push/pushDetail";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_pushInfoId,@"pushInfoId", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
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
    if ([_zhT isEqualToString:@"1"]) {
        str=@"2";
    }else if ([_zhT isEqualToString:@"2"]){
       str=@"3";
    }

    [self anniujiekou:str];
    
}
-(void)anniujiekou:(NSString*)str{
    NSString *fangshi=@"/push/progress";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:_pushInfoId,@"pushId",@"2",@"userId",str,@"progressStatus", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            XLNoteViewController *xln = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"note"];
            xln.typ=str;
            [self.navigationController pushViewController:xln animated:YES];
            
        });
       
        [WarningBox warningBoxHide:YES andView:self.view];
        
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
}
@end
