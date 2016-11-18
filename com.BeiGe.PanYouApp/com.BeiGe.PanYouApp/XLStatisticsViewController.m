//
//  XLStatisticsViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLStatisticsViewController.h"
#import "XL_WangLuo.h"
#import "WarningBox.h"
@interface XLStatisticsViewController ()//<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString*nian,*yue;
    NSString*ynian,*yyue;
}
@end

@implementation XLStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSDate *selected = [NSDate date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *datefffff=[[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy"];
    [datefffff setDateFormat:@"MM"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    nian =  [NSString stringWithFormat:
             @"%@", destDateString];
    ynian=[NSString stringWithFormat:
           @"%@", destDateString];
    NSString *daterr=[datefffff stringFromDate:selected];
    yue=[NSString stringWithFormat:@"%@",daterr];
    yyue=[NSString stringWithFormat:@"%@",daterr];
    _month.text=[NSString stringWithFormat:@"%@年%@月",nian,yue];
    [self jiekou:[NSString stringWithFormat:@"%@-%@",nian,yue]];
    
    //右侧按钮变色，且不可点；
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // _collection.delegate=self;
}
-(NSArray *)collectionAtIndexes:(NSIndexSet *)indexes{
    return [NSArray arrayWithObjects:@"", nil];
}

-(void)jiekou:(NSString*)date{
    NSString *fangshi=@"/attendance/Statistics";
    NSDictionary * rucan=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"userId",date,@"currentDate", nil];
    [WarningBox warningBoxModeIndeterminate:@"加载界面..." andView:self.view];
    [XL_WangLuo JuYuwangQingqiuwithBizMethod:fangshi Rucan:rucan type:Post success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
            
        }
    } failure:^(NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络错误,请重试!" andView:self.view];
        NSLog(@"%@",error);
    }];
}

- (IBAction)Left:(id)sender {
    yue=[NSString stringWithFormat:@"%d",[yue intValue]-1];
    if ([yue isEqualToString:@"0"]) {
        yue=@"12";
        nian=[NSString stringWithFormat:@"%d",[nian intValue]-1];
    }
    _month.text=[NSString stringWithFormat:@"%@年%@月",nian,yue];
    [self jiekou:[NSString stringWithFormat:@"%@-%@",nian,yue]];
}

- (IBAction)Right:(id)sender {
    
    if ([nian isEqualToString:ynian]&&[yue isEqualToString:yyue]) {
        
    }else{
        yue=[NSString stringWithFormat:@"%d",[yue intValue]+1];
        if ([yue isEqualToString:@"13"]) {
            yue=@"1";
            nian=[NSString stringWithFormat:@"%d",[nian intValue]+1];
        }
        _month.text=[NSString stringWithFormat:@"%@年%@月",nian,yue];
        [self jiekou:[NSString stringWithFormat:@"%@-%@",nian,yue]];
    }
}
@end
