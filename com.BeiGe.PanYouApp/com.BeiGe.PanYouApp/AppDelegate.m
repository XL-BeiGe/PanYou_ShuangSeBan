//
//  AppDelegate.m
//  com.BeiGe.PanYouApp
//
//  Created by 小狼 on 16/11/2.
//  Copyright © 2016年 BinXiaolang. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "Color+Hex.h"
#import "SDWebImage/UIImageView+WebCache.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define appkey @"f8c33a34b64f258586c0cdf3"
#define channell @""
#define isProduction @"0"


#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface AppDelegate ()<JPUSHRegisterDelegate>
//@property (strong, nonatomic) UIView *ADView;
@property (strong, nonatomic) UIView *lunchView;
@end

@implementation AppDelegate
@synthesize lunchView;

static AppDelegate *_appDelegate;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self.window makeKeyAndVisible];
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    lunchView = viewController.view;
//    lunchView = [[NSBundle mainBundle ]][0];
    lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    [self.window addSubview:lunchView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    NSString *str = @"http://pic.nipic.com/2008-04-01/20084113367207_2.jpg";
    [imageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"试题背景.png"]];
    [lunchView addSubview:imageV];
    
    [self.window bringSubviewToFront:lunchView];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    
    _appDelegate = self;
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];
    
    self.window.backgroundColor=[UIColor colorWithHexString:@"33c383"];
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:appkey
                          channel:channell
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [self method];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(localNotification) name:@"轮回公子" object:nil];
    
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
        
        [self localNotification];
        
    }else{
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    }
    
    
    
    return YES;
}
-(void)removeLun{
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        lunchView.alpha = 0.0f;
        lunchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
    } completion:^(BOOL finished) {
        [lunchView removeFromSuperview];
    }];
//     [lunchView removeFromSuperview];
}

+ (AppDelegate *)appDelegate {
    return _appDelegate;
}
-(void)method{
    NSString*tag=[[NSUserDefaults standardUserDefaults] objectForKey:@"mendian"];
    NSSet *tags=[NSSet setWithObjects:tag, nil];
    
    NSString*alias=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    
    [JPUSHService setTags:tags alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        NSLog(@"\nrescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
    }];

}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    
    // Required
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
         NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"xiaohongdian"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"111" object:nil];
    }else
     NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSString *message = [NSString stringWithFormat:@"%@", [userInfo[@"aps"] objectForKey:@"alert"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ,nil];
        [alert show];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
//    NSString *message = [NSString stringWithFormat:@"%@", [userInfo[@"aps"] objectForKey:@"alert"]];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ,nil];
    //    [alert show];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"xiaohongdian"];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSString *message = [NSString stringWithFormat:@"%@", [userInfo[@"aps"] objectForKey:@"alert"]];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ,nil];
//    [alert show];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"xiaohongdian"];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


#pragma mark ----本地通知
-(void)localNotification
{
   
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    NSString * path1 = [NSHomeDirectory() stringByAppendingString:@"/Documents/durgRemindList.plist"];
    
    NSMutableArray * pathArray1 = [[NSMutableArray alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path1];
    
    //获取用户id
    
    NSString *yhidString = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] intValue]];
    
    //获取某一个id的内容
    for (int i = 0 ; i < array.count; i++) {
        
        if ([[array[i] objectForKey:@"yhid"] isEqualToString:yhidString]) {
            
            [pathArray1 addObject:[array[i] objectForKey:@"neirong"]];
        }
    }
    
    for (NSDictionary *dic in pathArray1) {
        
        if ([[dic objectForKey:@"ison"] isEqualToString:@"1"]) {
            
            NSArray *mnt = [[dic objectForKey:@"riqi"] componentsSeparatedByString:@" "];
            
            //
            
            NSMutableArray *arr=[[NSMutableArray alloc] init];
            
            for (NSString *ser in mnt) {
                
                if (![ser isEqualToString:@"无"])
                    
                    [arr addObject:ser];
            }
            
            for (NSString *str in arr) {
                
                int mm = [self createTimeInterval:str];
                
                [self naozhong:mm ];
                
            }
        }
    }
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    [application registerForRemoteNotifications];
    
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        [self localNotification];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"盘优APP提示您!"
                          
                                                    message:notification.alertBody
                          
                                                   delegate:nil
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
    //这里，你就可以通过notification的userinfo，干一些你想做的事情了
    
    application.applicationIconBadgeNumber -= 1;
}
-(void)naozhong:(int)time
{
    UIApplication *app  = [UIApplication sharedApplication];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    if (notification) {
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
        
        // 设置重复间隔
        
        notification.repeatInterval = kCFCalendarUnitDay;
        
        
        // 设置提醒的文字内容
        
        notification.alertBody   = @"您该去考勤了";
        
        notification.alertAction = @"打开";
        
        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        // 通知提示音 使用默认的
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.soundName =@"7008.wav";
        // 设置应用程序右上角的提醒个数
        // notification.applicationIconBadgeNumber++;
        
        // 将通知添加到系统中
        [app scheduleLocalNotification:notification];
    }
}


-(int)createTimeInterval:(NSString*)timeDate
{
    NSArray *array = [timeDate componentsSeparatedByString:@":"];
    
    // int weekday1 = [array[0] intValue];
    int hour1 = [array[0] intValue];
    int minute1 = [array [1] intValue];
    
    NSDate *nowTime = [NSDate date];
    NSCalendar *calemdar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calemdar components:unitFlags fromDate:nowTime];
    
    //int weekday = (int)[dateComponent weekday];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    
    int sedconds = [self hour:(hour1 - hour)] + [self min:(minute1 - minute)];
    
    
    return sedconds;
}
-(int)hour:(int)hour
{
    hour = [self min:60]*hour;
    return hour;
}

-(int)min:(int)min
{
    min *=60;
    return min;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"111" object:nil];
}
@end
