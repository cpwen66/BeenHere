//
//  PinTableViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/6/23.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinTableViewController.h"
#import "PinDAO.h"
#import "Pin.h"
#import "PinImageDAO.h"
#import "PinImage.h"
//#import "PinTableViewCell.h"

@interface PinTableViewController ()<UITextViewDelegate>
{
    NSMutableArray *pinArray;
    NSMutableArray *pinImageArray;
    NSMutableArray *pinWithImageArray;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGSize labelViewSize;
    CGSize imageSize;
    
    NSString *labelViewString;
    NSString *textString;

}
@property (weak, nonatomic) IBOutlet UITextView *theTextView;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;


@end

@implementation PinTableViewController
- (void)textViewDidChange:(UITextView *)textView {
    
    textString = textView.text;
    [self.theTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _theTextView.delegate = self;
    
    //PinTableViewCell *pinCell = [PinTableViewCell new];
    textString = self.theTextView.text;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    pinWithImageArray = [NSMutableArray new];
    //從SQLite中取出大頭針的資料
    PinDAO *pinDAO = [[PinDAO alloc] init];
    //Pin *pin = [[Pin alloc] init];
    
    PinImageDAO *pinImageDAO = [[PinImageDAO alloc] init];
    PinImage *pinImage =[[PinImage alloc] init];
    
    pinArray = [pinDAO getAllPin];
    
    
    //組合新的Array, 如[[pin1, image1], [pin2, image2], ...]
    for (Pin *pin in pinArray) {
        NSLog(@"pin latitude: %f", pin.coordinate.latitude);
        //[pinIdArray addObject:pin.pinId];
        
        NSMutableArray *ary = [NSMutableArray new];
        [ary addObject:pin];
        // 如果有屬於某pinId的圖就..., 就從資料庫中拿第一張圖出來
        NSLog(@"arraySize= %lu", (unsigned long)[[pinImageDAO getAllImageByPinId:pin.pinId] count]);
        if ([[pinImageDAO getAllImageByPinId:pin.pinId] count] != 0) {
            
            //以pinId到資料庫中拿圖出來, 可能有很多筆資料，所以只取第一筆
            pinImage = [pinImageDAO getAllImageByPinId:pin.pinId][0];
            NSLog(@"pinImage: %@", pinImage);

            NSData *data = pinImage.imageData;
            //把第一筆資料的圖放進ary陣列的第二個元素
            [ary addObject:data];

        }
        // 把小陣列而放進大陣列，大陣列準備餵給tableView的
        [pinWithImageArray addObject:ary];
        NSLog(@"Ary: %@", ary);
        NSLog(@"Array: %@", pinWithImageArray);

        
    }
    

}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [pinWithImageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:200];
    imageSize = imageView.frame.size;
    
    UILabel *pinTitleLabel = (UILabel *)[cell viewWithTag:100];
    
    //設定label 的尺寸會隨字數增加而增加
    pinTitleLabel.numberOfLines = 0;
    pinTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    pinTitleLabel.font = [UIFont systemFontOfSize:14];
    NSString *text = self.theTextView.text;
    [pinTitleLabel sizeToFit];
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    // ceilf(x)是取大於或等於x的最小整數
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    CGFloat height = MAX(adjustedSize.height, 20.0f);
    [pinTitleLabel setFrame:CGRectMake(10, 10, 320- (10*2), MAX(height, 10))];
    
    //Pin *pin = [pinWithImageArray objectAtIndex:indexPath.row][0];
    //pinTitleLabel.text = pin.title;

    
    NSLog(@"pinTitleLabelHeight = %f", pinTitleLabel.frame.size.height);

    pinTitleLabel.text = textString;
    //labelViewString = pinTitleLabel.text;
    labelViewSize = pinTitleLabel.frame.size;
    
    if ([[pinWithImageArray objectAtIndex:indexPath.row] count] == 2) {
        NSMutableArray *ary = [NSMutableArray new];
        ary = [pinWithImageArray objectAtIndex:indexPath.row];
        NSMutableData *data = [NSMutableData new];
        data = ary[1];
        NSLog(@"data = %@", data);
        imageView.image = [UIImage imageWithData:data];
        
        
        //imageView.image = [UIImage imageWithData:[pinWithImageArray objectAtIndex:indexPath.row][1]];
    }
    
    return cell;
}

// 這個方法比heightForRowAtIndexPath:較節省資源，有更好的使用者體驗
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"labelHeight = %f", labelViewSize.height);
    
    // this method is called for each cell and returns height
    //labelViewString = @"Your very long text";
    
    NSString *text = self.theTextView.text;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    CGFloat height = MAX(adjustedSize.height, 20.0f);
    return height + (10 * 2)+150;
    //return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"labelHeight = %f", labelViewSize.height);
    
    // this method is called for each cell and returns height
    //labelViewString = @"Your very long text";
    
    NSString *text = self.theTextView.text;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    CGFloat height = MAX(adjustedSize.height, 20.0f);
    
    //return height + (10 * 2)+150;
    return UITableViewAutomaticDimension;

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
