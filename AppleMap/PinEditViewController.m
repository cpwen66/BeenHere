//
//  PinEditViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/6/24.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinEditViewController.h"
//#import "PinEditToolViewController.h"
#import "PinDAO.h"
#import "Pin.h"
#import "PinImage.h"
#import "PinImageDAO.h"
#import <AssetsLibrary/AssetsLibrary.h>

CGFloat const TEXT_MARGIN_IN_CELL = 20.0;

@interface PinEditViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    CGFloat titleTextViewHeight;
    int imageIndex;
    CGFloat scrollViewWidth;
    CGFloat contentWidth;
    CGFloat imagePosition;
    CGFloat newViewHeight;
    BOOL isFirstViewDidAppear;
    
    PinDAO *pinDAO;
    PinImageDAO *pinImageDAO;
    PinImage *pinImage;
    NSMutableArray *theSubViews;
    UITextView *titleTextView;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
//@property (weak, nonatomic) IBOutlet UIView *toolContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewBottomLayoutConstraint;

@end

@implementation PinEditViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.childViewControllers.
    
    imageIndex = 0;
    isFirstViewDidAppear = YES;
    
    Pin *pin = [[Pin alloc] init];
    pin.memberId = @"3";
    
    
    pinDAO = [[PinDAO alloc] init];
    NSMutableArray *rows = [pinDAO getAllPin];
    //NSLog(@"rows= %@", rows);
    
    pinImage = [[PinImage alloc] init];
    pinImageDAO = [[PinImageDAO alloc] init];
    

    // 監聽keyboard的動作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 替scrollView加上手勢
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // 下一行self.myScrollView改成self.view也可以
    [self.theScrollView addGestureRecognizer:tapGesture];
    
    //self.theScrollView.backgroundColor = [UIColor redColor];
    

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //取得scrollView的尺寸
    scrollViewWidth = self.theScrollView.frame.size.width;
    //CGFloat scrollViewHeight = self.theScrollView.frame.size.height;
    
    //NSLog(@"scrollView width= %f, height= %f", scrollViewWidth, scrollViewHeight);
    
    // 需要用到layout尺寸的程式不能放在viewDidLoad，因為那時候Layout還沒準備好，數值會是在XCode的預設值
    // 這裡我只要進來一次，產生一個titleTextView就好，不然每次進到viewDidAppear都會產生一個textView
    if (isFirstViewDidAppear) {
        // by code 產生textView
        CGRect textRect = CGRectMake(TEXT_MARGIN_IN_CELL, TEXT_MARGIN_IN_CELL, scrollViewWidth-2*TEXT_MARGIN_IN_CELL, 80);
        titleTextView = [[UITextView alloc] initWithFrame:textRect];
        titleTextView.text = @"這行要移掉";
        
        [titleTextView setFont:[UIFont systemFontOfSize:14]];
        [self.theScrollView addSubview:titleTextView];
        
        titleTextViewHeight = titleTextView.frame.size.height;
        
        isFirstViewDidAppear = false;
    }

    float sizeOfContent = 0;
    UIView *lastView = [self.theScrollView.subviews lastObject];
    NSInteger lastOriginY = lastView.frame.origin.y;
    NSInteger lastSizeHight = lastView.frame.size.height;
    sizeOfContent = lastOriginY + lastSizeHight;
    self.theScrollView.contentSize = CGSizeMake(scrollViewWidth-2*TEXT_MARGIN_IN_CELL, sizeOfContent);
    
    contentWidth = self.theScrollView.contentSize.width;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareToFriendBtnAction:(id)sender {
    //NSLog(@"contentView Width = %f, Height = %f", self.theScrollView.contentSize.width, self.theScrollView.contentSize.height);
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"screen width= %f, height= %f", screenWidth, screenHeight);
    
    
}

- (IBAction)takePictureBtnAction:(id)sender {
    
    // 設定值
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerController.mediaTypes = @[@"public.image"];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)donePostPinBtnAction:(id)sender {
    
    // 先練習只存到SQLite, 之後要改先上傳到server，之後再下載pinId
    // 先存Pin到SQLite
    self.currentPin.title = titleTextView.text;
    NSLog(@"self.currentPin.coordinate.latitude = %f", self.currentPin.coordinate.latitude);
    NSLog(@"self.currentPin.coordinate.longitude = %f", self.currentPin.coordinate.longitude);
    pinDAO = [[PinDAO alloc] init];
    [pinDAO insertPinIntoSQLite:self.currentPin];
    
    // 再把PinId取出來
    NSLog(@"lastPinId = %@", [pinDAO getLastPinId]);
    
    // 將PinId給image，把圖片存到SQLite
    NSMutableArray *ary = [NSMutableArray new];
    NSLog(@"self.theScrollView.subviews = %@", self.theScrollView.subviews);
    
    // 把scrollView裡的圖片，取出來放到另一個陣列
    for (UIView *view in self.theScrollView.subviews) {
        NSLog(@"self.theScrollView.subviews view = %@", view);

        if ([view isMemberOfClass:UIView.class]) {
            UIImageView *imageView = view.subviews[0];
            
            [ary addObject:imageView.image];
            NSLog(@"1234view = %@", view.subviews);
        }
    }
    NSLog(@"ary[0] = %@", ary[0]);
    NSLog(@"self.theScrollView.subviews = %@", self.theScrollView.subviews);
    PinImage *newPinImage = [[PinImage alloc] init];
    
    // 這裡只有先存一張圖，之後要加迴圈，存全部的圖
    newPinImage.imageData = UIImageJPEGRepresentation(ary[0], 1);
    newPinImage.pinId = [pinDAO getLastPinId];
    [pinImageDAO insertImageIntoSQLite:newPinImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}



// Called when the UIKeyboardDidShowNotification is sent.
// keyboard跳出來之後會進到這個方法
- (void)keyboardWillShow: (NSNotification *) aNotification {
    NSValue *value = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = value.CGRectValue.size;
    self.toolViewBottomLayoutConstraint.constant = keyboardSize.height;
}

- (void)keyboardWillHide: (NSNotification *) aNotification {
   self.toolViewBottomLayoutConstraint.constant = 0;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"shouldEnd");
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"didEnd");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touched");
}

// 要加<UIScrollViewDelegate>，才有此方法
// 如果scrollView被滑動，就會進入此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    //NSLog(@"contentOffset = %f", scrollView.contentOffset.x);
}

// 自訂方法，當使用者按下背景就進到這裡
- (void) hideKeyboard {
    
    //撤self.view下的keyboard
    [self.view endEditing:YES];
}

// 自訂的類別方法，.h還有宣告的內容
// 從網路上找的可縮圖的程式，
+ (UIImage *)imageWithiamge:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//使用此方法，需<UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    //回到原來的view
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];//editedImage是nil
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:originalImage];

    // 取大於等於的值
    newViewHeight = ceilf(imageView.frame.size.height * contentWidth / imageView.frame.size.width);
    CGSize decreasedImageSize = CGSizeMake(contentWidth, newViewHeight);
    
    // 呼叫自訂的縮圖程式
    UIImage *decreasedImage = [PinEditViewController imageWithiamge:originalImage scaledToSize:decreasedImageSize];
    
    // 重設CGRect及image
    [imageView setFrame:CGRectMake(0, 0, contentWidth, newViewHeight)];
    imageView.image = decreasedImage;
    NSLog(@"imageView height =%f, width = %f", imageView.frame.size.height, imageView.frame.size.width);

    
    
    // 建立空白的UIView
    imagePosition = TEXT_MARGIN_IN_CELL + titleTextViewHeight + 20 + (20 + newViewHeight) * imageIndex;
    CGRect newViewRect = CGRectMake(20, imagePosition, contentWidth, newViewHeight);
    UIView *newView = [[UIView alloc]initWithFrame:newViewRect];
    newView.backgroundColor = [UIColor blueColor];
    // 建立imageView，準備放進空白View
    
//    CGRect imageRect = CGRectMake(0, 0, 200, 300);
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
//    imageView.image = originalImage;
    
    //NSLog(@"imageView width = %f, height = %f", imageView.frame.size.width, imageView.frame.size.height);
    
    
    [newView addSubview:imageView];
    
    
    
    CGRect buttonRect = CGRectMake(contentWidth-20, 10, 20, 20);
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:buttonRect];
    [deleteButton setTitle:@"X" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newView addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    //[deleteButton targetForAction:@selector(deleteImage:) withSender:@""];
    
    self.theScrollView.contentSize = CGSizeMake(contentWidth, 1000);
    
    [self.theScrollView addSubview:newView];
    

    
    imageIndex++;
    
    //NSLog(@"info: %@", info);
    //NSLog(@"editedImage: %@", editedImage);
    //NSLog(@"originalImage: %@", originalImage);
    
    //用ALAssetsLibrary，要先#import <AssetsLibrary/AssetsLibrary.h>
    //利用ALAssetsLibrary存取照片
    //provides access to the videos and photos that are under the control of the Photos application.
//    ALAssetsLibrary *library = [ALAssetsLibrary new];
//    [library writeImageToSavedPhotosAlbum:originalImage.CGImage
//                              orientation:(ALAssetOrientation)originalImage.imageOrientation
//                          completionBlock:^(NSURL *assetURL, NSError *error) {
//                              NSString *message = nil;
//                              if (error)
//                                  message = error.localizedDescription;
//                              else
//                                  message = @"Saved OK.";
//                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                              [alertView show];
//                          }];
}

- (void)deleteImage:(UIButton *)sender {
    NSLog(@"sender's superView= %@", sender.superview);
    NSLog(@"description = %@", self.theScrollView.subviews.description);
    
    // 先把所有subView另存一份起來
    theSubViews = [NSMutableArray new];


    // 如果按鈕是被包在空白的UIView裡面的
    if ([self.theScrollView.subviews containsObject:sender.superview]) {
        // 就去把它取出來
        NSInteger indexOfSubview = [self.theScrollView.subviews indexOfObject:sender.superview];
     
        // 將準備要被刪除的subView之後的subView先存一份並刪除
        for (NSInteger i=([self.theScrollView.subviews count]-1); i>=(indexOfSubview+1); i--) {
            
            // iOS會在scrollView裡面加奇怪的UIImageView，這裡加isKindOfClass是為了閃開以避免拿到不對的view
            if (![self.theScrollView.subviews[i] isKindOfClass:UIImageView.class]) {
                [theSubViews addObject:self.theScrollView.subviews[i]];
                [self.theScrollView.subviews[i] removeFromSuperview];

            }
        }
        
        // 先記下準備要被刪除的subView的長度，等下要將其他UIView的位置扣掉它的長度重新算位置
        UIView *tempView = self.theScrollView.subviews[indexOfSubview];
        UIImageView *tempImageView = tempView.subviews[0];
        CGFloat tempImageHeight = tempImageView.frame.size.height;
        
        NSLog(@"theSubViewsDescription = %@", theSubViews.description);

        // 修改已保留的subView在self.theScrollView中出現的位置
        for (UIView *subView in theSubViews) {
            NSLog(@"subView = %@", subView);
            NSLog(@"subView = %f", subView.frame.origin.y);

            // 重新修改位置
            CGRect svRect = subView.frame;
            svRect.origin.y = svRect.origin.y - tempImageHeight - TEXT_MARGIN_IN_CELL;
            subView.frame = svRect;
            
        }
        
        // 刪除目標(subView)
        [self.theScrollView.subviews[indexOfSubview] removeFromSuperview];
        
        
        // 把subView加回到scrollView中
        // 因為之前是從陣列後面取出的，現在也要從暫存陣列的後面取出再存入scrollView，
        // 再次從theSubViews時的判斷會出錯
        for (int i=([theSubViews count]-1); i>=0; i--) {
            [self.theScrollView addSubview:theSubViews[i]];

        }
        
        // 位置的邏輯還要重新思考，這裡只是暫時用補償的，式子後面的-1
        imageIndex--;
        imagePosition = TEXT_MARGIN_IN_CELL + titleTextViewHeight + 20 + (20 + tempImageHeight) * (imageIndex-1);
        [self viewDidLayoutSubviews];

    }
    
}

// iOS內定的方法，更改layout必須經過這個方法去實作
// Your view controller can override this method to make changes after the view lays out its subviews.
// The default implementation of this method does nothing.
- (void)viewDidLayoutSubviews {
    self.theScrollView.contentSize = CGSizeMake(contentWidth, imagePosition + newViewHeight);

}


// 強制手機畫面不打橫
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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