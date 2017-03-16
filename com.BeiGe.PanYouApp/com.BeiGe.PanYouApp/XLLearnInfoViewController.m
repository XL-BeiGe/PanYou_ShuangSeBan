//
//  XLLearnInfoViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/2/9.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XLLearnInfoViewController.h"
#import "XL_WangLuo.h"
#import "WarningBox.h"
#import "XL_Header.h"

@interface XLLearnInfoViewController ()<UIWebViewDelegate>
{
    NSMutableArray *arr;
}
@end

@implementation XLLearnInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self jiekou];
    [self webview];
    [self navigatio];
    // Do any additional setup after loading the view.
}
-(void)navigatio{
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    UIBarButtonItem*left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self.navigationItem setLeftBarButtonItem:left];
    
}
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webview{
   _webvie.delegate=self;
    [_webvie setOpaque:YES];//opaque是不透明的意思
    [_webvie setScalesPageToFit:YES];//自动缩放以适应屏幕
    self.webvie.backgroundColor = [UIColor clearColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)jiekou{
    arr = [NSMutableArray array];
    
    NSString *fangshi=@"/knowledge/comments";
    NSString* uudud=[NSString stringWithFormat:@"%@",_idid];
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:uudud,@"knowledgeInfoId", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo QianWaiWangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
      // NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            arr=[responseObject objectForKey:@"data"];
    
        _titl.text =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"title"]];
        _laiy.text =[NSString stringWithFormat:@"资讯来源:%@",[[responseObject objectForKey:@"data"] objectForKey:@"userName"]];
        _time.text =[NSString stringWithFormat:@"发布时间:%@",[[responseObject objectForKey:@"data"] objectForKey:@"created"]];
       
            NSString *urlstr=[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"comments"]];
       NSString *transString = [NSString stringWithString:[urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   
        NSString *stor =@"/stockmgr";
        if([transString rangeOfString:stor].location!=NSNotFound){

            NSString*ssss =[NSString stringWithFormat:@"%@%@%@",Scheme,QianWaiWangIP,AppName];
            transString =[transString stringByReplacingOccurrencesOfString:stor withString:ssss];
           // NSLog(@"urlstring-------%@",transString);
            }
            
            
           [_webvie loadHTMLString:transString baseURL:nil];
            
            
            [WarningBox warningBoxHide:YES andView:self.view];
        }
        else if([[responseObject objectForKey:@"code"]isEqual:@"9999"]){
            //账号在其他手机登录，请重新登录。
            [XL_WangLuo sigejiu:self];
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
    
}
@end