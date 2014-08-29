//
//  GHDrawSettingsViewController.h
//  AD
//
//  Created by Gareth Harte on 29/01/2014.
//  Copyright (c) 2014 Gareth Harte. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GHDrawSettingsViewControllerDelegate <NSObject>
- (void)closeSettings:(id)sender;
@end

@interface GHDrawSettingsViewController : UIViewController

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;

@property (nonatomic, weak) id<GHDrawSettingsViewControllerDelegate> delegate;

- (IBAction)closeSettings:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *brushControl;

@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;

@property (weak, nonatomic) IBOutlet UILabel *brushValueLabel;

- (IBAction)sliderChanged:(id)sender;

@property CGFloat brush;

@property (weak, nonatomic) IBOutlet UISlider *redControl;

@property (weak, nonatomic) IBOutlet UISlider *greenControl;

@property (weak, nonatomic) IBOutlet UISlider *blueControl;

@property (weak, nonatomic) IBOutlet UILabel *redLabel;

@property (weak, nonatomic) IBOutlet UILabel *greenLabel;

@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rgbPreview;



@end








