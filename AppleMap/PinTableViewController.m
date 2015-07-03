//
//  PinTableViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/7/2.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinInfoViewController.h"
#import "AppleMapViewController.h"
#import "PinTableViewController.h"
#import "PinDAO.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>

//#import "PinImageDAO.h"

@interface PinTableViewController ()<CLLocationManagerDelegate>//<updatePinDistanceDelegate>
{
    NSMutableArray *pinArray;
    CLLocation *currentLocation;
    CLLocationManager *locationManager;

}

@property (strong, nonatomic) IBOutlet UITableView *pinListTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showSlideMenuBarBtnItem;

@end

@implementation PinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.distanceDict = [NSMutableDictionary new];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tool3.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showCustomAlterView)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    pinArray = [NSMutableArray new];
    PinDAO *pinDAO = [[PinDAO alloc] init];
    pinArray = [pinDAO getAllPin];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationChanged:) name:@"DISTANCE_CHANGED" object:nil];
    
    // 使用Slide menu (第三方套件)
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
    
        [self.showSlideMenuBarBtnItem setTarget:self.revealViewController];
        [self.showSlideMenuBarBtnItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    locationManager = [CLLocationManager new];
    
    // iOS8之後的改變，取得使用者對位置服務的授權
    // 在info.plist也要加入相對內容，參考Kent講義p.30
    // 檢查locationManager是否實作或繼承了requestAlwaysAuthorization方法
    // respondsToSelector的功能是去找CLLocationManager裡是否有此方法requestAlwaysAuthorization
    // iOS8之後才有requestAlwaysAuthorization方法
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //使用者活動的種類
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    //讓本身(ViewController)用protocol來接收回報的位置
    locationManager.delegate = self;
    //[locationManager startMonitoringSignificantLocationChanges];
    
    [locationManager startUpdatingLocation];//開始更新位置
    
    // 先以 非自動 的方式指定座標給currentLocation，不然從別的view回來，會沒有座標，這樣距離算不出來。
    // 但目前的問題是callout的距離不會改變
    currentLocation = [locationManager location];
    NSLog(@"currentLocationTable= %@", currentLocation);

    // 自訂delegate
//    AppleMapViewController *appleMapVC = [AppleMapViewController new];
//    appleMapVC.delegate = self;
//    [appleMapVC updatePinDistance];
    
}

//- (void)userLocationChanged:(NSNotification *)aNotification {
//    //NSLog(@"aNotification.description = %@", aNotification.description);
//    self.distanceDict = [[NSMutableDictionary alloc] init];
//    self.distanceDict = aNotification.object;
//    NSLog(@"distanceDict = %@", self.distanceDict);
//
//    [self.pinListTableView reloadData];
//}

// 自訂delegate
//- (void)dealPinDistance:(NSMutableDictionary *)pinDistanceDict {
//    self.distanceDict = pinDistanceDict;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 因為在上一頁已經將navigationBar隱藏，所以這裡要再打開才會出現navigationBar
    self.navigationController.navigationBarHidden = NO;

    
}

-(void) showCustomAlterView {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPinInfoSegue"]) {
        NSIndexPath *indexPath = [self.pinListTableView indexPathForSelectedRow];
        PinInfoViewController *pinInfoVC = segue.destinationViewController;
        pinInfoVC.infoPin = pinArray[indexPath.row];
    }
}

#pragma mark = Location & Distance

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"userLocation %f", userLocation.coordinate.latitude);
    
    
}


// 要#import <CoreLocation/CoreLocation.h>及加上<CLLocationManagerDelegate>，才能用這個方法
// 當iOS更新使用者位置，會進到這個方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    
    [self.distanceDict removeAllObjects];

    // 因為iOS的延遲，可能會丟出多個座標
    currentLocation = [locations lastObject];
    
    
    // 比對使用者和大頭針的距離，如果距離小於多少，就會送出localNotification到iOS
    // 取得大頭針與使用者距離
    for (Pin *pin in pinArray) {
        CLLocation *annoLocation = [[CLLocation alloc] initWithLatitude:pin.coordinate.latitude longitude:pin.coordinate.longitude];
        CGFloat distance = [currentLocation distanceFromLocation:annoLocation];
       
        
        // 把距離存在字典裡
        [self.distanceDict setValue:[NSString stringWithFormat:@"%1.1f", distance/1000.0] forKey:pin.pinId];
        
        
 /*
        // 需滿足三個條件才會要iOS送出通知，
        // 使用者離大頭針距離120公尺內、沒有到訪過此大頭針、尚未發送過通知
        if (distance < 120 && pin.visitedDate == nil && [notifiedArray containsObject:pin]==false) {
            UILocalNotification *localNoti = [[UILocalNotification alloc] init];
            localNoti.fireDate = nil;// nil表示馬上發出通知，不排程
            localNoti.timeZone = [NSTimeZone defaultTimeZone];
            localNoti.alertBody = pin.title;
            localNoti.soundName = UILocalNotificationDefaultSoundName;
            localNoti.applicationIconBadgeNumber = badgeNumber;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
            
            //AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            // 因為有加新的通知，所以要馬上更新編號
            //[appDelegate reorderApplicationIconBadgeNumber];
            
            // 程式要自己控制badgeNumber的編號，所以這裡badgeNumber+1
            badgeNumber++;
            
            // 將已經送出的notification先存在暫存的array
            [notifiedArray addObject:pin];
            self.theLabel.text = [NSString stringWithFormat:@"id=%@, D= %f", pin.pinId, distance];
        }
  */
        
    }
    
    //self.distanceDict = [[NSMutableDictionary alloc] init];
    
    NSLog(@"distanceDict = %@", self.distanceDict);
    
    [self.pinListTableView reloadData];
  
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [pinArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIImageView *headShotImageView = (UIImageView *)[cell viewWithTag:10];
    UILabel *ownerLabel = (UILabel *)[cell viewWithTag:20];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:30];
    UILabel *distanceLable = (UILabel *)[cell viewWithTag:40];
    
    headShotImageView.layer.borderWidth = 10;
    headShotImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headShotImageView.layer.cornerRadius = 25;
    headShotImageView.clipsToBounds = YES;
    headShotImageView.image = [UIImage imageNamed:@"headphoto.jpg"];
    
    ownerLabel.text = [NSString stringWithFormat:@"%@", [pinArray[indexPath.row] pinId]];
    titleLabel.text = [pinArray[indexPath.row] title];
    
    if (self.distanceDict[[pinArray[indexPath.row] pinId]] != nil) {
        distanceLable.text = [NSString stringWithFormat:@"%@kM", self.distanceDict[[pinArray[indexPath.row] pinId]]];
    } else {
        distanceLable.text = @"Updating";
    }
    return cell;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
