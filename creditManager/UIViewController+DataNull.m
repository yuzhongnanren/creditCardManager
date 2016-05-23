//
//  UIViewController+DataNull.m
//  creditManager
//
//  Created by haodai on 16/3/26.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "UIViewController+DataNull.h"
#import <objc/runtime.h>

@implementation UIViewController (DataNull)


- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexColorString:@"8e979a"];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}

- (UIImageView*)noDataImage {
    UIImageView *imageV = objc_getAssociatedObject(self, @selector(noDataImage));
    if (!imageV) {
        imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noData"]];
        objc_setAssociatedObject(self, @selector(noDataImage), imageV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageV;
}


- (void)setNoData {
    if (self.placeholderLabel) {
        [self.placeholderLabel removeFromSuperview];
    }
    if (self.noDataImage) {
        [self.noDataImage removeFromSuperview];
    }
    self.noDataImage.center = CGPointMake(self.view.center.x, self.view.center.y - 84.f);
    self.noDataImage.size = CGSizeMake(110.f, 76.f);
    
    self.placeholderLabel.frame = CGRectMake(0, 0, 100, 30);
    self.placeholderLabel.center = CGPointMake(self.view.center.x, 0);
    self.placeholderLabel.top = self.noDataImage.bottom;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:13];
    self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
    self.placeholderLabel.text = @"暂无数据";
    self.placeholderLabel.textColor = [UIColor colorWithHexColorString:@"8e979a"];
   
    
    [self.view addSubview:self.placeholderLabel];
    [self.view addSubview:self.noDataImage];
}

- (void)setHasData {
    if (self.placeholderLabel) {
        [self.placeholderLabel removeFromSuperview];
    }
    if (self.noDataImage) {
        [self.noDataImage removeFromSuperview];
    }
}

@end
