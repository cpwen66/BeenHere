//
//  talkviewcontroller.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/27.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "talkviewcontroller.h"

@interface talkviewcontroller ()<UITextViewDelegate>
{
    NSString * talkcontent;

}
@property (weak, nonatomic) IBOutlet UITextView *textfield;
@property (weak, nonatomic) IBOutlet UIImageView *talkpicture;

@end

@implementation talkviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(donenewcust) ];
    self.navigationItem.rightBarButtonItem=doneButton;
    
    
      _textfield.delegate = self;
      _textfield.text = @"寫下您的心情";
      _textfield.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)withfriend:(id)sender {
    
    
    
    
}
- (IBAction)where:(id)sender {
    
    
    
}
-(void)donenewcust{


      talkcontent=_textfield.text;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"textcontentwith" object:talkcontent];
    
    
 [self.navigationController popViewControllerAnimated:YES];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - uitextview
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _textfield.text = @"";
    _textfield.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_textfield.text.length == 0){
        _textfield.textColor = [UIColor lightGrayColor];
        _textfield.text = @"寫下您的心情";
        [_textfield resignFirstResponder];
    }
}
@end
