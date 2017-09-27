//
//  ChatHeaderView.m
//  ModelBook
//
//  Created by zdjt on 2017/8/17.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ChatHeaderView.h"
#import "UIColor+Ext.h"
#import "Const.h"

@interface ChatHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@end

@implementation ChatHeaderView

- (void)setModel:(ChatModel *)model {
    _model = model;
    
    self.titleLabel.text = model.chatType;
    
    if (self.model.targetUser.userType.isOpen) {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.arrowImageView.transform = CGAffineTransformIdentity;
    }
}

- (IBAction)clickButtonEvent:(UIButton *)sender {
    self.model.targetUser.userType.isOpen = !self.model.targetUser.userType.isOpen;
    
    if (self.openBlock) self.openBlock(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.font = [UIFont fontWithName:pageFontName size:14.f];
    
}

@end
