//
//  XLNoteInfoViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/4.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLNoteInfoViewController.h"

@interface XLNoteInfoViewController ()<UITextViewDelegate>
{
    UILabel *placeor;
}
@end

@implementation XLNoteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // _titlle.text=[NSString stringWithFormat:@"%@",];//标题
    //_Image.image = [sdwebimage];//图片
    //_neror.text =[NSString stringWithFormat:@"%@",]//内容
    //_neror.numberOfLines=0;
    // _shij.text = [NSString stringWithFormat:@"%@",]//时间
    //_compary.text =[NSString stringWithFormat:@"来源:%@",];//来源
    //_textview.text = [NSString stringWithFormat:@"%@",];//备注
    
    _Image.image =[UIImage imageNamed:@"icon_02_07.png"];
    _titlle.text = @"这是一个标题";
    _neror.text = @"这是个测试测试";
    _compary.text = @"来源:药店总部";
    _shij.text = @"时间2016/10/15";

    _textview.delegate = self;
    _textview.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 15);
    placeor = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    placeor.text = @"请输入您的建议...";
    placeor.textColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:218.0/255 alpha:1.0];
    placeor.font =[UIFont systemFontOfSize:14];
    placeor.backgroundColor = [UIColor clearColor];
    [_textview addSubview:placeor];
    self.title = @"通知详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
}
@end
