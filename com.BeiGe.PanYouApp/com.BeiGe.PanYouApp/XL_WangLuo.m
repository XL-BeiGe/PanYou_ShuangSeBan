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
#import "ViewController.h"
#import "XLLogin_ViewController.h"
@implementation XL_WangLuo
/*
 * 登陆专用
 * 这个接口是单机版的登录；
 */
+(void)WaiwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure{
    NSString *Waiwang;
    if([panduan isEqual:@"1"]){
        Waiwang=waiWaiWang;
    }else{
        Waiwang=WaiWang;
    }
    
    NSString *BizMethod=BizMetho;
    
    NSString *Url=[NSString stringWithFormat:@"%@%@",Waiwang,BizMethod];
    
    NSString *UserID=@"";
    NSString *vaildToken=@"1";//传空或非空
    NSString *accessToken=@"";//登陆不用传
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    NSDictionary*BizParamStr=BizParamSt;
    NSString *Rucan=[writer stringWithObject:BizParamStr];
    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",UserID,@"userid",vaildToken,@"vaildToken",accessToken,@"accessToken",Rucan,@"params", nil];
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
/*
 *单机版的接口
 *除了登录
 */
+(void)JuYuwangQingqiuwithBizMethod:(NSString*)BizMetho Rucan:(NSDictionary*)BizParamSt type:(Post_or_Get)type success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    NSUserDefaults * shuju=[NSUserDefaults standardUserDefaults];//非登录接口用
    NSString *JuYuwang;//登录接口不用
    if([panduan isEqual:@"1"]){
        JuYuwang=JuYuWai;
    }else{
        JuYuwang=JuYuWang;
    }
    NSString *BizMethod=BizMetho;
    
    NSString *Url=[NSString stringWithFormat:@"%@%@",JuYuwang,BizMethod];
    NSString *UserID=[shuju objectForKey:@"UserID"];//登陆不用传
    NSString *vaildToken=@"";//传空或非空
    NSString *accessToken=[shuju objectForKey:@"accessToken"];//登陆不用传
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    
    NSDictionary*BizParamStr=BizParamSt;
    
    NSString *Rucan=[writer stringWithObject:BizParamStr];
    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",vaildToken,@"vaildToken",UserID,@"userid",accessToken,@"accessToken",Rucan,@"params", nil];
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
    NSString *UserID=[shuju objectForKey:@"userId"];//登陆不用传
    NSString *vaildToken=@"";//传空或非空
    NSString *accessToken=[shuju objectForKey:@"accesstoken"];//登陆不用传
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    
    NSDictionary*BizParamStr=BizParamSt;
    
    NSString *Rucan=[writer stringWithObject:BizParamStr];
    NSDictionary *ChuanCan=[NSDictionary dictionaryWithObjectsAndKeys:Appkey,@"appkey",vaildToken,@"vaildToken",UserID,@"userid",accessToken,@"accessToken",Rucan,@"params", nil];
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
    NSDictionary*BizParamStr=BizParamSt;
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
+(void)sigejiu:(UIViewController*)vv{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"您的账号已在其他手机登录，请重新登录..." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //具体实现逻辑代码
        ViewController*view=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"llogin"];
        [view setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [vv presentViewController:view animated:YES completion:nil];
    }];
    [alert addAction:cancel];
    //显示提示框
    [vv presentViewController:alert animated:YES completion:nil];
    
}
+(void)youyigesigejiu:(UIViewController*)vv :(int)i{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"您的账号已在其他手机登录，请重新登录..." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (i==1) {
            [self sigejiu:vv];
        }else{
            //具体实现逻辑代码
            XLLogin_ViewController*view=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
            [view setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [vv presentViewController:view animated:YES completion:nil];
        }
    }];
    [alert addAction:cancel];
    //显示提示框
    [vv presentViewController:alert animated:YES completion:nil];
}
@end
