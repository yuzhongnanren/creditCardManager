//
//  GuidePageViewController.m
//  creditManager
//
//  Created by haodai on 16/4/5.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "GuidePageViewController.h"
#import "GuideView.h"
#import "ZYControllerManager.h"

@interface GuidePageViewController ()
@property (nonatomic, strong) GuideView *guideView;
@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    _guideView = [[GuideView alloc] initWithFrame:self.view.bounds];
    _guideView.exit = ^() {
        [[ZYControllerManager manager] goHome:mKeyWindow];
    };
    [self.view addSubview:_guideView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
