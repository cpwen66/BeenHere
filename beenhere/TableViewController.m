//
//  TableViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/30.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIViewController * account = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
    
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
//                     [self presentViewController:account animated:true completion:nil];
                    
                     [self.navigationController pushViewController:account animated:YES];
                    
                    //傳陣列資料過去
 
                    break;
                    
                default:
                    break;
                           }
             
            
            
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    //                     [self presentViewController:account animated:true completion:nil];
                    
                    [self.navigationController pushViewController:account animated:YES];
                    
                    //傳陣列資料過去
                    
                    break;
                case 1:
                    
                    
                    break;
                 case 2:
                    
                    [self removeuserdefult];
                    break;
                    
                    
                default:
                    break;
            }
            
            
            
            break;
        case 0:
            switch (indexPath.row) {
                case 0:
                    //                     [self presentViewController:account animated:true completion:nil];
                    
                    [self.navigationController pushViewController:account animated:YES];
                    
                    //傳陣列資料過去
                    
                    break;
                    
                default:
                    break;
            }
            
            
            
            break;

            
            
            
        default:
            break;
    }
    
    
   
    }




-(void)removeuserdefult{

    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:@"確定登出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bhereID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bherePassword"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bhereEmail"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIViewController *firstview = [self.storyboard instantiateViewControllerWithIdentifier:@"firstview"];
        //        [self showViewController:cameraVC sender:self];
        [self presentViewController:firstview animated:YES completion:nil];
        
        
    }];
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        
        
    }];
    [alertcontroller addAction:ok];
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];


    

    


}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
}


@end
