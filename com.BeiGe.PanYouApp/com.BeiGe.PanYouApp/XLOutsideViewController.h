//
//  XLOutsideViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLOutsideViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *outTime;//外出时间
@property (weak, nonatomic) IBOutlet UILabel *backTime;//回来时间
@property (weak, nonatomic) IBOutlet UITextView *textview;//原因
@property (weak, nonatomic) IBOutlet UIImageView *imagev;//背景
- (IBAction)OutTim:(id)sender;
- (IBAction)BackTim:(id)sender;

- (IBAction)TiJiao:(id)sender;

@end