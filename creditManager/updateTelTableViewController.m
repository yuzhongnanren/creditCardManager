//
//  updateTelTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "updateTelTableViewController.h"
#import "ReactiveCocoa.h"
#import "AES128Base64Util.h"

@interface updateTelTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

@implementation updateTelTableViewController
{
    NSInteger seconds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
  
    
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    seconds = 90;
    [self.password.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.password resignFirstResponder];
        }
    }];
    
    [self.tel.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.tel resignFirstResponder];
        }
    }];
    
    [self.code.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.code resignFirstResponder];
        }
    }];

}

- (IBAction)getCode:(id)sender {
    if (StringIsNull(_tel.text)) {
        mAlertView(@"", @"请输入手机号码");
        return;
    }
    BOOL b = [NSString validateMobile:_tel.text];
    if (!b) {
        mAlertView(@"", @"请填写正确的手机号码")
        return;
    }
    NSString *tel = [AES128Base64Util AES128Encrypt:_tel.text withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    _getCodeBtn.userInteractionEnabled = NO;
    [[HTTPClientManager manager] POST:@"sns/get_verify_code?" dictionary:@{@"mobile":tel,@"telid":@"4",@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            _getCodeBtn.userInteractionEnabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        _getCodeBtn.userInteractionEnabled = YES;
    } view:self.view progress:YES];

}

- (IBAction)save:(id)sender {
    if (StringIsNull(_password.text)) {
        mAlertView(@"", @"请输入原来的密码");
        return;
    }
    if (StringIsNull(_tel.text)) {
        mAlertView(@"", @"请输入手机号码");
        return;
    }
    if (StringIsNull(_code.text)) {
        mAlertView(@"", @"请输入验证码");
    }
    if (![NSString validateMobile:_tel.text]) {
        mAlertView(@"", @"请输入正确的手机号码");
        return;
    }
    NSString *oldtel = [AES128Base64Util AES128Encrypt:[ZYCacheManager shareInstance].user.telephone withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    NSString *newtel = [AES128Base64Util AES128Encrypt:_tel.text withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    [[HTTPClientManager manager] POST:@"UserCenter/change_mobile?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"mobile":oldtel,@"checksms":_code.text,@"new_mobile":newtel,@"passwd":_password.text} success:^(id responseObject) {
        mAlertView(@"修改成功",@"");
        [ZYCacheManager shareInstance].user.telephone = _tel.text;
        [[ZYCacheManager shareInstance] save];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerFireMethod {
    if (seconds == 1) {
        [self getCodeBtnStatus];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"(%lds)",(long)seconds];
        [_getCodeBtn setTitle:title forState:UIControlStateNormal];
        _getCodeBtn.userInteractionEnabled = NO;
    }
}


- (void)getCodeBtnStatus {
    [_timer invalidate];
    seconds = 90;
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _getCodeBtn.userInteractionEnabled = YES;
}


@end
