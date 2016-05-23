//
//  AppMacDef.h
//  abc
//
//  Created by fengjia on 8/21/13.
//  Copyright (c) 2013 fengjia. All rights reserved.
//
#import "AppDelegate.h"
/*---------------------------------程序相关常数-------------------------------------*/
#pragma mark - App 相关

#define YouMeng_Key @"56fcb64667e58e7e670006b7"

//默认的设备did和key

#define Auth_Key @"Eb953db38ae22be0"
#define Auth_Did @"10002"


//征信查询的Key
#define APPKEY @"tBb2Ta6UJhRJ04W77qGXdows19m0Vjj4"
#define MD5KEY @"23SDfds13t23dVVadBYfsDF35453FID1"

//App Id、下载地址、评价地址
#define mAppId      @"1100573907"
#define mAppUpdate    [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", mAppId]
#define mAppUrl       [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",mAppId]
#define mRateUrl      [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",mAppId]
#define mRateUrl_iOS7 [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",mAppId]

#define mAppAddress  [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",mAppId]

/*----------------------------------方法相关宏定义------------------------------------*/
#pragma mark -
#pragma mark - 常用方法宏定义
//方法简写
#define mDocumentsDir       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define mAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define mFileManager        [NSFileManager defaultManager]
#define mNotificationCenter [NSNotificationCenter defaultCenter]

//简单的以AlertView显示提示信息
#define mAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];\

#define ProgressLoading(a) if(a){\
[[JCCUtils sharedInstance] showProgressHud:self.view withMessage:@"信息加载中..."];\
}\

//加载图片
#define mImageByName(name)        [UIImage imageNamed:name]
#define mImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]

//以tag读取View
#define mViewByTag(parentView, tag, Class)  (Class *)[parentView viewWithTag:tag]
//读取Xib文件的类
#define mViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

//id对象与NSData之间转换
#define mObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define mDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

//度弧度转换
#define mDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define mRadianToDegrees(radian) (radian*180.0) / (M_PI)

//---------颜色相关---------
//颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mmRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

//----------设备系统相关---------
#define mRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiPhone5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH  ==  568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH  ==  667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH ==  736.0)

#define mIsPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define mIsiphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define Target_iOS8   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) ? YES : NO
#define Target_iOS7   ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) ? YES : NO
#define Target_iOS6   ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0f) ? YES : NO


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define IOS7_SDK_AVAILABLE 1
#endif



#define mSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define mCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define mAPPVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define mDeviceName      [UIDevice currentDevice].model]
#define mFirstLaunch     mAPPVersion     //以系统版本来判断是否是第一次启动，包括升级后启动。
#define mFirstRun        @"firstRun"     //判断是否为第一次运行，升级后启动不算是第一次运行

//--------调试相关-------

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define mSafeRelease(object)     [object release]; object=nil
#endif

//调试模式下输入NSLog，发布后不再输入。
#ifndef __OPTIMIZE__
#define NSLog(fmt, ...) NSLog((@"%s[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

/*-------------------------------------内联函数的宏定义（程序中可直接调用）----------------------------------------*/
#pragma mark -
#pragma mark - 内联函数的宏定义
//获取appDelegate实例。
UIKIT_STATIC_INLINE AppDelegate *appDelegate()
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
//生成uuid
UIKIT_STATIC_INLINE NSString *uuid()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef str_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)str_ref];    
    CFRelease(str_ref);
    return uuid;
}
//设置TableView选中背景,自行根据需要更改里面函数
UIKIT_STATIC_INLINE UIView *selectedBgView(CGRect rect, UIImage *image)
{
    if (image) {
        UIImageView *selectedImageView = [[UIImageView alloc] initWithFrame:rect];
        selectedImageView.image = image;
        return selectedImageView;
    } else {
        UIView *selectedBgView = [[UIView alloc] initWithFrame:rect];
        [selectedBgView setBackgroundColor:[UIColor colorWithRed:60/255. green:180/255. blue:255/255. alpha:0.5]];
        return selectedBgView;
    }
}

/*-------------------------------------单例的宏定义----------------------------------------*/
#pragma mark -
#pragma mark - 单例的宏定义

#define kSingleton(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##Instance \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
