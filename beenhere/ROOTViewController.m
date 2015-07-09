//
//  ROOTViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/25.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "ROOTViewController.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "mydb.h"
#import "AFNetworking.h"
#import "friendTableViewController.h"
#import "StoreInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "CameraViewController.h"
#import "talkviewcontroller.h"
#import "MBProgressHUD.h"
#import "PhotoSingleton.h"
#import "MapDateStore.h"

static NSString *const menuCellIdentifier = @"rotationCell";

@interface ROOTViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
MapDataProtocol
>
{
friendTableViewController * frinedview;
    NSString * NumRequest;
    UIView *contentView;
    UPStackMenu *stack;
    UIView *theSubView;
    NSString * TextContent;
    __weak IBOutlet UIView *thview;
}
@property (weak, nonatomic) IBOutlet UIButton *FriendreRreustlist;

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;

@property (weak, nonatomic) IBOutlet UIView *Textview;
@property (weak, nonatomic) IBOutlet UIButton *SendAction;
@property (weak, nonatomic) IBOutlet UITextView *TextviewContent;

@property (weak, nonatomic) IBOutlet UIButton *replysendBtn;

@property (weak, nonatomic) IBOutlet UIView *Emtionview;

@end

@implementation ROOTViewController

- (IBAction)SendinfoAction:(id)sender {
    
    [self changeDemo];
    _Textview.hidden=YES;
    TextContent=_TextviewContent.text;
    NSLog(@"text:%@",TextContent);
    
    //通知到indexTableviewController
    [[NSNotificationCenter defaultCenter]postNotificationName:@"textcontent" object:TextContent];
    
   
}

- (IBAction)sendCancelaction:(id)sender {

    [self changeDemo];
    _Textview.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
 
    NSString * BEID=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    

//    MapDateStore * mapManager = [[MapDateStore alloc] init];
//        mapManager.delegate = self;
//      [mapManager SearchPinContent];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleimage) name:@"handleimage" object:nil];

    [self userinfoinit];
    
     _TextviewContent.delegate = self;
    
    [self contentview];
    [self initiateMenuOptions];
    [self inittextview];
    
    // 重新搜尋朋友請求
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initfriendrequest) name:@"serachfriend" object:nil];
    
    [self SearchRequest:BEID];
    self.userpicture.layer.borderWidth = 2.0f;
    self.userpicture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userpicture.layer.cornerRadius = 25.0f;
       _userpicture.clipsToBounds = YES;
    
    [[_Emtionview layer] setBorderWidth:3.0];
    
    // 邊框顏色
    [[_Emtionview layer] setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor];
    
    [[_Emtionview layer] setCornerRadius:6.0];
    
      self.SendAction.layer.cornerRadius=5.0;
}

-(void)initfriendrequest {
   NSString * BEID=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
 
    [self SearchRequest:BEID];
}

-(void)inittextview {

    [[_Textview layer] setBorderWidth:2.0];
    //邊框顏色
    [[_Textview layer] setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor];
    _Textview.layer.cornerRadius = 2.5;

    [[_Textview layer] setCornerRadius:10.0];

    _TextviewContent.text = @"寫下您的心情";
    _TextviewContent.textColor = [UIColor lightGrayColor];
}

-(void)userinfoinit {
    
    NSString * BEID=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    
    
    NSData * picture=[[NSData alloc]init ];
     picture= [[mydb sharedInstance]getuserpicture:BEID];
    if (picture ==NULL) {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"downloaduserimage",@"cmd",BEID , @"userID", nil];
    
    AFHTTPRequestOperationManager *managere = [AFHTTPRequestOperationManager manager];
    managere.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [managere POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
      
        NSString *result = [apiResponse objectForKey:@"downloaduserimageresult"];
        
        if ([result isEqualToString:@"success"]) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * data=[apiResponse objectForKey:@"downloaduserimage"];
            
           
            
            NSData * imagedata = [[NSData alloc]initWithBase64EncodedString:data[@"userpicture"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
     
            
            if ([data[@"userpicture"]   isEqual:@""]) {
                
                [[mydb sharedInstance]insertimage:imagedata addcontent_no:BEID];
                
                UIImage * image=[UIImage imageNamed:@"headphoto.jpg"];
                    _userpicture.image=image;
            } else {
            UIImage * image=[UIImage imageWithData:imagedata];
                   _userpicture.image=image;
            }
            
        } else {
            NSLog(@"image download no suceess");
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    } else {
        
        UIImage * image=[UIImage imageWithData:picture];
        
         _userpicture.image=image;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self contentview];
    
    
}



-(void)contentview {

    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [contentView setBackgroundColor:[UIColor colorWithRed:112./255. green:47./255. blue:168./255. alpha:1.]];
     [contentView setBackgroundColor:[UIColor colorWithRed:24./255. green:182./255. blue:246./255. alpha:1.]];
    [contentView.layer setCornerRadius:6.];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectInset(contentView.frame, 10, 10)];
    [contentView addSubview:icon];
    
    [self changeDemo];
}

-(void)changeDemo {

    if(stack)
        [stack removeFromSuperview];
    
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    [stack setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 220)];
    [stack setDelegate:self];
    
    UPStackMenuItem *squareItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"message40"] highlightedImage:nil title:@"留言"];
    UPStackMenuItem *circleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"mood40"] highlightedImage:nil title:@"心情"];
    UPStackMenuItem *triangleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera40"] highlightedImage:nil title:@"相機"];
    UPStackMenuItem *crossItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"map40"] highlightedImage:nil title:@"地圖"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:squareItem, circleItem, triangleItem, crossItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor orangeColor]];
    }];
            [stack setAnimationType:UPStackMenuAnimationType_progressive];
            [stack setStackPosition:UPStackMenuStackPosition_up];
            [stack setOpenAnimationDuration:.4];
            [stack setCloseAnimationDuration:.4];
    
            [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
                [item setLabelPosition:UPStackMenuItemLabelPosition_right];
                [item setLabelPosition:UPStackMenuItemLabelPosition_left];
            }];
    
//        case 1:
//            [stack setAnimationType:UPStackMenuAnimationType_linear];
//            [stack setStackPosition:UPStackMenuStackPosition_down];
//            [stack setOpenAnimationDuration:.3];
//            [stack setCloseAnimationDuration:.3];
//            [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
//                [item setLabelPosition:UPStackMenuItemLabelPosition_right];
//            }];
//            break;
//            
//        case 2:
//            [stack setAnimationType:UPStackMenuAnimationType_progressiveInverse];
//            [stack setStackPosition:UPStackMenuStackPosition_up];
//            [stack setOpenAnimationDuration:.4];
//            [stack setCloseAnimationDuration:.4];
//            [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
//                if(idx%2 == 0)
//                    [item setLabelPosition:UPStackMenuItemLabelPosition_left];
//                else
//                    [item setLabelPosition:UPStackMenuItemLabelPosition_right];
//            }];
//            break;
//            
//        default:
//            break;
//    }
    
    [stack addItems:items];
    [self.view addSubview:stack];
    
    [self setStackIconClosed:YES];




}


- (IBAction)friendNoteAction:(UIBarButtonItem*)sender {

    NSLog(@"sadasd");
    
    NSString * numcount = [NSString stringWithFormat:@"有%@位使用者送出好友請求",NumRequest];
    
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:numcount message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];
}

-(void)sequefrinedtableview {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

  



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
    _TextviewContent.text = @"";
    _TextviewContent.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_TextviewContent.text.length == 0){
        _TextviewContent.textColor = [UIColor lightGrayColor];
        _TextviewContent.text = @"寫下您的心情";
        [_TextviewContent resignFirstResponder];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
}

#pragma mark - IBAction

- (IBAction)menuAction:(UIBarButtonItem *)sender {
    
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
    
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"Send message",
                        @"Like profile",
                        @"Add to friends",
                        @"Add to favourites",
                        @"Block user"];
    
    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
                       [UIImage imageNamed:@"SendMessageIcn"],
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"AddToFriendsIcn"],
                       [UIImage imageNamed:@"AddToFavouritesIcn"],
                       [UIImage imageNamed:@"BlockUserIcn"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIViewController * setting = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    
   UIViewController * friend = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
    
    //透過menu 選單 跳到所需頁面
    switch (indexPath.row) {
        case  (1) :

             [self.navigationController pushViewController:setting animated:YES];
            break;
        case  (3) :
            
            [self.navigationController pushViewController:friend animated:YES];
            
            break;
            
        default:
            break;
    }
    
    [tableView dismisWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)prepareForSegue:(YALContextMenuTableView *)segue sender:(id)sender{
    
}

#pragma mark - php search request
-(void)receiveFriendRquest:(NSDictionary *)receive{

    //將sql return 資料存成陣列
   
    [StoreInfo shareInstance].FriendRequestList=[receive[@"requestid"] mutableCopy];

    
    int count = [[StoreInfo shareInstance].FriendRequestList count];
    
    if (count != 0) {
         NumRequest=[NSString stringWithFormat:@"%lu",(unsigned long)[[StoreInfo shareInstance].FriendRequestList count]];
    }else{
    
        NumRequest=nil;
    }
    
    [self.FriendreRreustlist setTitle:NumRequest forState:UIControlStateNormal];
}

#pragma mark - 確認資料庫好友請求
//確認資料庫有沒有好友請求
-(void)SearchRequest:(NSString *)SearchfriendID{
    
    //設定根目錄
    
    
    //設定要POST的鍵值
    
    
    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"findRequest",@"cmd", SearchfriendID, @"userID", nil];
    

    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        
        
        // 取的signIn的key值，並輸出
       NSString *result = [apiResponse objectForKey:@"findRequest"];
        NSString * friend = [apiResponse objectForKey:@"requestid"];
        
        NSLog(@"result:%@ ",friend);
        
        
        //   判斷signUp的key值是否等於success
        if (![result isEqualToString:@"success"]) {
            //
            //
            NSLog(@"success");
            [self receiveFriendRquest:apiResponse];
            //
        }else{
            
            NSLog(@"no success");
            
            
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        //  [self SearchResult:@"coneect error"];
        
        
        
        
    }];
}


- (IBAction)friendrequestcount:(id)sender {

    NSLog(@"sadasd");
    
    if (NumRequest != 0) {
        
    NSString * numcount =[NSString stringWithFormat:@"有%@位使用者送出好友請求",NumRequest];
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:numcount message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        friendTableViewController * friend = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
        
        [self.navigationController pushViewController:friend animated:YES];
    }];
    
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];
    
    } else {
        friendTableViewController * friend = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
    
        [self.navigationController pushViewController:friend animated:YES];
    }
}

- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}


#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:NO];
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{

    talkviewcontroller * talk = [self.storyboard instantiateViewControllerWithIdentifier:@"talk"];
       UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraview"];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AppleMap" bundle:nil];
//    
    id targetViewController = [storyBoard instantiateViewControllerWithIdentifier:@"SWReveal"];
    NSUserDefaults *defaultsImageC = [NSUserDefaults standardUserDefaults];
   
    
    switch (index) {
        case 0:
           _Textview.hidden=NO;
        [stack removeFromSuperview];
        [contentView removeFromSuperview];
            break;
         case 1:
    
            [self.navigationController pushViewController:talk animated:YES];
            [stack removeFromSuperview];
            [contentView removeFromSuperview];
            break;
        case 2:
         
            [self presentViewController:cameraVC animated:YES completion:nil];
            [defaultsImageC setBool:YES forKey:@"isContent"];
            [defaultsImageC synchronize];
            [defaultsImageC setBool:NO forKey:@"isImage"];
            [defaultsImageC synchronize];
            [defaultsImageC setBool:NO forKey:@"isPhoto"];
            [defaultsImageC synchronize];
            
            break;
         case 3:
             [self presentViewController:targetViewController animated:true completion:nil];
            
            break;
        default:
            break;
    }
    NSLog(@"index:%lu",(unsigned long)index);
}

//code 跑出UIVIEW 待刪
-(void)UserTextView{
    
    theSubView=[[UIView alloc]
                        initWithFrame:CGRectMake(20, 380, 340, 130)];
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 100)];
    
    
    text.backgroundColor=[UIColor whiteColor];
    theSubView.backgroundColor=[UIColor whiteColor];
    [theSubView addSubview:text];
    [[_Textview layer] setBorderWidth:3.0];
    //邊框顏色
    [[_Textview layer] setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor];
    
    [[theSubView layer] setCornerRadius:10.0];
    
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    theButton.frame = CGRectMake(280, 90, 60, 60);
    [theButton setImage:[UIImage imageNamed:@"Button Image.png"] forState:UIControlStateNormal];
    [theButton setTitle:@"c" forState:UIControlStateNormal];
    
    [theButton addTarget:self action:@selector(onSkillButton) forControlEvents:UIControlEventTouchUpInside];
    [theSubView addSubview:theButton];
   
    [self.view addSubview:theSubView];
}

#pragma mark - Camera Method
-(void)handleimage{

    if ([PhotoSingleton shareInstance].thumbnailPhoto != nil ) {
 
        self.userpicture.image = [PhotoSingleton shareInstance].thumbnailPhoto;
    }
    

    
    if ([PhotoSingleton shareInstance].frontPhoto != nil) {
   
        self.userbackground.image = [PhotoSingleton shareInstance].frontPhoto;
    }
    
//    
//    if ([PhotoSingleton shareInstance].frontPhoto != nil) {
//      
//        NSLog(@"www");
//        
//    }


}
// 點擊大頭照跳出選項
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

// 點擊大頭照更換照片
- (IBAction)tap:(id)sender {
    [self jumpPhotoView:self];
    self.isThumbnailPicked = YES;

//    NSString *aboutString = @"更新大頭貼照";
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:aboutString
//                                                            delegate:self
//                                                   cancelButtonTitle:@"取消"
//                                              destructiveButtonTitle:nil
//                                                   otherButtonTitles:@"拍照", nil];
//    [actionSheet showInView:self.view];
}

// ActionSheet 拍照方法
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 ) {
        UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraview"];
        [self presentViewController:cameraVC animated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 更換封面照片按鈕
- (IBAction)changeImageAction:(id)sender {
    [self jumpImageView:self];
    self.isCoverPhotoPicked = NO;
}

// 更換封面照片呼叫方法
- (void)jumpImageView:(id)sender {
    
    CGRect viewRect = CGRectMake(10, 190, self.view.bounds.size.width-20, 150);
    UIView *changeImageView = [[UIView alloc]initWithFrame:viewRect];
    CALayer *layer = [changeImageView layer];
    if ((self.isCoverPhotoPicked = YES)) {
        self.isThumbnailPicked = NO;
    }
    
    //邊框顏色
    [[changeImageView layer] setBorderWidth:1.0];
    [[changeImageView layer]setBorderColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor];
    [[changeImageView layer] setCornerRadius:5.0];
    [changeImageView setBackgroundColor:[UIColor whiteColor]];
    layer.masksToBounds = YES;
    
    [self.view.layer addSublayer:layer];
    [self.view addSubview:changeImageView];
    
    
    // 標題
    UILabel *titleImageLabel =[[UILabel alloc]initWithFrame:viewRect];
    [titleImageLabel setFrame:CGRectMake(15, 195, self.view.bounds.size.width-30, 30)];
    titleImageLabel.textColor = [UIColor grayColor];
    titleImageLabel.textAlignment =  NSTextAlignmentCenter;
    titleImageLabel.text = @"更新封面照片";
    [self.view addSubview:titleImageLabel];
    
    
    // 拍照按鈕
    UIButton *takeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [takeImageButton setFrame:CGRectMake(15, 230, self.view.bounds.size.width-30, 30)];
    [takeImageButton setTitle:@"拍照" forState:UIControlStateNormal];
    [takeImageButton addTarget:self action:@selector(cameraView:) forControlEvents:UIControlEventTouchUpInside];
    [takeImageButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.view addSubview:takeImageButton];
    
    NSUserDefaults *defaultsImage = [NSUserDefaults standardUserDefaults];
    [defaultsImage setBool:YES forKey:@"isImage"];
    [defaultsImage synchronize];
    
    NSUserDefaults *defaultsPhoto = [NSUserDefaults standardUserDefaults];
    [defaultsPhoto setBool:NO forKey:@"isPhoto"];
    [defaultsPhoto synchronize];
    
    
    // 選擇照片按鈕
    UIButton *pickImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pickImageButton setFrame:CGRectMake(15, 265, self.view.bounds.size.width-30, 30)];
    [pickImageButton setTitle:@"從相簿選擇照片" forState:UIControlStateNormal];
    [pickImageButton addTarget:self action:@selector(pickImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickImageButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.view addSubview:pickImageButton];
    
    if ((self.isCoverPhotoPicked = YES)) {
        self.isThumbnailPicked = NO;
    }
    
    
    // 取消按鈕
    UIButton *cancelImageButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelImageButton setFrame:CGRectMake(15, 300, self.view.bounds.size.width-30, 30)];
    [cancelImageButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelImageButton addTarget:self action:@selector(cancelImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelImageButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.view addSubview:cancelImageButton];
    
    
    // 間隔線1
    UIView *lineImageA = [[UIView alloc]initWithFrame:viewRect];
    [lineImageA setFrame:CGRectMake(10, 227, self.view.bounds.size.width-20, 1)];
    [[lineImageA layer]setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7].CGColor];
    
    [self.view addSubview:lineImageA];
    
    
    // 間隔線2
    UIView *lineImageB = [[UIView alloc]initWithFrame:viewRect];
    [lineImageB setFrame:CGRectMake(25, 265, self.view.bounds.size.width-50, 0.5)];
    [[lineImageB layer]setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3].CGColor];
    
    [self.view addSubview:lineImageB];
    
    
    // 間隔線3
    UIView *lineImageC = [[UIView alloc]initWithFrame:viewRect];
    [lineImageC setFrame:CGRectMake(25, 300, self.view.bounds.size.width-50, 0.5)];
    [[lineImageC layer]setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3].CGColor];
    
    [self.view addSubview:lineImageC];
    
    
    // Set tag
    changeImageView.tag = 1121;
    takeImageButton.tag = 1122;
    pickImageButton.tag = 1123;
    cancelImageButton.tag = 1124;
    lineImageA.tag = 1125;
    lineImageB.tag = 1126;
    lineImageC.tag = 1127;
    titleImageLabel.tag = 1128;
    
}

// 更換大頭照呼叫方法
- (void)jumpPhotoView:(id)sender {
    
    CGRect viewRect = CGRectMake(10, 190, self.view.bounds.size.width-20, 150);
    UIView* changePhotoView = [[UIView alloc] initWithFrame:viewRect];
    CALayer *layer = [changePhotoView layer];
    if ((self.isThumbnailPicked = YES)) {
        self.isCoverPhotoPicked = NO;
    }
    
    // 設定邊框
    [[changePhotoView layer] setBorderWidth:1.0];
    [[changePhotoView layer] setBorderColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor];
    [[changePhotoView layer] setCornerRadius:5.0];
    [changePhotoView setBackgroundColor:[UIColor whiteColor]];
    layer.masksToBounds = YES;
    
    [self.view.layer addSublayer:layer];
    [self.view addSubview:changePhotoView];
    
    
    // 標題
    UILabel *titlePhotoLabel =[[UILabel alloc]initWithFrame:viewRect];
    [titlePhotoLabel setFrame:CGRectMake(15, 195, self.view.bounds.size.width-30, 30)];
    titlePhotoLabel.textColor = [UIColor grayColor];
    titlePhotoLabel.textAlignment =  NSTextAlignmentCenter;
    titlePhotoLabel.text = @"更新大頭照片";
    
    [self.view addSubview:titlePhotoLabel];
    
    
    // 拍照按鈕
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [takePhotoButton setFrame:CGRectMake(15, 230, self.view.bounds.size.width-30, 30)];
    [takePhotoButton addTarget:self action:@selector(cameraView:) forControlEvents:UIControlEventTouchUpInside];
    [takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.view addSubview:takePhotoButton];
    
    NSUserDefaults *defaultsPhoto = [NSUserDefaults standardUserDefaults];
    [defaultsPhoto setBool:YES forKey:@"isPhoto"];
    [defaultsPhoto synchronize];
    
    NSUserDefaults *defaultsImage = [NSUserDefaults standardUserDefaults];
    [defaultsImage setBool:NO forKey:@"isImage"];
    [defaultsImage synchronize];
    
    
    // 選擇相片按鈕
    UIButton *pickPhotoButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pickPhotoButton setFrame:CGRectMake(15, 265, self.view.bounds.size.width-30, 30)];
    [pickPhotoButton setTitle:@"從相簿選擇照片" forState:UIControlStateNormal];
    [pickPhotoButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [pickPhotoButton addTarget:self action:@selector(pickPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pickPhotoButton];
    if ((self.isThumbnailPicked = YES)) {
        self.isCoverPhotoPicked = NO;
    }
    
    
    // 取消按鈕
    UIButton *cancelPhotoButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelPhotoButton setFrame:CGRectMake(15, 300, self.view.bounds.size.width-30, 30)];
    [cancelPhotoButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [cancelPhotoButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelPhotoButton addTarget:self action:@selector(cancelPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelPhotoButton];
    
    
    // 間隔線1
    UIView *linePhotoA = [[UIView alloc]initWithFrame:viewRect];
    [linePhotoA setFrame:CGRectMake(10, 227, self.view.bounds.size.width-20, 1)];
    [[linePhotoA layer]setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7].CGColor];
    
    [self.view addSubview:linePhotoA];
    
    
    // 間隔線2
    UIView *linePhotoB = [[UIView alloc]initWithFrame:viewRect];
    [linePhotoB setFrame:CGRectMake(25, 265, self.view.bounds.size.width-50, 0.5)];
    [[linePhotoB layer]setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3].CGColor];
    
    [self.view addSubview:linePhotoB];
    
    
    // 間隔線3
    UIView *linePhotoC = [[UIView alloc]initWithFrame:viewRect];
    [linePhotoC setFrame:CGRectMake(25, 300, self.view.bounds.size.width-50, 0.5)];
    [[linePhotoC layer]setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3].CGColor];
    
    [self.view addSubview:linePhotoC];
    
    
    // Set tag
    changePhotoView.tag = 1111;
    takePhotoButton.tag = 1112;
    pickPhotoButton.tag = 1113;
    cancelPhotoButton.tag = 1114;
    linePhotoA.tag = 1115;
    linePhotoB.tag = 1116;
    linePhotoC.tag = 1117;
    titlePhotoLabel.tag = 1118;
}

// 呼叫負責拍照的CameraViewController方法
- (void)cameraView:(id)sender {
    UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraview"];
    
    [self presentViewController:cameraVC animated:YES completion:nil];
}

// 取消大頭照片按鈕
- (void)cancelPhotoClick:(id)sender {
    [[self.view viewWithTag:1111] removeFromSuperview];
    [[self.view viewWithTag:1112] removeFromSuperview];
    [[self.view viewWithTag:1113] removeFromSuperview];
    [[self.view viewWithTag:1114] removeFromSuperview];
    [[self.view viewWithTag:1115] removeFromSuperview];
    [[self.view viewWithTag:1116] removeFromSuperview];
    [[self.view viewWithTag:1117] removeFromSuperview];
    [[self.view viewWithTag:1118] removeFromSuperview];
}

// 取消封面照片按鈕
- (void)cancelImageClick:(id)sender {
    [[self.view viewWithTag:1121] removeFromSuperview];
    [[self.view viewWithTag:1122] removeFromSuperview];
    [[self.view viewWithTag:1123] removeFromSuperview];
    [[self.view viewWithTag:1124] removeFromSuperview];
    [[self.view viewWithTag:1125] removeFromSuperview];
    [[self.view viewWithTag:1126] removeFromSuperview];
    [[self.view viewWithTag:1127] removeFromSuperview];
    [[self.view viewWithTag:1128] removeFromSuperview];
}

// 挑選照片方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *imageEdited;
    if ([mediaType isEqualToString:@"public.image"]) {
        imageEdited = [info
                       objectForKey:UIImagePickerControllerEditedImage];
    }
    
    // 取得使用者拍攝的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // 存檔
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //    CameraViewController *cavc = [[CameraViewController alloc] init];
    // 關閉拍照程式
    if (self.isThumbnailPicked == YES) {
        [PhotoSingleton shareInstance].thumbnailPhoto = imageEdited;
        
        [self dismissViewControllerAnimated:YES completion:^{
            self.userpicture.image = [PhotoSingleton shareInstance].thumbnailPhoto;
        }];
    } else if (self.isCoverPhotoPicked == NO) {
        [PhotoSingleton shareInstance].frontPhoto = imageEdited;
        
        [self dismissViewControllerAnimated:YES completion:^{
           self.userbackground.image = [PhotoSingleton shareInstance].frontPhoto;
        }];
    }
}

// 挑選大頭照片按鈕方法
- (void)pickPhotoPressed:(id)sender {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    //photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

// 挑選封面照片按鈕方法
- (void)pickImageAction:(id)sender {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];

    photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

// 消除更換大頭照片及封面照片跳出的View
- (void)viewDidDisappear:(BOOL)animated {
    [[self.view viewWithTag:1111] removeFromSuperview];
    [[self.view viewWithTag:1112] removeFromSuperview];
    [[self.view viewWithTag:1113] removeFromSuperview];
    [[self.view viewWithTag:1114] removeFromSuperview];
    [[self.view viewWithTag:1115] removeFromSuperview];
    [[self.view viewWithTag:1116] removeFromSuperview];
    [[self.view viewWithTag:1117] removeFromSuperview];
    [[self.view viewWithTag:1118] removeFromSuperview];
    
    [[self.view viewWithTag:1121] removeFromSuperview];
    [[self.view viewWithTag:1122] removeFromSuperview];
    [[self.view viewWithTag:1123] removeFromSuperview];
    [[self.view viewWithTag:1124] removeFromSuperview];
    [[self.view viewWithTag:1125] removeFromSuperview];
    [[self.view viewWithTag:1126] removeFromSuperview];
    [[self.view viewWithTag:1127] removeFromSuperview];
    [[self.view viewWithTag:1128] removeFromSuperview];
}

@end
