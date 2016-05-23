//
//  MKBadgeView.m
//  ZJT
//
//  Created by wangcy on 14-12-9.
//  Copyright (c) 2014年 zjt. All rights reserved.
//

#import "MKBadgeView.h"

#define badgePadding 10.f
@interface MKBadgeView()

@property (nonatomic) UILabel *badge;

@end

@implementation MKBadgeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    [self initBadgeLable];
}

- (void)initBadgeLable {
    if (self.badge) {
        return;
    }
    self.badge = [[UILabel alloc] initWithFrame:self.bounds];
    self.badge.textColor            = self.badgeTextColor;
    self.badge.backgroundColor      = self.badgeBGColor;
    self.badge.font                 = self.badgeFont;
    self.badge.textAlignment        = NSTextAlignmentCenter;
    self.badge.text = self.badgeValue;
    [self addSubview:self.badge];
    CGSize size = [self.badgeValue sizeWithFont:self.badge.font constrainedToSize:CGSizeMake(2000, self.badge.height) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.width > self.badge.height) {
        [self.badge setWidth:size.width + badgePadding];
    }
    self.badge.layer.cornerRadius = (self.badge.height) / 2.f;
    self.badge.layer.masksToBounds = YES;
}


- (void)refreshBadge
{
    // Change new attributes
    self.badge.textColor        = self.badgeTextColor;
    self.badge.backgroundColor  = self.badgeBGColor;
    self.badge.font             = self.badgeFont;
}


- (void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    _badgeBGColor = badgeBGColor;
    
    if (self.badge) {
        [self refreshBadge];
    }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    if (self.badge) {
        [self refreshBadge];
    }
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    _badgeFont = badgeFont;
    if (self.badge) {
        [self refreshBadge];
    }
}

- (void)updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1]];
        [animation setToValue:[NSNumber numberWithFloat:1.5]];
         animation.autoreverses = YES;
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4 :1.3 :1 :1]];
        [self.badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    // Set the new value
    self.badge.text = self.badgeValue;
    // Animate the size modification if needed
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
