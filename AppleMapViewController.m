//
//  AppleMapViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/6/22.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "PinTableViewController.h"
#import "AppleMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PinDAO.h"
#import "PinImage.h"
#import "PinImageDAO.h"
#import "PinEditViewController.h"
#import "PinInfoViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
//因為Pin繼承至MKPointAnnotation，所以不用再import

@interface AppleMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocation *currentLocation;
    BOOL isFirstLocationReceived;
    UIImage *leftCalloutImage;
    PinImageDAO *pinImageDAO;
    NSMutableArray *allPinRows;
    NSInteger badgeNumber;
    NSMutableArray *notifiedArray;
    NSInteger counting;
    NSMutableDictionary *distanceDict;
    UIButton *rightCalloutButton;
    
    //必須先#import <CoreLocation/CoreLocation.h>才能使用CLLocationManager類別
    CLLocationManager *locationManager;
}


@property (weak, nonatomic) IBOutlet MKMapView *appleMapView;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UIButton *showSlideMenuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showSlideMenuBarBtnItem;

@end

@implementation AppleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    badgeNumber = 1;
    
    self.appleMapView.delegate = self;
    
    notifiedArray = [[NSMutableArray alloc] init];
    
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
    
    //下面這行是Kent沒有用的，
    //在其他程式中，如果沒有加這行，就不會出現代表使用者現在位置的藍點
    // 也可以加屬性列加入設定
    self.appleMapView.ShowsUserLocation = YES;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePinVisitedDate) name:@"UPDATE_PIN_VISITED_DATE" object:nil];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if (revealViewController) {
        [self.showSlideMenuBarBtnItem setTarget:self.revealViewController];
        [self.showSlideMenuBarBtnItem setAction: @selector( revealToggle: )];

        //[self.showSlideMenuButton targetForAction:@selector(revealToggle:) withSender:self.revealViewController];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [locationManager stopUpdatingLocation];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // navigationBar和按鈕都隱藏
    //self.navigationController.navigationBarHidden = YES;
    
    // 讓navigationBar透明，但按鈕還在
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTranslucent:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    pinImageDAO = [[PinImageDAO alloc] init];
    PinDAO *pinDAO = [[PinDAO alloc] init];
    allPinRows = [pinDAO getAllPin];

    //先移除所有大頭針
    [self.appleMapView removeAnnotations:[self.appleMapView annotations]];
    

    Pin *pin = [[Pin alloc] init];;
    
    // 再從資料庫拿出資料，更新所有大頭針
    for(pin in allPinRows) {
        [self.appleMapView addAnnotation:pin];
        NSLog(@"id = %@, latitude = %f, longitude = %f, title = %@", pin.pinId, pin.coordinate.latitude, pin.coordinate.longitude, pin.title);
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Pin *)sender {
    if ([segue.identifier isEqualToString:@"showPinEditSegue"]) {
        PinEditViewController *pinEditVC = (PinEditViewController *)segue.destinationViewController;
        
        // 從下一頁拿上來的物件變數，也要初始化才可以用
        pinEditVC.currentPin = [[Pin alloc] init];
        pinEditVC.currentPin.coordinate = currentLocation.coordinate;

        // 假資料，測試用
//        CLLocationCoordinate2D annotationCoordinat;
//        annotationCoordinat.latitude = 24.969856;
//        annotationCoordinat.longitude = 121.189256;
//        pinEditVC.currentPin = [[Pin alloc] init];
//        pinEditVC.currentPin.coordinate = annotationCoordinat;
//        NSLog(@"pinEditVC.currentPin.coordinate.latitude = %f", pinEditVC.currentPin.coordinate.latitude);
        
    } else if ([segue.identifier isEqualToString:@"showPinInfoSegue"]) {
        
        PinInfoViewController *pinInfoVC = (PinInfoViewController *)segue.destinationViewController;
        pinInfoVC.infoPin = sender;
        
    }
//    else if ([segue.identifier isEqualToString:@"showPinListSegue"]) {
//        PinTableViewController *pinTableVC = (PinTableViewController *)segue.destinationViewController;
//        pinTableVC.distanceDict = distanceDict;
//    }
    
    
}

- (IBAction)addPinButtonAction:(id)sender {
    
    //    MKPointAnnotation *newAnnotation = [MKPointAnnotation new];
    //    newAnnotation.coordinate = currentLocation.coordinate;
    //    newAnnotation.title = @"I'm here";
    //    newAnnotation.subtitle = @"change me";
    //
    //    [self.appleMapView addAnnotation:newAnnotation];
    
    // 如果已經在storyboard，就不要再寫底下這一行，不然會翻2次頁
    //[self performSegueWithIdentifier:@"showPinEditSegue" sender:nil];
}

- (IBAction)returnUserLocationBtnAction:(id)sender {
    
    [self returnUserLocation];
}

- (IBAction)showPinMessage:(id)sender {
    Pin *pin = [[Pin alloc] init];
    PinDAO *pinDAO = [[PinDAO alloc] init];
    pin = [pinDAO getPinById:@"4"];
    //self.theLabel = pin.visitedDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm:ss"];

    self.theLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:pin.visitedDate]];
}


- (IBAction)listPinButtonAction:(id)sender {
//    PinTableViewController *pinTableVC = [[PinTableViewController alloc] init];
//    [self.navigationController pushViewController:pinTableVC animated:YES];
    
    // 如果已經在storyboard，就不要再寫底下這一行，不然會翻2次頁
    //[self performSegueWithIdentifier:@"showPinListSegue" sender:nil];
    
    
    
}

//參數的annotation是畫面上有出現的大頭針，因為要出現在畫面，所有需要view，就會來這個方法取得view
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    NSLog(@"%@", mapView.userLocation);
    
    // 表示不自訂藍點
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    // 叫mapView去佇列中拿名字叫newPin的AnnotationView
    MKAnnotationView *reuseAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"newPin"];
    
    
    // 如果佇列中沒有叫newPin的AnnotationView，就會得到nil
    // 那就創建叫newPin的AnnotationView
    // 這個AnnotationView是要給annotation用的
    if (reuseAnnotationView == nil) {
        reuseAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"newPin"];
    } else{
        // 如果AnnotationView不是nil，那就設定reuseAnnotationView的annotation是annotation
        // 這個方法是給annotation，然後回傳AnnotationView
        
        reuseAnnotationView.annotation = annotation;
    }
    NSLog(@"reuseAnnotationView.subviews = %@", reuseAnnotationView.subviews);

    
    reuseAnnotationView.draggable = false;
    reuseAnnotationView.image = [UIImage imageNamed:@"pointRed.png"];
    reuseAnnotationView.canShowCallout = true;
    
    // 如果不自訂按鈕的型式，那只要寫底下這行就可以了
     //UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    CGRect rightButtonRect = CGRectMake(0, 0, 80, 100);
    rightCalloutButton = [[UIButton alloc] initWithFrame:rightButtonRect];
    //UIImage *catImage = [UIImage imageNamed:@"cat1.jpg"];
    rightCalloutButton.backgroundColor = [UIColor lightGrayColor];

    //[rightCalloutButton setImage:catImage forState:UIControlStateNormal];

    Pin *anno = (Pin *)annotation;
    
    // 取得大頭針經緯度
    CLLocation *annoLocation = [[CLLocation alloc] initWithLatitude:anno.coordinate.latitude longitude:anno.coordinate.longitude];
    
    // 增加右邊按鈕，顯示大頭針與使用者距離，按下可導航
    rightCalloutButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSLog(@"[currentLocation distanceFromLocation:annoLocation]/1000.0] = %f", [currentLocation distanceFromLocation:annoLocation]/1000.0);
    [rightCalloutButton setTitle:[NSString stringWithFormat:@"%1.1f\nkM", [currentLocation distanceFromLocation:annoLocation]/1000.0] forState:UIControlStateNormal];
    reuseAnnotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    //當右邊的calloutButton被按下會去執行self的那個方法
    [rightCalloutButton addTarget:self action:@selector(showNavigationPath) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"annotation = %@", annotation);

    //    在泡泡的左邊增加圖片，按下圖片，會前往下一頁看詳細的圖片
    CGRect leftRect = CGRectMake(0, 0, 80, 100);
    
    //取出某個Pin的圖
    NSMutableArray *imageArray = [NSMutableArray new];
    imageArray = [pinImageDAO getAllImageByPinId:anno.pinId];
    
    PinImage *pinImage = [[PinImage alloc] init];
    
    //只用第一張，如果沒有圖就用預設圖
    if ([imageArray count]>0) {
        pinImage = imageArray[0];
    } else {
        
        //
        UIImage *img = [[UIImage alloc] init];
        img = [UIImage imageNamed:@"cat2.jpg"];
        pinImage.imageData = UIImageJPEGRepresentation(img, 0.5);
        
    }
    
    UIImage *image = [UIImage imageWithData:pinImage.imageData];
    
    // callout左邊放按鈕，這裡沒使用，是因為正平還不知道怎麼分辨使用者按了callout左邊還是右邊按鈕
    //UIButton *leftCalloutButton = [[UIButton alloc] initWithFrame:leftRect];
    //[leftCalloutButton setImage:image forState:UIControlStateNormal];
    //reuseAnnotationView.leftCalloutAccessoryView = leftCalloutButton;
    
    // callout左邊放圖片，放圖片，程式比較複雜，要在圖片上增加手勢
    UIImageView *leftCalloutImageView = [[UIImageView alloc] initWithFrame:leftRect];
    leftCalloutImageView.image = image;
    leftCalloutImageView.userInteractionEnabled = true;
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPinInfo)];
    [leftCalloutImageView addGestureRecognizer:imageTapGesture];

    reuseAnnotationView.leftCalloutAccessoryView = leftCalloutImageView;
    
    return reuseAnnotationView;
}

// 當使用者按下泡泡會進到此方法，暫時先comment，沒有用到
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    NSLog(@"MKAnnotationView.annotation = %@", view.annotation);
//}


// 當在地圖上按下一個大頭針，就會進到這方法
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {

    //[self.appleMapView selectAnnotation:view.annotation animated:YES];
    NSLog(@"MKAnnotationView.annotation = %@", view.annotation);

    Pin *pin = [[Pin alloc] init];
    
    [self.appleMapView removeAnnotation:pin];
    [self.appleMapView addAnnotation:pin];
//    CLLocationCoordinate2D center = self.appleMapView.centerCoordinate;
//    self.appleMapView.centerCoordinate = center;
    //[view setNeedsLayout];

}

// 自訂方法
// 當使用者按下callout按鈕，會進到此方法，準備到下一頁
- (void)showPinInfo {
    
    // 先得知按了那個一個annotation
    // 因為是by code產生的按鈕，所以在storyboard沒有按鈕，segue要從黃點拉到下一個頁面
    Pin *pin = [self.appleMapView selectedAnnotations][0];

    [self performSegueWithIdentifier:@"showPinInfoSegue" sender:pin];

}

- (void)showNavigationPath {

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"userLocation %f", userLocation.coordinate.latitude);
    
    
}


// 要#import <CoreLocation/CoreLocation.h>及加上<CLLocationManagerDelegate>，才能用這個方法
// 當iOS更新使用者位置，會進到這個方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    counting++;
    
    distanceDict = [NSMutableDictionary new];
    NSLog(@"counting = %d", counting);
    // 因為iOS的延遲，可能會丟出多個座標
    currentLocation = [locations lastObject];
    
    // 因為只要第一次更新位置時，執行一些動作，所以設定一個變數來控制
    if (isFirstLocationReceived == NO) {
        
        // 讓使用者回到地圖中心
        [self returnUserLocation];
        isFirstLocationReceived = YES;

    }
    
    // 比對使用者和大頭針的距離，如果距離小於多少，就會送出localNotification到iOS
    // 取得大頭針與使用者距離
    for (Pin *pin in allPinRows) {
        CLLocation *annoLocation = [[CLLocation alloc] initWithLatitude:pin.coordinate.latitude longitude:pin.coordinate.longitude];
        CGFloat distance = [currentLocation distanceFromLocation:annoLocation];
        //NSLog(@"pinId = %@, distance = %f, date=%@", pin.pinId, distance, pin.visitedDate);
        self.theLabel.text = [NSString stringWithFormat:@"pinId = %@, distance = %f, date=%@", pin.pinId, distance, pin.visitedDate];
        
        // 把距離存在字典裡，準備廣播出去
        [distanceDict setValue:[NSString stringWithFormat:@"%1.1f", distance/1000.0] forKey:pin.pinId];
        
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
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"DISTANCE_CHANGED" object:distanceDict];
    
}


//  自訂delegate的方法，讓呼叫的人可以利用distanceDict實作
//- (void) updatePinDistance {
//    [self.delegate dealPinDistance:distanceDict];
//}



// 在AppDelegate放了一個postNotificationName:object:，當app進入前景，這個viewController會收到廣播後執執行這個方法
- (void)updatePinVisitedDate {
    
    PinDAO *pinDAO = [[PinDAO alloc] init];
    for (Pin *pin in notifiedArray) {
        NSLog(@"date=%@", [NSDate date]);
        // 更新每一個大頭針的到訪時間
        [pinDAO updateVisitedDateFromSQLite:pin.pinId setVisitedDate:[NSDate date]];
    }

    // 因為更新的到訪時間，從資料庫更新陣列中的大頭針資料
    allPinRows = [pinDAO getAllPin];

    // 清掉已發出通知的pin
    [notifiedArray removeAllObjects];
    
    // 重新編號通知，從1開始才會叮咚
    badgeNumber = 1;
}

//自訂方法，讓使用者回到地圖中心
- (void)returnUserLocation {
    
    // 將地圖的region設定一個變數，這樣後面用這個變數就好，比較簡短，
    // 例如，不用寫self.myMapView.region.center = ...
    // 必須 #import <MapKit/MapKit.h>，才能使用MKCoordinateRegion類別
    MKCoordinateRegion region = self.appleMapView.region;
    
    //MapView在storyboard要拉好constraint，不然app一開始執行時，使用者的位置會跑掉，其實不是使用者跑掉，而是地圖偏掉了
    region.center = currentLocation.coordinate;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [self.appleMapView setRegion:region animated:YES];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}
*/

@end
