//
//  JCCWebViewController.m
//  JCC
//
//  Created by zhouyong on 15/6/12.
//  Copyright (c) 2015年 jucaicun. All rights reserved.
//

#import "JCCBaseWebViewController.h"
#import "MKWebView.h"

@interface JCCBaseWebViewController ()<MKWebViewDelegate>

@end

@implementation JCCBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//  那
    self.view.backgroundColor = [UIColor whiteColor];
    if (isNotNull(self.webTitle)) {
       self.title = self.webTitle;
    }
    
    MKWebView *webView = [[MKWebView alloc] initWithFrame:CGRectMake(0, _off_Y, self.view.width, self.view.height- NavigationBarHeight - _off_Y) url:_url type:@""];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    if (_type == 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"question"] style:UIBarButtonItemStyleBordered target:self action:@selector(enterQuestion)];
        self.navigationItem.rightBarButtonItem = item;
        webView.webView.scrollView.bounces = NO;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webLinkTouch:(NSString *)url {
    
}

- (void)enterQuestion {
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.title = @"征信查询帮助";
    web.url = [NSString stringWithFormat:@"%@/Home/Index/help",BaseUrl];
    [self.navigationController pushViewController:web animated:YES];
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
