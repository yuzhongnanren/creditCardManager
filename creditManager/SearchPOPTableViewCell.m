//
//  SearchPOPTableViewCell.m
//  creditManager
//
//  Created by haodai on 16/3/4.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "SearchPOPTableViewCell.h"

@implementation SearchPOPTableViewCell
{
    UILabel *_searchTitle;
    UIImageView *_icon;
}
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
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _searchTitle = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, 200, 44)];
    _searchTitle.backgroundColor = [UIColor clearColor];
    _searchTitle.textColor = [UIColor colorWithHexColorString:@"666666"];
    _searchTitle.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_searchTitle];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 28.f - 16.f, (self.height - 11.f)/2, 16.f, 11.f)];
    _icon.image = [UIImage imageNamed:@"righ"];
    _icon.hidden = YES;
    [self.contentView addSubview:_icon];
}

- (void)setContent:(NSString *)content {
    _content = content;
    _searchTitle.text = _content;
}

- (void)setIsTapSelected:(BOOL)isTapSelected {
    _isTapSelected = isTapSelected;
    if (_isTapSelected) {
        _searchTitle.textColor = [UIColor colorWithHexColorString:@"00aaee"];
        _icon.hidden = NO;
    }else {
        _searchTitle.textColor = [UIColor colorWithHexColorString:@"666666"];
        _icon.hidden = YES;
    }
}

@end
