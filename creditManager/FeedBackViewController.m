//
//  FeedBackViewController.m
//  creditManager
//
//  Created by haodai on 16/3/21.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UITextView+Placeholder.h"
#import "ZYTextField.h"
#import "ReactiveCocoa.h"
@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet ZYTextField *qq;
@property (weak, nonatomic) IBOutlet ZYTextField *mail;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.placeholder = @"请详细描述您的问题或建议，我们将及时跟进与解决!";
    ViewBorderRadius(_textView, 1, 1, [UIColor colorWithHexColorString:@"f0f0f0"]);
    _qq.removeView = self.view;
    _qq.enableKeyBoardHeight = YES;
    _mail.removeView = self.view;
    _mail.enableKeyBoardHeight = YES;
    
    [self.qq.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.qq resignFirstResponder];
        }
    }];
    
    
    [self.mail.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.mail resignFirstResponder];
        }
    }];
    
    [self.textView.rac_textSignal subscribeNext:^(NSString* x) {
        if ([x isEqualToString:@"\n"]) {
            [self.textView resignFirstResponder];
        }
    }];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (IBAction)submit:(id)sender {
    if (![_textView hasText]) {
        mAlertView(@"", @"请输入您的反馈信息");
        return;
    }
    if (![_qq hasText] && ![_mail hasText]) {
        mAlertView(@"", @"请至少留下一种联系方式");
        return;
    }
    [[HTTPClientManager manager] POST:@"userLogin/feedback?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"content":_textView.text,@"contact":_mail.text,@"qq":_qq.text} success:^(id responseObject) {
        mAlertView(@"提交成功", @"感谢您的反馈！");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
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
