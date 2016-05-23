//
//  ZYSearchPOPView.h
//  creditManager
//
//  Created by haodai on 16/3/4.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BlockSearchIndex)(NSInteger);
typedef void (^BlockSearchCancel)(void);

@interface ZYSearchPOPView : UIView
@property (nonatomic, copy) BlockSearchIndex searchIndex;
@property (nonatomic, copy) BlockSearchCancel searchCancel;
- (void)searchDataSource:(NSArray*)dataSource currentSelected:(NSInteger)index;
- (void)show;
- (void)dismiss;

@end
