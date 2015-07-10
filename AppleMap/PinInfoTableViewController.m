//
//  PinInfoTableViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/7/4.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinInfoTableViewController.h"
#import "PinDAO.h"
#import "Pin.h"
#import "PinImageDAO.h"
#import "PinImage.h"
#import <QuartzCore/QuartzCore.h>
#import "PinInfoTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "mydb.h"

@interface PinInfoTableViewController ()
{
    NSMutableArray *pinArray;
    NSMutableArray *pinImageArray;
    NSMutableArray *pinWithImageArray;
    UILabel *titleLabel;
    NSMutableArray *cellViewArray;
    UIImage *imgForNavigationBar;
}
//@property (weak, nonatomic) IBOutlet UIView *headerView;

//@property (weak, nonatomic) IBOutlet UILabel *postedTitleLabel;

@end

@implementation PinInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBarHidden = NO;
    
    self.tableView.allowsSelection = NO;// 讓使用者對tableView的點擊無效
    
    mydb *friendDB =[[mydb alloc] init];
    
    //[self.infoTableView reloadData];
    
    cellViewArray = [NSMutableArray new];
    titleLabel = [UILabel new];
    
    PinImageDAO *pinImageDAO = [[PinImageDAO alloc] init];
    //PinImage *pinImage = [[PinImage alloc] init];
/*
    if (self.infoPin.visitedDate != nil) {
        NSLog(@"visitedDate = %@", self.infoPin.visitedDate);
        titleLabel.text = [NSString stringWithFormat:@"%@\n\n在%@", self.infoPin.title, self.infoPin.visitedDate];
    } else {
        titleLabel.text = self.infoPin.title;
    }
*/
    // 上面要先拿到label的文字，下面是要算label的高度
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    //NSLog(@"screen width= %f, height= %f", screenWidth, screenHeight);
    
//    CGFloat tableViewWidth = self.infoTableView.frame.size.width;
//    CGFloat tableViewHeight = self.infoTableView.frame.size.height;
/*
    CGSize maxSize = CGSizeMake(screenWidth-80, 999);
    NSString *contentString = titleLabel.text;
    UIFont *contentFont = titleLabel.font;
    CGRect contentFrame;
    NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:contentFont, NSFontAttributeName, nil];
    CGSize contentSize = [contentString boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:contentDic
                                                     context:nil].size;
    contentFrame = CGRectMake(40, 20, screenWidth-80, contentSize.height + 40);
    titleLabel.frame = contentFrame;
    
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    
    //下面為倒圓角要用的二行程式，也要#import <QuartzCore/QuartzCore.h>
    titleLabel.layer.cornerRadius = 7;
    titleLabel.layer.masksToBounds = YES;

    
    CGRect rect = CGRectMake(0, 0, screenWidth, contentSize.height + 40);
    UIView *cellView = [[UIView alloc] initWithFrame:rect];
    cellView.frame = titleLabel.frame;
    [cellView addSubview:titleLabel];
    [cellView bringSubviewToFront:titleLabel];
    這行先comment掉，先不放圖在scrollView cell裡面
    [cellViewArray addObject:cellView];
 */
    // 用大頭針的id取出圖片
    
    pinImageArray = [pinImageDAO getAllImageByPinId:self.infoPin.pinId];
   
    // 如果資料庫裡有圖片，就拿出來用，如果沒有，就用預設的圖片
    if ([pinImageArray count] > 0) {
        for (PinImage *pinImg in pinImageArray) {
            UIImage *img = [[UIImage alloc] initWithData:pinImg.imageData];
//            CGRect imgRect = CGRectMake(20, 0, ceilf(screenWidth-40)/1, ceilf((img.size.height/img.size.width*(screenWidth-40)))/1);
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            //imgView.backgroundColor = [UIColor blueColor];
//            imgView.image = img;
            
//            CGRect iRect = CGRectMake(0, 0, screenWidth, ceilf((img.size.height/img.size.width*(screenWidth-40)))/1);
//            
//            UIView *view = [[UIView alloc] initWithFrame:iRect];
            //            NSLog(@"view.height = %f", view.frame.size.height);
            //            NSLog(@"view.width = %f", view.frame.size.width);
//            view.backgroundColor = [UIColor whiteColor];//
//            [view addSubview:imgView];
            //[cellViewArray addObject:view];
            [cellViewArray addObject:img];
        }
    } else {
        
        UIImage *img = [UIImage imageNamed:@"noimage.png"];

//        UIImageView *imgView = [[UIImageView alloc] init];
//        //NSLog(@"imageWidth= %f", testImage.frame.size.width);
//        
//        CGRect imgRect = CGRectMake(20, 0, ceilf(screenWidth-40)/1, ceilf((img.size.height/img.size.width*(screenWidth-40)))/1);
//        imgView = [[UIImageView alloc] initWithFrame:imgRect];
//        imgView.image = img;
        
        [cellViewArray addObject:img];
    }

//    UIImageView *img1 = cellViewArray[0];
    imgForNavigationBar = cellViewArray[0];
    
    NSLog(@"cellViewArray = %@", cellViewArray);
    
//    self.postedTitleLabel.numberOfLines = 0;
//    self.postedTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.postedTitleLabel.preferredMaxLayoutWidth = self.postedTitleLabel.frame.size.width;
    
    CGRect labelRect = CGRectMake(0, 0, screenWidth, 50);

    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    

    NSLog(@"postedDate= %@", self.infoPin.postedDate);
    NSLog(@"visitedDate= %@", self.infoPin.visitedDate);

    // NSString to NSDate
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSLog(@"visitedDate = %@", self.infoPin.visitedDate);
    
    NSMutableArray *memberInfoArray =[NSMutableArray new];
    
    
    //memberInfoArray = [friendDB SearchFriendList:self.infoPin.memberId];

    
    NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    
    NSLog(@"id%@, pin_id%@",self.infoPin.memberId,userID);
    
    NSString *memberIdString = [NSString stringWithFormat:@"%@",self.infoPin.memberId];
    
    NSString *memberName;
    if ([memberIdString isEqualToString:userID]) {
        memberInfoArray = [friendDB querymemberinfo:memberIdString];
        memberName = memberInfoArray[0][@"name"];

        NSLog(@"array = %@", memberInfoArray);
    }else{
        memberInfoArray = [friendDB SearchFriendList:self.infoPin.memberId];
        memberName = memberInfoArray[0][@"friendname"];

    }
    
    
    label.text = [NSString stringWithFormat:@"%@ 在想：\n  %@\n\n在%@", memberName, self.infoPin.title, [dateFormat stringFromDate:self.infoPin.postedDate]];
    

    CGSize maxSize2 = CGSizeMake(screenWidth-80, 999);
    NSString *contentString2 = label.text;
    UIFont *contentFont2 = label.font;
    CGRect contentFrame2;
    NSDictionary *contentDic2 = [NSDictionary dictionaryWithObjectsAndKeys:contentFont2, NSFontAttributeName, nil];
    CGSize contentSize2 = [contentString2 boundingRectWithSize:maxSize2
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:contentDic2
                                                     context:nil].size;
    contentFrame2 = CGRectMake(40, 20, screenWidth-80, contentSize2.height);
    label.frame = contentFrame2;
    
    label.backgroundColor = [UIColor whiteColor];//
    label.numberOfLines = 0;
    
    //下面為倒圓角要用的二行程式，也要#import <QuartzCore/QuartzCore.h>
    label.layer.cornerRadius = 7;
    label.layer.masksToBounds = YES;
    
    CGRect headerViewRect = CGRectMake(0, 0, screenWidth, contentSize2.height + 40);
    UIView *view = [[UIView alloc] initWithFrame:headerViewRect];
    view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];//
    [view addSubview:label];
    
    [self.tableView.tableHeaderView sizeToFit];
    self.tableView.tableHeaderView = view;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    
//    self.tableView.tableHeaderView = nil;
//    UIView *header = self.headerView;
//    CGRect frame = header.frame;
//    frame.size.width = self.tableView.frame.size.width;
//    header.frame =frame;
//    [header setNeedsLayout];
//    [header layoutIfNeeded];
//    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    CGRect headerFrame = header.frame;
//    headerFrame.size.height = height;
//    header.frame = headerFrame;
//    self.tableView.tableHeaderView = header;
    //self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //PinInfoTableViewController *pinInfoTableVC = [PinInfoTableViewController new];
//    CGRect headerViewRect = self.tableView.tableHeaderView.frame;
//    headerViewRect.size.height = 100;//self.postedTitleLabel.frame.size.height;
//    self.tableView.tableHeaderView.frame = headerViewRect;
//
//    CGRect headerViewRect = CGRectMake(0, 0, screenWidth, 100);
//    UIView *headerView = self.tableView.tableHeaderView;
//    headerView.frame = headerViewRect;
//    [self.tableView setTableHeaderView:nil];
//    self.tableView.tableHeaderView = headerView;
    
//    [self.tableView beginUpdates];
//    [self.tableView setTableHeaderView:headerView];
//    [self.tableView endUpdates];
//    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] initWithFrame:headerViewRect];
//    [self.tableView setTableHeaderView:header];
//    [self.tableView reloadData];
    
//    CGSize maxSize1 = CGSizeMake(screenWidth-80, 999);
//    NSString *contentString1 = self.postedTitleLabel.text;
//    UIFont *contentFont1 = self.postedTitleLabel.font;
//    CGRect contentFrame1;
//    NSDictionary *contentDic1 = [NSDictionary dictionaryWithObjectsAndKeys:contentFont1, NSFontAttributeName, nil];
//    CGSize contentSize1 = [contentString1 boundingRectWithSize:maxSize1
//                                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                                  attributes:contentDic1
//                                                     context:nil].size;
//    contentFrame1 = CGRectMake(40, 20, screenWidth-80, contentSize1.height + 40);
//    self.postedTitleLabel.frame = contentFrame1;
//    
//    self.postedTitleLabel.backgroundColor = [UIColor whiteColor];
//    self.postedTitleLabel.numberOfLines = 0;
    
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    CGRect frame = CGRectZero;
//    frame.size.width = self.tableView.bounds.size.width;
//    frame.size.height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    if (self.tableView.tableHeaderView != self.headerView || !CGRectEqualToRect(frame, self.headerView.frame)) {
//        self.headerView.frame = frame;
//        [self.headerView layoutIfNeeded];
//        self.tableView.tableHeaderView = self.headerView;
//    }

//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 本來是想辦法把navigation Bar消失的顏色加回來，但只能用image的方法加回來
    [self.navigationController.navigationBar setBackgroundImage:imgForNavigationBar forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = imageView.image;
    [self.navigationController.navigationBar setTranslucent:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)naviBtnAction:(id)sender {
//    CLGeocoder *geocoder = [CLGeocoder new];
//    CLPlacemark *placemark = [CLPlacemark new];
//    placemark.location.coordinate.latitude = self.infoPin.coordinate.latitude;
    MKPlacemark *targetPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.infoPin.coordinate addressDictionary:nil];
    MKMapItem *targetMapItem = [[MKMapItem alloc] initWithPlacemark:targetPlacemark];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    [targetMapItem openInMapsWithLaunchOptions:options];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [cellViewArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSLog(@"count:%d", [cellViewArray count]);
    //[cell prepareForReuse];
    
    // Configure the cell...
  
//    PinInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PinInfoTableViewCell class])];
    //PinInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PinInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    //CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    UIImage *cellImg = cellViewArray[indexPath.row];
//    CGRect imgRect = CGRectMake(0, 0, ceilf(screenWidth-20)/1, ceilf((cellImg.size.height/cellImg.size.width*(screenWidth-20)))/1);
//    cell.infoImageView.frame = imgRect;
    
    cell.infoImageView.image = cellImg;
    
    //[cell bringSubviewToFront:cell.infoImageView];
        if (cell == nil) {
            NSLog(@"cell == nil");
        }
    //UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
//    view = cellViewArray[indexPath.row];
//    [cell addSubview:view];
//    UIImageView *imgView = cellViewArray[indexPath.row];
//    imageView.image = imgView.image;
//    UIView * imageView = cellViewArray[indexPath.row];
//    [view addSubview:imageView];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    UIImageView *imageView = [UIImageView new];
//    imageView.image = cellViewArray[indexPath.row];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    NSLog(@"screenWidth = %f", screenWidth);
    UIImage *cellImg = cellViewArray[indexPath.row];
    return ceilf((cellImg.size.height/cellImg.size.width*(screenWidth)))/1-40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, tableView.frame.size.height)];
    NSString *string = @"testing";
    label.text = string;
    [view addSubview:label];
    return nil;
}

// 強制手機畫面不打橫
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
