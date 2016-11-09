//
//  XLOutsideViewController.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XLOutsideViewController.h"

@interface XLOutsideViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIView *backview;//时间选择器背景;
    UIButton*but;//时间选择器的确定按钮;
    int waifan;//外出返回时间选择器判断;
}

@property(strong,nonatomic) UIImage *image1;
@property(strong,nonatomic) UIDatePicker *picker;
@end

@implementation XLOutsideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imagev.userInteractionEnabled=YES;
    UITapGestureRecognizer *ss =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianji)];
    [_imagev addGestureRecognizer:ss];
    
}
-(void)shijianxuanze{
    
    float height=[[UIScreen mainScreen] bounds].size.height;
    float width =[[UIScreen mainScreen] bounds].size.width;
    backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height-200)];
    backview.backgroundColor=[UIColor blackColor];
    backview.alpha=0.5;
    UITapGestureRecognizer *ss =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshi)];
    [backview addGestureRecognizer:ss];
    [self.view addSubview:backview];
    _picker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, height-200, width, 200)];
    _picker.contentMode=UIViewContentModeCenter;
    _picker.datePickerMode=UIDatePickerModeDateAndTime;
    
    but=[[UIButton alloc] initWithFrame:CGRectMake(width-60, height-240, 55, 40)];
    [but addTarget:self action:@selector(buttt) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:@"确定" forState:UIControlStateNormal];
    
    [self.view addSubview:_picker];
    [self.view addSubview:but];
}
-(void)buttt{
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [_picker date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message =  [NSString stringWithFormat:
                          @"%@", destDateString];
    NSLog(@"%@",message);
    if (waifan==1) {
        _outTime.text=message;
    }else{
        _backTime.text=message;
    }
    [backview removeFromSuperview];
    [but removeFromSuperview];
    [_picker removeFromSuperview];
}
-(void)xiaoshi{
    [backview removeFromSuperview];
    [but removeFromSuperview];
    [_picker removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dianji{
    NSLog(@"hahah ");
    [self xiangji];
}
//直接打开相机
-(void)xiangji{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
    
    }];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    [picker dismissViewControllerAnimated:NO completion:^{}];
    
    _image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存图片至本地，方法见下文
    
    //按时间为图片命名
    NSDateFormatter *forr=[[NSDateFormatter alloc] init];
    
    [forr setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *name=[NSString stringWithFormat:@"hehe.png"];
    
    [self saveImage:_image1 withName:name];
    
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dicpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    
    [fm createDirectoryAtPath:dicpath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *picpath=[NSString stringWithFormat:@"%@/%@",dicpath,imageName];
    [fm createFileAtPath:picpath contents:imageData attributes:nil];
    
    _imagev.image=[UIImage imageWithData:imageData];
    
}

- (IBAction)OutTim:(id)sender {
    waifan=1;
    [self shijianxuanze];
}

- (IBAction)BackTim:(id)sender {
    waifan=0;
    [self shijianxuanze];
}

- (IBAction)TiJiao:(id)sender {
    [self tijiaojiekou];
}
-(void)tijiaojiekou{
    
    
}
@end
