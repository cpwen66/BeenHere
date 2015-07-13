//
//  AppleMapViewController.h
//  beenhere
//
//  Created by CP Wen on 2015/6/22.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol updatePinDistanceDelegate <NSObject>
//
//@optional
//-(void) dealPinDistance:(NSMutableDictionary *)pinDistanceDict;
//@end

@interface AppleMapViewController : UIViewController

//@property (weak, nonatomic) id<updatePinDistanceDelegate> delegate;
//- (void) updatePinDistance;

- (void) reloadAllPins;
-(void)reloadAllPinsNotif ;

@end
