//
//  RegisterViewController.m
//  creditManager
//
//  Created by haodai on 16/3/17.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "RegisterViewController.h"
#import "AES128Base64Util.h"
#import "ZYControllerManager.h"
#import "ReactiveCocoa.h"
#import "JCCBaseWebViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *againPassWord;

@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RegisterViewController
{
    NSInteger seconds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    seconds = 90;
    
    [self.tel.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.tel resignFirstResponder];
        }
    }];
    
    [self.passWord.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.passWord resignFirstResponder];
        }
    }];
    
    [self.againPassWord.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.againPassWord resignFirstResponder];
        }
    }];
    
    [self.code.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.code resignFirstResponder];
        }
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - IBAction
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
    [[HTTPClientManager manager] POST:@"sns/get_verify_code?" dictionary:@{@"mobile":tel,@"telid":@"1",@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            _getCodeBtn.userInteractionEnabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        _getCodeBtn.userInteractionEnabled = YES;
    } view:self.view progress:YES];
}


- (IBAction)enterRegister:(id)sender {
    if (![_tel hasText]) {
        mAlertView(@"", @"请输入手机号");
        return;
    }
    if (![_passWord hasText]) {
        mAlertView(@"", @"请输入密码");
        return;
    }
    if (![_againPassWord hasText]) {
        mAlertView(@"", @"请再次输入密码")
        return;
    }
    if (![_code hasText]) {
        mAlertView(@"", @"请输入验证码");
        return;
    }
    if (![NSString validateMobile:_tel.text]) {
        mAlertView(@"", @"请输入正确的手机号码");
        return;
    }
    if (_passWord.text.length < 6) {
        mAlertView(@"", @"密码必须6位以上");
        return;
    }
    if (![_passWord.text isEqualToString:_againPassWord.text]) {
        mAlertView(@"", @"您2次密码不一样");
        return;
    }
    [MobClick event:@"register"];
    NSString *tel = [AES128Base64Util AES128Encrypt:_tel.text withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    [[HTTPClientManager manager] POST:@"userLogin/signin?" dictionary:@{@"mobile":tel,@"checksms":_code.text,@"passwd":_passWord.text,@"confirm_passwd":_againPassWord.text} success:^(id responseObject) {
        [ZYCacheManager shareInstance].user.uid = [[responseObject objectForKey:@"uid"] integerValue];
        [ZYCacheManager shareInstance].user.isLogin = YES;
        [ZYCacheManager shareInstance].user.photoPath = [responseObject objectForKey:@"avatar"];
        [ZYCacheManager shareInstance].user.birthday = [responseObject objectForKey:@"birthday"];
        [ZYCacheManager shareInstance].user.telephone = _tel.text;
        [ZYCacheManager shareInstance].user.nickname = [responseObject objectForKey:@"nickname"];
        [ZYCacheManager shareInstance].user.sex = [[responseObject objectForKey:@"sex"] integerValue];
        [[ZYCacheManager shareInstance] save];
        [[ZYControllerManager manager] dismiss:self.navigationController];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
    
}

- (IBAction)agreement:(id)sender {
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.webTitle = @"用户协议";
    web.url = [BaseUrl stringByAppendingPathComponent:@"Home/Index/protocol"];
    [self.navigationController pushViewController:web animated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
