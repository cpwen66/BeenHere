//
//  PinEditTableViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/6/27.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinEditTableViewController.h"
//#import "PinEditTableViewCell.h"
#import "PinImageDetailViewController.h"

CGFloat const TEXT_MARGIN_IN_CELL1 = 20.0;


@interface PinEditTableViewController ()
{
    NSMutableArray *pinWithImageArray;
    NSArray *pinWithImageArray1;
}
@end

@implementation PinEditTableViewController

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.clearsSelectionOnViewWillAppear = NO;
//        self.preferredContentSize = CGSizeMake(320.0, 600.0);
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    pinWithImageArray1 = @[@"pointRed.png",@"cat1.jpg",@"cat2.jpg",
                           @"cat3.jpg",@"cat4.jpg",@"cat5.jpg",@"cat6.jpg",
                           @"cat7.jpg",@"cat8.jpg",@"cat9.jpg",@"cat10.jpg"];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(postPin)];
    self.navigationItem.rightBarButtonItem = addButton;
//
//    self.detailViewController = (PinImageDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postPin {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [pinWithImageArray1 count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    // 實驗性的取得手機螢幕的尺寸
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"screen width= %f, height= %f", screenWidth, screenHeight);
    
    //實驗性的取得scrollView的尺寸
    CGFloat contentViewWidth = cell.contentView.frame.size.width;
    CGFloat contentViewHeight = cell.contentView.frame.size.height;
    NSLog(@"contentView width= %f, height= %f", contentViewWidth, contentViewHeight);

    // 跳過第一張圖，因為第一張圖是用來製造空白
    if (indexPath.row != 0) {
    
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
        [imageView setImage:[UIImage imageNamed:pinWithImageArray1[indexPath.row]]];
        
        CGRect textRect = CGRectMake(contentViewWidth-TEXT_MARGIN_IN_CELL1-20, TEXT_MARGIN_IN_CELL1, 20, 20);
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:textRect];
        [deleteButton setTitle:@"X" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        //deleteButton.backgroundColor = [UIColor blueColor];
        [cell addSubview:deleteButton];
        [deleteButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        CGRect textRect = CGRectMake(TEXT_MARGIN_IN_CELL1, TEXT_MARGIN_IN_CELL1, contentViewWidth-2*TEXT_MARGIN_IN_CELL1, contentViewHeight-2*TEXT_MARGIN_IN_CELL1);
        UITextView *titleTextView = [[UITextView alloc] initWithFrame:textRect];
        titleTextView.text = @"dfjalskdjfalsdjfalkdsjfalksdjfalksdjfwofjlkdjalkdjf";
        titleTextView.backgroundColor = [UIColor grayColor];
        [cell addSubview:titleTextView];
    //UITextView *titleTextView = (UITextView *)[cell viewWithTag:200];

    }
    //UIImage *image = [UIImage imageNamed:pinWithImageArray1[indexPath.row]];
    //[cell.imageView setImage:image];
    
    return cell;
}
- (void)deleteImage {
    
}


// 在table上出現的Section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
