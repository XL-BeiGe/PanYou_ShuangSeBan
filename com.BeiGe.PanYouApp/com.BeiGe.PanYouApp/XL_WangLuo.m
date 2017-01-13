//
//  XL_WangLuo.m
//  PanDianDanJi
//
//  Created by 小狼 on 16/9/7.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "XL_WangLuo.h"
#import "XL_Header.h"
#import "SBJsonWriter.h"
#import "AFNetworking.h"
@implementation XL_WangLuo
/*
 * 登陆专用
 */
+(void)WaiwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *Waiwang=WaiWang;
    NSString *BizMethod=BizMetho;
    
    NSString *Url=[NSString stringWithFormat:@"%@%@",Waiwang,BizMethod];
    
    NSString *UserID=@"";
    NSString *vaildToken=@"1";//传空或非空
    NSString *accessToken=@"";//登陆不用传
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    
    NSDictionary*BizParamStr=BizParamSt;
    
    NSString *Rucan=[writer stringWithObject:BizParamStr];
    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",UserID,@"userid",vaildToken,@"vaildToken",accessToken,@"accessToken",Rucan,@"params", nil];
    NSLog(@"-*-*-*-*-%@",Url);
    NSLog(@"\n－－－－－请求－－－－－\n%@",ChuanCan);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    
    switch (type) {
        case Get:{
            [manager GET:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            
            break;
        case Post:{
            [manager POST:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            
            break;
    }
    
}

+(void)QianWaiwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *Waiwang=QianWaiWang;
    NSString *BizMethod=BizMetho;
    
    NSString *Url=[NSString stringWithFormat:@"%@%@",Waiwang,BizMethod];
    
    NSString *UserID=@"";
    NSString *vaildToken=@"1";//传空或非空
    NSString *accessToken=@"";//登陆不用传
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    
    NSDictionary*BizParamStr=BizParamSt;
    
    NSString *Rucan=[writer stringWithObject:BizParamStr];
    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",UserID,@"userid",vaildToken,@"vaildToken",accessToken,@"accessToken",Rucan,@"params", nil];
    NSLog(@"-*-*-*-*-%@",Url);
    NSLog(@"\n－－－－－请求－－－－－\n%@",ChuanCan);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    
    switch (type) {
        case Get:{
            [manager GET:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            
            break;
        case Post:{
            [manager POST:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            
            break;
    }
    
}

+(void)JuYuwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    NSUserDefaults * shuju=[NSUserDefaults standardUserDefaults];//非登录接口用
    NSString *JuYuwang=JuYuWang;//登录接口不用
    NSString *BizMethod=BizMetho;
    
    NSString *Url=[NSString stringWithFormat:@"%@%@",JuYuwang,BizMethod];
    NSLog(@"\n\n*********\n\n%@",Url);
    NSString *UserID=[shuju objectForKey:@"UserID"];//登陆不用传
    NSLog(@"%@",UserID);
    NSString *vaildToken=@"";//传空或非空
    NSString *accessToken=[shuju objectForKey:@"accessToken"];//登陆不用传
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    
    NSDictionary*BizParamStr=BizParamSt;
    
    NSString *Rucan=[writer stringWithObject:BizParamStr];
    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",vaildToken,@"vaildToken",UserID,@"userid",accessToken,@"accessToken",Rucan,@"params", nil];
    NSLog(@"%@",ChuanCan);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    
    switch (type) {
        case Get:{
            [manager GET:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            
            break;
        case Post:{
            [manager POST:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            
            break;
    }
}


+(void)QianWaiWangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    NSUserDefaults * shuju=[NSUserDefaults standardUserDefaults];//非登录接口用
    NSString *QianWaiwang=QianWaiWang;//登录接口不用
    NSString *BizMethod=BizMetho;
    
    NSString *Url=[NSString stringWithFormat:@"%@%@",QianWaiwang,BizMethod];
    NSLog(@"\n\n*********\n\n%@",Url);
    NSString *UserID=[shuju objectForKey:@"userId"];//登陆不用传
    NSLog(@"%@",UserID);
    NSString *vaildToken=@"";//传空或非空
    NSString *accessToken=[shuju objectForKey:@"accessToken"];//登陆不用传
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    
    NSDictionary*BizParamStr=BizParamSt;
    
    NSString *Rucan=[writer stringWithObject:BizParamStr];
    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",vaildToken,@"vaildToken",UserID,@"userid",accessToken,@"accessToken",Rucan,@"params", nil];
    NSLog(@"%@",ChuanCan);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    
    switch (type) {
        case Get:{
            [manager GET:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            
            break;
        case Post:{
            [manager POST:Url parameters:ChuanCan progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            
            break;
    }
}


+(void)ShangChuanTuPianwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type image:(UIImage*)image key:(NSString*)key success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    NSString *JuYuwang=QianWaiWang;//登录接口不用
    NSString *BizMethod=BizMetho;
    
    NSString *Url=[NSString stringWithFormat:@"%@%@",JuYuwang,BizMethod];
    NSLog(@"\n\n*********\n\n%@",Url);
    
    
   
//    NSString *vaildToken=@"";//传空或非空
   
//    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    
    NSDictionary*BizParamStr=BizParamSt;
    
//    NSString *Rucan=[writer stringWithObject:BizParamStr];
//    
//    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",vaildToken,@"vaildToken",UserID,@"userid",accessToken,@"accessToken",Rucan,@"params", nil];
//    NSLog(@"%@",ChuanCan);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    
    [manager POST:Url parameters:BizParamStr constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data= UIImageJPEGRepresentation(image, 0.5); //如果用jpg方法需添加jpg压缩方法
        NSDateFormatter *fm = [[NSDateFormatter alloc] init];
        // 设置时间格式
        fm.dateFormat = @"yyyyMMdd_HHmmss";
        NSString *str = [fm stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:key fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

}
@end
