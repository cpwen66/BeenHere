//
//  QuoteTableViewCell.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/19.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "QuoteTableViewCell.h"



@implementation QuoteTableViewCell

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
    self.cellbackground.frame=self.bounds;
    }

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    [self.cellbackground updateConstraintsIfNeeded];
    [self.cellbackground layoutIfNeeded];
    

    
   self.contentlabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentlabel.frame);
}
- (void)drawRect:(CGRect)rect
{
    [[self.simleView layer] setBorderWidth:1.0];
    //邊框顏色
    [[self.simleView layer] setBorderColor:[UIColor colorWithRed:35.0 green:196.0 blue:246.0 alpha:0.9].CGColor];
    //    [[self.cellbackground layer] setBorderColor:[UIColor colorWithRed:246.0 green:241.0 blue:236.0 alpha:0.9].CGColor];
    self.simleView.layer.cornerRadius = 1.0;
    [[self.simleView layer] setCornerRadius:5.0];
    
    
    [[self.cellbackground layer] setBorderWidth:1.0];
    //邊框顏色
     [[self.cellbackground layer] setBorderColor:[UIColor colorWithRed:35.0 green:196.0 blue:246.0 alpha:0.9].CGColor];
//    [[self.cellbackground layer] setBorderColor:[UIColor colorWithRed:246.0 green:241.0 blue:236.0 alpha:0.9].CGColor];
    self.cellbackground.layer.cornerRadius = 1.0;
    [[self.cellbackground layer] setCornerRadius:5.0];
    
    self.emtionbutton.layer.borderWidth=1.0;
    self.emtionbutton.layer.cornerRadius=10.0;
    self.emtionbutton.layer.borderColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
    
    
    self.userimage.layer.borderWidth=2.0f;
     self.userimage.layer.borderColor = [UIColor whiteColor].CGColor;
//    CGRect cellFrame = self.contentlabel.frame;
//    CGRect buttonFrame = self.cellButton.frame;
//    int indentation = self.treeNode.nodeLevel * 25;
//   cellFrame.origin.x = cellFrame.origin.x + indentation + 5;
// //   buttonFrame.origin.x = 2 + indentation;
//    self.contentlabel.frame = cellFrame;
//    self.cellButton.frame = buttonFrame;
    CGRect cellFrame = self.contentlabel.frame;
    CGRect buttonFrame = self.cellButton.frame;
    CGRect detail=self.detaillabel.frame;
    CGRect userimage = self.userimage.frame;
    CGRect cellview=self.cellbackground.frame;
    CGRect emtionview=self.emtionbutton.frame;
    CGRect cellimage=self.cellimage.frame;
    
    
//    int iInt1 = (int)self.treeNode.nodeLevel;
    BOOL bool1 = (BOOL)self.treeNode.nodeLevel;
    int indentation = bool1 * 40;
   
     BOOL bool2 = (BOOL)self.treeNode.Typetag;
//    if ([self.treeNode.Typetag isEqualToString:@"3"]) {
//        cellimage.size.height=100;
//        cellimage.size.width=60;
//    }
    
    detail.origin.x = buttonFrame.size.width + indentation ;
    
     //cellFrame.origin.x = cellFrame.origin.x + indentation ;
    NSLog(@"cellview's Frame:%@,%f,%i",NSStringFromCGRect(cellview),cellview.origin.x,indentation);
   // cellview.origin.x+=indentation;
        cellview.origin.x=87+indentation;
    

    
    int indent=bool1 * 20;
    
    int indentat=bool1*70;
    
    // emtionview.origin.x=emtionview.origin.x - indentat;
    userimage.origin.x = indentat +3;
    userimage.size.width= 46 - indent;
    userimage.size.height= 40 - indent;
  //  buttonFrame.origin.x = 2 + indentation;
    self.contentlabel.frame = cellFrame;
    self.cellButton.frame = buttonFrame;
    self.userimage.frame = userimage;
    self.detaillabel.frame=detail;
    self.cellbackground.frame=cellview;
    self.emtionbutton.frame=emtionview;
    self.cellimage.frame=cellimage;
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
