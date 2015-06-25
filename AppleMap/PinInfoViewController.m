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


@interface PinInfoViewController ()
{
    NSMutableArray *pinArray;
    NSMutableArray *pinImageArray;
}
@end

@implementation PinInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PinDAO *pinDAO = [[PinDAO alloc] init];
    Pin *pin = [[Pin alloc] init];
    pinArray = [pinDAO getAllPin];
    
    for (pin in pinArray) {
        NSLog(@"pin latitude: %f", pin.coordinate.latitude);
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
