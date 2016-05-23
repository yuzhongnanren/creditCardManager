//
//  SubmitCreditMessage.m
//  creditManager
//
//  Created by haodai on 16/3/15.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "SubmitCreditMessage.h"
#import "AES128Base64Util.h"
#import "CreditCardFormSubmit.h"
#import "ReactiveCocoa.h"

@interface SubmitCreditMessage ()
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SubmitCreditMessage
{
    NSInteger seconds;
}


- (void)awakeFromNib {
    // Initialization code
    UIViewController *controller = [self getViewController];
    if (controller){
        @weakify(self)
        [controller.rac_willDeallocSignal
         subscribeCompleted:^{
             @strongify(self);
             [self.timer invalidate];
              self.timer = nil;
         }];
    }
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    seconds = 90;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCreditForm:(SubmitCredit *)creditForm {
    if (creditForm == nil) {
        return;
    }
    _creditForm = creditForm;
    _education.text = creditForm.education;
    _house.text = creditForm.house;
    _creditMessage.text = creditForm.creditMessage;
    _work.text = creditForm.work;
    _companyType.text = creditForm.companyType;
    _socialSecurity.text = creditForm.socialSecurity;
    _workIndetified.text = creditForm.workIndetified;
    _id_card.text = creditForm.id_card;
    _name.text = creditForm.name;
    _district.text = creditForm.district;
    _address.text = creditForm.address;
    _tel.text = creditForm.tel;
    _code.text = creditForm.code;
}

- (IBAction)getCode:(id)sender {
    if (_creditForm.tel == nil || [_creditForm.tel isEqualToString:@""]) {
        mAlertView(@"", @"请输入手机号码");
        return;
    }
    
    BOOL b = [NSString validateMobile:_creditForm.tel];
    if (!b) {
        mAlertView(@"", @"请填写正确的手机号码")
        return;
    }
    
    NSString *tel = [AES128Base64Util AES128Encrypt:_creditForm.tel withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    _getCodeBtn.userInteractionEnabled = NO;
    [[HTTPClientManager manager] POST:@"sns/get_verify_code?" dictionary:@{@"mobile":tel,@"telid":@"6",@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            _getCodeBtn.userInteractionEnabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        _getCodeBtn.userInteractionEnabled = YES;
    } view:self progress:NO];
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


- (UIViewController*)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[CreditCardFormSubmit class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (void)dealloc {
    NSLog(@"122222");
    [self.timer invalidate];
    self.timer = nil;
}

@end
