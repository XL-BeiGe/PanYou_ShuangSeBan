//
//  XLNoteInfoViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/4.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>
//为声明的Block定义名字
typedef void (^ReturnTextBlock)(NSString *showText);
@interface XLNoteInfoViewController : UIViewController
//传值 定义Block属性
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
//传值方法
- (void)returnText:(ReturnTextBlock)block;

@property (weak, nonatomic) IBOutlet UILabel *compary;//来源
@property (weak, nonatomic) IBOutlet UILabel *titlle;//标题
@property (weak, nonatomic) IBOutlet UIImageView *Image;//图片
@property (weak, nonatomic) IBOutlet UILabel *neror;//内容
@property (weak, nonatomic) IBOutlet UILabel *shij;//时间
@property (weak, nonatomic) IBOutlet UIImageView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *backimg;
@property (weak, nonatomic) IBOutlet UITextView *textview;//备注
@property (weak, nonatomic) IBOutlet UIView *imp;
- (IBAction)victory:(id)sender;
@property (strong, nonatomic) NSString *pushInfoId;
@property (strong, nonatomic) NSString *zhT;
@end
