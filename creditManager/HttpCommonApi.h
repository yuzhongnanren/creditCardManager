//
//  HttpCommonApi.h
//  Shandai
//
//  Created by haodai on 15/12/29.
//  Copyright © 2015年 haodai. All rights reserved.
//

#ifndef HttpCommonApi_h
#define HttpCommonApi_h

//接口地址：http://api.haodai.com
//正式a24ed9b29a8d6b1a38c82990dfec220e
//测试接口地址 : http://sandbox.api.haodai.com
//测试1dd7f6eb4cf408114b1b8d1f662eda22

#define HTTP_HeadValue_Oauth2  @"oauth2 1dd7f6eb4cf408114b1b8d1f662eda22"

#define HTTP_Source @"open.haodai"
#define HTTP_Ref @"hd_110120"
#define HTTP_Auth @"app"

#define BaseUrl   @"http://sandbox.api.haodai.com"

#define HTML5_URL @"http://8.yun.haodai.com/"

#define AUTH_IV @"#u)aK&B-Wrg!G|t6"

#define ServerVersion @"1.0"//服务器版本

#define Register_device  @"/capi/sys/register_device.json"

#define Get_verify_code @"/capi/sns/get_verify_code.json"

#endif /* HttpCommonApi_h */
