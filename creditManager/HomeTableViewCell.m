//
//  HomeTableViewCell.m
//  creditManager
//
//  Created by haodai on 16/2/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "ZYScrollView.h"
#import "HotBankView.h"

@interface HomeTableViewCell ()<ZYScrollViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet ZYScrollView *hotBankScr;
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardDes;
@property (weak, nonatomic) IBOutlet UILabel *cardApplyNum;
@property (weak, nonatomic) IBOutlet ZYScrollView *cheapCreditScr;
//************个人信用卡绑定＊＊＊＊＊＊＊＊＊＊＊
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userCreditDes;
@property (weak, nonatomic) IBOutlet UILabel *userTip;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout2;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _hotBankScr.tag = 888;
    _cheapCreditScr.tag = 999;
    ViewRadius(_userImg, _userImg.width/2);
    _hotBankScr.delegate = self;
    _hotBankScr.pagingEnabled = YES;
    _pageControl.currentPageIndicatorTintColor = mBlueColor;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHexColorString:@"ededed"];
    _pageControl.currentPage = 0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    [self.contentView addSubview:line];
    
    if (IS_IPHONE_6P) {
        _rightLayout1.constant = _rightLayout1.constant + 20;
        _rightLayout2.constant = _rightLayout2.constant + 20;
    }else if (IS_IPHONE_6) {
        _rightLayout1.constant = _rightLayout1.constant + 10;
        _rightLayout2.constant = _rightLayout2.constant + 10;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHotBanks:(NSArray *)hotBanks {
    if (hotBanks.count == 0) {
        return;
    }
     _hotBanks = hotBanks;
    _pageControl.numberOfPages = ceilf(_hotBanks.count/4.f);
    [_hotBankScr initOpusViewCount:hotBanks.count placeholder:nil delegate:self left:0 top:0 gap:0];
    _hotBankScr.contentSize = CGSizeMake(ceilf(hotBanks.count/4.f)*SCREEN_WIDTH, _hotBankScr.height);
}

- (void)setCredit:(CreditCard *)credit {
    _credit = credit;
    [_cardImg sd_setImageWithURL:[NSURL URLWithString:_credit.img] placeholderImage:[UIImage imageNamed:@"creditPlacehold"]];
    _cardName.text = _credit.name;
    _cardDes.text = _credit.descr;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld人申请",(long)_credit.apply_count]];
    NSRange range = [[NSString stringWithFormat:@"%ld人申请",(long)_credit.apply_count] rangeOfString:[NSString stringWithFormat:@"%ld人",(long)_credit.apply_count]];
    [string addAttribute:NSForegroundColorAttributeName  value:[UIColor colorWithHexColorString:@"f7636e"] range:range];
    _cardApplyNum.attributedText = string;
}

- (void)setDiscountCredits:(NSArray *)discountCredits {
    if (discountCredits.count == 0) {
        return;
    }
     _discountCredits = discountCredits;
    [_cheapCreditScr initOpusViewCount:discountCredits.count placeholder:nil delegate:self left:15 top:15 gap:10];
}

- (void)dealloc {
    _hotBankScr.opusDelegate = nil;
}

#pragma mark - ZYScrollViewDelegate
- (UIView*)opusView:(ZYScrollView *)opusView index:(NSInteger)index {
    if (opusView.tag == 888) {
        HotBankView *hotView = LoadNibWithName(@"HotBankView");
        hotView.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, self.height);
        hotView.bank = [self.hotBanks objectAtIndex:index];
        return hotView;
    }else {
        
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
}

- (void)opusView:(ZYScrollView *)opusView didTapAtIndex:(NSInteger)index {
    if (opusView.tag == 888) {
        if (self.tapHotBlock) {
            self.tapHotBlock(index);
        }
    }else if (opusView.tag == 999) {
        if (self.tapDiscountCreditBlock) {
            self.tapDiscountCreditBlock(index);
        }
    }
    
}

#pragma mark - Action
/**
 *  进度查询
 *
 *  @param sender
 */
- (IBAction)progress:(id)sender {
    if (self.progressBlock) {
        self.progressBlock();
    }
}
/**
 *  征信查询
 *
 *  @param sender
 */
- (IBAction)creditLookup:(id)sender {
    if (self.creditLookupBlock) {
        self.creditLookupBlock();
    }
}
/**
 *  关闭提示
 *
 *  @param sender
 */
- (IBAction)CloseTip:(id)sender {
    if (self.tapCloseTip) {
        self.tapCloseTip();
    }
}


- (void)setUserImage:(NSString*)user cardNum:(NSInteger)count tip:(NSString*)str {
    if (!StringIsNull(user)) {
        [_userImg sd_setImageWithURL:[NSURL URLWithString:user]];
    }
    if (count == 0) {
         _userCreditDes.text = @"还没绑定信用卡";
    }else {
         _userCreditDes.text = [NSString  stringWithFormat:@"已绑定%ld张信用卡",(long)count];
    }
    if (!StringIsNull(str)) {
        _userTip.text = [NSString  stringWithFormat:@"%@的信用卡即将到期",str];
    }else {
        _userTip.text = @"赶紧去我的里面绑定吧";
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",(scrollView.contentOffset.x + 2)/self.width);
    _pageControl.currentPage = (scrollView.contentOffset.x + 2)/self.width;
}


@end
