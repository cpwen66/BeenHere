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

@interface PinTableViewController ()
{
    NSMutableArray *pinArray;
    NSMutableArray *pinImageArray;
}


@end

@implementation PinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    PinDAO *pinDAO = [[PinDAO alloc] init];
    //Pin *pin = [[Pin alloc] init];
    pinArray = [pinDAO getAllPin];
    
    for (Pin *pin in pinArray) {
        NSLog(@"pin latitude: %f", pin.coordinate.latitude);
    }
    
    PinImageDAO *pinImageDAO = [[PinImageDAO alloc] init];
    PinImage *pinImage =[[PinImage alloc] init];
    pinImageArray = [pinImageDAO getAllImageByPinId:@"1"];
    for (pinImage in pinImageArray) {
        NSLog(@"ImageId = %@", pinImage.imageId);
    }
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
    return [pinArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *pinTitleLabel = (UILabel *)[cell viewWithTag:100];
    Pin *pin = [pinArray objectAtIndex:indexPath.row];
    pinTitleLabel.text = pin.title;
    
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
