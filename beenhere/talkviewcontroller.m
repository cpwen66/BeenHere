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
@property (weak, nonatomic) IBOutlet UIView *emtionview;
@property (weak, nonatomic) IBOutlet UITextView *textfield;
@property (weak, nonatomic) IBOutlet UIImageView *talkpicture;
@property (weak, nonatomic) IBOutlet UIButton *simle;
@property (weak, nonatomic) IBOutlet UIButton *sad;
@property (weak, nonatomic) IBOutlet UIButton *happy;
@property (weak, nonatomic) IBOutlet UIButton *impish;
@property (weak, nonatomic) IBOutlet UIButton *oho;
@property (weak, nonatomic) IBOutlet UIButton *cool;
@property (weak, nonatomic) IBOutlet UIButton *whereBtn;
@property (weak, nonatomic) IBOutlet UIButton *withpeopleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moodimageview;
@property (weak,nonatomic)UIImage * setimage;
@end

@implementation talkviewcontroller
- (IBAction)emtionbtn:(id)sender {
    
    
    _emtionview.hidden=NO;
    
}

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
    _setimage=_moodimageview.image;
    NSDictionary *params = [NSDictionary new];
    params = @{
               @"text":talkcontent,
               @"image":_setimage
               };
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"textcontentwith" object:params];
    
    
 [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)simleAvtion:(id)sender {
    
    UIImage * image=[UIImage imageNamed:@"simle"];
    _moodimageview.image=image;
    
    
    _emtionview.hidden=YES;
}

- (IBAction)SadAction:(id)sender {
    UIImage * image=[UIImage imageNamed:@"simle"];
    _moodimageview.image=image;
    
    
    _emtionview.hidden=YES;
}
- (IBAction)HappyAction:(id)sender {
    UIImage * image=[UIImage imageNamed:@"happy"];
    _moodimageview.image=image;
    
    
    _emtionview.hidden=YES;
}

- (IBAction)ohoAction:(id)sender {
    UIImage * image=[UIImage imageNamed:@"oho"];
    _moodimageview.image=image;
    
    
    _emtionview.hidden=YES;
}

- (IBAction)impishAvtion:(id)sender {
    UIImage * image=[UIImage imageNamed:@"impish"];
    _moodimageview.image=image;
    
    
    _emtionview.hidden=YES;
}
- (IBAction)coolAction:(id)sender {
    UIImage * image=[UIImage imageNamed:@"cool"];
    _moodimageview.image=image;
    
    
    _emtionview.hidden=YES;
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
