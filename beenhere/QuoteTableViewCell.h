//
//  QuoteTableViewCell.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/19.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@interface QuoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UILabel *detaillabel;
@property (retain, nonatomic) IBOutlet UIButton *cellButton;
@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UIImageView *cellimage;
@property (weak, nonatomic) IBOutlet UILabel *NAME;
@property (nonatomic) BOOL isExpanded;
@property (weak, nonatomic) IBOutlet UIButton *emtionbutton;
@property (weak, nonatomic) IBOutlet UIButton *showemtion;

@property (retain, strong) TreeViewNode *treeNode;

- (IBAction)expand:(id)sender;
- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;

@property (weak, nonatomic) IBOutlet UIView *cellbackground;


@end
