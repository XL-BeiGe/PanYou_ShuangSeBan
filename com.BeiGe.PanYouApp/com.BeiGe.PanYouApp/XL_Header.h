//
//  XL_Header.h
//  PanDianDanJi
//
//  Created by 小狼 on 16/9/7.
//  Copyright © 2016年 BinXiaolang. All rights reserved.

/*125.211.221.232:9000*/
#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define Host    @""
#define Port    @"80"

#define Scheme  @"http://"
#define AppName @"/stockmgr"
#define apath    @"/api/rest/1.0"

#define WaiWang [NSString stringWithFormat:@"%@%@%@%@",Scheme,JuyuwangIP,AppName,apath]
#define waiWaiWang [NSString stringWithFormat:@"%@%@%@%@",Scheme,juyuwaiwangIP,AppName,apath]
#define QianWaiWang [NSString stringWithFormat:@"%@%@%@%@",Scheme,QianWaiWangIP,AppName,apath]
#define JuyuwangIP [[NSUserDefaults standardUserDefaults] objectForKey:@"JuYuWang"]
#define JuYuWang [NSString stringWithFormat:@"%@%@%@%@",Scheme,JuyuwangIP,AppName,apath]
#define juyuwaiwangIP  [[NSUserDefaults standardUserDefaults] objectForKey:@"JuYuWai"]
#define JuYuWai [NSString stringWithFormat:@"%@%@%@%@",Scheme,juyuwaiwangIP,AppName,apath]
//==1 为网络盘点    ==0为单机盘点
#define panduan  [[NSUserDefaults standardUserDefaults] objectForKey:@"isPandian"]

//#define QianWaiWangIP @"192.168.1.118:8080"
//#define QianWaiWangIP @"192.168.1.122:8081"//徐老师
//#define QianWaiWangIP @"192.168.1.144:8082"
#define QianWaiWangIP @"125.211.221.232:60088"
#define QianWaiWang [NSString stringWithFormat:@"%@%@%@%@",Scheme,QianWaiWangIP,AppName,apath]

#define Appkey   @"d800528f235e4142b78a8c26c4d537d9"

#define TongBuShiTiLei [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"approvalNumber",@"text",@"barCode",@"text",@"costPrice",@"text",@"id",@"text",@"isNewRecord",@"text",@"manufacturer",@"text",@"prodBatchNo",@"text",@"productCode",@"text",@"productName",@"text",@"pycode",@"text",@"salePrice",@"text",@"specification",@"text",@"vipPrice", nil]

#define TongBuBiaoMing @"tongbu"

#define XiaZaiShiTiLei [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"approvalNumber",@"text",@"barCode",@"text",@"checkId",@"text",@"checkNum",@"text",@"costPrice",@"text",@"id",@"text",@"manufacturer",@"text",@"oldpos",@"text",@"prodBatchNo",@"text",@"productCode",@"text",@"productName",@"text",@"purchaseBatchNo",@"text",@"pycode",@"text",@"salePrice",@"text",@"specification",@"text",@"status",@"integer",@"stockNum",@"text",@"vipPrice",@"text",@"f1",@"text",@"f2", nil]


#define XiaZaiBiaoMing @"xiazai"
/*
 //	盘点批次号
    String checkId;
	
 //	药品编号
	String productCode;
	
 //	药品名称
	String productName;
	
 //	批号
	String prodBatchNo;
	
 //	盘点数量
	int checkNum;
	
 //	货位号
	String newpos;
	
 //	生产厂家
	String manufacturer;
	
 //	规格
	String specification;
	
 //	条码号
	String barCode;
	
 //	批准文号
	String approvalNumber;
	
 //	助记码
	String pycode;
	
 //	状态
	String status;
	
 //	盘点时间
	String checkTime;
 */
#define ShangChuanShiTiLei [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"productCode",@"text",@"checkNum",@"text",@"prodBatchNo",@"text",@"status",@"text",@"checkTime",@"text",@"productName",@"text",@"manufacturer",@"text",@"specification",@"text",@"barCode",@"text",@"approvalNumber",@"text",@"pycode",@"text",@"checkId",@"text",@"newpos",@"text",@"f1",@"text",@"f2", nil]

#define ShangChuanBiaoMing @"shangchuan"

#define ChaXunShiTiLei [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"costPrice",@"text",@"salePrice",@"text",@"vipPrice",@"text",@"pycode",@"text",@"barCode",@"text",@"manufacturer",@"text",@"productName",@"text",@"productCode",@"text",@"specification",@"text",@"approvalNumber",@"text",@"id",@"text",@"isNewRecord", nil]

#define ChaXunBiaoMing @"chaxun"
