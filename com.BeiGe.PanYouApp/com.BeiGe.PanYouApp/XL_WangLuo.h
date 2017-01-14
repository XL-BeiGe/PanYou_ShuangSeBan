//
//  XL_WangLuo.h
//  PanDianDanJi
//
//  Created by 小狼 on 16/9/7.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,Post_or_Get) {
    /**
     *  get请求
     */
    Get = 0,
    /**
     *  post请求
     */
    Post
};

@interface XL_WangLuo : NSObject
/*
 * 单机版的登录
 */
+(void)WaiwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
/*
 * 单机版除了登录接口
 */
+(void)JuYuwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/*
 * 店小二的上传图片
 */
+(void)ShangChuanTuPianwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type image:(UIImage*)image key:(NSString*)key success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
/*
 * 外网登陆专用
 */
+(void)QianWaiwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
/*
 * 外网除了登录接口
 */
+(void)QianWaiWangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
@end
