//
//  UIViewController+MobClick.m
//  creditManager
//
//  Created by haodai on 16/4/25.
//  Copyright © 2016年 haodai. All rights reserved.
//
#import <objc/runtime.h>
#import "UIViewController+MobClick.h"

@implementation UIViewController (MobClick)

+ (void)load {
    [super load];
    // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。 viewWillAppear
    Method fromMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"viewWillAppear:"));
    Method toMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"swizzlingViewWillAppear"));
   
    Method fromMethod1 = class_getInstanceMethod([self class], NSSelectorFromString(@"viewWillDisappear:"));
    Method toMethod1 = class_getInstanceMethod([self class], NSSelectorFromString(@"swizzlingViewWillDisappear"));
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], NSSelectorFromString(@"viewWillAppear:"), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
    if (!class_addMethod([self class], NSSelectorFromString(@"viewWillDisappear:"), method_getImplementation(toMethod1), method_getTypeEncoding(toMethod1))) {
        method_exchangeImplementations(fromMethod1, toMethod1);
    }
}

// 我们自己实现的方法，也就是和self的viewwillappear方法进行交换的方法。
- (void)swizzlingViewWillAppear {
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
    if([str isEqualToString:@"HomeViewController"]){
        [MobClick beginLogPageView:@"首页"];
    }else if([str isEqualToString:@"CityViewController"]) {
        [MobClick beginLogPageView:@"城市选择"];
    }else if([str isEqualToString:@"CreditProgressViewController"]) {
        [MobClick beginLogPageView:@"进度查询"];
    }else if([str isEqualToString:@"CreditListViewController"]) {
        [MobClick beginLogPageView:@"信用卡列表"];
    }else if([str isEqualToString:@"CreditDetailViewController"]) {
        [MobClick beginLogPageView:@"信用卡详情"];
    }else if([str isEqualToString:@"CreditCardFormSubmit"]) {
        [MobClick beginLogPageView:@"信用卡表单提交"];
    }else if([str isEqualToString:@"CardSubmitSuccess"]) {
        [MobClick beginLogPageView:@"提交成功"];
    }else if([str isEqualToString:@"ApplyCardViewController"]) {
        [MobClick beginLogPageView:@"办卡"];
    }else if([str isEqualToString:@"CardSortViewController"]) {
        [MobClick beginLogPageView:@"卡排行"];
    }else if([str isEqualToString:@"CardDiscountViewController"]) {
        [MobClick beginLogPageView:@"卡优惠"];
    }else if([str isEqualToString:@"CardServerTableViewController"]) {
        [MobClick beginLogPageView:@"卡服务"];
    }else if([str isEqualToString:@"CardInformationViewController"]) {
        [MobClick beginLogPageView:@"卡资讯"];
    }else if([str isEqualToString:@"BankMessageTableViewController"]) {
        [MobClick beginLogPageView:@"银行信息"];
    }else if([str isEqualToString:@"BankTelTableViewController"]) {
        [MobClick beginLogPageView:@"银行电话"];
    }else if([str isEqualToString:@"LoginViewController"]) {
        [MobClick beginLogPageView:@"登录"];
    }else if([str isEqualToString:@"RegisterViewController"]) {
        [MobClick beginLogPageView:@"注册"];
    }else if([str isEqualToString:@"UserTableViewController"]) {
        [MobClick beginLogPageView:@"我的"];
    }else if([str isEqualToString:@"UserMessageViewController"]) {
        [MobClick beginLogPageView:@"个人资料"];
    }else if([str isEqualToString:@"MyCreditCardViewController"]) {
        [MobClick beginLogPageView:@"我的信用卡"];
    }else if([str isEqualToString:@"BangCreditTableViewController"]) {
        [MobClick beginLogPageView:@"绑卡"];
    }else if([str isEqualToString:@"MyStoreCardViewController"]) {
        [MobClick beginLogPageView:@"我想申请的卡"];
    }else if([str isEqualToString:@"SecretSetTableViewController"]) {
        [MobClick beginLogPageView:@"设置"];
    }else if([str isEqualToString:@"UpdatePasswordTableViewController"]) {
        [MobClick beginLogPageView:@"更新密码"];
    }else if([str isEqualToString:@"updateTelTableViewController"]) {
        [MobClick beginLogPageView:@"更换手机"];
    }else if([str isEqualToString:@"FeedBackViewController"]) {
        [MobClick beginLogPageView:@"反馈"];
    }else if([str isEqualToString:@"StagingCalculatorViewController"]) {
        [MobClick beginLogPageView:@"分期计算器"];
    }
    [self swizzlingViewWillAppear];
}

- (void)swizzlingViewWillDisappear {
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
    if([str isEqualToString:@"HomeViewController"]){
        [MobClick endLogPageView:@"首页"];
    }else if([str isEqualToString:@"CityViewController"]) {
        [MobClick endLogPageView:@"城市选择"];
    }else if([str isEqualToString:@"CreditProgressViewController"]) {
        [MobClick endLogPageView:@"进度查询"];
    }else if([str isEqualToString:@"CreditListViewController"]) {
        [MobClick endLogPageView:@"信用卡列表"];
    }else if([str isEqualToString:@"CreditDetailViewController"]) {
        [MobClick endLogPageView:@"信用卡详情"];
    }else if([str isEqualToString:@"CreditCardFormSubmit"]) {
        [MobClick endLogPageView:@"信用卡表单提交"];
    }else if([str isEqualToString:@"CardSubmitSuccess"]) {
        [MobClick endLogPageView:@"提交成功"];
    }else if([str isEqualToString:@"ApplyCardViewController"]) {
        [MobClick endLogPageView:@"办卡"];
    }else if([str isEqualToString:@"CardSortViewController"]) {
        [MobClick endLogPageView:@"卡排行"];
    }else if([str isEqualToString:@"CardDiscountViewController"]) {
        [MobClick endLogPageView:@"卡优惠"];
    }else if([str isEqualToString:@"CardServerTableViewController"]) {
        [MobClick endLogPageView:@"卡服务"];
    }else if([str isEqualToString:@"CardInformationViewController"]) {
        [MobClick endLogPageView:@"卡资讯"];
    }else if([str isEqualToString:@"BankMessageTableViewController"]) {
        [MobClick endLogPageView:@"银行信息"];
    }else if([str isEqualToString:@"BankTelTableViewController"]) {
        [MobClick endLogPageView:@"银行电话"];
    }else if([str isEqualToString:@"LoginViewController"]) {
        [MobClick endLogPageView:@"登录"];
    }else if([str isEqualToString:@"RegisterViewController"]) {
        [MobClick endLogPageView:@"注册"];
    }else if([str isEqualToString:@"UserTableViewController"]) {
        [MobClick endLogPageView:@"我的"];
    }else if([str isEqualToString:@"UserMessageViewController"]) {
        [MobClick endLogPageView:@"个人资料"];
    }else if([str isEqualToString:@"MyCreditCardViewController"]) {
        [MobClick endLogPageView:@"我的信用卡"];
    }else if([str isEqualToString:@"BangCreditTableViewController"]) {
        [MobClick endLogPageView:@"绑卡"];
    }else if([str isEqualToString:@"MyStoreCardViewController"]) {
        [MobClick endLogPageView:@"我想申请的卡"];
    }else if([str isEqualToString:@"SecretSetTableViewController"]) {
        [MobClick endLogPageView:@"设置"];
    }else if([str isEqualToString:@"UpdatePasswordTableViewController"]) {
        [MobClick endLogPageView:@"更新密码"];
    }else if([str isEqualToString:@"updateTelTableViewController"]) {
        [MobClick endLogPageView:@"更换手机"];
    }else if([str isEqualToString:@"FeedBackViewController"]) {
        [MobClick endLogPageView:@"反馈"];
    }else if([str isEqualToString:@"StagingCalculatorViewController"]) {
        [MobClick endLogPageView:@"分期计算器"];
    }
    [self swizzlingViewWillDisappear];
}
@end
