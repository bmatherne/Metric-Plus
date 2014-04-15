//
//  BMLengthController.h
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMLengthController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *millimeterField;
    IBOutlet UITextField *centimeterField;
    IBOutlet UITextField *inchField;
    IBOutlet UITextField *decimeterField;
    IBOutlet UITextField *feetField;
    IBOutlet UITextField *yardField;
    IBOutlet UITextField *meterField;
    IBOutlet UITextField *kilometerField;
    IBOutlet UITextField *mileField;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationBar *navBar;
    
    IBOutlet UILabel *millimeterLabel;
    IBOutlet UILabel *centimeterLabel;
    IBOutlet UILabel *inchLabel;
    IBOutlet UILabel *decimeterLabel;
    IBOutlet UILabel *feetLabel;
    IBOutlet UILabel *yardLabel;
    IBOutlet UILabel *meterLabel;
    IBOutlet UILabel *kilometerLabel;
    IBOutlet UILabel *mileLabel;
    
    IBOutlet UIButton *clearButton;
    
    UIToolbar *keyboardToolbar;
}

@property (nonatomic, strong) NSNumber *millimeter, *centimeter, *inch, *decimeter, *feet, *yard, *meter, *kilometer, *mile;
@property (nonatomic, strong) UITextField *millimeterField;
@property (nonatomic, strong) UITextField *centimeterField;
@property (nonatomic, strong) UITextField *inchField;
@property (nonatomic, strong) UITextField *decimeterField;
@property (nonatomic, strong) UITextField *feetField;
@property (nonatomic, strong) UITextField *yardField;
@property (nonatomic, strong) UITextField *meterField;
@property (nonatomic, strong) UITextField *kilometerField;
@property (nonatomic, strong) UITextField *mileField;

- (IBAction)clearTextFields;
- (void)millimeterFieldDidChange:(id)sender;
- (void)centimeterFieldDidChange:(id)sender;
- (void)inchFieldDidChange:(id)sender;
- (void)decimeterFieldDidChange:(id)sender;
- (void)feetFieldDidChange:(id)sender;
- (void)yardFieldDidChange:(id)sender;
- (void)meterFieldDidChange:(id)sender;
- (void)kilometerFieldDidChange:(id)sender;
- (void)mileFieldDidChange:(id)sender;
- (void)negativeField:(id)sender;
- (void)resignKeyboard:(id)sender;

@end
