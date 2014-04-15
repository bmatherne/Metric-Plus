//
//  BMAreaController.m
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import "BMAreaController.h"

@interface BMAreaController ()

@end

@implementation BMAreaController

@synthesize squareMillimeter, squareCentimeter, squareInch, squareFeet, squareYard, squareMeter, acre, squareKilometer, squareMile, squareMillimeterField, squareCentimeterField, squareInchField, squareFeetField, squareYardField, squareMeterField, acreField, squareKilometerField, squareMileField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Area";
        self.tabBarItem.image = [UIImage imageNamed:@"257-box3.png"];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    }
    return self;
}

#pragma mark - View Resizing

- (void)keyboardWillShow:(NSNotification *)_notification
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    NSDictionary* userInfo = [_notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize navBarSize = navBar.bounds.size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    scrollView.frame = CGRectMake(0, 44, 320, (screenBound.size.height - keyboardSize.height - navBarSize.height));
    [UIView commitAnimations];}

- (void)keyboardWillHide:(NSNotification *)_notification
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize tabBarSize = self.tabBarController.tabBar.bounds.size;
    CGSize navBarSize = navBar.bounds.size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    scrollView.frame = CGRectMake(0, 44, 320, (screenBound.size.height - navBarSize.height - tabBarSize.height));
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    // Set the scrollview's content size and content offset for 3.5 inch display
    if (screenBound.size.height == 480.0)
    {
        if (!((textField.frame.origin.y - 50.0) < 0))
        {
            [scrollView setContentOffset:CGPointMake(0, (textField.frame.origin.y - 50.0)) animated:YES];
        }
    }
    // Set the scrollview's content size and content offset for 4 inch display
    if (screenBound.size.height == 568.0)
    {
        if (!((textField.frame.origin.y - 100.0) < 0))
        {
            [scrollView setContentOffset:CGPointMake(0, (textField.frame.origin.y - 100.0)) animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [scrollView setScrollEnabled:YES];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize tabBarSize = self.tabBarController.tabBar.bounds.size;
    CGSize navBarSize = navBar.bounds.size;
    
    scrollView.frame = CGRectMake(0, 44, 320, (screenBound.size.height - navBarSize.height - tabBarSize.height));
    [scrollView setContentSize:CGSizeMake(320, 425)];
}

// Clear the text fields when the view disappears
- (void)viewWillDisappear:(BOOL)animated
{
    [squareMillimeterField setText:@""];
    [squareCentimeterField setText:@""];
    [squareInchField setText:@""];
    [squareFeetField setText:@""];
    [squareYardField setText:@""];
    [squareMeterField setText:@""];
    [acreField setText:@""];
    [squareKilometerField setText:@""];
    [squareMileField setText:@""];
    squareMillimeter = nil;
    squareCentimeter = nil;
    squareInch = nil;
    squareFeet = nil;
    squareYard = nil;
    squareMeter = nil;
    acre = nil;
    squareKilometer = nil;
    squareMile = nil;
    keyboardToolbar = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Remove status bar in iOS 7
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    // This if statement initializes a toolbar to be displayed
    // above the keyboard. It will have 2 buttons: one to toggle negative
    // values, and one to resign the keyboard.
    if (keyboardToolbar == nil)
    {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *negativeButton = [[UIBarButtonItem alloc] initWithTitle:@"+ / -" style:UIBarButtonItemStyleBordered target:self action:@selector(negativeField:)];
        
        negativeButton.width = 70.0f;
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:negativeButton, extraSpace, doneButton, nil]];
        [keyboardToolbar setBarStyle:UIBarStyleBlackOpaque];
    }
    
    // The keyboardToolbar is set to display above the keyboard
    // for all of the text fields in the temperature view.
    squareMillimeterField.inputAccessoryView = keyboardToolbar;
    squareCentimeterField.inputAccessoryView = keyboardToolbar;
    squareInchField.inputAccessoryView = keyboardToolbar;
    squareFeetField.inputAccessoryView = keyboardToolbar;
    squareYardField.inputAccessoryView = keyboardToolbar;
    squareMeterField.inputAccessoryView = keyboardToolbar;
    acreField.inputAccessoryView = keyboardToolbar;
    squareKilometerField.inputAccessoryView = keyboardToolbar;
    squareMileField.inputAccessoryView = keyboardToolbar;
    
    // Round the corners of the labels.
    squareMillimeterLabel.layer.cornerRadius = 8;
    squareCentimeterLabel.layer.cornerRadius = 8;
    squareInchLabel.layer.cornerRadius = 8;
    squareFeetLabel.layer.cornerRadius = 8;
    squareYardLabel.layer.cornerRadius = 8;
    squareMeterLabel.layer.cornerRadius = 8;
    acreLabel.layer.cornerRadius = 8;
    squareKilometerLabel.layer.cornerRadius = 8;
    squareMileLabel.layer.cornerRadius = 8;
    
    // When the text is edited in the text fields, the
    // appropriate methods will be called.
    [squareMillimeterField addTarget:self action:@selector(squareMillimeterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [squareCentimeterField addTarget:self action:@selector(squareCentimeterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [squareInchField addTarget:self action:@selector(squareInchFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [squareFeetField addTarget:self action:@selector(squareFeetFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [squareYardField addTarget:self action:@selector(squareYardFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [squareMeterField addTarget:self action:@selector(squareMeterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [acreField addTarget:self action:@selector(acreFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [squareKilometerField addTarget:self action:@selector(squareKilometerFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [squareMileField addTarget:self action:@selector(squareMileFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Set background images for the UIButton
    UIImage *buttonImage = [UIImage imageNamed:@"darkButton.png"];
    [clearButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Removes the keyboard. Obvious, yes?
- (void)resignKeyboard:(id)sender
{
    if ([squareMillimeterField isFirstResponder])
        [squareMillimeterField resignFirstResponder];
    else if ([squareCentimeterField isFirstResponder])
        [squareCentimeterField resignFirstResponder];
    else if ([squareInchField isFirstResponder])
        [squareInchField resignFirstResponder];
    else if ([squareFeetField isFirstResponder])
        [squareFeetField resignFirstResponder];
    else if ([squareYardField isFirstResponder])
        [squareYardField resignFirstResponder];
    else if ([squareMeterField isFirstResponder])
        [squareMeterField resignFirstResponder];
    else if ([acreField isFirstResponder])
        [acreField resignFirstResponder];
    else if ([squareKilometerField isFirstResponder])
        [squareKilometerField resignFirstResponder];
    else if ([squareMileField isFirstResponder])
        [squareMileField resignFirstResponder];
}

#pragma mark - UIButton Method

- (IBAction)clearTextFields {
    [squareMillimeterField setText:@""];
    [squareCentimeterField setText:@""];
    [squareInchField setText:@""];
    [squareFeetField setText:@""];
    [squareYardField setText:@""];
    [squareMeterField setText:@""];
    [acreField setText:@""];
    [squareKilometerField setText:@""];
    [squareMileField setText:@""];
    squareMillimeter = nil;
    squareCentimeter = nil;
    squareInch = nil;
    squareFeet = nil;
    squareYard = nil;
    squareMeter = nil;
    acre = nil;
    squareKilometer = nil;
    squareMile = nil;
}

#pragma mark - Setter Methods

- (void)setSquareMillimeter:(NSNumber *)sM
{
    squareMillimeter = sM;
    
    squareCentimeter = [NSNumber numberWithDouble:([sM doubleValue] / 100.00)];
    squareInch = [NSNumber numberWithDouble:([sM doubleValue] / 645.16)];
    squareFeet = [NSNumber numberWithDouble:([sM doubleValue] / 92903)];
    squareYard = [NSNumber numberWithDouble:([sM doubleValue] / 8.3613e+5)];
    squareMeter = [NSNumber numberWithDouble:([sM doubleValue] / 1.0000e+6)];
    acre = [NSNumber numberWithDouble:([sM doubleValue] / 4.0469e+9)];
    squareKilometer = [NSNumber numberWithDouble:([sM doubleValue] / 1.0000e+12)];
    squareMile = [NSNumber numberWithDouble:([sM doubleValue] / 2.5900e+12)];
}

- (void)setSquareCentimeter:(NSNumber *)sC
{
    squareCentimeter = sC;
    
    squareMillimeter = [NSNumber numberWithDouble:([sC doubleValue] * 100.00)];
    squareInch = [NSNumber numberWithDouble:([sC doubleValue] / 6.4516)];
    squareFeet = [NSNumber numberWithDouble:([sC doubleValue] / 929.03)];
    squareYard = [NSNumber numberWithDouble:([sC doubleValue] / 8361.3)];
    squareMeter = [NSNumber numberWithDouble:([sC doubleValue] / 10000)];
    acre = [NSNumber numberWithDouble:([sC doubleValue] / 4.0469e+7)];
    squareKilometer = [NSNumber numberWithDouble:([sC doubleValue] / 1.0000e+10)];
    squareMile = [NSNumber numberWithDouble:([sC doubleValue] / 2.5900e+10)];
}

- (void)setSquareInch:(NSNumber *)sI
{
    squareInch = sI;
    
    squareMillimeter = [NSNumber numberWithDouble:([sI doubleValue] * 645.16)];
    squareCentimeter = [NSNumber numberWithDouble:([sI doubleValue] * 6.4516)];
    squareFeet = [NSNumber numberWithDouble:([sI doubleValue] / 144.00)];
    squareYard = [NSNumber numberWithDouble:([sI doubleValue] / 1296.0)];
    squareMeter = [NSNumber numberWithDouble:([sI doubleValue] / 1550.0)];
    acre = [NSNumber numberWithDouble:([sI doubleValue] / 6.2726e+6)];
    squareKilometer = [NSNumber numberWithDouble:([sI doubleValue] / 1.5500e+9)];
    squareMile = [NSNumber numberWithDouble:([sI doubleValue] / 4.0145e+9)];
}

- (void)setSquareFeet:(NSNumber *)sF
{
    squareFeet = sF;
    
    squareMillimeter = [NSNumber numberWithDouble:([sF doubleValue] * 92903)];
    squareCentimeter = [NSNumber numberWithDouble:([sF doubleValue] * 929.03)];
    squareInch = [NSNumber numberWithDouble:([sF doubleValue] * 144.00)];
    squareYard = [NSNumber numberWithDouble:([sF doubleValue] / 9.0000)];
    squareMeter = [NSNumber numberWithDouble:([sF doubleValue] / 10.764)];
    acre = [NSNumber numberWithDouble:([sF doubleValue] / 43560)];
    squareKilometer = [NSNumber numberWithDouble:([sF doubleValue] / 1.0764e+7)];
    squareMile = [NSNumber numberWithDouble:([sF doubleValue] / 2.7878e+7)];
}

- (void)setSquareYard:(NSNumber *)sY
{
    squareYard = sY;
    
    squareMillimeter = [NSNumber numberWithDouble:([sY doubleValue] * 8.3613e+5)];
    squareCentimeter = [NSNumber numberWithDouble:([sY doubleValue] * 8361.3)];
    squareInch = [NSNumber numberWithDouble:([sY doubleValue] * 1296.0)];
    squareFeet = [NSNumber numberWithDouble:([sY doubleValue] * 9.0000)];
    squareMeter = [NSNumber numberWithDouble:([sY doubleValue] / 1.1960)];
    acre = [NSNumber numberWithDouble:([sY doubleValue] / 4840.0)];
    squareKilometer = [NSNumber numberWithDouble:([sY doubleValue] / 1.1960e+6)];
    squareMile = [NSNumber numberWithDouble:([sY doubleValue] / 3.0976e+6)];
}

- (void)setSquareMeter:(NSNumber *)sM
{
    squareMeter = sM;
    
    squareMillimeter = [NSNumber numberWithDouble:([sM doubleValue] * 1.0000e+6)];
    squareCentimeter = [NSNumber numberWithDouble:([sM doubleValue] * 10000)];
    squareInch = [NSNumber numberWithDouble:([sM doubleValue] * 1550.0)];
    squareFeet = [NSNumber numberWithDouble:([sM doubleValue] * 10.764)];
    squareYard = [NSNumber numberWithDouble:([sM doubleValue] * 1.1960)];
    acre = [NSNumber numberWithDouble:([sM doubleValue] / 4046.9)];
    squareKilometer = [NSNumber numberWithDouble:([sM doubleValue] / 1.0000e+6)];
    squareMile = [NSNumber numberWithDouble:([sM doubleValue] / 2.5900e+6)];
}

- (void)setAcre:(NSNumber *)a
{
    acre = a;
    
    squareMillimeter = [NSNumber numberWithDouble:([a doubleValue] * 4.0469e+9)];
    squareCentimeter = [NSNumber numberWithDouble:([a doubleValue] * 4.0469e+7)];
    squareInch = [NSNumber numberWithDouble:([a doubleValue] * 6.2726e+6)];
    squareFeet = [NSNumber numberWithDouble:([a doubleValue] * 43560)];
    squareYard = [NSNumber numberWithDouble:([a doubleValue] * 4840.0)];
    squareMeter = [NSNumber numberWithDouble:([a doubleValue] * 4046.9)];
    squareKilometer = [NSNumber numberWithDouble:([a doubleValue] / 247.11)];
    squareMile = [NSNumber numberWithDouble:([a doubleValue] / 640.00)];
}

- (void)setSquareKilometer:(NSNumber *)sK
{
    squareKilometer = sK;
    
    squareMillimeter = [NSNumber numberWithDouble:([sK doubleValue] * 1.0000e+12)];
    squareCentimeter = [NSNumber numberWithDouble:([sK doubleValue] * 1.0000e+10)];
    squareInch = [NSNumber numberWithDouble:([sK doubleValue] * 1.5500e+9)];
    squareFeet = [NSNumber numberWithDouble:([sK doubleValue] * 1.0764e+7)];
    squareYard = [NSNumber numberWithDouble:([sK doubleValue] * 1.1960e+6)];
    squareMeter = [NSNumber numberWithDouble:([sK doubleValue] * 1.0000e+6)];
    acre = [NSNumber numberWithDouble:([sK doubleValue] * 247.11)];
    squareMile = [NSNumber numberWithDouble:([sK doubleValue] / 2.5900)];
}

- (void)setSquareMile:(NSNumber *)sM
{
    squareMile = sM;
    
    squareMillimeter = [NSNumber numberWithDouble:([sM doubleValue] * 2.5900e+12)];
    squareCentimeter = [NSNumber numberWithDouble:([sM doubleValue] * 2.5900e+10)];
    squareInch = [NSNumber numberWithDouble:([sM doubleValue] * 4.0145e+9)];
    squareFeet = [NSNumber numberWithDouble:([sM doubleValue] * 2.7878e+7)];
    squareYard = [NSNumber numberWithDouble:([sM doubleValue] * 3.0976e+6)];
    squareMeter = [NSNumber numberWithDouble:([sM doubleValue] * 2.5900e+6)];
    acre = [NSNumber numberWithDouble:([sM doubleValue] * 640.00)];
    squareKilometer = [NSNumber numberWithDouble:([sM doubleValue] * 2.5900)];
}

#pragma mark - Calculation Methods

- (void)squareMillimeterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareMillimeterField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareMillimeterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareMillimeterField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareMillimeterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareMillimeterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareMillimeterField.text doubleValue]];
    
    [self setSquareMillimeter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(squareMillimeter.doubleValue) == 0))
    {
        [squareCentimeterField setText:@""];
        [squareInchField setText:@""];
        [squareFeetField setText:@""];
        [squareYardField setText:@""];
        [squareMeterField setText:@""];
        [acreField setText:@""];
        [squareKilometerField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)squareCentimeterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareCentimeterField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareCentimeterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareCentimeterField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareCentimeterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareCentimeterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareCentimeterField.text doubleValue]];
    
    [self setSquareCentimeter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(squareCentimeter.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareInchField setText:@""];
        [squareFeetField setText:@""];
        [squareYardField setText:@""];
        [squareMeterField setText:@""];
        [acreField setText:@""];
        [squareKilometerField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)squareInchFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareInchField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareInchField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareInchField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareInchField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareInchField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareInchField.text doubleValue]];
    
    [self setSquareInch:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(squareInch.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareCentimeterField setText:@""];
        [squareFeetField setText:@""];
        [squareYardField setText:@""];
        [squareMeterField setText:@""];
        [acreField setText:@""];
        [squareKilometerField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)squareFeetFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareFeetField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareFeetField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareFeetField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareFeetField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareFeetField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareFeetField.text doubleValue]];
    
    [self setSquareFeet:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(squareFeet.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareCentimeterField setText:@""];
        [squareInchField setText:@""];
        [squareYardField setText:@""];
        [squareMeterField setText:@""];
        [acreField setText:@""];
        [squareKilometerField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)squareYardFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareYardField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareYardField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareYardField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareYardField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareYardField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareYardField.text doubleValue]];
    
    [self setSquareYard:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(squareYard.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareCentimeterField setText:@""];
        [squareInchField setText:@""];
        [squareFeetField setText:@""];
        [squareMeterField setText:@""];
        [acreField setText:@""];
        [squareKilometerField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)squareMeterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareMeterField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareMeterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareMeterField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareMeterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareMeterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareMeterField.text doubleValue]];
    
    [self setSquareMeter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(squareMeter.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareCentimeterField setText:@""];
        [squareInchField setText:@""];
        [squareFeetField setText:@""];
        [squareYardField setText:@""];
        [acreField setText:@""];
        [squareKilometerField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)acreFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:acreField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        acreField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            acreField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            acreField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        acreField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[acreField.text doubleValue]];
    
    [self setAcre:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(acre.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareCentimeterField setText:@""];
        [squareInchField setText:@""];
        [squareFeetField setText:@""];
        [squareYardField setText:@""];
        [squareMeterField setText:@""];
        [squareKilometerField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)squareKilometerFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareKilometerField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareKilometerField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareKilometerField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareKilometerField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareKilometerField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareKilometerField.text doubleValue]];
    
    [self setSquareKilometer:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareMile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMile];
        [squareMileField setText:y];
    }
    
    if ((fabs(squareKilometer.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareCentimeterField setText:@""];
        [squareInchField setText:@""];
        [squareFeetField setText:@""];
        [squareYardField setText:@""];
        [squareMeterField setText:@""];
        [acreField setText:@""];
        [squareMileField setText:@""];
    }
}

- (void)squareMileFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:squareMileField.text];
    
    // If a decimal point is the first character in the string,
    // insert a 0 in front of it.
    if ([string hasPrefix:@"."])
    {
        [string insertString:@"0" atIndex:0];
        
        // Check to make sure there's no negative sign after the decimal point
        NSRange negRange = [string rangeOfString:@"-"];
        if (!(negRange.location == NSNotFound))
        {
            // Remove the negative sign from its location
            [string deleteCharactersInRange:NSMakeRange(negRange.location, 1)];
            // And add the negative sign to the beginning of the string.
            [string insertString:@"-" atIndex:0];
        }
        squareMileField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            squareMileField.text = string;
        }
    }
    // Begin the search to remove second decimal point.
    NSRange range = [string rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        // Do nothing.
    }
    else
    {
        // Compare from the location of the found decimal point
        // to see if there is a second decimal point.
        NSUInteger x = range.location;
        NSRange range2 = [string rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + 1, string.length - 1 - x)];
        if (!(range2.location == NSNotFound))
        {
            // If second decimal point is found, delete it.
            [string deleteCharactersInRange:NSMakeRange(range2.location, 1)];
            squareMileField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        squareMileField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[squareMileField.text doubleValue]];
    
    [self setSquareMile:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(squareMillimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
        [squareMillimeterField setText:y];
    }
    
    if (fabs(squareCentimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
        [squareCentimeterField setText:y];
    }
    
    if (fabs(squareInch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareInch];
        [squareInchField setText:y];
    }
    
    if (fabs(squareFeet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareFeet];
        [squareFeetField setText:y];
    }
    
    if (fabs(squareYard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareYard];
        [squareYardField setText:y];
    }
    
    if (fabs(squareMeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareMeter];
        [squareMeterField setText:y];
    }
    
    if (fabs(acre.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:acre];
        [acreField setText:y];
    }
    
    if (fabs(squareKilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
        [squareKilometerField setText:y];
    }
    
    if ((fabs(squareMile.doubleValue) == 0))
    {
        [squareMillimeterField setText:@""];
        [squareCentimeterField setText:@""];
        [squareInchField setText:@""];
        [squareFeetField setText:@""];
        [squareYardField setText:@""];
        [squareMeterField setText:@""];
        [acreField setText:@""];
        [squareKilometerField setText:@""];
    }
}

- (void)negativeField:(id)sender
{
    if ([squareMillimeterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareMillimeterField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareMillimeterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareMillimeterField.text doubleValue]];
        
        [self setSquareMillimeter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(squareMillimeter.doubleValue) == 0))
        {
            [squareCentimeterField setText:@""];
            [squareInchField setText:@""];
            [squareFeetField setText:@""];
            [squareYardField setText:@""];
            [squareMeterField setText:@""];
            [acreField setText:@""];
            [squareKilometerField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([squareCentimeterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareCentimeterField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareCentimeterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareCentimeterField.text doubleValue]];
        
        [self setSquareCentimeter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(squareCentimeter.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareInchField setText:@""];
            [squareFeetField setText:@""];
            [squareYardField setText:@""];
            [squareMeterField setText:@""];
            [acreField setText:@""];
            [squareKilometerField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([squareInchField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareInchField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareInchField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareInchField.text doubleValue]];
        
        [self setSquareInch:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(squareInch.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareCentimeterField setText:@""];
            [squareFeetField setText:@""];
            [squareYardField setText:@""];
            [squareMeterField setText:@""];
            [acreField setText:@""];
            [squareKilometerField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([squareFeetField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareFeetField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareFeetField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareFeetField.text doubleValue]];
        
        [self setSquareFeet:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(squareFeet.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareCentimeterField setText:@""];
            [squareInchField setText:@""];
            [squareYardField setText:@""];
            [squareMeterField setText:@""];
            [acreField setText:@""];
            [squareKilometerField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([squareYardField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareYardField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareYardField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareYardField.text doubleValue]];
        
        [self setSquareYard:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(squareYard.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareCentimeterField setText:@""];
            [squareInchField setText:@""];
            [squareFeetField setText:@""];
            [squareMeterField setText:@""];
            [acreField setText:@""];
            [squareKilometerField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([squareMeterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareMeterField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareMeterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareMeterField.text doubleValue]];
        
        [self setSquareMeter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(squareMeter.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareCentimeterField setText:@""];
            [squareInchField setText:@""];
            [squareFeetField setText:@""];
            [squareYardField setText:@""];
            [acreField setText:@""];
            [squareKilometerField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([acreField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:acreField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        acreField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[acreField.text doubleValue]];
        
        [self setAcre:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(acre.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareCentimeterField setText:@""];
            [squareInchField setText:@""];
            [squareFeetField setText:@""];
            [squareYardField setText:@""];
            [squareMeterField setText:@""];
            [squareKilometerField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([squareKilometerField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareKilometerField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareKilometerField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareKilometerField.text doubleValue]];
        
        [self setSquareKilometer:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareMile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMile];
            [squareMileField setText:y];
        }
        
        if ((fabs(squareKilometer.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareCentimeterField setText:@""];
            [squareInchField setText:@""];
            [squareFeetField setText:@""];
            [squareYardField setText:@""];
            [squareMeterField setText:@""];
            [acreField setText:@""];
            [squareMileField setText:@""];
        }
    }
    else if ([squareMileField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:squareMileField.text];
        NSRange stringRange = [string rangeOfString:@"-"];
        
        // If the field is already negative, remove the negative sign.
        if ([string hasPrefix:@"-"])
        {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        // Otherwise, add the negative sign.
        else if (stringRange.location == NSNotFound)
        {
            [string insertString:@"-" atIndex:0];
        }
        
        // Add the updated string to the text field.
        squareMileField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[squareMileField.text doubleValue]];
        
        [self setSquareMile:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(squareMillimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMillimeter];
            [squareMillimeterField setText:y];
        }
        
        if (fabs(squareCentimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareCentimeter];
            [squareCentimeterField setText:y];
        }
        
        if (fabs(squareInch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareInch];
            [squareInchField setText:y];
        }
        
        if (fabs(squareFeet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareFeet];
            [squareFeetField setText:y];
        }
        
        if (fabs(squareYard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareYard];
            [squareYardField setText:y];
        }
        
        if (fabs(squareMeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareMeter];
            [squareMeterField setText:y];
        }
        
        if (fabs(acre.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:acre];
            [acreField setText:y];
        }
        
        if (fabs(squareKilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:squareKilometer];
            [squareKilometerField setText:y];
        }
        
        if ((fabs(squareMile.doubleValue) == 0))
        {
            [squareMillimeterField setText:@""];
            [squareCentimeterField setText:@""];
            [squareInchField setText:@""];
            [squareFeetField setText:@""];
            [squareYardField setText:@""];
            [squareMeterField setText:@""];
            [acreField setText:@""];
            [squareKilometerField setText:@""];
        }
    }
}

@end
