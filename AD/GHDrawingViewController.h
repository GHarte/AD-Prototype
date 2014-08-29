//
//  GHDrawingViewController.h
//  AD
//
//  Created by Gareth Harte on 29/01/2014.
//  Copyright (c) 2014 Gareth Harte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHDrawSettingsViewController.h"
#import "GKImagePicker.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface GHDrawingViewController : UIViewController <GHDrawSettingsViewControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GKImagePickerDelegate, MFMailComposeViewControllerDelegate>{
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat tempRed;
    CGFloat tempGreen;
    CGFloat tempBlue;
    CGFloat brush;
    CGFloat opacity;
    
    CGFloat fontSize;
    NSString *fontName;
    
    BOOL mouseSwiped;
    
    NSString *lastTool;
    
    NSMutableArray *drawingArray;
    
    
}


@property (strong, nonatomic) IBOutlet UIImageView *tempDrawImage;

@property (strong, nonatomic) IBOutlet UIButton *Brush;

@property (strong, nonatomic) IBOutlet UIButton *ClearOutlet;

@property (strong, nonatomic) IBOutlet UIButton *eraserOutlet;

@property (strong, nonatomic) IBOutlet UIButton *saveOutlet;

@property (strong, nonatomic) IBOutlet UIButton *undoOutlet;

@property (strong, nonatomic) IBOutlet UIButton *redoOutlet;

@property (strong, nonatomic) IBOutlet UIButton *colourOutlet;

@property (strong, nonatomic) IBOutlet UIButton *speechOutlet;

@property (strong, nonatomic) IBOutlet UIButton *openOutlet;



- (IBAction)colourPressed:(id)sender;

- (IBAction)eraserPressed:(id)sender;

- (IBAction)brushPressed:(id)sender;

- (IBAction)Clear:(id)sender;

- (IBAction)savePressed:(id)sender;

- (IBAction)undoPressed:(id)sender;

- (IBAction)redoPressed:(id)sender;

- (IBAction)openPressed:(id)sender;

- (IBAction)speechPressed:(id)sender;

@end
