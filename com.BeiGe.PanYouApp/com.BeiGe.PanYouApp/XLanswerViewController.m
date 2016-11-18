//
//  XLanswerViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 16/11/15.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLanswerViewController.h"

@interface XLanswerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *TableView;

@end

@implementation XLanswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self delegate];
}
-(void)delegate{
    _TableView.delegate=self;
    _TableView.dataSource=self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _timuarr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aa=@"hehe";
    UITableViewCell *cell=[self.TableView dequeueReusableCellWithIdentifier:aa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aa];
    }
    
    return cell;
}
@end
