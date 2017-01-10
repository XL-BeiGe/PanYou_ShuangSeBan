//
//  XLSizeForLabel.h
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/1/9.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XLSizeForLabel : NSObject
+(CGSize)labelRectWithSize:(CGSize)size
                 LabelText:(NSString *)labelText
                      Font:(UIFont *)font;
@end
