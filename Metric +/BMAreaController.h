//
//  BMAreaController.h
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMAreaController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *squareMillimeterField;
    IBOutlet UITextField *squareCentimeterField;
    IBOutlet UITextField *squareInchField;
    IBOutlet UITextField *squareFeetField;
    IBOutlet UITextField *squareYardField;
    IBOutlet UITextField *squareMeterField;
    IBOutlet UITextField *acreField;
    IBOutlet UITextField *squareKilometerField;
    IBOutlet UITextField *squareMileField;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationBar *navBar;
    
    IBOutlet UILabel *squareMillimeterLabel;
    IBOutlet UILabel *squareCentimeterLabel;
    IBOutlet UILabel *squareInchLabel;
    IBOutlet UILabel *squareFeetLabel;
    IBOutlet UILabel *squareYardLabel;
    IBOutlet UILabel *squareMeterLabel;
    IBOutlet UILabel *acreLabel;
    IBOutlet UILabel *squareKilometerLabel;
    IBOutlet UILabel *squareMileLabel;
    
    IBOutlet UIButton *clearButton;
    
    UIToolbar *keyboardToolbar;
}

@property (nonatomic, strong) NSNumber *squareMillimeter, *squareCentimeter, *squareInch, *squareFeet, *squareYard, *squareMeter, *acre, *squareKilometer, *squareMile;
@property (nonatomic, strong) UITextField *squareMillimeterField;
@property (nonatomic, strong) UITextField *squareCentimeterField;
@property (nonatomic, strong) UITextField *squareInchField;
@property (nonatomic, strong) UITextField *squareFeetField;
@property (nonatomic, strong) UITextField *squareYardField;
@property (nonatomic, strong) UITextField *squareMeterField;
@property (nonatomic, strong) UITextField *acreField;
@property (nonatomic, strong) UITextField *squareKilometerField;
@property (nonatomic, strong) UITextField *squareMileField;

- (IBAction)clearTextFields;
- (void)squareMillimeterFieldDidChange:(id)sender;
- (void)squareCentimeterFieldDidChange:(id)sender;
- (void)squareInchFieldDidChange:(id)sender;
- (void)squareFeetFieldDidChange:(id)sender;
- (void)squareYardFieldDidChange:(id)sender;
- (void)squareMeterFieldDidChange:(id)sender;
- (void)acreFieldDidChange:(id)sender;
- (void)squareKilometerFieldDidChange:(id)sender;
- (void)squareMileFieldDidChange:(id)sender;
- (void)negativeField:(id)sender;
- (void)resignKeyboard:(id)sender;

@end
