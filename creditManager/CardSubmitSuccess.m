//
//  CardSubmitSuccess.m
//  creditManager
//
//  Created by haodai on 16/3/15.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CardSubmitSuccess.h"
#import "CreditListViewController.h"

@interface CardSubmitSuccess ()

@end

@implementation CardSubmitSuccess

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信用卡申请";
    // 设置返回按钮的文本
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"返回"
                                   style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender {
    for (id v in self.navigationController.viewControllers) {
        if ([v isKindOfClass:[CreditListViewController class]]) {
            [self.navigationController popToViewController:v animated:YES];
            break;
        }
    }
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
