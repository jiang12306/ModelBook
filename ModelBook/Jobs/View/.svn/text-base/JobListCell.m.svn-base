//
//  JobListCell.m
//  ModelBook
//
//  Created by zdjt on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "JobListCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UIImage+Ext.h"
#import "UIColor+Ext.h"

@implementation JobListCell

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

- (void)setModel:(JobListModel *)model {
    _model = model;
    self.typeLabel.text = model.jobName;
    
    self.numLabel.text = @"";
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!/both/50x50",model.jobImage]]];
    
    if (model.showState.intValue == 0) {
        self.stateButton.on = NO;
        self.stateButton.hidden = NO;
    }else if (model.showState.intValue == 2 || model.showState.intValue == 3 || model.showState.intValue == 5 || model.showState.intValue == 7 || model.showState.intValue == 8) {
        self.stateButton.on = YES;
        self.stateButton.hidden = NO;
    }else {
        self.stateButton.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.stateButton setOnTintColor:[UIColor colorWithHex:0xDCFAFB]];
    
    [self.stateButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(49.f, 31.f));
        make.right.equalTo(self.mas_right).offset(-35.f);;
    }];
}

- (void)switchButtonEvent:(UISwitch *)sender
{
    if (sender.on) {
        if (self.applyBlock) self.applyBlock(self);
    }else {
        if (self.cancleBlock) self.cancleBlock(self);
    }
}

- (IBAction)coverButtonEvent:(UIButton *)sender {
    if (self.coverBlock) self.coverBlock(self);
}

@end
