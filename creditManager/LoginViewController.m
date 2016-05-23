//
//  LoginViewController.m
//  creditManager
//
//  Created by haodai on 16/3/17.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "LoginViewController.h"
#import "AES128Base64Util.h"
#import "ZYControllerManager.h"
#import "ReactiveCocoa.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *commonLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *fastLoginBtn;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UILabel *codeTip;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, assign) NSInteger type;//1表示普通登录 2表示快速登录
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *y_line;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *line;

@end

@implementation LoginViewController
{
    NSInteger seconds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_commonLoginBtn setTitleColor:[UIColor colorWithHexColorString:@"808080"] forState:0];
    [_commonLoginBtn setTitleColor:mBlueColor forState:UIControlStateSelected];
    [_fastLoginBtn setTitleColor:[UIColor colorWithHexColorString:@"808080"] forState:0];
    [_fastLoginBtn setTitleColor:mBlueColor forState:UIControlStateSelected];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 42.f, SCREEN_WIDTH/2, 2.f)];
    _line.backgroundColor = mBlueColor;
    [self.backView addSubview:_line];
    
    self.type = 1;
    
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    seconds = 90;
    
    [self.tel.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.tel resignFirstResponder];
        }
    }];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (_type == 1) {
        _fastLoginBtn.selected = NO;
        _commonLoginBtn.selected = YES;
        _line.left = 0;
        _codeTip.text = @"密码";
        _code.placeholder = @"请输入密码";
        _code.secureTextEntry = YES;
        _getCodeBtn.hidden = YES;
        _y_line.hidden = YES;
    }else {
        _fastLoginBtn.selected = YES;
        _commonLoginBtn.selected = NO;
        _line.left = SCREEN_WIDTH/2;
        _codeTip.text = @"验证码";
        _code.placeholder = @"请输入验证码";
        _code.secureTextEntry = NO;
        _getCodeBtn.hidden = NO;
        _y_line.hidden = NO;
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)commonLogin:(id)sender {
    self.type = 1;
}

- (IBAction)fastLogin:(id)sender {
    self.type = 2;
}

- (IBAction)login:(id)sender {
    if (_type == 1) {
        if (StringIsNull(_tel.text)) {
            mAlertView(@"", @"请输入手机号码");
            return;
        }
        if (StringIsNull(_code.text)) {
            mAlertView(@"", @"请输入密码");
            return;
        }
        [MobClick event:@"login"];
        NSString *tel = [AES128Base64Util AES128Encrypt:_tel.text withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
        [[HTTPClientManager manager] POST:@"userLogin/login?" dictionary:@{@"mobile":tel,@"is_code_login":@"0",@"checksms":@"",@"passwd":_code.text} success:^(id responseObject) {
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
    }else {
        if (StringIsNull(_tel.text)) {
            mAlertView(@"", @"请输入手机号码");
            return;
        }
        if (StringIsNull(_code.text)) {
            mAlertView(@"", @"请输入验证码");
            return;
        }
        [MobClick event:@"login"];
        NSString *tel = [AES128Base64Util AES128Encrypt:_tel.text withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
        [[HTTPClientManager manager] POST:@"userLogin/login?" dictionary:@{@"mobile":tel,@"is_code_login":@"1",@"checksms":_code.text,@"passwd":@""} success:^(id responseObject) {
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
    [[HTTPClientManager manager] POST:@"sns/get_verify_code?" dictionary:@{@"mobile":tel,@"telid":@"1",@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            _getCodeBtn.userInteractionEnabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        _getCodeBtn.userInteractionEnabled = YES;
    } view:self.view progress:YES];
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
