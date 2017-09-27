//
//  InfoAddressView.m
//  ModelBook
//
//  Created by zdjt on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "InfoAddressCell.h"
#import "Const.h"
#import <Masonry.h>

@interface InfoAddressCell ()

@end

@implementation InfoAddressCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UISwitch *stateButton = [[UISwitch alloc] init];
        self.stateButton = stateButton;
        [stateButton addTarget:self action:@selector(switchButtonEvent:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:stateButton];
    }
    return self;
}

- (void)setModel:(InfoAddressModel *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    
    self.stateButton.on = model.state;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    
    [self.stateButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(49.f, 31.f));
        make.right.equalTo(self.mas_right).offset(-5.f);;
    }];
    
}
- (void)switchButtonEvent:(UISwitch *)sender {
    self.model.state = sender.isOn;
    if (self.changeBlock) self.changeBlock(self);
}


@end
