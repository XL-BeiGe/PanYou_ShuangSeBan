//
//  XLnotifoViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/1/22.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *showText);
@interface XLnotifoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;


@property (strong, nonatomic) NSString *pushInfoId;
@property (strong, nonatomic) NSString *zhT;
//传值 定义Block属性
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
//传值方法
- (void)returnText:(ReturnTextBlock)block;
@end
