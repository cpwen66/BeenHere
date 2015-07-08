//
//  friendTableViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/5.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "friendTableViewController.h"
#import "mydb.h"
#import "SERVERCLASS.h"
#import "AFNetworking.h"
#import "StoreInfo.h"
#import "friendrootTableViewController.h"
#import "friendrootViewController.h"

@interface friendTableViewController ()<serDelegate,UISearchBarDelegate>
{
 NSString * friendID;
    NSInteger * cellindex;
    NSMutableArray *allUsers;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end



@implementation friendTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(addfriend) ];
    
    self.navigationItem.rightBarButtonItem=doneButton;
    
 
   
    [self showFriendList];
    
    
       [self initlist];
     self.searchBar.delegate = self;
}


-(void)viewDidAppear:(BOOL)animated{

    [self showFriendList];
    
    
    [self initlist];


}



-(void)initlist{

    
    
    
    frindRequestList=[StoreInfo shareInstance].FriendRequestList;

    
    NSLog(@"fr:%@",frindRequestList);
    
    MyfriendList=[StoreInfo shareInstance].MyFriendtList;
    
    
    
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    switch (section) {
        case 0:
       
            return [frindRequestList count];
          
                break;
          
        case 1:
           
                
            
            return [MyfriendList count];
          
                break;
            
        default: 
            break;
    }
       return 0;
  

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
  

    
    
    NSString *string;

    
    
    
    switch (section) {
            
        case 0:
            if (frindRequestList != nil) {
            string = @"好友請求";
            return string;
            
            }
            else
            {
                return nil;
            }
            break;
        case 1:
            string = @"好友列表";
            
            return string;
            break;
            
            
            
        default:
            break;
    }
    
    
    
    UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:8];
    NSMutableAttributedString * sectionTilte = [[NSMutableAttributedString alloc] initWithString:string];
        [sectionTilte addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,0)];
        [sectionTilte addAttribute:NSFontAttributeName value:myFont range:NSMakeRange(0,0)];
    
    
    return string;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


   

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return appropriate cell(s) based on section
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        
    if(indexPath.section == 0)
    {
        cell.textLabel.text =[NSString stringWithFormat:@"name:%@",frindRequestList[indexPath.row][@"name"]];
        
        NSLog(@"name:%@",frindRequestList[indexPath.row][@"name"]);
        UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addFriendButton.frame = CGRectMake(300.0f, 5.0f, 75.0f, 30.0f);
        [addFriendButton setTitle:@"Add" forState:UIControlStateNormal];
        [cell addSubview:addFriendButton];
        [addFriendButton addTarget:self
                            action:@selector(agreefriend:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        addFriendButton.tag=indexPath.row;
        
        
        UIButton *chcanelFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        chcanelFriendButton.frame = CGRectMake(250.0f, 5.0f, 75.0f, 30.0f);
        [chcanelFriendButton setTitle:@"No" forState:UIControlStateNormal];
        [cell addSubview:chcanelFriendButton];
        [chcanelFriendButton addTarget:self
                            action:@selector(chanelfriendRequest:)
                  forControlEvents:UIControlEventTouchUpInside];

        chcanelFriendButton.tag=indexPath.row;
        
    }

    
    
    if(indexPath.section == 1)
    {
         cell.textLabel.text =[NSString stringWithFormat:@"%@ ",MyfriendList[indexPath.row][@"name"]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    

    NSData * picture=[[NSData alloc]init ];
    
        picture= [[mydb sharedInstance]getuserpicture:MyfriendList[indexPath.row][@"id"]];
    
    
    if (picture ==NULL) {
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"downloaduserimage",@"cmd",MyfriendList[indexPath.row][@"id"] , @"userID", nil];
        
        
        NSLog(@"params%@",params);
        
        AFHTTPRequestOperationManager *managere = [AFHTTPRequestOperationManager manager];
        managere.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [managere POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
            NSLog(@"result:%@",apiResponse);
            
            NSString *result;
            //bug 待修
            if ((responseObject[@"api"]!=[NSNull null])) {
            result = [apiResponse objectForKey:@"downloaduserimageresult"];
            };
            
            
            if ([result isEqualToString:@"success"]) {
                
             
                NSDictionary * data=[apiResponse objectForKey:@"downloaduserimage"];
                
                if (![data[@"userpicture"] isEqual:@""]) {
                    NSData * imagedata = [[NSData alloc]initWithBase64EncodedString:data[@"userpicture"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    
                    //修改到sqlite 圖像
                    [[mydb sharedInstance]updateuserpicture:imagedata addID:MyfriendList[indexPath.row][@"id"] ];
                    
                    UIImage * image=[UIImage imageWithData:imagedata];
                    
                    cell.imageView.image=image;
                }else{
                    UIImage * image=[UIImage imageNamed:@"headphoto.jpg"];
                    
                    cell.imageView.image=image;
//                    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                }
                
                
                
                
            }else {
                NSLog(@"image download no suceess");
                
            }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"request error:%@",error);
          
            
        }];
        
    } else{  UIImage * image=[UIImage imageWithData:picture];
        
        cell.imageView.image=image;

        
    }

}
  
    
    return cell;
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    NSIndexPath *indexpath=self.tableView.indexPathForSelectedRow;
//    TreeViewNode *node = [self.displayArray objectAtIndex:indexpath.row];
    friendrootViewController *tvc=segue.destinationViewController;

    tvc.friendid=MyfriendList[indexpath.row][@"id"];
    [StoreInfo shareInstance].Friendid=MyfriendList[indexpath.row][@"id"];
    

}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
      NSIndexPath *indexpath=self.tableView.indexPathForSelectedRow;
    
    
    
    friendrootViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"custAddEditAc"];
    
    vc.friendid=MyfriendList[indexpath.row][@"id"];;
   
   
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - agree or chanel friend request
-(void)agreefriend:(id)sender{

    UIButton *senderButton = (UIButton *)sender;
    
    NSString * requestid=[NSString stringWithFormat:@"%@ ",frindRequestList[senderButton.tag][@"id"]];
    NSString * RequestFriendName=[NSString stringWithFormat:@"%@",frindRequestList[senderButton.tag][@"name"]];
    
    NSString * Myid=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"addfriendrequest",@"cmd", Myid, @"userID", requestid, @"friendID",@"2", @"numchange",nil];
    


  
   [[SERVERCLASS alloc]postRequest:params success:^(id jsonObject) {
       NSDictionary *apiResponse = [jsonObject objectForKey:@"api"];
       NSLog(@"apiResponse:%@",apiResponse);
       // 取的signIn的key值，並輸出
       NSString *result = [apiResponse objectForKey:@"addfriendrequest"];
       NSLog(@"addfriendrequest result:%@",result);
       
       NSString * e = [apiResponse objectForKey:@"validID"];
       NSLog(@"validID:%@",e);
       
       if ([result isEqualToString:@"success"]) {
           
           
           [[StoreInfo shareInstance].FriendRequestList removeObjectAtIndex:senderButton.tag];
           [self initlist];
         
           
           
             [[NSNotificationCenter defaultCenter]postNotificationName:@"serachfriend" object:nil];
           
           //同時存進sqlite
           [[mydb sharedInstance]insertfriendname:Myid friendname:RequestFriendName andffriendID:requestid ];
           
           [self.tableView reloadData];
       }
    } failure:^(NSError *error) {
        
    } ];
    
    
    
}




-(void)chanelfriendRequest:(id)sender{

    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    
    [frindRequestList removeObjectAtIndex:senderButton.tag];
    [self initlist];
    
}


-(void)agreefriendAction:(NSString*)myid andre:(NSString*)reid{

  


}
#pragma mark - find friend list

-(void)showFriendList{



    
    NSString * Myid=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"showfriend",@"cmd", Myid, @"userID",nil];
    
    
    
    
    [[SERVERCLASS alloc]postRequest:params success:^(id jsonObject) {
        NSDictionary *apiResponse = [jsonObject objectForKey:@"api"];
        NSLog(@"apiResponse friend:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"showfriend"];
   
     
        
        if ([result isEqualToString:@"success"]) {
            
            [StoreInfo shareInstance].MyFriendtList=[apiResponse[@"showfriendinfo"]mutableCopy];
            
             NSDictionary *reslutdata = [apiResponse objectForKey:@"showfriendinfo"];
            for (NSDictionary *dict in reslutdata) {
                
                
           [[mydb sharedInstance]inserfriendlist:dict];
             
            }
            [self initlist];
            
            
            
        }
    } failure:^(NSError *error) {
        
    } ];
    




}


#pragma mark - find friend
//尋找朋友
-(void)addfriend{
    
    
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:@"尋找朋友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"輸入id或Email";
        
        CGFloat yourSelectedFontSize = 20.0 ;
        UIFont *yourNewSameStyleFont = [textField.font fontWithSize:yourSelectedFontSize];
        textField.font = yourNewSameStyleFont ;
        
       
        
        
    }];
    
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        //將輸入的字取出
      UITextField * search=alertcontroller.textFields.firstObject;
        searchID=search.text;
        
//        NSString * searchresult=[[SERVERCLASS alloc]uploadUsers:searchID ];
      //   NSLog(@"search result:%@",searchresult);
    
     
        [self SearchFirend:searchID];
        NSLog(@"CONTENT:%@",searchID);
        
    }];
    
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];


    
    
    
    
}


//alertview 搜尋結果
-(void)SearchResult:(NSString *)result
{
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:result message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *add=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        if ([result isEqualToString:@"是否加好友"]) {
            //成功開始下一步
            [self addFirendRequest:friendID andfrisetrequest:@"1"];
        }
        
        
    }];
    
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        if ([result isEqualToString:@"取消"]) {
            //成功開始下一步
            
        }
        
        
    }];
    [alertcontroller addAction:add];
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];
    
    
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



#pragma php method
//送出好友請求
-(NSString*)addFirendRequest:(NSString *)addfriendID andfrisetrequest:(NSString *)Requestnum {
    
    
    
   //取出自己的ID
    NSString * myid=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    
    
    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"addrequest",@"cmd", myid, @"userID",addfriendID, @"friendID",@"requestadd",@"content",Requestnum,@"Requestnum", nil];
    
    NSLog(@"params addrequest:%@",params);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的addrequest的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"addrequest"];
        NSLog(@"result:%@",result);
        
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            //
            //
            NSLog(@"success");
            [self AddFeiend:@"好友請求已送出"];
            //
        }else{
            
            NSLog(@"no success");
            
            
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        [self SearchResult:@"connect error"];
        
        
        
        
    }];
    
    
    
    NSString * result= [[NSUserDefaults standardUserDefaults]stringForKey:@"sreachID" ];
    
    
    
    return result;
    
}

#pragma mark - php searech friend
-(void)resultInfo:(NSDictionary*)Response{

     friendID=[Response objectForKey:@"findid"];
    NSLog(@"friend id:%@",friendID);
    
    
}

//找尋使用者
-(NSString*)SearchFirend:(NSString *)SearchfriendID{
    
    
    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"findaccount",@"cmd", SearchfriendID, @"userID", nil];
    
    NSLog(@"par:%@",params);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
       
        
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"findaccount"];
         NSString * friend = [apiResponse objectForKey:@"findid"];
        NSLog(@"result:%@   %@",result,friend);
        
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            //
            //
           [self SearchResult:@"是否加好友"];
            [self resultInfo:apiResponse];
            
            //
        }else{
            
            [self SearchResult:(@"找尋不到")];
            
            
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        [self SearchResult:@"coneect error"];
        
        
        
        
    }];
    
    
    
    NSString * result= [[NSUserDefaults standardUserDefaults]stringForKey:@"sreachID" ];
   
    
   
    return result;
    
}

#pragma ALERT INFOMATION
-(void)AddFeiend:(NSString *)result
{
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:result message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];
    
    
}
#pragma mark - uisearchbardelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text=nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    NSString *query = searchBar.text;
    
    if ([query length]>0) {
        //查詢
        //        NSPredicate *filter = [NSPredicate predicateWithFormat:
        //                               @"(ContactName contains[c] %@) or (CompanyName contains[c] %@)", query, query];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"name contains[c] %@", query];
        
        
        NSArray *filteredArrays = [MyfriendList filteredArrayUsingPredicate:filter];
        
        MyfriendList = [NSMutableArray arrayWithArray:filteredArrays];
        
    } else {
        [self initlist];
    }
    
    [self.tableView reloadData];






}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *query = searchBar.text;
    
    if ([query length]>0) {
        //查詢
//        NSPredicate *filter = [NSPredicate predicateWithFormat:
//                               @"(ContactName contains[c] %@) or (CompanyName contains[c] %@)", query, query];
 NSPredicate *filter = [NSPredicate predicateWithFormat:@"name contains[c] %@", query];
        
        
        NSArray *filteredArrays = [MyfriendList filteredArrayUsingPredicate:filter];
        
        MyfriendList = [NSMutableArray arrayWithArray:filteredArrays];
        
    } else {
        [self initlist];
    }
    
    [self.tableView reloadData];
    
}




@end
