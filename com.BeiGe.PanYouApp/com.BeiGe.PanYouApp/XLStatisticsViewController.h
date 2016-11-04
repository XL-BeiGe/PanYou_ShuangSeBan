//
//  XLStatisticsViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLStatisticsViewController : UIViewController
- (IBAction)Left:(id)sender;
- (IBAction)Right:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *month;//月份
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end
