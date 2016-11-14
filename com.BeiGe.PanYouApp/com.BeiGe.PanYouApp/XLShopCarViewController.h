//
//  XLShopCarViewController.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2016/11/3.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLShopCarViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *coupon;//优惠券
@property (weak, nonatomic) IBOutlet UITextField *couprice;//优惠金额
@property (weak, nonatomic) IBOutlet UITableView *tabel;
- (IBAction)SetAccounts:(id)sender;

@end
