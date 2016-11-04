//
//  XLNoteInfoViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/4.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLNoteInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *compary;//来源
@property (weak, nonatomic) IBOutlet UILabel *titlle;//标题
@property (weak, nonatomic) IBOutlet UIImageView *Image;//图片
@property (weak, nonatomic) IBOutlet UILabel *neror;//内容
@property (weak, nonatomic) IBOutlet UILabel *shij;//时间
@property (weak, nonatomic) IBOutlet UITextView *textview;//备注
- (IBAction)victory:(id)sender;

@end
