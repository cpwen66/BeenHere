//
//  ReuseTableViewCell.m
//  beenhere
//
//  Created by CP Wen on 2015/7/4.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "ReuseTableViewCell.h"

@implementation ReuseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    
    for (UIView *view in self.contentView.subviews ) {
        [view removeFromSuperview];
    }
    
    [super prepareForReuse];
    
    
    
    
    //[[self viewWithTag:100] removeFromSuperview];
     
}

@end
