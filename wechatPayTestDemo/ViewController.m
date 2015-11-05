//
//  ViewController.m
//  wechatPayTestDemo
//
//  Created by 3g on 15/9/13.
//  Copyright (c) 2015年 3G. All rights reserved.
//

#import "ViewController.h"

//微信sdk
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(100, 101, 111, 111);
    [payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    payButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:payButton];
}

/*********************************************
            **** 温馨提示 *****
 1.记得加URL Schemes  : wx+appId   例如：wx3ebd2asdfasdfasdf
 
 2.检查支持库、框架是否都加进来了：UIKit  CoreGraphics  Foudation SystemConfiguration
                            libz.dylib  libsqlite3.0.dylib iOS9.0后的后缀是.tbd
 
 3.项目是否强制支持了http的请求
 
 4.有没有添加微信SDK的白名单weixin  wechat
 
 5.检查：秘钥（spKey）商户号（MCH_ID）AppId 填了没有
 
 6.检查订单号会不会重复，各参数是否都正确
 
 7.微信支付的钱单位是：分
 
 8.是否支持BitCode 不支持的话要在BuildSetting里关掉bitCode
 
 *********************************************/

- (void)pay {
    
    payRequsestHandler *wxPayManager = [[payRequsestHandler alloc] initWithAppid:APP_ID mch_id:MCH_ID spKey:PARTNER_ID];
    
    //预支付,拿到的参数数据（dict）用来调起微信支付
    //为了数据安全，这一步建议在后台做，然后通过接口请求直接返回dic给到客户端
    NSMutableDictionary *dict = [wxPayManager getPrepayWithOrderName:@"test" price:@"10" device:@"app"];
    
    if (dict == nil) {
        NSString *debug = [wxPayManager getDebugifo];
        UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"提示" message:debug delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aleart show];
    }
    
    NSMutableString *stamp = [dict objectForKey:@"timestamp"];
    
    //调起微信支付客户端
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}
//******
//支付结果的处理在AppDelegate.m文件
//******


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
