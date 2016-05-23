//
//  UpdatePasswordTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "UpdatePasswordTableViewController.h"
#import "ReactiveCocoa.h"
#import "AES128Base64Util.h"

@interface UpdatePasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *againPassword;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation UpdatePasswordTableViewController
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
    [self.passWord.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.passWord resignFirstResponder];
        }
    }];
    
    [self.againPassword.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.againPassword resignFirstResponder];
        }
    }];
    
    [self.code.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.code resignFirstResponder];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}


- (IBAction)getCode:(id)sender {
   NSString *tel = [AES128Base64Util AES128Encrypt:[ZYCacheManager shareInstance].user.telephone withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    _getCodeBtn.userInteractionEnabled = NO;
    [[HTTPClientManager manager] POST:@"sns/get_verify_code?" dictionary:@{@"mobile":tel,@"telid":@"3",@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            _getCodeBtn.userInteractionEnabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        _getCodeBtn.userInteractionEnabled = YES;
    } view:self.view progress:YES];
}

- (IBAction)save:(id)sender {
    if (![_passWord hasText]) {
        mAlertView(@"", @"请输入密码");
        return;
    }
    if (![_againPassword hasText]) {
        mAlertView(@"", @"请再次输入密码")
        return;
    }
    if (![_code hasText]) {
        mAlertView(@"", @"请输入验证码");
        return;
    }
    if (_passWord.text.length < 6) {
        mAlertView(@"", @"密码必须6位以上");
        return;
    }
    if (![_passWord.text isEqualToString:_againPassword.text]) {
        mAlertView(@"", @"您2次密码不一样");
        return;
    }
     NSString *tel = [AES128Base64Util AES128Encrypt:[ZYCacheManager shareInstance].user.telephone withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    [[HTTPClientManager manager] POST:@"UserCenter/change_password" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"mobile":tel,@"checksms":_code.text,@"passwd":_passWord.text,@"confirm_passwd":_againPassword.text} success:^(id responseObject) {
        mAlertView(@"", @"密码修改成功");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
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


@end
