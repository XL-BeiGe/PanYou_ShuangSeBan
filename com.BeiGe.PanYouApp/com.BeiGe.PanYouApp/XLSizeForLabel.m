//
//  XLSizeForLabel.m
//  com.BeiGe.PanYouApp
//
//  Created by newmac on 2017/1/9.
//  Copyright © 2017年 BinXiaolang. All rights reserved.
//

#import "XLSizeForLabel.h"

@implementation XLSizeForLabel
+(CGSize)labelRectWithSize:(CGSize)size
                 LabelText:(NSString *)labelText
                      Font:(UIFont *)font{
    
    NSDictionary  *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize actualsize = [labelText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return actualsize;
}
@end
