//
//  SideBarTableViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/7/3.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "SideBarTableViewController.h"

@interface SideBarTableViewController ()
{
    NSArray *menuItems;
    UIImageView *myPinCheckmark;
}

@end

@implementation SideBarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuItems = @[@"pinList", @"map", @"takeapicture", @"setting", @"sorting"];
    
    self.preference = [NSUserDefaults standardUserDefaults];
    
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
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...

//    myPinCheckmark = [UIImageView new];
//    if ([cell.reuseIdentifier isEqualToString:@"mypin"]) {
//        NSLog(@"mypin");
//        myPinCheckmark = (UIImageView *)[cell viewWithTag:2];
//        myPinCheckmark.image = [UIImage imageNamed:@"menu.png"];
//        myPinCheckmark.alpha = 0;
//    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case 2:
//            if ( myPinCheckmark.alpha >= 0.5) {
//                myPinCheckmark.alpha = 0;
//            } else {
//                myPinCheckmark.alpha = 1;
//            }
            //myPinCheckmark.alpha >= 0.5 ? myPinCheckmark.alpha = 0 : myPinCheckmark.alpha = 0 ;
//            NSLog(@"alpha=%f", myPinCheckmark.alpha);
        

//}
    
    NSLog(@"indexPath=%d", [indexPath row]);
//    switch (indexPath.row) {
//            case 2:
//            if ([[self.preference valueForKey:@"pinOwner"] isEqualToString:@"friendsPin"]) {
//                [self.preference setValue:@"allPin" forKey:@"pinOwner"];
//            } else {
//                [self.preference setValue:@"myPin" forKey:@"pinOwner"];
//            }
//            case 3:
//            [self.preference setValue:@"friendsPin" forKey:@"pinOwner"];
//    }
    //[tableView reloadData];
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
