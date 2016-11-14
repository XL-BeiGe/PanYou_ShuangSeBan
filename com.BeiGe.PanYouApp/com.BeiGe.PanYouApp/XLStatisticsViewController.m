//
//  XLStatisticsViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLStatisticsViewController.h"

@interface XLStatisticsViewController ()//<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation XLStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self jiekou:@"今天"];
    _collection.delegate=self;
}
-(NSArray *)collectionAtIndexes:(NSIndexSet *)indexes{
    return [NSArray arrayWithObjects:@"", nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)jiekou:(NSString*)date{
    
}

- (IBAction)Left:(id)sender {
    [self jiekou:@"今天－1"];
}

- (IBAction)Right:(id)sender {
    [self jiekou:@"今天＋1"];
}
@end
