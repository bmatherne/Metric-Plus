//
//  BMTemperatureController.m
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import "BMTemperatureController.h"

@interface BMTemperatureController ()

@end

@implementation BMTemperatureController

@synthesize celcius, fahrenheit, kelvin, celciusField, fahrenheitField, kelvinField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Temperature";
        self.tabBarItem.image = [UIImage imageNamed:@"93-thermometer.png"];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [scrollView setScrollEnabled:YES];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize tabBarSize = self.tabBarController.tabBar.bounds.size;
    CGSize navBarSize = navBar.bounds.size;
    
    scrollView.frame = CGRectMake(0, 44, 320, (screenBound.size.height - navBarSize.height - tabBarSize.height));
    [scrollView setContentSize:CGSizeMake(320, 200)];
}

// Clear the text fields when the view disappears
- (void)viewWillDisappear:(BOOL)animated
{
    [celciusField setText:@""];
    [fahrenheitField setText:@""];
    [kelvinField setText:@""];
    celcius = nil;
    fahrenheit = nil;
    kelvin = nil;
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
    celciusField.inputAccessoryView = keyboardToolbar;
    fahrenheitField.inputAccessoryView = keyboardToolbar;
    kelvinField.inputAccessoryView = keyboardToolbar;
    
    // Round the corners of the labels.
    celciusLabel.layer.cornerRadius = 8;
    fahrenheitLabel.layer.cornerRadius = 8;
    kelvinLabel.layer.cornerRadius = 8;
    
    // When the text is edited in the text fields, the
    // appropriate methods will be called.
    [celciusField addTarget:self action:@selector(celciusFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [fahrenheitField addTarget:self action:@selector(fahrenheitFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [kelvinField addTarget:self action:@selector(kelvinFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
    if ([celciusField isFirstResponder])
        [celciusField resignFirstResponder];
    
    else if ([fahrenheitField isFirstResponder])
        [fahrenheitField resignFirstResponder];
    
    else if ([kelvinField isFirstResponder])
        [kelvinField resignFirstResponder];
}

#pragma mark - UIButton Method

- (IBAction)clearTextFields {
    [celciusField setText:@""];
    [fahrenheitField setText:@""];
    [kelvinField setText:@""];
    celcius = nil;
    fahrenheit = nil;
    kelvin = nil;
}

#pragma mark - Setter Methods

- (void)setCelcius:(NSNumber *)c
{
    celcius = c;
    
    fahrenheit = [NSNumber numberWithDouble:([c doubleValue] * 1.8 + 32.00)];
    kelvin = [NSNumber numberWithDouble:([c doubleValue] + 273.15)];
}

- (void)setFahrenheit:(NSNumber *)f
{
    fahrenheit = f;
    
    celcius = [NSNumber numberWithDouble:(([f doubleValue] - 32.0) / 1.8)];
    kelvin = [NSNumber numberWithDouble:(([f doubleValue] - 32.0) / 1.8 + 273.15)];
}

- (void)setKelvin:(NSNumber *)k
{
    kelvin = k;
    
    celcius = [NSNumber numberWithDouble:([k doubleValue] - 273.15)];
    fahrenheit = [NSNumber numberWithDouble:(([k doubleValue] - 273.15) * 1.8 + 32.0)];
}

#pragma mark - Calculation Methods

- (void)celciusFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:celciusField.text];
    
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
        celciusField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            celciusField.text = string;
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
            celciusField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        celciusField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[celciusField.text doubleValue]];
    
    [self setCelcius:x];
    
    NSNumberFormatter *temperatureFormatter = [[NSNumberFormatter alloc] init];
    [temperatureFormatter setMaximumFractionDigits:3];
    [temperatureFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *fString = [temperatureFormatter stringFromNumber:fahrenheit];
    NSString *kString = [temperatureFormatter stringFromNumber:kelvin];
    
    [fahrenheitField setText:fString];
    [kelvinField setText:kString];
    
    if ([celciusField.text isEqual:@""] || [celciusField.text isEqual:@"-"])
    {
        [fahrenheitField setText:@""];
        [kelvinField setText:@""];
    }
}

- (void)fahrenheitFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:fahrenheitField.text];
    
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
        fahrenheitField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            fahrenheitField.text = string;
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
            fahrenheitField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        fahrenheitField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[fahrenheitField.text doubleValue]];
    
    [self setFahrenheit:x];
    
    NSNumberFormatter *temperatureFormatter = [[NSNumberFormatter alloc] init];
    [temperatureFormatter setMaximumFractionDigits:3];
    [temperatureFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *cString = [temperatureFormatter stringFromNumber:celcius];
    NSString *kString = [temperatureFormatter stringFromNumber:kelvin];
    
    [celciusField setText:cString];
    [kelvinField setText:kString];
    
    if ([fahrenheitField.text isEqual:@""] || [fahrenheitField.text isEqual:@"-"])
    {
        [celciusField setText:@""];
        [kelvinField setText:@""];
    }
}

- (void)kelvinFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:kelvinField.text];
    
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
        kelvinField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            kelvinField.text = string;
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
            kelvinField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        kelvinField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[kelvinField.text doubleValue]];
    
    [self setKelvin:x];
    
    NSNumberFormatter *temperatureFormatter = [[NSNumberFormatter alloc] init];
    [temperatureFormatter setMaximumFractionDigits:3];
    [temperatureFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *cString = [temperatureFormatter stringFromNumber:celcius];
    NSString *fString = [temperatureFormatter stringFromNumber:fahrenheit];
    
    [celciusField setText:cString];
    [fahrenheitField setText:fString];
    
    if ([kelvinField.text isEqual:@""] || [kelvinField.text isEqual:@"-"])
    {
        [celciusField setText:@""];
        [fahrenheitField setText:@""];
    }
}

- (void)negativeField:(id)sender
{
    if ([celciusField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:celciusField.text];
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
        celciusField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[celciusField.text doubleValue]];
        
        [self setCelcius:x];
        
        NSNumberFormatter *temperatureFormatter = [[NSNumberFormatter alloc] init];
        [temperatureFormatter setMaximumFractionDigits:3];
        [temperatureFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *fString = [temperatureFormatter stringFromNumber:fahrenheit];
        NSString *kString = [temperatureFormatter stringFromNumber:kelvin];
        
        [fahrenheitField setText:fString];
        [kelvinField setText:kString];
        
        if ([celciusField.text isEqual:@""] || [celciusField.text isEqual:@"-"])
        {
            [fahrenheitField setText:@""];
            [kelvinField setText:@""];
        }
    }
    
    if ([fahrenheitField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:fahrenheitField.text];
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
        fahrenheitField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[fahrenheitField.text doubleValue]];
        
        [self setFahrenheit:x];
        
        NSNumberFormatter *temperatureFormatter = [[NSNumberFormatter alloc] init];
        [temperatureFormatter setMaximumFractionDigits:3];
        [temperatureFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *cString = [temperatureFormatter stringFromNumber:celcius];
        NSString *kString = [temperatureFormatter stringFromNumber:kelvin];
        
        [celciusField setText:cString];
        [kelvinField setText:kString];
        
        if ([fahrenheitField.text isEqual:@""] || [fahrenheitField.text isEqual:@"-"])
        {
            [celciusField setText:@""];
            [kelvinField setText:@""];
        }
    }
    
    if ([kelvinField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:kelvinField.text];
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
        kelvinField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[kelvinField.text doubleValue]];
        
        [self setKelvin:x];
        
        NSNumberFormatter *temperatureFormatter = [[NSNumberFormatter alloc] init];
        [temperatureFormatter setMaximumFractionDigits:3];
        [temperatureFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *cString = [temperatureFormatter stringFromNumber:celcius];
        NSString *fString = [temperatureFormatter stringFromNumber:fahrenheit];
        
        [celciusField setText:cString];
        [fahrenheitField setText:fString];
        
        if ([kelvinField.text isEqual:@""] || [kelvinField.text isEqual:@"-"])
        {
            [celciusField setText:@""];
            [fahrenheitField setText:@""];
        }
    }
}

@end