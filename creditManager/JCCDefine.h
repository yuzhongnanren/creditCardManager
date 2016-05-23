//
//  JCCDefine.h
//  JCC
//
//  Created by feng jia on 14-8-4.
//  Copyright (c) 2014年 feng jia. All rights reserved.
//

#define mCommonColor  [UIColor colorWithRed:224.0/255.0 green:158.0/255.0 blue:124.0/255.0 alpha:1.000] //#ff5d3b
#define mBlueColor [UIColor colorWithHexColorString:@"00aaee"]

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define NavigationBarHeight 64.f
#define TabBarHeight 49.f


#define StoryBoardDefined(a) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:a]
#define LoadNibWithName(a)  [[[NSBundle mainBundle] loadNibNamed:a owner:self options:nil] objectAtIndex:0]

#define TelephoneWithNumber(view,a) \
  NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",a]];\
  UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];\
  [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];\
   [view addSubview:phoneCallWebView];\


// block self
#ifndef isNull
#define isNull(a)  ( (a==nil) || ((NSNull*)a==[NSNull null]) )
#define isNotNull(a)  (!isNull(a))
#endif


#define StringIsNull(string) (string == nil || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)

#define WEAKSELF typeof(self) __weak weakSelf = self;

#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;



// 字体颜色
#define Gray136             [UIColor colorWithHexColorString:@"808080"]
//一般正文

#define TextColorDeep       RGBCOLOR(51, 51, 51)//突出正文

#define TextColorTip        RGBCOLOR(153, 153, 153) //提示文字

#define LineColor  RGBCOLOR(222, 222, 222)//边框线条


// 背景灰
#define BackgroundColor    [UIColor colorWithHexColorString:@"f5f6f8"]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

