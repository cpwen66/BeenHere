//
//  IndexTableViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/15.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "IndexTableViewController.h"
#import "StoreInfo.h"
#import "QuoteTableViewCell.h"
#import "TreeViewNode.h"
#import "replyViewController.h"
#import "mydb.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
@interface IndexTableViewController ()
{

    NSMutableArray* Content;
    NSDictionary * contentkey;
    
    NSUInteger indentation;
    NSMutableArray *nodes;
    
}
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@property (nonatomic, strong) QuoteTableViewCell *prototypeCell;
@property (nonatomic, retain) NSMutableArray *displayArray;
@property (nonatomic) int currentSelection;

@end

@implementation IndexTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.currentSelection = -1;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"welcome",@"text", nil];
    //展開收起
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
   
    
    //relodata table
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loaddata) name:@"loaddata" object:nil];
    
    
    //self.tableView.layer.borderWidth = 1.0;
    
     [_prototypeCell setNeedsDisplay];
    
    [self fillNodesArray:params];
    [self fillDisplayArray];
  
     [self.tableView reloadData];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddContent:) name:@"textcontent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddContentwith:) name:@"textcontentwith" object:nil];
    
    [self initdata];
}

-(void)initdata{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"connecting"];
    
 NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
   
    [[mydb sharedInstance]querymysqlindexcontent:userID ];
   
    
    
    
    [self loaddata];
}
-(void)viewWillAppear:(BOOL)animated{

[self loaddata];
}
//從sqlite取內容資料
-(void)loaddata{

    
    Content=[[NSMutableArray alloc]init ];
    nodes=[[NSMutableArray alloc]init ];

    
    
     NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    
     NSString *userNAME = [[NSUserDefaults standardUserDefaults]stringForKey:@"bherename"];
 
    
    
   Content=[[mydb sharedInstance]queryindexcontent:userID ];

   
   
    
    if (!Content.count==0) {
        
    
    for (int a=0;  a<=Content.count-1 ; a++) {
       
    TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
        firstLevelNode1.nodeLevel = 0;
        firstLevelNode1.Typetag = Content[a][@"typetag"];
        firstLevelNode1.nodeObject = Content[a][@"text"];
        firstLevelNode1.isExpanded = YES;
        firstLevelNode1.beeid = Content[a][@"id"];
           if (Content[a][@"imageid"] != [NSNull null]){
        firstLevelNode1.imageid= Content[a][@"imageid"];
           }else{
               firstLevelNode1.imageid=nil;
           }
        
        
       
        firstLevelNode1.name=Content[a][@"name"];
        firstLevelNode1.nodeChildren = [[self fillChildrenForNode:[NSString stringWithFormat:@"%@",Content[a][@"content_no"]]] mutableCopy];
        firstLevelNode1.content_no=[NSString stringWithFormat:@"%@",Content[a][@"content_no"]];
        
        if (Content[a][@"image"] != [NSNull null]){
        firstLevelNode1.imagedate=Content[a][@"image"];
        }
        if (Content[a][@"date"] != [NSNull null]) {
            //原本取sqlite的日期的方法
//      NSDate *date = [NSDate dateWithTimeIntervalSince1970:[Content[a][@"date"] integerValue]];
        

            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
   
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss" ];
            NSString *currentTime = [dateFormatter stringFromDate:firstLevelNode1.date];
            NSDate *date = [dateFormatter dateFromString:Content[a][@"date"]];
            
            
            firstLevelNode1.date=date;
            NSLog(@"firstdate:%@  %@",currentTime,date);
        }
        [nodes insertObject:firstLevelNode1 atIndex:0];
      
    }
    }
    
    
    

    NSString  * wellcome=[NSString stringWithFormat:@"welcome %@",userNAME];
    
    TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
    firstLevelNode1.nodeLevel = 3;
    firstLevelNode1.Typetag = @"4";
    firstLevelNode1.nodeObject = wellcome;
    firstLevelNode1.isExpanded = YES;

    
        //firstLevelNode1.imageid= 4;
    firstLevelNode1.name=userNAME;
    [nodes addObject:firstLevelNode1];
    
    [self fillDisplayArray];
    [self.tableView reloadData];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)EmtionBtnaction:(id)sender {
}

//內容子陣列
- (NSArray *)fillChildrenForNode:(NSString *)content_no
{
   
    NSMutableArray * child=[[NSMutableArray alloc] init];
    child=[[mydb sharedInstance]queryreplycontent:content_no];
    
    NSMutableArray *childrenArray=[[NSMutableArray alloc] init];
    
    if (!child.count==0) {
        
    
    for (int a=0; a <= child.count-1; a++) {
        
        TreeViewNode *secondLevelNode1 = [[TreeViewNode alloc]init];
        secondLevelNode1.nodeLevel = 1;
        secondLevelNode1.nodeObject=child[a][@"text"];
        secondLevelNode1.content_no=child[a][@"content_no"];
        if (child[a][@"date"] != [NSNull null]) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[child[a][@"date"] integerValue]];
        
            secondLevelNode1.date=date;
        }
        secondLevelNode1.beeid=child[a][@"id"];
        [childrenArray insertObject:secondLevelNode1 atIndex:0];
    }
    
    }
    
    return childrenArray;
    
    
    
   }

//輸入文字存進陣列
- (void)fillNodesArray:(NSDictionary *)parms
{
    
    
    
    TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
    firstLevelNode1.nodeLevel = 0;
    firstLevelNode1.nodeObject = parms[@"text"];
    firstLevelNode1.isExpanded = YES;
    firstLevelNode1.date=[NSDate date];
    //    firstLevelNode1.nodeChildren = [[self fillChildrenForNode] mutableCopy];
 
    //    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    //    NSDate *date = [dateFormatter dateFromString:birthday];
    [nodes insertObject:firstLevelNode1 atIndex:0];
    
    
    
    [self fillDisplayArray];
    [self.tableView reloadData];
}

#pragma mark - 輸入的回覆的文字
//回覆按鈕
- (IBAction)replyAction:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
      TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    NSLog(@"index:%@,row:%ld",indexPath,(long)indexPath.row);
   

}



#pragma mark - 輸入的文字存到陣列及mysql
-(void)AddContent:(NSNotification *)message{

    NSDictionary * dict=[[NSDictionary alloc]init];
    
    dict = [NSDictionary dictionaryWithObject:message.object forKey:@"text"];
    
   // [self fillNodesArray:dict];
    
    NSString * text=message.object;
    //輸入時間


    
    
    //存到SQLite
    NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];

    
    NSDictionary *params=[[NSDictionary alloc]init ];
    
    //取出當前時間 及時區的轉換
    NSDate * new = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:new];
    NSDate *localDate = [new dateByAddingTimeInterval:timeZoneOffset];
  
   
//       NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"demo.jpg"],0.5);
    
//    params = [NSDictionary dictionaryWithObjectsAndKeys:@"insertcontent",@"cmd", userID, @"userID", text, @"text", localDate, @"date",@"0",@"level",imageData,@"image",@"1",@"imageid",@"1",@"typetag",nil];
//    
//    NSLog(@"insert params:%@",params);
//    
//    
//    [[mydb sharedInstance]insertcontentremotewithimage:params ];
    
     params = [NSDictionary dictionaryWithObjectsAndKeys:@"insertcontent",@"cmd", userID, @"userID", text, @"text", localDate, @"date",@"0",@"level",@"1",@"typetag",nil];
    
    [[mydb sharedInstance]insertcontentremote:params ];
    
   // [self.tableView reloadData];
    
}
-(void)AddContentwith:(NSNotification *)message{
    
    NSDictionary * dict=[[NSDictionary alloc]init];
    
    dict = [NSDictionary dictionaryWithObject:message.object forKey:@"text"];
    
    // [self fillNodesArray:dict];
    
    NSString * text=message.object;
    //輸入時間
    
    
    
    
    //存到SQLite
    NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    
    
    NSDictionary *params=[[NSDictionary alloc]init ];
    
    //取出當前時間 及時區的轉換
    NSDate * new = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:new];
    NSDate *localDate = [new dateByAddingTimeInterval:timeZoneOffset];
    
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"demo.jpg"],0.5);
    
        params = [NSDictionary dictionaryWithObjectsAndKeys:@"insertcontent",@"cmd", userID, @"userID", text, @"text", localDate, @"date",@"0",@"level",imageData,@"image",@"2",@"imageid",@"1",@"typetag",nil];
    
        NSLog(@"insert params:%@",params);
    
    
        [[mydb sharedInstance]insertcontentremotewithimage:params ];
    

    
    // [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrototypeCell
- (QuoteTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    }
    
    return _prototypeCell;
}

#pragma mark - Configure
- (void)configureCell:(QuoteTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    
    
    
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    cell.treeNode = node;
    cell.contentlabel.text = node.nodeObject;
    
    NSLog(@"tree=%lu",(unsigned long)cell.treeNode.nodeLevel);
    
    if (cell.treeNode.nodeLevel==1) {
        cell.iconimage.image=nil;
    };

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:node.date];
   
    cell.detaillabel.text=currentTime;
    
    
   
    int number = [cell.treeNode.imageid intValue];
    
    NSLog(@"number:%d",number);
    
    if (number == 1) {
    //如果sqlite裏有圖就直接存取 沒有就從mysql查詢
    if (cell.treeNode.imagedate!=NULL) {
      
        
        UIImage * image=[UIImage imageWithData:cell.treeNode.imagedate];
        
        cell.cellimage.image=image;
    }else{
    
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"downloadimage",@"cmd",node.content_no , @"content_no", nil];
   
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"connecting"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        
       
        NSString *result = [apiResponse objectForKey:@"downloadimageresult"];
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
              [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary * data=[apiResponse objectForKey:@"downloadimage"];

                NSData * imagedata = [[NSData alloc]initWithBase64EncodedString:data[@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
           
                UIImage * image=[UIImage imageWithData:imagedata];
        
            cell.cellimage.image=image;
            
            [[mydb sharedInstance]insertimage:imagedata addcontent_no:cell.treeNode.content_no ];
            
                  }else {
                         NSLog(@"image download no suceess");
            
        }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
      }
    }else{
    
        cell.cellimage.image=nil;
    }

    //userpicture
    NSLog(@"tree:%@",cell.treeNode.Typetag);
     int type = [cell.treeNode.Typetag intValue];
    if (type==1) {
        UIImage *image =[UIImage imageNamed:@"camera16x.png"];
        cell.iconimage.image=image;
    }else if(type==2){
        UIImage *image =[UIImage imageNamed:@"pencil.png"];
        cell.iconimage.image=image;
    
    
    }
    

   
    
    

    
    
    
    
   }

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
    
    self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
   

    
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];
    
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.displayArray.count;
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentcell" forIndexPath:indexPath];
    
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
   

     [cell setNeedsDisplay];
    
    
    
   
    
    
    cell.emtionbutton.tag=indexPath.row;
    cell.closeBtn.tag=indexPath.row;
    
    
    
    return cell;
    
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do things with your cell here
    
    // set selection
    self.currentSelection = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [[cell viewWithTag:1001] setHidden:NO];
    
    // animate
    [tableView beginUpdates];
    [tableView endUpdates];
    
    
    
    
    
}

- (IBAction)SmileBTN:(id)sender {
    
    
    UIButton *senderButton = (UIButton *)sender;
    //NSLog(@"current Row=%ld",(long)senderButton.tag);
    NSIndexPath *path = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];
    QuoteTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    cell.simleView.hidden=NO;
    
    [cell.contentView addSubview:cell.simleView];
}

- (IBAction)closeSimleview:(id)sender {
    
    UIButton *senderButton = (UIButton *)sender;
    //NSLog(@"current Row=%ld",(long)senderButton.tag);
    NSIndexPath *path = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];
    QuoteTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    cell.simleView.hidden=YES;
    
    
    
}


- (IBAction)simle:(id)sender {
    
    UIButton *senderButton = sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    NSIndexPath *path = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];
    
    NSLog(@"path%@",path);
    QuoteTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [cell.emtionbutton setTitle:@"1" forState:UIControlStateNormal];
    
    [senderButton setTitle:@"1" forState:UIControlStateNormal];
}




#pragma mark-
- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.tableView reloadData];
    
    }
//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in nodes) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
 
 NSIndexPath *indexpath=self.tableView.indexPathForSelectedRow;
  TreeViewNode *node = [self.displayArray objectAtIndex:indexpath.row];
 replyViewController *tvc=segue.destinationViewController;
 
  tvc.node=node;
     
   
 }




@end
