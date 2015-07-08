//
//  PinListViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/7/9.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinListViewController.h"
#import "AppleMapViewController.h"
#import "PinDAO.h"
#import "SWRevealViewController.h"
#import "PinInfoTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "mydb.h"

@interface PinListViewController ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *pinArray;
    CLLocation *currentLocation;
    CLLocationManager *locationManager;
    CGFloat screenWidth;
    CGFloat screenHeight;
    UIPickerView *filterPickerView;
    NSArray *pickerArray;
    NSArray *sortedPinArray;
    UITapGestureRecognizer *tapGesture;
    UIPanGestureRecognizer *panGesture;
    mydb *friendDB;
    
}

@property (weak, nonatomic) IBOutlet UITableView *pinListTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showSlideMenuBarBtnItem;
@property (weak, nonatomic) IBOutlet UIPickerView *sortingPickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortingPickerViewConstraint;

@end

@implementation PinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    friendDB = [[mydb alloc] init];
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
    sortedPinArray = (NSMutableArray *) pinArray;
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
    locationManager.distanceFilter = 20;
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
    
    //self.pinListTableView.delegate = self;
    
    self.sortingPickerView.backgroundColor = [UIColor whiteColor];
    pickerArray = @[@"FROM 🐣 TO 🐔", @"FROM 🐔 TO 🐣", @"FROM 🚲 TO ✈️", @"FROM ✈️ TO 🚲"];
    
    self.sortingPickerView.delegate = self;
    self.sortingPickerView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 因為在上一頁已經將navigationBar隱藏，所以這裡要再打開才會出現navigationBar
    self.navigationController.navigationBarHidden = NO;
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPinInfoSegue"]) {
        NSIndexPath *indexPath = [self.pinListTableView indexPathForSelectedRow];
        PinInfoTableViewController *pinInfoTableVC = segue.destinationViewController;
        pinInfoTableVC.infoPin = pinArray[indexPath.row];
    }
}

- (IBAction)sortingBarBtnItem:(id)sender {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.sortingPickerViewConstraint.constant = -170;
        } completion:nil];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)];
        
        // 下一行self.myScrollView改成self.view也可以
        [self.view addGestureRecognizer:tapGesture];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)];
        [self.view addGestureRecognizer:panGesture];

}

- (void)hidePickerView {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.sortingPickerViewConstraint.constant = 0;
    } completion:nil];
    [self.view removeGestureRecognizer:tapGesture];
    [self.view removeGestureRecognizer:panGesture];
    
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
        pin.distance = [NSNumber numberWithFloat:[currentLocation distanceFromLocation:annoLocation]];
        
        //NSLog(@"distance=%f", distance);
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
    return [sortedPinArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIImageView *headShotImageView = (UIImageView *)[cell viewWithTag:10];
    UILabel *ownerLabel = (UILabel *)[cell viewWithTag:20];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:30];
    UILabel *distanceLable = (UILabel *)[cell viewWithTag:40];
    
    headShotImageView.layer.borderWidth = 10;
    headShotImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headShotImageView.layer.cornerRadius = 25;
    headShotImageView.clipsToBounds = YES;
    Pin * pin=[[Pin alloc]init ];
    pin = sortedPinArray[indexPath.row];
    
    headShotImageView.image = [UIImage imageNamed:@"headphoto.jpg"];
    
    NSMutableArray *memberInfoArray = [NSMutableArray new];
    memberInfoArray = [friendDB SearchFriendList:pin.memberId];
    //pin.subtitle = [NSString stringWithFormat:@"%@ 到此一遊", memberInfoArray[0][@"friendname"]];
    
    
    ownerLabel.text = [NSString stringWithFormat:@"%@ 在想：", memberInfoArray[0][@"friendname"]];
    titleLabel.text = [NSString stringWithFormat:@"  %@",[sortedPinArray[indexPath.row] title]];
    
    if (self.distanceDict[[sortedPinArray[indexPath.row] pinId]] != nil) {
        //distanceLable.text = [NSString stringWithFormat:@"%@kM", self.distanceDict[[pinArray[indexPath.row] pinId]]];
        
        distanceLable.text = [NSString stringWithFormat:@"%1.2fkM", [pin.distance floatValue]/1000.0];
    } else {
        distanceLable.text = @"Updating";
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    PinInfoTableViewController *infoTableVC = [[PinInfoTableViewController alloc] init];
    //
    //    infoTableVC.infoPin = pinArray[indexPath.row];
    //    [self.navigationController pushViewController:infoTableVC animated:YES];
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

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (row == 0) {
        sortedPinArray = [pinArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *n1 = [(Pin *) obj1 postedDate];
            NSDate *n2 = [(Pin *) obj2 postedDate];
            return [n1 compare:n2];
        }];
    } else if (row == 1) {
        NSArray *ary = [NSArray new];
        ary = [pinArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *n1 = [(Pin *) obj1 postedDate];
            NSDate *n2 = [(Pin *) obj2 postedDate];
            return [n1 compare:n2];
            
        }];
        sortedPinArray =[[ary reverseObjectEnumerator] allObjects];
        
    } else if (row == 2) {
        //PinDAO *pinDAO = [[PinDAO alloc] init];
        
        sortedPinArray = [pinArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *n1 = [(Pin *) obj1 distance];
            NSNumber *n2 = [(Pin *) obj2 distance];
            return [n1 compare:n2];
        }];
        
    } else {
        NSArray *ary = [NSArray new];
        
        ary = [pinArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *n1 = [(Pin *) obj1 distance];
            NSNumber *n2 = [(Pin *) obj2 distance];
            return [n1 compare:n2];
        }];
        sortedPinArray =[[ary reverseObjectEnumerator] allObjects];
        
    }
    //    Pin *pin = [[Pin alloc] init];
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pin.distance" ascending:YES];
    //
    //    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //    sortedPickerArray = [pickerArray sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.pinListTableView reloadData];
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
