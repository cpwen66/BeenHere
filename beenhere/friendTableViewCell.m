//
//  friendTableViewCell.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/30.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "friendTableViewCell.h"

@implementation friendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
   }

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
   
    
    self.contentlabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentlabel.frame);
}
- (void)drawRect:(CGRect)rect
{
    CGRect cellFrame = self.contentlabel.frame;
    CGRect buttonFrame = self.cellButton.frame;
    CGRect detail=self.detaillabel.frame;
    CGRect userimage = self.userimage.frame;
    CGRect cellview=self.cellbackground.frame;
    CGRect emtionview=self.emtionbutton.frame;
    
    int iInt1 = (int)self.treeNode.nodeLevel;
    int indentation = iInt1 * 40;
    
    
    detail.origin.x = buttonFrame.size.width + indentation ;
    
    cellFrame.origin.x = cellFrame.origin.x + indentation ;
    cellview.origin.x=cellview.origin.x + indentation;
    //cellFrame.size.width=cellFrame.size.width - indentation;
    // emtionview.origin.x=emtionview.origin.x - indentation;
    //cellFrame.size.width=cellFrame.size.width - indentation;
    // cellview.size.width=cellview.size.width-indentation;
    
    int indent=iInt1 * 20;
    
    int indentat=iInt1*70;
    
    // emtionview.origin.x=emtionview.origin.x - indentat;
    userimage.origin.x = indentat +3;
    userimage.size.width= userimage.size.width - indent;
    userimage.size.height= userimage.size.height - indent;
    //  buttonFrame.origin.x = 2 + indentation;
    self.contentlabel.frame = cellFrame;
    self.cellButton.frame = buttonFrame;
    self.userimage.frame = userimage;
    self.detaillabel.frame=detail;
    self.cellbackground.frame=cellview;
    self.emtionbutton.frame=emtionview;
    

    
}

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage
{
    [self.cellButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (IBAction)expand:(id)sender
{
    self.treeNode.isExpanded = !self.treeNode.isExpanded;
    [self setSelected:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ProjectTreeNodeButtonClicked" object:self];
}

- (IBAction)reply:(id)sender {
    
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"replyButtonClicked" object:self];
    
    
}
@end
