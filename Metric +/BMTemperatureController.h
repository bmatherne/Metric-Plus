//
//  BMTemperatureController.h
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMTemperatureController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *celciusField;
    IBOutlet UITextField *fahrenheitField;
    IBOutlet UITextField *kelvinField;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationBar *navBar;
    
    IBOutlet UILabel *celciusLabel;
    IBOutlet UILabel *fahrenheitLabel;
    IBOutlet UILabel *kelvinLabel;
    
    IBOutlet UIButton *clearButton;
    
    UIToolbar *keyboardToolbar;
}

@property (nonatomic, strong) NSNumber *celcius, *fahrenheit, *kelvin;
@property (nonatomic, strong) UITextField *celciusField;
@property (nonatomic, strong) UITextField *fahrenheitField;
@property (nonatomic, strong) UITextField *kelvinField;

- (void)celciusFieldDidChange:(id)sender;
- (void)fahrenheitFieldDidChange:(id)sender;
- (void)kelvinFieldDidChange:(id)sender;
- (void)negativeField:(id)sender;
- (void)resignKeyboard:(id)sender;
- (IBAction)clearTextFields;

@end
