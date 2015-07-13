//
//  replyViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/21.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "replyViewController.h"
#import "TreeViewNode.h"
#import "detailreplyTableViewCell.h"
#import "mydb.h"
#import "Pushdelegate.h"

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@interface replyViewController ()<UITableViewDataSource, UITableViewDelegate,PushProtocol,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) detailreplyTableViewCell *prototypeCell;

@property (weak, nonatomic) IBOutlet UITextField *replytextfield;

@property (weak, nonatomic) IBOutlet UIButton *SendBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldConstraint;

@end

@implementation replyViewController
@synthesize replytextfield;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    replylist=[[NSMutableArray alloc] init];
    
    replychildrn= _node.nodeChildren;

        
  
     [replylist addObject:_node];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    // 替scrollView加上手勢
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//
//    // 下一行self.myScrollView改成self.view也可以
    [self.tableview addGestureRecognizer:tapGesture];
    [self fillNodeWithChildrenArray:_node.nodeChildren];
 
 
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
     self.SendBtn.layer.cornerRadius=5.0;
    replytextfield.delegate=self;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
    if (![replytextfield isExclusiveTouch]) {
        [replytextfield resignFirstResponder];
    }
    
    
}


// Called when the UIKeyboardDidShowNotification is sent.
// keyboard跳出來之後會進到這個方法
- (void)keyboardWillShow: (NSNotification *) aNotification {
    NSValue *value = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = value.CGRectValue.size;
    self.textFieldConstraint.constant = keyboardSize.height;
}

- (void)keyboardWillHide: (NSNotification *) aNotification {
    self.textFieldConstraint.constant = 0;
    
}
-(void)dismissKeyboard
{
    [replytextfield resignFirstResponder]; //textNotes 請自行更換成所用之變數
}
- (IBAction)dissmissuitextfield:(id)sender {
    [replytextfield resignFirstResponder];
}
-(void)hideKeyboard {
    
    //撤self.view下的keyboard
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 將輸入內容存到nsstring
- (IBAction)replyAction:(id)sender {
    
    replytext=replytextfield.text;
    if (replytext!=NULL) {
         [self insertreplycontentToSQLite];
    }
    
    
    

     [self dismissViewControllerAnimated:YES completion:nil];
}

//將回覆內容存入mysql及sqllite
-(void)insertreplycontentToSQLite{

NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];

    
    //取出當前時間 及時區的轉換
    NSDate * new = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:new];
    NSDate *localDate = [new dateByAddingTimeInterval:timeZoneOffset];
    
    
      NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"insertcontentreply",@"cmd", userID, @"userID", replytext, @"text", localDate, @"date",@"1",@"level",_node .content_no,@"content_no",nil];
    
    
    
    //存到mysql
    [[mydb sharedInstance]insertcontentreplyremote:params ];

    
    
    
    Pushdelegate * push=[[Pushdelegate alloc] init];
    //push 通知
    if (_flag==1) {
        [push FriendReplyPush:_friend_id and:_node.content_no];
        NSLog(@"node:%@",_node.beeid);
        push.delegate=self;
    }
    
    
//    //存入sqlite
//    [[mydb sharedInstance]insertreplyMemeberNo:userID andcontenttext:replytext andlevel:@"1" anddate:[NSDate date] andcontentno:_node .content_no];
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [replylist addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
#pragma mark - PrototypeCell
- (detailreplyTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableview dequeueReusableCellWithIdentifier:NSStringFromClass([detailreplyTableViewCell class])];
    }
    
    return _prototypeCell;
}

#pragma mark - Configure
- (void)configureCell:(detailreplyTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString *quote = replylist[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *currentTime = [dateFormatter stringFromDate:_node.date];
    TreeViewNode * node=replylist[indexPath.row];
    cell.contentLabel.text =node.nodeObject;
    cell.timeLabel.text = currentTime;
    cell.namelabel.text=node.name;
}


//- (NSArray *)fillChildrenForNode
//{
//    TreeViewNode *secondLevelNode1 = [[TreeViewNode alloc]init];
//    secondLevelNode1.nodeLevel = 1;
//    secondLevelNode1.nodeObject = [NSString stringWithFormat:@"Child node 1"];
//    
//    
//    NSArray *childrenArray = [NSArray arrayWithObjects:secondLevelNode1,  nil];
//    
//    return childrenArray;
//}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [replylist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailreplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([detailreplyTableViewCell class])];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
    //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];
    
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
