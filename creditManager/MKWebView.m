//
//  MKWebView.m
//  ZJT
//
//  Created by wangcy on 14-8-12.
//  Copyright (c) 2014年 zjt. All rights reserved.
//

#import "MKWebView.h"

#import "Masonry.h"

#define KTagActivitity 6666


@implementation MKWebView
@synthesize webView = _webView;

- (void)awakeFromNib {
    
    _webView = [[UIWebView alloc] initWithFrame:self.bounds];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    //这里传来的数据有可能是网址

}

- (id)initWithFrame:(CGRect)frame url:(NSString*)html type:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self addSubview:_webView];
        //这里传来的数据有可能是网址
        if ([type isEqualToString:@"string"]) {
                if (isNotNull(html)) {
                    [_webView loadHTMLString:html baseURL:nil];
                }
        }else {
                if (isNotNull(html)) {
                    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:html]]];
                }
        }
    }
    return self;
}

- (void)setScroll:(BOOL)scroll {
    _scroll = scroll;
    if (scroll) {
        _webView.scrollView.scrollEnabled = YES;
    }else {
        _webView.scrollView.scrollEnabled = NO;
    }
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

#pragma mark -
#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[webView viewWithTag:KTagActivitity] removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIActivityIndicatorView *_activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activity.center = webView.center;
    _activity.tag = KTagActivitity;
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [webView addSubview:_activity];
    [_activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    CGFloat height = [height_str floatValue];

    NSLog(@"height: %@//%f", [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"],webView.scrollView.contentSize.height);
    if ([self.delegate respondsToSelector:@selector(MKWebViewFinishContentHeight:)]) {
        [self.delegate MKWebViewFinishContentHeight:height];
    }
    [[webView viewWithTag:KTagActivitity] removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[request URL];
    NSLog(@"--%@--scheme:%@",[[requestURL relativeString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[requestURL scheme]);
    if (([[requestURL scheme] isEqualToString:@"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString: @"mailto" ])
        && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        return YES;
    }
    return YES;
}


- (void)dealloc {
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
    
@end

