//
//  JCCBaseViewController.m
//  JCC
//
//  Created by feng jia on 14-12-26.
//  Copyright (c) 2014年 jucaicun. All rights reserved.
//

#import "JCCBaseViewController.h"

@interface JCCBaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation JCCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.showMode = JCCPush;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_hiddenBackBtn) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:mImageByName(@"backarrow_icon") style:UIBarButtonItemStylePlain target:self action:@selector(clickBack:)];
        [leftButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController])
    {
        if (self.navigationController.delegate == self)
        {
            self.navigationController.delegate = nil;
        }
        if (self.navigationController.interactivePopGestureRecognizer.delegate == self)
        {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
}

- (UIBarButtonItem *)backButton {
    NSLog(@"back btn");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 9, 30, 30);
    [button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"navigator_btn_back"] forState:UIControlStateNormal];
    //[button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem __autoreleasing *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (void)clickBack:(id)sender {
    if (self.showMode == JCCPush) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}



// 隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if ([viewController isKindOfClass:[JCCFoundViewController class]]) {
//        [navigationController setNavigationBarHidden:YES animated:animated];
//    } else {
//        [navigationController setNavigationBarHidden:NO animated:animated];
//    }
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
