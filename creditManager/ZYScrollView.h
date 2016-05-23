//
//  ZYScrollView.h
//  creditManager
//
//  Created by haodai on 16/2/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYScrollView;

@protocol ZYScrollViewDelegate <NSObject>

@required
- (UIView *)opusView:(ZYScrollView *)opusView index:(NSInteger)index;

@optional
- (void)opusView:(ZYScrollView *)opusView didTapAtIndex:(NSInteger)index;

@end

@interface ZYScrollView : UIScrollView
@property (nonatomic, assign) id <ZYScrollViewDelegate> opusDelegate;

- (void)initOpusViewCount:(NSInteger)count placeholder:(UIImage*)placeholder delegate:(id <ZYScrollViewDelegate>) delegate left:(CGFloat)left top:(CGFloat)top gap:(CGFloat)gap;


@end
