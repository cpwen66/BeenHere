//
//  PinInfoTableViewCell.m
//  beenhere
//
//  Created by CP Wen on 2015/7/6.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinInfoTableViewCell.h"

@implementation PinInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.infoImageView.image = nil;
    //[self.infoImageView removeFromSuperview];
}

@end
