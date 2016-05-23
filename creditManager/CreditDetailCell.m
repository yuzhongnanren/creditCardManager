//
//  CreditDetailCell.m
//  creditManager
//
//  Created by haodai on 16/3/8.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditDetailCell.h"
#import "ZYScrollView.h"

@interface CreditDetailCell ()<ZYScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *card_des;
@property (weak, nonatomic) IBOutlet UILabel *card_content;
@property (weak, nonatomic) IBOutlet ZYScrollView *scr;


@end

@implementation CreditDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:@"DetailCell"]) {
            
        }else if ([reuseIdentifier isEqualToString:@"RateCell"]) {
    
        }
    }
    return self;
}

- (void)setPrivileg:(NSArray*)privileg {
    if (privileg.count == 0) {
        return;
    }
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    CGFloat off_y = 15.f;
    for (int i = 0; i < privileg.count; i++) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, off_y, 8.f, 13.f)];
        icon.image = [UIImage imageNamed:@"fire"];
        [self.contentView addSubview:icon];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 5, off_y, SCREEN_WIDTH - 15.f - 15.f - 5.f - 4.f, 15)];
        content.textColor = [UIColor colorWithHexColorString:@"808080"];
        content.font = [UIFont systemFontOfSize:13];
        content.text = [[privileg objectAtIndex:i] objectForKey:@"title"];
        content.backgroundColor = [UIColor clearColor];
        content.numberOfLines = 0;
        [self.contentView addSubview:content];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        
        CGRect rect = [[[privileg objectAtIndex:i] objectForKey:@"title"] boundingRectWithSize:CGSizeMake(content.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil];
        content.height = rect.size.height;
        
        off_y = content.bottom + 15.f;
    }
}



- (void)setRates:(NSArray*)rates {
    if (rates.count == 0) {
        return;
    }
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 80, 15)];
    title.textColor = [UIColor colorWithHexColorString:@"47494f"];
    title.font = [UIFont systemFontOfSize:13];
    title.text = @"分期费率";
    title.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:title];
    
    
    for (int i = 0; i < ceilf(rates.count/2.f); i ++) {
        for (int j = 0; j < 2; j++) {
            if (i * 2 + j < rates.count) {
                UILabel *rate = [[UILabel alloc] initWithFrame:CGRectMake(100 + j*120, 8 + (15+8)*i, 100, 15)];
                rate.textColor = [UIColor colorWithHexColorString:@"808080"];
                rate.font = [UIFont systemFontOfSize:13];
                NSDictionary *d = [rates objectAtIndex:i * 2 + j];
                rate.text = [NSString stringWithFormat:@"%@个月:%@%@",d.allKeys.firstObject,[d objectForKey:d.allKeys.firstObject],@"%"];
                rate.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:rate];
            }
        }
    }
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 8 + (15+8)*ceilf(rates.count/2.f), SCREEN_WIDTH, 30)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];
    
//    UIView *whiteView = [UIView a]
    
}


- (void)setCardTitle:(NSString *)title content:(NSString*)content {
    _card_content.text = content;
    _card_des.text = title;
}


- (void)setDiscountCredits:(NSArray *)discountCredits {
    if (discountCredits.count == 0) {
        return;
    }
    _discountCredits = discountCredits;
    [_scr initOpusViewCount:discountCredits.count placeholder:nil delegate:self left:15 top:15 gap:10];
}

#pragma mark - ZYScrollViewDelegate
- (UIView*)opusView:(ZYScrollView *)opusView index:(NSInteger)index {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 143.f, 89.f + 25.f)];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 143.f, 89.f)];
    [img sd_setImageWithURL:[NSURL URLWithString:[[self.discountCredits objectAtIndex:index] objectForKey:@"thumbnail"]]];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    img.userInteractionEnabled = YES;
    [contentView addSubview:img];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom, img.width, 25.f)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithHexColorString:@"47494f"];
    title.font = [UIFont systemFontOfSize:12];
    title.text = [[self.discountCredits objectAtIndex:index] objectForKey:@"title"];
    title.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:title];
    
    return contentView;
}

- (void)opusView:(ZYScrollView *)opusView didTapAtIndex:(NSInteger)index {
        if (self.tapBlock) {
            self.tapBlock(index);
        }
}


@end
