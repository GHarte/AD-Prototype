//
//  GHDrawingViewController.m
//  AD
//
//  Created by Gareth Harte on 29/01/2014.
//  Copyright (c) 2014 Gareth Harte. All rights reserved.
//


#import "GHDrawingViewController.h"
#import "NEOColorPickerViewController.h"
#import "GKImagePicker.h"
#import <Social/Social.h>


static const NSInteger INPUT_ALERTVIEW_TAG = 64;

@interface GHDrawingViewController () <NEOColorPickerViewControllerDelegate>{
    
    NSMutableArray *lineArray; //Store lines for undo & redo
    NSMutableArray *tempLineArray;
    
}

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation GHDrawingViewController

@synthesize imagePicker, popoverController;

int currentLine = 0;
NSData *chosenImage;
UIImage *image1;

- (void)viewDidLoad
{
   
    
    UIGraphicsBeginImageContextWithOptions(self.tempDrawImage.bounds.size, NO, 0.0);
    
    
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
    
    
    //Save a blank once the app is opened so that we can use it when clear is pressed
    NSData *pngData = UIImagePNGRepresentation(self.tempDrawImage.image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"blankimage.png"];
    [pngData writeToFile:filePath atomically:YES];
    
    UIGraphicsEndImageContext();
    
    
    //set default brush colour to black
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    
    fontSize = 16.0;
    fontName = @"Arial";
    
    lastTool = @"brush";
    
    lineArray = [[NSMutableArray alloc]init];
    tempLineArray = [[NSMutableArray alloc]init];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Drawing & Text Input Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    //Do this when the drawing area is touched.
    
    //mouseSwiped = NO;
    UITouch *touch = [touches anyObject]; //Store the touch in a UITouch object.
    lastPoint = [touch locationInView:self.tempDrawImage]; //lastPoint = X and Y co-ordinates of the last location of the 'tempDrawImage' imageView to be touched.
    
   
    //Hide UI elements when drawing
    
    [self.Brush setHidden:YES];
    [self.ClearOutlet setHidden:YES];
    [self.eraserOutlet setHidden:YES];
    [self.undoOutlet setHidden:YES];
    [self.redoOutlet setHidden:YES];
    [self.colourOutlet setHidden:YES];
    [self.speechOutlet setHidden:YES];
    [self.openOutlet setHidden:YES];
  
    [lineArray addObject:self.tempDrawImage.image];
    
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    //Do this when the user moves their finger around the drawing area if brush or eraser is selected.
    
    if([lastTool  isEqual: @"brush"] || [lastTool isEqual:@"eraser"]){ //Don't change RGB values unless the eraser was used.
    
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.tempDrawImage];
    
    UIGraphicsBeginImageContext(self.tempDrawImage.frame.size); //Begin image context using tempDrawImage's frame for its size.
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)]; //Draw on tempDrawImage's image. Set up the image to be the same size as the imageView.
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y); //End the line at lastPoints co-ordinates.
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y); //Start the line at currentPoints co-ordinates.
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //Use a circle to draw the line, can also use a square.
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush ); //Set line width = the value stored in 'brush'.
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0); //Stroke the line with the RGB values and full alpha.
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext(); //set tempDrawImage's image to what has been drawn.

    UIGraphicsEndImageContext(); //end the image context
    
    lastPoint = currentPoint; //set lastPoint = the location where the finger stopped drawing
        
    }
    
}
    

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        
        if([lastTool  isEqual: @"brush"] || [lastTool isEqual:@"eraser"]){
        
        UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        }
        
        else if([lastTool isEqual:@"speech"]){
        
        // ADDS FUNCTIONALITY FOR PLACING TEXT WHEN SCREEN IS TAPPED.
            
            UIAlertView *txtInputAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [txtInputAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            txtInputAlert.tag = INPUT_ALERTVIEW_TAG;
            [txtInputAlert show];
         
         
        }
        
    }
    
    
    UIGraphicsEndImageContext();
    
    //Unhide UI elements
    
    [self.Brush setHidden:NO];  //brush button outlet
    [self.ClearOutlet setHidden:NO];
    [self.eraserOutlet setHidden:NO];
    [self.undoOutlet setHidden:NO];
    [self.redoOutlet setHidden:NO];
    [self.colourOutlet setHidden:NO];
    [self.speechOutlet setHidden:NO];
    [self.openOutlet setHidden:NO];
    
    mouseSwiped = NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    //Place text on screen where it was tapped if the user presses OK.
    switch (alertView.tag) {
        case INPUT_ALERTVIEW_TAG:
        {
            if (buttonIndex == 1) {
                [lineArray addObject:self.tempDrawImage.image];
                NSString *txt = [alertView textFieldAtIndex:0].text;
                UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:opacity].CGColor);
                [self.tempDrawImage.image drawInRect:CGRectMake(0,0,self.tempDrawImage.frame.size.width,self.tempDrawImage.frame.size.height)];
                CGRect rect = CGRectMake(lastPoint.x, lastPoint.y, 150, 200);
                
                [txt drawInRect:CGRectIntegral(rect) withAttributes:attributes];
                self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
    }
}


#pragma mark - Settings Logic

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Apply the current settings of the brush to the brush preview on the settings page
    GHDrawSettingsViewController * dSettingsVC = (GHDrawSettingsViewController *)segue.destinationViewController;
    dSettingsVC.delegate = self;
    dSettingsVC.brush = brush;
    dSettingsVC.red = red;
    dSettingsVC.green = green;
    dSettingsVC.blue = blue;
    
}

- (void)closeSettings:(id)sender {
    
    //Apply the settings configured in the settings page to our brush.
    brush = ((GHDrawSettingsViewController*)sender).brush;
    red = ((GHDrawSettingsViewController*)sender).red;
    green = ((GHDrawSettingsViewController*)sender).green;
    blue = ((GHDrawSettingsViewController*)sender).blue;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.currentColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    
}


#pragma mark - Button Actions

- (IBAction)brushPressed:(id)sender {
    
    if([lastTool  isEqual: @"eraser"]){ //Don't change RGB values unless the eraser was used.
        red = tempRed;
        green = tempGreen;
        blue = tempBlue;
    }
    
    lastTool = @"brush";
    
}

- (IBAction)eraserPressed:(id)sender {
    
    //store current colours in temporary variables.
    tempRed = red;
    tempGreen = green;
    tempBlue = blue;
    
    //Set RGB values to white.
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
    
    lastTool = @"eraser";
    
}

- (IBAction)undoPressed:(id)sender {
    
    
    if (lineArray.count == 0) {
            return;
    }
    
    if (self.tempDrawImage.image) {
        [tempLineArray addObject:self.tempDrawImage.image]; //store object being deleted into tempLineArray for redo
    }
    
    self.tempDrawImage.image = (UIImage *)[lineArray lastObject];
    [lineArray removeLastObject];
    
    
}

- (IBAction)redoPressed:(id)sender {
    
    if (tempLineArray.count == 0) {
        return;
    }
    
    if (self.tempDrawImage.image) {
        [lineArray addObject:self.tempDrawImage.image]; //store object being deleted into lineArray for undo
    }
    
    self.tempDrawImage.image = (UIImage *)[tempLineArray lastObject];
    [tempLineArray removeLastObject];
    
}

- (IBAction)Clear:(id)sender {
    
    [lineArray addObject:self.tempDrawImage.image]; //for undo
    self.tempDrawImage.image = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"blankimage.png"];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    self.tempDrawImage.image = [UIImage imageWithData:pngData];
    
}

- (IBAction)colourPressed:(id)sender {
    
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = self.currentColor;
    controller.title = @"Colour Palette";
	UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

- (IBAction)speechPressed:(id)sender {
    
    lastTool = @"speech";
    
}

- (IBAction)openPressed:(id)sender {
    
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(320, 420);
    self.imagePicker.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        
    } else {
        
        [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
        
    }
    
}

- (IBAction)savePressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Camera Roll", @"Share on Facebook",@"Share to Twitter", @"Cancel", nil];
    [actionSheet showInView:self.view];
    
    
    
}

#pragma mark - Color Picker Logic

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:color]; //Extract RGB values from the UIColor object 'color' selected in the colour palette.
    
    red = components [0];
    green = components [1];
    blue = components [2];
    
    
    self.currentColor = color;
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
	[controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Open Image logic

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    self.tempDrawImage.image = image;
    [self hideImagePicker];
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
}


#pragma mark - Save/Share Image Logic

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
	{
        //Saves image to photos album / camera roll.
        
        UIGraphicsBeginImageContextWithOptions(self.tempDrawImage.bounds.size, NO, 0.0);
        
        
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
        
        UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
    
    if (buttonIndex == 1)
    {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            
            chosenImage = UIImagePNGRepresentation(self.tempDrawImage.image);
            image1 = [UIImage imageWithData:chosenImage];
            
            SLComposeViewController *faceSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [faceSheet setInitialText:@"Sharing from my own app! :)"];
            [faceSheet addImage:image1];
            [self presentViewController:faceSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't share to Facebook right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    
    if (buttonIndex == 2)
    {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            
            chosenImage = UIImagePNGRepresentation(self.tempDrawImage.image);
            image1 = [UIImage imageWithData:chosenImage];
            
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"Tweeting from my own app! :)"];
            [tweetSheet addImage:image1];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    
}




- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved to Camera Roll"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

@end