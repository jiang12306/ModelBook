//
//  ChatCell.m
//  ModelBook
//
//  Created by zdjt on 2017/8/17.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ChatCell.h"
#import "Const.h"

@interface ChatCell ()

@end

@implementation ChatCell

- (void)setModel:(ChatModel *)model {
    _model = model;
    
    
}

- (void)setBadge:(int)badge
{
    _badge = badge;
    
    if (badge <= 0) {
        self.badgeLabel.hidden = YES;
    }else if (badge < 100) {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",badge];
    }else {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = [NSString stringWithFormat:@"99+"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.messageLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.timeLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.badgeLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.badgeLabel.layer.cornerRadius = 12.f;
    self.badgeLabel.layer.masksToBounds = YES;
}

@end
