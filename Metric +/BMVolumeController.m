//
//  BMVolumeController.m
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import "BMVolumeController.h"

@interface BMVolumeController ()

@end

@implementation BMVolumeController

@synthesize milliliter, teaspoon, centiliter, tablespoon, ounce, cup, pint, liter, gallon, kiloliter, milliliterField, teaspoonField, centiliterField, tablespoonField, ounceField, cupField, pintField, literField, gallonField, kiloliterField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Volume";
        self.tabBarItem.image = [UIImage imageNamed:@"91-beaker-2.png"];
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
    [scrollView setContentSize:CGSizeMake(320, 464)];
}

// Clear the text fields when the view disappears
- (void)viewWillDisappear:(BOOL)animated
{
    [milliliterField setText:@""];
    [teaspoonField setText:@""];
    [centiliterField setText:@""];
    [tablespoonField setText:@""];
    [ounceField setText:@""];
    [cupField setText:@""];
    [pintField setText:@""];
    [literField setText:@""];
    [gallonField setText:@""];
    [kiloliterField setText:@""];
    milliliter = nil;
    teaspoon = nil;
    centiliter = nil;
    tablespoon = nil;
    ounce = nil;
    cup = nil;
    pint = nil;
    liter = nil;
    gallon = nil;
    kiloliter = nil;
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
    milliliterField.inputAccessoryView = keyboardToolbar;
    teaspoonField.inputAccessoryView = keyboardToolbar;
    centiliterField.inputAccessoryView = keyboardToolbar;
    tablespoonField.inputAccessoryView = keyboardToolbar;
    ounceField.inputAccessoryView = keyboardToolbar;
    cupField.inputAccessoryView = keyboardToolbar;
    pintField.inputAccessoryView = keyboardToolbar;
    literField.inputAccessoryView = keyboardToolbar;
    gallonField.inputAccessoryView = keyboardToolbar;
    kiloliterField.inputAccessoryView = keyboardToolbar;
    
    // Round the corners of the labels
    milliliterLabel.layer.cornerRadius = 8;
    teaspoonLabel.layer.cornerRadius = 8;
    centiliterLabel.layer.cornerRadius = 8;
    tablespoonLabel.layer.cornerRadius = 8;
    ounceLabel.layer.cornerRadius = 8;
    cupLabel.layer.cornerRadius = 8;
    pintLabel.layer.cornerRadius = 8;
    literLabel.layer.cornerRadius = 8;
    gallonLabel.layer.cornerRadius = 8;
    kiloliterLabel.layer.cornerRadius = 8;
    
    // When the text is edited in the text fields, the
    // appropriate methods will be called.
    [milliliterField addTarget:self action:@selector(milliliterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [teaspoonField addTarget:self action:@selector(teaspoonFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [centiliterField addTarget:self action:@selector(centiliterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [tablespoonField addTarget:self action:@selector(tablespoonFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [ounceField addTarget:self action:@selector(ounceFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cupField addTarget:self action:@selector(cupFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [pintField addTarget:self action:@selector(pintFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [literField addTarget:self action:@selector(literFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [gallonField addTarget:self action:@selector(gallonFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [kiloliterField addTarget:self action:@selector(kiloliterFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
    if ([milliliterField isFirstResponder])
        [milliliterField resignFirstResponder];
    else if ([teaspoonField isFirstResponder])
        [teaspoonField resignFirstResponder];
    else if ([centiliterField isFirstResponder])
        [centiliterField resignFirstResponder];
    else if ([tablespoonField isFirstResponder])
        [tablespoonField resignFirstResponder];
    else if ([ounceField isFirstResponder])
        [ounceField resignFirstResponder];
    else if ([cupField isFirstResponder])
        [cupField resignFirstResponder];
    else if ([pintField isFirstResponder])
        [pintField resignFirstResponder];
    else if ([literField isFirstResponder])
        [literField resignFirstResponder];
    else if ([gallonField isFirstResponder])
        [gallonField resignFirstResponder];
    else if ([kiloliterField isFirstResponder])
        [kiloliterField resignFirstResponder];
}

#pragma mark - UIButton Method

- (IBAction)clearTextFields {
    [milliliterField setText:@""];
    [teaspoonField setText:@""];
    [centiliterField setText:@""];
    [tablespoonField setText:@""];
    [ounceField setText:@""];
    [cupField setText:@""];
    [pintField setText:@""];
    [literField setText:@""];
    [gallonField setText:@""];
    [kiloliterField setText:@""];
    milliliter = nil;
    teaspoon = nil;
    centiliter = nil;
    tablespoon = nil;
    ounce = nil;
    cup = nil;
    pint = nil;
    liter = nil;
    gallon = nil;
    kiloliter = nil;
}

#pragma mark - Setter Methods

- (void)setMilliliter:(NSNumber *)m
{
    milliliter = m;
    
    teaspoon = [NSNumber numberWithDouble:([m doubleValue] / 4.9289)];
    centiliter = [NSNumber numberWithDouble:([m doubleValue] / 10.000)];
    tablespoon = [NSNumber numberWithDouble:([m doubleValue] / 14.787)];
    ounce = [NSNumber numberWithDouble:([m doubleValue] / 29.574)];
    cup = [NSNumber numberWithDouble:([m doubleValue] / 236.59)];
    pint = [NSNumber numberWithDouble:([m doubleValue] / 473.18)];
    liter = [NSNumber numberWithDouble:([m doubleValue] / 1000.0)];
    gallon = [NSNumber numberWithDouble:([m doubleValue] / 3785.4)];
    kiloliter = [NSNumber numberWithDouble:([m doubleValue] / 1.0000e+6)];
}

- (void)setTeaspoon:(NSNumber *)t
{
    teaspoon = t;
    
    milliliter = [NSNumber numberWithDouble:([t doubleValue] * 4.9289)];
    centiliter = [NSNumber numberWithDouble:([t doubleValue] / 2.0288)];
    tablespoon = [NSNumber numberWithDouble:([t doubleValue] / 3.0000)];
    ounce = [NSNumber numberWithDouble:([t doubleValue] / 6.0000)];
    cup = [NSNumber numberWithDouble:([t doubleValue] / 48.000)];
    pint = [NSNumber numberWithDouble:([t doubleValue] / 96.000)];
    liter = [NSNumber numberWithDouble:([t doubleValue] / 202.88)];
    gallon = [NSNumber numberWithDouble:([t doubleValue] / 768.00)];
    kiloliter = [NSNumber numberWithDouble:([t doubleValue] / 2.0288e+5)];
}

- (void)setCentiliter:(NSNumber *)c
{
    centiliter = c;
    
    milliliter = [NSNumber numberWithDouble:([c doubleValue] * 10.000)];
    teaspoon = [NSNumber numberWithDouble:([c doubleValue] * 2.0288)];
    tablespoon = [NSNumber numberWithDouble:([c doubleValue] / 1.4787)];
    ounce = [NSNumber numberWithDouble:([c doubleValue] / 2.9574)];
    cup = [NSNumber numberWithDouble:([c doubleValue] / 23.659)];
    pint = [NSNumber numberWithDouble:([c doubleValue] / 47.318)];
    liter = [NSNumber numberWithDouble:([c doubleValue] / 100.00)];
    gallon = [NSNumber numberWithDouble:([c doubleValue] / 378.54)];
    kiloliter = [NSNumber numberWithDouble:([c doubleValue] / 1.0000e+5)];
}

- (void)setTablespoon:(NSNumber *)t
{
    tablespoon = t;
    
    milliliter = [NSNumber numberWithDouble:([t doubleValue] * 14.787)];
    teaspoon = [NSNumber numberWithDouble:([t doubleValue] * 3.0000)];
    centiliter = [NSNumber numberWithDouble:([t doubleValue] * 1.4787)];
    ounce = [NSNumber numberWithDouble:([t doubleValue] / 2.0000)];
    cup = [NSNumber numberWithDouble:([t doubleValue] / 16.000)];
    pint = [NSNumber numberWithDouble:([t doubleValue] / 32.000)];
    liter = [NSNumber numberWithDouble:([t doubleValue] / 67.628)];
    gallon = [NSNumber numberWithDouble:([t doubleValue] / 256.00)];
    kiloliter = [NSNumber numberWithDouble:([t doubleValue] / 67628)];
}

- (void)setOunce:(NSNumber *)o
{
    ounce = o;
    
    milliliter = [NSNumber numberWithDouble:([o doubleValue] * 29.574)];
    teaspoon = [NSNumber numberWithDouble:([o doubleValue] * 6.0000)];
    centiliter = [NSNumber numberWithDouble:([o doubleValue] * 2.9574)];
    tablespoon = [NSNumber numberWithDouble:([o doubleValue] * 2.0000)];
    cup = [NSNumber numberWithDouble:([o doubleValue] / 8.0000)];
    pint = [NSNumber numberWithDouble:([o doubleValue] / 16.000)];
    liter = [NSNumber numberWithDouble:([o doubleValue] / 33.814)];
    gallon = [NSNumber numberWithDouble:([o doubleValue] / 128.00)];
    kiloliter = [NSNumber numberWithDouble:([o doubleValue] / 33814)];
}

- (void)setCup:(NSNumber *)c
{
    cup = c;
    
    milliliter = [NSNumber numberWithDouble:([c doubleValue] * 236.59)];
    teaspoon = [NSNumber numberWithDouble:([c doubleValue] * 48.000)];
    centiliter = [NSNumber numberWithDouble:([c doubleValue] * 23.659)];
    tablespoon = [NSNumber numberWithDouble:([c doubleValue] * 16.000)];
    ounce = [NSNumber numberWithDouble:([c doubleValue] * 8.0000)];
    pint = [NSNumber numberWithDouble:([c doubleValue] / 2.0000)];
    liter = [NSNumber numberWithDouble:([c doubleValue] / 4.2268)];
    gallon = [NSNumber numberWithDouble:([c doubleValue] / 16.000)];
    kiloliter = [NSNumber numberWithDouble:([c doubleValue] / 4226.8)];
}

- (void)setPint:(NSNumber *)p
{
    pint = p;
    
    milliliter = [NSNumber numberWithDouble:([p doubleValue] * 473.18)];
    teaspoon = [NSNumber numberWithDouble:([p doubleValue] * 96.000)];
    centiliter = [NSNumber numberWithDouble:([p doubleValue] * 47.318)];
    tablespoon = [NSNumber numberWithDouble:([p doubleValue] * 32.000)];
    ounce = [NSNumber numberWithDouble:([p doubleValue] * 16.000)];
    cup = [NSNumber numberWithDouble:([p doubleValue] * 2.0000)];
    liter = [NSNumber numberWithDouble:([p doubleValue] / 2.1134)];
    gallon = [NSNumber numberWithDouble:([p doubleValue] / 8.0000)];
    kiloliter = [NSNumber numberWithDouble:([p doubleValue] / 2113.4)];
}

- (void)setLiter:(NSNumber *)l
{
    liter = l;
    
    milliliter = [NSNumber numberWithDouble:([l doubleValue] * 1000.0)];
    teaspoon = [NSNumber numberWithDouble:([l doubleValue] * 202.88)];
    centiliter = [NSNumber numberWithDouble:([l doubleValue] * 100.00)];
    tablespoon = [NSNumber numberWithDouble:([l doubleValue] * 67.628)];
    ounce = [NSNumber numberWithDouble:([l doubleValue] * 33.814)];
    cup = [NSNumber numberWithDouble:([l doubleValue] * 4.2268)];
    pint = [NSNumber numberWithDouble:([l doubleValue] * 2.1134)];
    gallon = [NSNumber numberWithDouble:([l doubleValue] / 3.7854)];
    kiloliter = [NSNumber numberWithDouble:([l doubleValue] / 1000.0)];
}

- (void)setGallon:(NSNumber *)g
{
    gallon = g;
    
    milliliter = [NSNumber numberWithDouble:([g doubleValue] * 3785.4)];
    teaspoon = [NSNumber numberWithDouble:([g doubleValue] * 768.00)];
    centiliter = [NSNumber numberWithDouble:([g doubleValue] * 378.54)];
    tablespoon = [NSNumber numberWithDouble:([g doubleValue] * 256.00)];
    ounce = [NSNumber numberWithDouble:([g doubleValue] * 128.00)];
    cup = [NSNumber numberWithDouble:([g doubleValue] * 16.000)];
    pint = [NSNumber numberWithDouble:([g doubleValue] * 8.0000)];
    liter = [NSNumber numberWithDouble:([g doubleValue] * 3.7854)];
    kiloliter = [NSNumber numberWithDouble:([g doubleValue] / 264.17)];
}

- (void)setKiloliter:(NSNumber *)k
{
    kiloliter = k;
    
    milliliter = [NSNumber numberWithDouble:([k doubleValue] * 1.0000e+6)];
    teaspoon = [NSNumber numberWithDouble:([k doubleValue] * 2.0288e+5)];
    centiliter = [NSNumber numberWithDouble:([k doubleValue] * 1.0000e+5)];
    tablespoon = [NSNumber numberWithDouble:([k doubleValue] * 67628)];
    ounce = [NSNumber numberWithDouble:([k doubleValue] * 33814)];
    cup = [NSNumber numberWithDouble:([k doubleValue] * 4226.8)];
    pint = [NSNumber numberWithDouble:([k doubleValue] * 2113.4)];
    liter = [NSNumber numberWithDouble:([k doubleValue] * 1000.0)];
    gallon = [NSNumber numberWithDouble:([k doubleValue] * 264.17)];
}

#pragma mark - Calculation Methods

- (void)milliliterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:milliliterField.text];
    
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
        milliliterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            milliliterField.text = string;
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
            milliliterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        milliliterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[milliliterField.text doubleValue]];
    
    [self setMilliliter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(milliliter.doubleValue) == 0))
    {
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)teaspoonFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:teaspoonField.text];
    
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
        teaspoonField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            teaspoonField.text = string;
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
            teaspoonField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        teaspoonField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[teaspoonField.text doubleValue]];
    
    [self setTeaspoon:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(teaspoon.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)centiliterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:centiliterField.text];
    
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
        centiliterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            centiliterField.text = string;
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
            centiliterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        centiliterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[centiliterField.text doubleValue]];
    
    [self setCentiliter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(centiliter.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)tablespoonFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:tablespoonField.text];
    
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
        tablespoonField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            tablespoonField.text = string;
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
            tablespoonField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        tablespoonField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[tablespoonField.text doubleValue]];
    
    [self setTablespoon:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(tablespoon.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)ounceFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:ounceField.text];
    
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
        ounceField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            ounceField.text = string;
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
            ounceField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        ounceField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[ounceField.text doubleValue]];
    
    [self setOunce:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(ounce.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)cupFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:cupField.text];
    
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
        cupField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            cupField.text = string;
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
            cupField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        cupField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[cupField.text doubleValue]];
    
    [self setCup:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(cup.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)pintFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:pintField.text];
    
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
        pintField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            pintField.text = string;
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
            pintField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        pintField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[pintField.text doubleValue]];
    
    [self setPint:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(pint.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)literFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:literField.text];
    
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
        literField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            literField.text = string;
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
            literField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        literField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[literField.text doubleValue]];
    
    [self setLiter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(liter.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [gallonField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)gallonFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:gallonField.text];
    
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
        gallonField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            gallonField.text = string;
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
            gallonField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        gallonField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[gallonField.text doubleValue]];
    
    [self setGallon:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(kiloliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:kiloliter];
        [kiloliterField setText:y];
    }
    
    if ((fabs(gallon.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [kiloliterField setText:@""];
    }
}

- (void)kiloliterFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:kiloliterField.text];
    
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
        kiloliterField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            kiloliterField.text = string;
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
            kiloliterField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        kiloliterField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[kiloliterField.text doubleValue]];
    
    [self setKiloliter:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milliliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:milliliter];
        [milliliterField setText:y];
    }
    
    if (fabs(teaspoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:teaspoon];
        [teaspoonField setText:y];
    }
    
    if (fabs(centiliter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:centiliter];
        [centiliterField setText:y];
    }
    
    if (fabs(tablespoon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:tablespoon];
        [tablespoonField setText:y];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:y];
    }
    
    if (fabs(cup.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:cup];
        [cupField setText:y];
    }
    
    if (fabs(pint.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:pint];
        [pintField setText:y];
    }
    
    if (fabs(liter.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:liter];
        [literField setText:y];
    }
    
    if (fabs(gallon.doubleValue) < 0.000001)
    {
        NSString *y = [scientificFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    else
    {
        NSString *y = [decimalFormatter stringFromNumber:gallon];
        [gallonField setText:y];
    }
    
    if ((fabs(kiloliter.doubleValue) == 0))
    {
        [milliliterField setText:@""];
        [teaspoonField setText:@""];
        [centiliterField setText:@""];
        [tablespoonField setText:@""];
        [ounceField setText:@""];
        [cupField setText:@""];
        [pintField setText:@""];
        [literField setText:@""];
        [gallonField setText:@""];
    }
}

- (void)negativeField:(id)sender
{
    if ([milliliterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:milliliterField.text];
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
        milliliterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[milliliterField.text doubleValue]];
        
        [self setMilliliter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(milliliter.doubleValue) == 0))
        {
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([teaspoonField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:teaspoonField.text];
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
        teaspoonField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[teaspoonField.text doubleValue]];
        
        [self setTeaspoon:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(teaspoon.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([centiliterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:centiliterField.text];
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
        centiliterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[centiliterField.text doubleValue]];
        
        [self setCentiliter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(centiliter.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([tablespoonField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:tablespoonField.text];
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
        tablespoonField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[tablespoonField.text doubleValue]];
        
        [self setTablespoon:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(tablespoon.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([ounceField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:ounceField.text];
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
        ounceField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[ounceField.text doubleValue]];
        
        [self setOunce:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(ounce.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([cupField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:cupField.text];
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
        cupField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[cupField.text doubleValue]];
        
        [self setCup:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(cup.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([pintField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:pintField.text];
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
        pintField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[pintField.text doubleValue]];
        
        [self setPint:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(pint.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([literField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:literField.text];
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
        literField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[literField.text doubleValue]];
        
        [self setLiter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(liter.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [gallonField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([gallonField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:gallonField.text];
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
        gallonField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[gallonField.text doubleValue]];
        
        [self setGallon:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(kiloliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:kiloliter];
            [kiloliterField setText:y];
        }
        
        if ((fabs(gallon.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [kiloliterField setText:@""];
        }
    }
    else if ([kiloliterField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:kiloliterField.text];
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
        kiloliterField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[kiloliterField.text doubleValue]];
        
        [self setKiloliter:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milliliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:milliliter];
            [milliliterField setText:y];
        }
        
        if (fabs(teaspoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:teaspoon];
            [teaspoonField setText:y];
        }
        
        if (fabs(centiliter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:centiliter];
            [centiliterField setText:y];
        }
        
        if (fabs(tablespoon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:tablespoon];
            [tablespoonField setText:y];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:y];
        }
        
        if (fabs(cup.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:cup];
            [cupField setText:y];
        }
        
        if (fabs(pint.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:pint];
            [pintField setText:y];
        }
        
        if (fabs(liter.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:liter];
            [literField setText:y];
        }
        
        if (fabs(gallon.doubleValue) < 0.000001)
        {
            NSString *y = [scientificFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        else
        {
            NSString *y = [decimalFormatter stringFromNumber:gallon];
            [gallonField setText:y];
        }
        
        if ((fabs(kiloliter.doubleValue) == 0))
        {
            [milliliterField setText:@""];
            [teaspoonField setText:@""];
            [centiliterField setText:@""];
            [tablespoonField setText:@""];
            [ounceField setText:@""];
            [cupField setText:@""];
            [pintField setText:@""];
            [literField setText:@""];
            [gallonField setText:@""];
        }
    }
}

@end
