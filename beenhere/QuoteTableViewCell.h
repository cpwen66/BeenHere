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
@property (weak, nonatomic) IBOutlet UIView *emtionview;

@property (retain, strong) TreeViewNode *treeNode;

- (IBAction)expand:(id)sender;
- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;

@property (weak, nonatomic) IBOutlet UIView *cellbackground;

@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UIView *simleView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *simleBTN;
@property (weak, nonatomic) IBOutlet UIButton *CoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *SadBtn;
@property (weak, nonatomic) IBOutlet UIButton *HappyBtn;
@property (weak, nonatomic) IBOutlet UIButton *ImpishBtn;
@property (weak, nonatomic) IBOutlet UIButton *OhoBtn;


@end
