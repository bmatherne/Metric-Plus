//
//  BMLengthController.m
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import "BMLengthController.h"

@interface BMLengthController ()

@end

@implementation BMLengthController

@synthesize millimeter, centimeter, inch, decimeter, feet, yard, meter, kilometer, mile, millimeterField, centimeterField, inchField, decimeterField, feetField, yardField, meterField, kilometerField, mileField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Length";
        self.tabBarItem.image = [UIImage imageNamed:@"186-ruler.png"];
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
    [UIView commitAnimations];
}

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
    [millimeterField setText:@""];
    [centimeterField setText:@""];
    [inchField setText:@""];
    [decimeterField setText:@""];
    [feetField setText:@""];
    [yardField setText:@""];
    [meterField setText:@""];
    [kilometerField setText:@""];
    [mileField setText:@""];
    millimeter = nil;
    centimeter = nil;
    inch = nil;
    decimeter = nil;
    feet = nil;
    yard = nil;
    meter = nil;
    kilometer = nil;
    mile = nil;
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
    millimeterField.inputAccessoryView = keyboardToolbar;
    centimeterField.inputAccessoryView = keyboardToolbar;
    inchField.inputAccessoryView = keyboardToolbar;
    decimeterField.inputAccessoryView = keyboardToolbar;
    feetField.inputAccessoryView = keyboardToolbar;
    yardField.inputAccessoryView = keyboardToolbar;
    meterField.inputAccessoryView = keyboardToolbar;
    kilometerField.inputAccessoryView = keyboardToolbar;
    mileField.inputAccessoryView = keyboardToolbar;
    
    // Round the corners of the labels
    millimeterLabel.layer.cornerRadius = 8;
    centimeterLabel.layer.cornerRadius = 8;
    inchLabel.layer.cornerRadius = 8;
    decimeterLabel.layer.cornerRadius = 8;
    feetLabel.layer.cornerRadius = 8;
    yardLabel.layer.cornerRadius = 8;
    meterLabel.layer.cornerRadius = 8;
    kilometerLabel.layer.cornerRadius = 8;
    mileLabel.layer.cornerRadius = 8;
    
    // When the text is edited in the text fields, the
    // appropriate methods will be called.
    [millimeterField addTarget:self action:@selector(millimeterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [centimeterField addTarget:self action:@selector(centimeterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inchField addTarget:self action:@selector(inchFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [decimeterField addTarget:self action:@selector(decimeterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [feetField addTarget:self action:@selector(feetFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [yardField addTarget:self action:@selector(yardFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [meterField addTarget:self action:@selector(meterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [kilometerField addTarget:self action:@selector(kilometerFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [mileField addTarget:self action:@selector(mileFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
    if ([millimeterField isFirstResponder])
        [millimeterField resignFirstResponder];
    
    else if ([centimeterField isFirstResponder])
        [centimeterField resignFirstResponder];
    
    else if ([inchField isFirstResponder])
        [inchField resignFirstResponder];
    
    else if ([decimeterField isFirstResponder])
        [decimeterField resignFirstResponder];
    
    else if ([feetField isFirstResponder])
        [feetField resignFirstResponder];
    
    else if ([yardField isFirstResponder])
        [yardField resignFirstResponder];
    
    else if ([meterField isFirstResponder])
        [meterField resignFirstResponder];
    
    else if ([kilometerField isFirstResponder])
        [kilometerField resignFirstResponder];
    
    else if ([mileField isFirstResponder])
        [mileField resignFirstResponder];
}

#pragma mark - UIButton Method

- (IBAction)clearTextFields {
    [millimeterField setText:@""];
    [centimeterField setText:@""];
    [inchField setText:@""];
    [decimeterField setText:@""];
    [feetField setText:@""];
    [yardField setText:@""];
    [meterField setText:@""];
    [kilometerField setText:@""];
    [mileField setText:@""];
    millimeter = nil;
    centimeter = nil;
    inch = nil;
    decimeter = nil;
    feet = nil;
    yard = nil;
    meter = nil;
    kilometer = nil;
    mile = nil;
}

#pragma mark - Setter Methods

- (void)setMillimeter:(NSNumber *)m
{
    millimeter = m;
    
    centimeter = [NSNumber numberWithDouble:([m doubleValue] / 10.0)];
    inch = [NSNumber numberWithDouble:([m doubleValue] / 25.400)];
    decimeter = [NSNumber numberWithDouble:([m doubleValue] / 100.00)];
    feet = [NSNumber numberWithDouble:([m doubleValue] / 304.80)];
    yard = [NSNumber numberWithDouble:([m doubleValue] / 914.40)];
    meter = [NSNumber numberWithDouble:([m doubleValue] / 1000.0)];
    kilometer = [NSNumber numberWithDouble:([m doubleValue] / 1.0000e+6)];
    mile = [NSNumber numberWithDouble:([m doubleValue] / 1.6093e+6)];
}

- (void)setCentimeter:(NSNumber *)c
{
    centimeter = c;
    
    millimeter = [NSNumber numberWithDouble:([c doubleValue] * 10.000)];
    inch = [NSNumber numberWithDouble:([c doubleValue] / 2.5400)];
    decimeter = [NSNumber numberWithDouble:([c doubleValue] / 10.000)];
    feet = [NSNumber numberWithDouble:([c doubleValue] / 30.480)];
    yard = [NSNumber numberWithDouble:([c doubleValue] / 91.440)];
    meter = [NSNumber numberWithDouble:([c doubleValue] / 100.00)];
    kilometer = [NSNumber numberWithDouble:([c doubleValue] / 1.0000e+5)];
    mile = [NSNumber numberWithDouble:([c doubleValue] / 1.6093e+5)];
}

- (void)setInch:(NSNumber *)i
{
    inch = i;
    
    millimeter = [NSNumber numberWithDouble:([i doubleValue] * 25.400)];
    centimeter = [NSNumber numberWithDouble:([i doubleValue] * 2.5400)];
    decimeter = [NSNumber numberWithDouble:([i doubleValue] / 3.9370)];
    feet = [NSNumber numberWithDouble:([i doubleValue] / 12.000)];
    yard = [NSNumber numberWithDouble:([i doubleValue] / 36.000)];
    meter = [NSNumber numberWithDouble:([i doubleValue] / 39.370)];
    kilometer = [NSNumber numberWithDouble:([i doubleValue] / 39370)];
    mile = [NSNumber numberWithDouble:([i doubleValue] / 63360)];
}

- (void)setDecimeter:(NSNumber *)d
{
    decimeter = d;
    
    millimeter = [NSNumber numberWithDouble:([d doubleValue] * 100.00)];
    centimeter = [NSNumber numberWithDouble:([d doubleValue] * 10.000)];
    inch = [NSNumber numberWithDouble:([d doubleValue] * 3.9370)];
    feet = [NSNumber numberWithDouble:([d doubleValue] / 3.0480)];
    yard = [NSNumber numberWithDouble:([d doubleValue] / 9.1440)];
    meter = [NSNumber numberWithDouble:([d doubleValue] / 10.000)];
    kilometer = [NSNumber numberWithDouble:([d doubleValue] / 10000)];
    mile = [NSNumber numberWithDouble:([d doubleValue] / 16093)];
}

- (void)setFeet:(NSNumber *)f
{
    feet = f;
    
    millimeter = [NSNumber numberWithDouble:([f doubleValue] * 304.80)];
    centimeter = [NSNumber numberWithDouble:([f doubleValue] * 30.480)];
    inch = [NSNumber numberWithDouble:([f doubleValue] * 12.000)];
    decimeter = [NSNumber numberWithDouble:([f doubleValue] * 3.0480)];
    yard = [NSNumber numberWithDouble:([f doubleValue] / 3.0000)];
    meter = [NSNumber numberWithDouble:([f doubleValue] / 3.2808)];
    kilometer = [NSNumber numberWithDouble:([f doubleValue] / 3280.8)];
    mile = [NSNumber numberWithDouble:([f doubleValue] / 5280.0)];
}

- (void)setYard:(NSNumber *)y
{
    yard = y;
    
    millimeter = [NSNumber numberWithDouble:([y doubleValue] * 914.40)];
    centimeter = [NSNumber numberWithDouble:([y doubleValue] * 91.440)];
    inch = [NSNumber numberWithDouble:([y doubleValue] * 36.000)];
    decimeter = [NSNumber numberWithDouble:([y doubleValue] * 9.1440)];
    feet = [NSNumber numberWithDouble:([y doubleValue] * 3.0000)];
    meter = [NSNumber numberWithDouble:([y doubleValue] / 1.0936)];
    kilometer = [NSNumber numberWithDouble:([y doubleValue] / 1093.6)];
    mile = [NSNumber numberWithDouble:([y doubleValue] / 1760.0)];
}

- (void)setMeter:(NSNumber *)m
{
    meter = m;
    
    millimeter = [NSNumber numberWithDouble:([m doubleValue] * 1000.0)];
    centimeter = [NSNumber numberWithDouble:([m doubleValue] * 100.00)];
    inch = [NSNumber numberWithDouble:([m doubleValue] * 39.370)];
    decimeter = [NSNumber numberWithDouble:([m doubleValue] * 10.000)];
    feet = [NSNumber numberWithDouble:([m doubleValue] * 3.2808)];
    yard = [NSNumber numberWithDouble:([m doubleValue] * 1.0936)];
    kilometer = [NSNumber numberWithDouble:([m doubleValue] / 1000.0)];
    mile = [NSNumber numberWithDouble:([m doubleValue] / 1609.3)];
}

- (void)setKilometer:(NSNumber *)k
{
    kilometer = k;
    
    millimeter = [NSNumber numberWithDouble:([k doubleValue] * 1.0000e+6)];
    centimeter = [NSNumber numberWithDouble:([k doubleValue] * 1.0000e+5)];
    inch = [NSNumber numberWithDouble:([k doubleValue] * 39370)];
    decimeter = [NSNumber numberWithDouble:([k doubleValue] * 10000)];
    feet = [NSNumber numberWithDouble:([k doubleValue] * 3280.8)];
    yard = [NSNumber numberWithDouble:([k doubleValue] * 1093.6)];
    meter = [NSNumber numberWithDouble:([k doubleValue] * 1000.0)];
    mile = [NSNumber numberWithDouble:([k doubleValue] / 1.6093)];
}

- (void)setMile:(NSNumber *)m
{
    mile = m;
    
    millimeter = [NSNumber numberWithDouble:([m doubleValue] * 1.6093e+6)];
    centimeter = [NSNumber numberWithDouble:([m doubleValue] * 1.6093e+5)];
    inch = [NSNumber numberWithDouble:([m doubleValue] * 63360)];
    decimeter = [NSNumber numberWithDouble:([m doubleValue] * 16093)];
    feet = [NSNumber numberWithDouble:([m doubleValue] * 5280.0)];
    yard = [NSNumber numberWithDouble:([m doubleValue] * 1760.0)];
    meter = [NSNumber numberWithDouble:([m doubleValue] * 1609.3)];
    kilometer = [NSNumber numberWithDouble:([m doubleValue] * 1.6093)];
}

#pragma mark - Calculation Methods

- (void)millimeterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:millimeterField.text];
    
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
        millimeterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            millimeterField.text = string;
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
            millimeterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        millimeterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[millimeterField.text doubleValue]];
    
    [self setMillimeter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(millimeter.doubleValue) == 0))
    {
        [centimeterField setText:@""];
        [inchField setText:@""];
        [decimeterField setText:@""];
        [feetField setText:@""];
        [yardField setText:@""];
        [meterField setText:@""];
        [kilometerField setText:@""];
        [mileField setText:@""];
    }
}

- (void)centimeterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:centimeterField.text];
    
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
        centimeterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            centimeterField.text = string;
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
            centimeterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        centimeterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[centimeterField.text doubleValue]];
    
    [self setCentimeter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(centimeter.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [inchField setText:@""];
        [decimeterField setText:@""];
        [feetField setText:@""];
        [yardField setText:@""];
        [meterField setText:@""];
        [kilometerField setText:@""];
        [mileField setText:@""];
    }
}

- (void)inchFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:inchField.text];
    
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
        inchField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            inchField.text = string;
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
            inchField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        inchField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[inchField.text doubleValue]];
    
    [self setInch:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(inch.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [centimeterField setText:@""];
        [decimeterField setText:@""];
        [feetField setText:@""];
        [yardField setText:@""];
        [meterField setText:@""];
        [kilometerField setText:@""];
        [mileField setText:@""];
    }
}

- (void)decimeterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:decimeterField.text];
    
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
        decimeterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            decimeterField.text = string;
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
            decimeterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        decimeterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[decimeterField.text doubleValue]];
    
    [self setDecimeter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(decimeter.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [centimeterField setText:@""];
        [inchField setText:@""];
        [feetField setText:@""];
        [yardField setText:@""];
        [meterField setText:@""];
        [kilometerField setText:@""];
        [mileField setText:@""];
    }
}

- (void)feetFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:feetField.text];
    
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
        feetField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            feetField.text = string;
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
            feetField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        feetField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[feetField.text doubleValue]];
    
    [self setFeet:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(feet.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [centimeterField setText:@""];
        [inchField setText:@""];
        [decimeterField setText:@""];
        [yardField setText:@""];
        [meterField setText:@""];
        [kilometerField setText:@""];
        [mileField setText:@""];
    }
}

- (void)yardFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:yardField.text];
    
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
        yardField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            yardField.text = string;
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
            yardField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        yardField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[yardField.text doubleValue]];
    
    [self setYard:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(yard.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [centimeterField setText:@""];
        [inchField setText:@""];
        [decimeterField setText:@""];
        [feetField setText:@""];
        [meterField setText:@""];
        [kilometerField setText:@""];
        [mileField setText:@""];
    }
}

- (void)meterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:meterField.text];
    
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
        meterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            meterField.text = string;
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
            meterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        meterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[meterField.text doubleValue]];
    
    [self setMeter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(meter.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [centimeterField setText:@""];
        [inchField setText:@""];
        [decimeterField setText:@""];
        [feetField setText:@""];
        [yardField setText:@""];
        [kilometerField setText:@""];
        [mileField setText:@""];
    }
}

- (void)kilometerFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:kilometerField.text];
    
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
        kilometerField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            kilometerField.text = string;
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
            kilometerField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        kilometerField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[kilometerField.text doubleValue]];
    
    [self setKilometer:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(mile.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:mile];
        [mileField setText:y];
    }
    
    if ((fabs(kilometer.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [centimeterField setText:@""];
        [inchField setText:@""];
        [decimeterField setText:@""];
        [feetField setText:@""];
        [yardField setText:@""];
        [meterField setText:@""];
        [mileField setText:@""];
    }
}

- (void)mileFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:mileField.text];
    
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
        mileField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            mileField.text = string;
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
            mileField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        mileField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[mileField.text doubleValue]];
    
    [self setMile:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(millimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:millimeter];
        [millimeterField setText:y];
    }
    
    if (fabs(centimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centimeter];
        [centimeterField setText:y];
    }
    
    if (fabs(inch.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:inch];
        [inchField setText:y];
    }
    
    if (fabs(decimeter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:decimeter];
        [decimeterField setText:y];
    }
    
    if (fabs(feet.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:feet];
        [feetField setText:y];
    }
    
    if (fabs(yard.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:yard];
        [yardField setText:y];
    }
    
    if (fabs(meter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:meter];
        [meterField setText:y];
    }
    
    if (fabs(kilometer.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kilometer];
        [kilometerField setText:y];
    }
    
    if ((fabs(mile.doubleValue) == 0))
    {
        [millimeterField setText:@""];
        [centimeterField setText:@""];
        [inchField setText:@""];
        [decimeterField setText:@""];
        [feetField setText:@""];
        [yardField setText:@""];
        [meterField setText:@""];
        [kilometerField setText:@""];
    }
}

- (void)negativeField:(id)sender
{
    if ([millimeterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:millimeterField.text];
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
        millimeterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[millimeterField.text doubleValue]];
        
        [self setMillimeter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(millimeter.doubleValue) == 0))
        {
            [centimeterField setText:@""];
            [inchField setText:@""];
            [decimeterField setText:@""];
            [feetField setText:@""];
            [yardField setText:@""];
            [meterField setText:@""];
            [kilometerField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([centimeterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:centimeterField.text];
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
        centimeterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[centimeterField.text doubleValue]];
        
        [self setCentimeter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(centimeter.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [inchField setText:@""];
            [decimeterField setText:@""];
            [feetField setText:@""];
            [yardField setText:@""];
            [meterField setText:@""];
            [kilometerField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([inchField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:inchField.text];
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
        inchField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[inchField.text doubleValue]];
        
        [self setInch:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(inch.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [centimeterField setText:@""];
            [decimeterField setText:@""];
            [feetField setText:@""];
            [yardField setText:@""];
            [meterField setText:@""];
            [kilometerField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([decimeterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:decimeterField.text];
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
        decimeterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[decimeterField.text doubleValue]];
        
        [self setDecimeter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(decimeter.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [centimeterField setText:@""];
            [inchField setText:@""];
            [feetField setText:@""];
            [yardField setText:@""];
            [meterField setText:@""];
            [kilometerField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([feetField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:feetField.text];
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
        feetField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[feetField.text doubleValue]];
        
        [self setFeet:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(feet.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [centimeterField setText:@""];
            [inchField setText:@""];
            [decimeterField setText:@""];
            [yardField setText:@""];
            [meterField setText:@""];
            [kilometerField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([yardField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:yardField.text];
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
        yardField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[yardField.text doubleValue]];
        
        [self setYard:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(yard.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [centimeterField setText:@""];
            [inchField setText:@""];
            [decimeterField setText:@""];
            [feetField setText:@""];
            [meterField setText:@""];
            [kilometerField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([meterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:meterField.text];
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
        meterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[meterField.text doubleValue]];
        
        [self setMeter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(meter.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [centimeterField setText:@""];
            [inchField setText:@""];
            [decimeterField setText:@""];
            [feetField setText:@""];
            [yardField setText:@""];
            [kilometerField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([kilometerField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:kilometerField.text];
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
        kilometerField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[kilometerField.text doubleValue]];
        
        [self setKilometer:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(mile.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:mile];
            [mileField setText:y];
        }
        
        if ((fabs(kilometer.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [centimeterField setText:@""];
            [inchField setText:@""];
            [decimeterField setText:@""];
            [feetField setText:@""];
            [yardField setText:@""];
            [meterField setText:@""];
            [mileField setText:@""];
        }
    }
    else if ([mileField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:mileField.text];
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
        mileField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[mileField.text doubleValue]];
        
        [self setMile:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(millimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:millimeter];
            [millimeterField setText:y];
        }
        
        if (fabs(centimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centimeter];
            [centimeterField setText:y];
        }
        
        if (fabs(inch.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:inch];
            [inchField setText:y];
        }
        
        if (fabs(decimeter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:decimeter];
            [decimeterField setText:y];
        }
        
        if (fabs(feet.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:feet];
            [feetField setText:y];
        }
        
        if (fabs(yard.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:yard];
            [yardField setText:y];
        }
        
        if (fabs(meter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:meter];
            [meterField setText:y];
        }
        
        if (fabs(kilometer.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kilometer];
            [kilometerField setText:y];
        }
        
        if ((fabs(mile.doubleValue) == 0))
        {
            [millimeterField setText:@""];
            [centimeterField setText:@""];
            [inchField setText:@""];
            [decimeterField setText:@""];
            [feetField setText:@""];
            [yardField setText:@""];
            [meterField setText:@""];
            [kilometerField setText:@""];
        }
    }
}

@end
