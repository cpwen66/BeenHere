//
//  friendrootTableViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/30.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "friendrootTableViewController.h"
#import "IndexTableViewController.h"
#import "StoreInfo.h"
#import "friendTableViewCell.h"
#import "TreeViewNode.h"
#import "mydb.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "replyViewController.h"
#import "talkviewcontroller.h"
#import "MapDateStore.h"
@interface friendrootTableViewController ()<MapDataProtocol>{
NSMutableArray* Content;
NSDictionary * contentkey;

NSUInteger indentation;
    NSMutableArray *nodes;
}
@property (nonatomic, strong) friendTableViewCell *prototypeCell;
@property (nonatomic, retain) NSMutableArray *displayArray;
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
@end

@implementation friendrootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      
    _friendid=[StoreInfo shareInstance].Friendid;
    NSLog(@"myfriendid:%@",_friendid);
    
    //relodata table
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loaddata) name:@"loaddata" object:nil];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddContentfriendwith:) name:@"textcontentfriendwith" object:nil];
   
    
    MapDateStore * mapManager = [MapDateStore new];
    [mapManager setDelegate:self];
    
    [mapManager searchcontentCount:_friendid];
    
    [self fillDisplayArray];
    //[self initdata];

     [self loaddata];
    
}
-(void)initindexcontent{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"connecting"];

    [[mydb sharedInstance]querymysqlindexcontent:_friendid ];
    
    
    
    [self loaddata];



}
//-(void)initdata{
//    
////    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////    [hud setLabelText:@"connecting"];
//    
//    
//    [[mydb sharedInstance]querymysqlindexcontent:_friendid ];
//    
//    
//    
//    [self loaddata];
//}
//從sqlite取內容資料
-(void)loaddata{
    
    
    Content=[[NSMutableArray alloc]init ];
    nodes=[[NSMutableArray alloc]init ];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"connecting"];
    
    
    
    Content=[[mydb sharedInstance]queryindexcontent:_friendid ];
    
    
    
    if (!Content.count==0) {
        
        
        for (int a=0;  a<=Content.count-1 ; a++) {
            
            TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
            firstLevelNode1.nodeLevel = 0;
            firstLevelNode1.nodeObject = Content[a][@"text"];
            firstLevelNode1.isExpanded = YES;
            firstLevelNode1.beeid = Content[a][@"id"];
            firstLevelNode1.Typetag = Content[a][@"typetag"];
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
    
    
    
    
    [self fillDisplayArray];
    [self.tableView reloadData];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AddContentfriendwith:(NSNotification *)message{
  
    NSDictionary * dict=[[NSDictionary alloc]init];
    
    //    dict = [NSDictionary dictionaryWithObject:message.object forKey:@"text"];
    dict=message.object;
    
    
    NSLog(@"s:%@",dict);
    // [self fillNodesArray:dict];
    
    
    
   // NSString * text=dict[@"text"];
    NSString * text=@"感謝各位聽我們報告";
    
    UIImage * image;
    
    if (dict[@"image"]!=[NSNull null]) {
        image=dict[@"image"];
    }else{
        image=nil;
    }
    //輸入時間
    
    
    
    
    //存到SQLite

    
    
    NSDictionary *params=[[NSDictionary alloc]init ];
    
    //取出當前時間 及時區的轉換
    NSDate * new = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:new];
    NSDate *localDate = [new dateByAddingTimeInterval:timeZoneOffset];
    
    
    //    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"demo.jpg"],0.5);
    NSData *imageData = UIImagePNGRepresentation(image);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"insertcontent",@"cmd", _friendid, @"userID", text, @"text", localDate, @"date",@"0",@"level",imageData,@"image",@"1",@"imageid",@"3",@"typetag",nil];
    
    NSLog(@"insert params:%@",params);
    
    
    [[mydb sharedInstance]insertcontentremotewithimage:params ];
    
    
    
    // [self.tableView reloadData];
    
}
#pragma mark - Table view data source
- (friendTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([friendTableViewCell class])];
    }
    
    return _prototypeCell;
}

#pragma mark - Configure
- (void)configureCell:(friendTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSString *quote = Content[indexPath.row][@"text"];
    
    
    
    
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    cell.treeNode = node;
    cell.contentlabel.text = node.nodeObject;
    
   
    
    if (cell.treeNode.nodeLevel==1) {
        
    };
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:node.date];
    
    cell.detaillabel.text=currentTime;
    

    
    
    int number = [cell.treeNode.imageid intValue];
    
 
    
    if (number == 1) {
        //如果sqlite裏有圖就直接存取 沒有就從mysql查詢
        if (cell.treeNode.imagedate!=NULL) {
            
            
            UIImage * image=[UIImage imageWithData:cell.treeNode.imagedate];
            
            cell.cellimage.image=image;
        }else{
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"downloadimage",@"cmd",node.content_no , @"content_no", nil];
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setLabelText:@"connecting"];
            
            //產生控制request的物件
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            //以POST的方式request並
            [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    
//userpicture////////////
    
    NSData * picture=[[NSData alloc]init ];
    picture= [[mydb sharedInstance]getuserpicture:cell.treeNode.beeid];
    if (picture ==NULL) {
    
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"downloaduserimage",@"cmd",node.beeid , @"userID", nil];
    
     AFHTTPRequestOperationManager *managere = [AFHTTPRequestOperationManager manager];
    managere.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [managere POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"result:%@",apiResponse);
        
        NSString *result;
        if (responseObject[@"api"]!=[NSNull null]) {
            result = [apiResponse objectForKey:@"downloaduserimageresult"];
        }
       
      
        if ([result isEqualToString:@"success"]) {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * data=[apiResponse objectForKey:@"downloaduserimage"];
            
            if (![data[@"userpicture"] isEqual:@""]) {
                NSData * imagedata = [[NSData alloc]initWithBase64EncodedString:data[@"userpicture"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                //修改到sqlite 圖像
                [[mydb sharedInstance]updateuserpicture:imagedata addID:cell.treeNode.beeid ];
                
                UIImage * image=[UIImage imageWithData:imagedata];
                
                cell.userimage.image=image;
            }else{
                UIImage * image=[UIImage imageNamed:@"system_user_picture.jpg"];
                
                cell.userimage.image=image;

            }
           
            

            
        }else {
            NSLog(@"image download no suceess");
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

    } else{  UIImage * image=[UIImage imageWithData:picture];
    
    cell.userimage.image=image;
    }
    
    
    
    int type = [cell.treeNode.Typetag intValue];
    if (type==1) {
        
        UIImage *image =[UIImage imageNamed:@"pencil.png"];
        cell.iconimage.image=image;
    }else if(type==2){
        UIImage *image =[UIImage imageNamed:@"camera16x.png"];
        cell.iconimage.image=image;
        
        
    }else if(type==3){
        UIImage *image =[UIImage imageNamed:@"camera16x.png"];
        cell.iconimage.image=image;
        
    }else{
    
     cell.iconimage.image=nil;
    }
//

    
    
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
    //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
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
    
    friendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([friendTableViewCell class])];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    
    [cell setNeedsDisplay];
    
    //    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    addFriendButton.frame = CGRectMake(300.0f, 5.0f, 75.0f, 30.0f);
    //    [addFriendButton setTitle:@"like" forState:UIControlStateNormal];
    //
    //    UIImage * img=[UIImage imageNamed:@"smood.png"];
    //    [addFriendButton setImage:img forState:UIControlStateNormal];
    //    [cell addSubview:addFriendButton];
    //    [addFriendButton addTarget:self
    //                        action:@selector(agreefriend:)
    //              forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
    
    
    
    
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    NSIndexPath *indexpath=self.tableView.indexPathForSelectedRow;
    TreeViewNode *node = [self.displayArray objectAtIndex:indexpath.row];
   replyViewController *tvc=segue.destinationViewController;
    
   tvc.node=node;
    tvc.flag=1;
    tvc.friend_id=_friendid;
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
