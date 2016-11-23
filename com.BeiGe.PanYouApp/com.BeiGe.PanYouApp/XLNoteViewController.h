//
//  XLNoteViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/4.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLNoteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *table;
//- (IBAction)Changed:(id)sender;

- (IBAction)ChangeV:(UISegmentedControl *)sender;
@property (strong, nonatomic) NSString *typ;
@end
