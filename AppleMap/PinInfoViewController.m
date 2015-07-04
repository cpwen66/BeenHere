//
//  PinInfoViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinInfoViewController.h"
#import "PinDAO.h"
#import "Pin.h"
#import "PinImageDAO.h"
#import "PinImage.h"
#import <QuartzCore/QuartzCore.h>

// 重要：因為tableView在這個例子只是IBOutlet，所以要在storyboard的tableView上按右鍵，
// 將dataSource拉到viewController(黃點)，不然tableView不會動作
@interface PinInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *pinArray;
    NSMutableArray *pinImageArray;
    NSMutableArray *pinWithImageArray;
    UILabel *titleLabel;
    NSMutableArray *cellViewArray;
}
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;


@end

@implementation PinInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.infoTableView.delegate = self;
    self.infoTableView.allowsSelection = NO;// 讓使用者對tableView的點擊無效
    
    //[self.infoTableView reloadData];
    
    cellViewArray = [NSMutableArray new];
    titleLabel = [UILabel new];
    
    PinImageDAO *pinImageDAO = [[PinImageDAO alloc] init];
    PinImage *pinImage = [[PinImage alloc] init];

    titleLabel.text = self.infoPin.title;
    
    // 上面要先拿到label的文字，下面是要算label的高度
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"screen width= %f, height= %f", screenWidth, screenHeight);
    
    CGFloat tableViewWidth = self.infoTableView.frame.size.width;
    CGFloat tableViewHeight = self.infoTableView.frame.size.height;

    CGSize maxSize = CGSizeMake(screenWidth-80, 999);
    NSString *contentString = titleLabel.text;
    UIFont *contentFont = titleLabel.font;
    CGRect contentFrame;
    NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:contentFont, NSFontAttributeName, nil];
    CGSize contentSize = [contentString boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:contentDic
                                                     context:nil].size;
    contentFrame = CGRectMake(40, 20, screenWidth-80, contentSize.height);
    titleLabel.frame = contentFrame;
    
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    
    //下面為倒圓角要用的二行程式，也要#import <QuartzCore/QuartzCore.h>
    titleLabel.layer.cornerRadius = 7;
    titleLabel.layer.masksToBounds = YES;

    UIView *cellView = [[UIView alloc] initWithFrame:titleLabel.frame];
    //cellView.frame = titleLabel.frame;
    [cellView addSubview:titleLabel];
    [cellView bringSubviewToFront:titleLabel];
    [cellViewArray addObject:cellView];
    
    
    // 用大頭針的id取出圖片
    
    pinImageArray = [pinImageDAO getAllImageByPinId:self.infoPin.pinId];

 
    // 如果資料庫裡有圖片，就拿出來用，如果沒有，就用預設的圖片
    if ([pinImageArray count] > 0) {
        for (PinImage *pinImg in pinImageArray) {
            UIImage *img = [[UIImage alloc] initWithData:pinImg.imageData];
            CGRect imgRect = CGRectMake(0, 0, ceilf(screenWidth-80)/1, ceilf((img.size.height/img.size.width*(screenWidth-80)))/1);
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgRect];
            imgView.image = img;

            UIView *view = [[UIView alloc] initWithFrame:imgView.frame];
//            NSLog(@"view.height = %f", view.frame.size.height);
//            NSLog(@"view.width = %f", view.frame.size.width);

            [view addSubview:imgView];
            [cellViewArray addObject:view];
        }
    } else {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat2.jpg"]];
        //NSLog(@"imageWidth= %f", testImage.frame.size.width);
        UIView *view = [[UIView alloc] initWithFrame:imgView.frame];
        [view addSubview:imgView];
        [cellViewArray addObject:view];
    }

    NSLog(@"cellViewArray = %@", cellViewArray);
    NSLog(@"cellViewArray = %@", cellViewArray);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 /*
    pinWithImageArray = [NSMutableArray new];
    
    //從SQLite中取出大頭針的資料
    
    PinImageDAO *pinImageDAO = [[PinImageDAO alloc] init];
    PinImage *pinImage =[[PinImage alloc] init];
    
    // index 0先放大頭針的資料
    [pinWithImageArray addObject:self.infoPin];
    
    
    // 用大頭針的id取出圖片
    pinImageArray = [pinImageDAO getAllImageByPinId:self.infoPin.pinId];
    //NSLog(@"pinImageArray: %@", pinImageArray);

    // 如果資料庫裡有圖片，就拿出來用，如果沒有，就用預設的圖片
    if ([pinImageArray count] > 0) {
        for (pinImage in pinImageArray) {
            [pinWithImageArray addObject:pinImage];
        }
    } else {
        //PinImage *pinImg = [[PinImage alloc] init];
        UIImage *img = [UIImage imageNamed:@"cat2.jpg"];
        pinImage.imageData = UIImageJPEGRepresentation(img, 1);
        [pinWithImageArray addObject:pinImage];
    }

*/
    //[pinWithImageArray arrayByAddingObjectsFromArray:pinImageArray];
    //NSLog(@"pinWithImageArray: %@, count=%d", pinWithImageArray, [pinWithImageArray count]);

    
     
    //組合新的Array, 如[[pin1, image1], [pin2, image2], ...]
//    for (Pin *pin in pinArray) {
//        NSLog(@"pin latitude: %f", pin.coordinate.latitude);
//        //[pinIdArray addObject:pin.pinId];
//        
//        NSMutableArray *ary = [NSMutableArray new];
//        [ary addObject:pin];
//        // 如果有屬於某pinId的圖就..., 就從資料庫中拿第一張圖出來
//        NSLog(@"arraySize= %lu", (unsigned long)[[pinImageDAO getAllImageByPinId:pin.pinId] count]);
//        if ([[pinImageDAO getAllImageByPinId:pin.pinId] count] != 0) {
//            
//            //以pinId到資料庫中拿圖出來, 可能有很多筆資料，所以只取第一筆
//            pinImage = [pinImageDAO getAllImageByPinId:pin.pinId][0];
//            NSLog(@"pinImage: %@", pinImage);
//            
//            NSData *data = pinImage.imageData;
//            //把第一筆資料的圖放進ary陣列的第二個元素
//            [ary addObject:data];
//            
//        }
//        // 把小陣列而放進大陣列，大陣列準備餵給tableView的
//        [pinWithImageArray addObject:ary];
//        NSLog(@"Ary: %@", ary);
    
        
        
//    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSLog(@"cellViewArray count =%d", [cellViewArray count]);
    return [cellViewArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //[cell.contentView addSubview:cellViewArray[indexPath.row]];
    // Configure the cell...
    //[cell addSubview:cellViewArray[indexPath.row]];
    UIView *view = (UIView *)[cell viewWithTag:100];
    view = cellViewArray[indexPath.row];
    NSLog(@"cellViewArray count =%d", [cellViewArray count]);

 /*
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:200];
    //NSLog(@"pinWithImageArray = %@", pinWithImageArray);
    
    NSLog(@"indexPath = %ld", (long)indexPath.item);// 如果陣列中的元素是Pin就進入...
    NSLog(@"indexPath.description = %@", indexPath.description);// 如果陣列中的元素是Pin就進入...

    //if (indexPath.item == 0) {
    if ([pinWithImageArray[indexPath.row] isMemberOfClass:Pin.class]) {
  
        
        CGFloat tableViewWidth = self.infoTableView.frame.size.width;

        titleLabel = [[UILabel alloc]init];
        Pin *pin = pinWithImageArray[indexPath.row];
        titleLabel.text = [NSString stringWithFormat:@"%@: %@",pin.pinId, pin.title];

        // 上面要先拿到label的文字，下面是要算label的高度
        CGSize maxSize = CGSizeMake(tableViewWidth-80, 999);
        NSString *contentString = titleLabel.text;
        UIFont *contentFont = titleLabel.font;
        CGRect contentFrame;
        NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:contentFont, NSFontAttributeName, nil];
        CGSize contentSize = [contentString boundingRectWithSize:maxSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:contentDic
                                                         context:nil].size;
        contentFrame = CGRectMake(40, 20, tableViewWidth-80, contentSize.height);
        titleLabel.frame = contentFrame;
        
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;

        //下面為倒圓角要用的二行程式，也要#import <QuartzCore/QuartzCore.h>
        titleLabel.layer.cornerRadius = 7;
        titleLabel.layer.masksToBounds = YES;
       
        [cell addSubview:titleLabel];

    } else if ([pinWithImageArray[indexPath.row] isMemberOfClass:PinImage.class]) {
//    } else {
        PinImage *pinImage = pinWithImageArray[indexPath.row];
        
        imageView.image = [[UIImage alloc] initWithData:pinImage.imageData];
    }
 */
     return cell;
    
//    imageSize = imageView.frame.size;
//    
//    UILabel *pinTitleLabel = (UILabel *)[cell viewWithTag:100];
//    
//    //設定label 的尺寸會隨字數增加而增加
//    pinTitleLabel.numberOfLines = 0;
//    pinTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    pinTitleLabel.font = [UIFont systemFontOfSize:14];
//    NSString *text = self.theTextView.text;
//    [pinTitleLabel sizeToFit];
//    
//    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
//
//    // Values are fractional -- you should take the ceilf to get equivalent values
//    // ceilf(x)是取大於或等於x的最小整數
//    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
//    
//    CGFloat height = MAX(adjustedSize.height, 20.0f);
//    [pinTitleLabel setFrame:CGRectMake(10, 10, 320- (10*2), MAX(height, 10))];
//    
//    //Pin *pin = [pinWithImageArray objectAtIndex:indexPath.row][0];
//    //pinTitleLabel.text = pin.title;
//    
//    
//    NSLog(@"pinTitleLabelHeight = %f", pinTitleLabel.frame.size.height);
//    
//    pinTitleLabel.text = textString;
//    //labelViewString = pinTitleLabel.text;
//    labelViewSize = pinTitleLabel.frame.size;
//    
//    if ([[pinWithImageArray objectAtIndex:indexPath.row] count] == 2) {
//        NSMutableArray *ary = [NSMutableArray new];
//        ary = [pinWithImageArray objectAtIndex:indexPath.row];
//        NSMutableData *data = [NSMutableData new];
//        data = ary[1];
//        NSLog(@"data = %@", data);
//        imageView.image = [UIImage imageWithData:data];
//        
//        
//        //imageView.image = [UIImage imageWithData:[pinWithImageArray objectAtIndex:indexPath.row][1]];
//    }
    
   
}

// 這個方法比heightForRowAtIndexPath:較節省資源，有更好的使用者體驗
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSLog(@"labelHeight = %f", labelViewSize.height);
//    
//    // this method is called for each cell and returns height
//    //labelViewString = @"Your very long text";
//    
//    NSString *text = self.theTextView.text;
//    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
//    
//    // Values are fractional -- you should take the ceilf to get equivalent values
//    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
//    
//    CGFloat height = MAX(adjustedSize.height, 20.0f);
//    return height + (10 * 2)+150;
//    //return UITableViewAutomaticDimension;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [UIView new];
    view = cellViewArray[indexPath.row];
    
    //return 340;
    return view.frame.size.height;
/*
    if ([pinWithImageArray[indexPath.row] isMemberOfClass:Pin.class]) {
        
        return titleLabel.frame.size.height + 40;
        
    } else if ([pinWithImageArray[indexPath.row] isMemberOfClass:PinImage.class]) {
        
        CGFloat tableViewWidth = self.infoTableView.frame.size.width;
        //CGFloat tableViewHeight = self.infoTableView.frame.size.height;
        
        PinImage *pinImage = pinWithImageArray[indexPath.row];
        UIImage *image = [[UIImage alloc] initWithData:pinImage.imageData];
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        
        return (tableViewWidth/imageWidth*imageHeight + 20);

    } else {
        return self.infoTableView.frame.size.height + 20;
    }
  */
}






//    NSLog(@"labelHeight = %f", labelViewSize.height);
    
    // this method is called for each cell and returns height
    //labelViewString = @"Your very long text";
    
//    NSString *text = self.theTextView.text;
//    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
//    
//    // Values are fractional -- you should take the ceilf to get equivalent values
//    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
//    
//    CGFloat height = MAX(adjustedSize.height, 20.0f);
//    
//    //return height + (10 * 2)+150;
//    return UITableViewAutomaticDimension;
    



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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
