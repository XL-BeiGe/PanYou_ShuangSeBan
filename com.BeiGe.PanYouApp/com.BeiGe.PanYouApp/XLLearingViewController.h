//
//  XLLearingViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/2/9.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLLearingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *Image;

@end
