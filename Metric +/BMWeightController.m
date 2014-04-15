//
//  BMWeightController.m
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import "BMWeightController.h"

@interface BMWeightController ()

@end

@implementation BMWeightController

@synthesize milligram, gram, ounce, pound, kilogram, stone, shortTon, metricTon, longTon, milligramField, gramField, ounceField, poundField, kilogramField, stoneField, shortTonField, metricTonField, longTonField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Weight";
        self.tabBarItem.image = [UIImage imageNamed:@"89-dumbells.png"];
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
    [milligramField setText:@""];
    [gramField setText:@""];
    [ounceField setText:@""];
    [poundField setText:@""];
    [kilogramField setText:@""];
    [stoneField setText:@""];
    [shortTonField setText:@""];
    [metricTonField setText:@""];
    [longTonField setText:@""];
    milligram = nil;
    gram = nil;
    ounce = nil;
    pound = nil;
    kilogram = nil;
    stone = nil;
    shortTon = nil;
    metricTon = nil;
    longTon = nil;
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
    milligramField.inputAccessoryView = keyboardToolbar;
    gramField.inputAccessoryView = keyboardToolbar;
    ounceField.inputAccessoryView = keyboardToolbar;
    poundField.inputAccessoryView = keyboardToolbar;
    kilogramField.inputAccessoryView = keyboardToolbar;
    stoneField.inputAccessoryView = keyboardToolbar;
    shortTonField.inputAccessoryView = keyboardToolbar;
    metricTonField.inputAccessoryView = keyboardToolbar;
    longTonField.inputAccessoryView = keyboardToolbar;
    
    // Round the corners of the labels.
    milligramLabel.layer.cornerRadius = 8;
    gramLabel.layer.cornerRadius = 8;
    ounceLabel.layer.cornerRadius = 8;
    poundLabel.layer.cornerRadius = 8;
    kilogramLabel.layer.cornerRadius = 8;
    stoneLabel.layer.cornerRadius = 8;
    shortTonLabel.layer.cornerRadius = 8;
    metricTonLabel.layer.cornerRadius = 8;
    longTonLabel.layer.cornerRadius = 8;
    
    // When the text is edited in the text fields, the
    // appropriate methods will be called.
    [milligramField addTarget:self action:@selector(milligramFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [gramField addTarget:self action:@selector(gramFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [ounceField addTarget:self action:@selector(ounceFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [poundField addTarget:self action:@selector(poundFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [kilogramField addTarget:self action:@selector(kilogramFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [stoneField addTarget:self action:@selector(stoneFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [shortTonField addTarget:self action:@selector(shortTonFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [metricTonField addTarget:self action:@selector(metricTonFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [longTonField addTarget:self action:@selector(longTonFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
    if ([milligramField isFirstResponder])
        [milligramField resignFirstResponder];
    
    else if ([gramField isFirstResponder])
        [gramField resignFirstResponder];
    
    else if ([ounceField isFirstResponder])
        [ounceField resignFirstResponder];
    
    else if ([poundField isFirstResponder])
        [poundField resignFirstResponder];
    
    else if ([kilogramField isFirstResponder])
        [kilogramField resignFirstResponder];
    
    else if ([stoneField isFirstResponder])
        [stoneField resignFirstResponder];
    
    else if ([shortTonField isFirstResponder])
        [shortTonField resignFirstResponder];
    
    else if ([metricTonField isFirstResponder])
        [metricTonField resignFirstResponder];
    
    else if ([longTonField isFirstResponder])
        [longTonField resignFirstResponder];
}

#pragma mark - UIButton Method

- (IBAction)clearTextFields {
    [milligramField setText:@""];
    [gramField setText:@""];
    [ounceField setText:@""];
    [poundField setText:@""];
    [kilogramField setText:@""];
    [stoneField setText:@""];
    [shortTonField setText:@""];
    [metricTonField setText:@""];
    [longTonField setText:@""];
    milligram = nil;
    gram = nil;
    ounce = nil;
    pound = nil;
    kilogram = nil;
    stone = nil;
    shortTon = nil;
    metricTon = nil;
    longTon = nil;
}

#pragma mark - Setter Methods

- (void)setMilligram:(NSNumber *)m
{
    milligram = m;
    
    gram = [NSNumber numberWithDouble:([m doubleValue] / 1000.0)];
    ounce = [NSNumber numberWithDouble:([m doubleValue] / 28350.0)];
    pound = [NSNumber numberWithDouble:([m doubleValue] / 4.5359e+5)];
    kilogram = [NSNumber numberWithDouble:([m doubleValue] / 1.0000e+6)];
    stone = [NSNumber numberWithDouble:([m doubleValue] / 6.3503e+6)];
    shortTon = [NSNumber numberWithDouble:([m doubleValue] / 9.0718e+8)];
    metricTon = [NSNumber numberWithDouble:([m doubleValue] / 1.0000e+9)];
    longTon = [NSNumber numberWithDouble:([m doubleValue] / 1.0160e+9)];
}

- (void)setGram:(NSNumber *)g
{
    gram = g;
    
    milligram = [NSNumber numberWithDouble:([g doubleValue] * 1000.0)];
    ounce = [NSNumber numberWithDouble:([g doubleValue] / 28.350)];
    pound = [NSNumber numberWithDouble:([g doubleValue] / 453.59)];
    kilogram = [NSNumber numberWithDouble:([g doubleValue] / 1000.0)];
    stone = [NSNumber numberWithDouble:([g doubleValue] / 6350.3)];
    shortTon = [NSNumber numberWithDouble:([g doubleValue] / 9.0718e+5)];
    metricTon = [NSNumber numberWithDouble:([g doubleValue] / 1.0000e+6)];
    longTon = [NSNumber numberWithDouble:([g doubleValue] / 1.0160e+6)];
}

- (void)setOunce:(NSNumber *)o
{
    ounce = o;
    
    milligram = [NSNumber numberWithDouble:([o doubleValue] * 28350.0)];
    gram = [NSNumber numberWithDouble:([o doubleValue] * 28.350)];
    pound = [NSNumber numberWithDouble:([o doubleValue] / 16.000)];
    kilogram = [NSNumber numberWithDouble:([o doubleValue] / 35.274)];
    stone = [NSNumber numberWithDouble:([o doubleValue] / 224.00)];
    shortTon = [NSNumber numberWithDouble:([o doubleValue] / 32000.0)];
    metricTon = [NSNumber numberWithDouble:([o doubleValue] / 35274.0)];
    longTon = [NSNumber numberWithDouble:([o doubleValue] / 35840.0)];
}

- (void)setPound:(NSNumber *)p
{
    pound = p;
    
    milligram = [NSNumber numberWithDouble:([p doubleValue] * 4.5359e+5)];
    gram = [NSNumber numberWithDouble:([p doubleValue] * 453.59)];
    ounce = [NSNumber numberWithDouble:([p doubleValue] * 16.000)];
    kilogram = [NSNumber numberWithDouble:([p doubleValue] / 2.2046)];
    stone = [NSNumber numberWithDouble:([p doubleValue] / 14.000)];
    shortTon = [NSNumber numberWithDouble:([p doubleValue] / 2000.0)];
    metricTon = [NSNumber numberWithDouble:([p doubleValue] / 2204.6)];
    longTon = [NSNumber numberWithDouble:([p doubleValue] / 2240.0)];
}

- (void)setKilogram:(NSNumber *)k
{
    kilogram = k;
    
    milligram = [NSNumber numberWithDouble:([k doubleValue] * 1.0000e+6)];
    gram = [NSNumber numberWithDouble:([k doubleValue] * 1000.0)];
    ounce = [NSNumber numberWithDouble:([k doubleValue] * 35.274)];
    pound = [NSNumber numberWithDouble:([k doubleValue] * 2.2046)];
    stone = [NSNumber numberWithDouble:([k doubleValue] / 6.3503)];
    shortTon = [NSNumber numberWithDouble:([k doubleValue] / 907.18)];
    metricTon = [NSNumber numberWithDouble:([k doubleValue] / 1000.0)];
    longTon = [NSNumber numberWithDouble:([k doubleValue] / 1016.0)];
}

- (void)setStone:(NSNumber *)s
{
    stone = s;
    
    milligram = [NSNumber numberWithDouble:([s doubleValue] * 6.3503e+6)];
    gram = [NSNumber numberWithDouble:([s doubleValue] * 6350.3)];
    ounce = [NSNumber numberWithDouble:([s doubleValue] * 224.00)];
    pound = [NSNumber numberWithDouble:([s doubleValue] * 14.000)];
    kilogram = [NSNumber numberWithDouble:([s doubleValue] * 6.3503)];
    shortTon = [NSNumber numberWithDouble:([s doubleValue] / 142.86)];
    metricTon = [NSNumber numberWithDouble:([s doubleValue] / 157.47)];
    longTon = [NSNumber numberWithDouble:([s doubleValue] / 160.00)];
}

- (void)setShortTon:(NSNumber *)sT
{
    shortTon = sT;
    
    milligram = [NSNumber numberWithDouble:([sT doubleValue] * 9.0718e+8)];
    gram = [NSNumber numberWithDouble:([sT doubleValue] * 9.0718e+5)];
    ounce = [NSNumber numberWithDouble:([sT doubleValue] * 32000.0)];
    pound = [NSNumber numberWithDouble:([sT doubleValue] * 2000.0)];
    kilogram = [NSNumber numberWithDouble:([sT doubleValue] * 907.18)];
    stone = [NSNumber numberWithDouble:([sT doubleValue] * 142.86)];
    metricTon = [NSNumber numberWithDouble:([sT doubleValue] / 1.1023)];
    longTon = [NSNumber numberWithDouble:([sT doubleValue] / 1.1200)];
}

- (void)setMetricTon:(NSNumber *)mT
{
    metricTon = mT;
    
    milligram = [NSNumber numberWithDouble:([mT doubleValue] * 1.0000e+9)];
    gram = [NSNumber numberWithDouble:([mT doubleValue] * 1.0000e+6)];
    ounce = [NSNumber numberWithDouble:([mT doubleValue] * 35274.0)];
    pound = [NSNumber numberWithDouble:([mT doubleValue] * 2204.6)];
    kilogram = [NSNumber numberWithDouble:([mT doubleValue] * 1000.0)];
    stone = [NSNumber numberWithDouble:([mT doubleValue] * 157.47)];
    shortTon = [NSNumber numberWithDouble:([mT doubleValue] * 1.1023)];
    longTon = [NSNumber numberWithDouble:([mT doubleValue] / 1.0160)];
}

- (void)setLongTon:(NSNumber *)lT
{
    longTon = lT;
    
    milligram = [NSNumber numberWithDouble:([lT doubleValue] * 1.0160e+9)];
    gram = [NSNumber numberWithDouble:([lT doubleValue] * 1.0160e+6)];
    ounce = [NSNumber numberWithDouble:([lT doubleValue] * 35840.0)];
    pound = [NSNumber numberWithDouble:([lT doubleValue] * 2240.0)];
    kilogram = [NSNumber numberWithDouble:([lT doubleValue] * 1016.0)];
    stone = [NSNumber numberWithDouble:([lT doubleValue] * 160.00)];
    shortTon = [NSNumber numberWithDouble:([lT doubleValue] * 1.1200)];
    metricTon = [NSNumber numberWithDouble:([lT doubleValue] * 1.0160)];
}

#pragma mark - Calculation Methods

- (void)milligramFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:milligramField.text];
    
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
        milligramField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            milligramField.text = string;
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
            milligramField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        milligramField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[milligramField.text doubleValue]];
    
    [self setMilligram:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(milligram.doubleValue) == 0))
    {
        [gramField setText:@""];
        [ounceField setText:@""];
        [poundField setText:@""];
        [kilogramField setText:@""];
        [stoneField setText:@""];
        [shortTonField setText:@""];
        [metricTonField setText:@""];
        [longTonField setText:@""];
    }
}

- (void)gramFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:gramField.text];
    
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
        gramField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            gramField.text = string;
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
            gramField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        gramField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[gramField.text doubleValue]];
    
    [self setGram:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(gram.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [ounceField setText:@""];
        [poundField setText:@""];
        [kilogramField setText:@""];
        [stoneField setText:@""];
        [shortTonField setText:@""];
        [metricTonField setText:@""];
        [longTonField setText:@""];
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
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(ounce.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [gramField setText:@""];
        [poundField setText:@""];
        [kilogramField setText:@""];
        [stoneField setText:@""];
        [shortTonField setText:@""];
        [metricTonField setText:@""];
        [longTonField setText:@""];
    }
}

- (void)poundFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:poundField.text];
    
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
        poundField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            poundField.text = string;
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
            poundField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        poundField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[poundField.text doubleValue]];
    
    [self setPound:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(pound.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [gramField setText:@""];
        [ounceField setText:@""];
        [kilogramField setText:@""];
        [stoneField setText:@""];
        [shortTonField setText:@""];
        [metricTonField setText:@""];
        [longTonField setText:@""];
    }
}

- (void)kilogramFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:kilogramField.text];
    
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
        kilogramField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            kilogramField.text = string;
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
            kilogramField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        kilogramField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[kilogramField.text doubleValue]];
    
    [self setKilogram:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(kilogram.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [gramField setText:@""];
        [ounceField setText:@""];
        [poundField setText:@""];
        [stoneField setText:@""];
        [shortTonField setText:@""];
        [metricTonField setText:@""];
        [longTonField setText:@""];
    }
}

- (void)stoneFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:stoneField.text];
    
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
        stoneField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            stoneField.text = string;
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
            stoneField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        stoneField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[stoneField.text doubleValue]];
    
    [self setStone:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(stone.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [gramField setText:@""];
        [ounceField setText:@""];
        [poundField setText:@""];
        [kilogramField setText:@""];
        [shortTonField setText:@""];
        [metricTonField setText:@""];
        [longTonField setText:@""];
    }
}

- (void)shortTonFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:shortTonField.text];
    
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
        shortTonField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            shortTonField.text = string;
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
            shortTonField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        shortTonField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[shortTonField.text doubleValue]];
    
    [self setShortTon:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(shortTon.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [gramField setText:@""];
        [ounceField setText:@""];
        [poundField setText:@""];
        [kilogramField setText:@""];
        [stoneField setText:@""];
        [metricTonField setText:@""];
        [longTonField setText:@""];
    }
}

- (void)metricTonFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:metricTonField.text];
    
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
        metricTonField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            metricTonField.text = string;
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
            metricTonField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        metricTonField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[metricTonField.text doubleValue]];
    
    [self setMetricTon:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(longTon.doubleValue) < 0.000001)
    {
        NSString *lTString = [scientificFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    else
    {
        NSString *lTString = [decimalFormatter stringFromNumber:longTon];
        [longTonField setText:lTString];
    }
    
    if ((fabs(metricTon.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [gramField setText:@""];
        [ounceField setText:@""];
        [poundField setText:@""];
        [kilogramField setText:@""];
        [stoneField setText:@""];
        [shortTonField setText:@""];
        [longTonField setText:@""];
    }
}

- (void)longTonFieldDidChange:(id)sender
{
    // Make sure there aren't two decimal points
    NSMutableString *string = [NSMutableString stringWithString:longTonField.text];
    
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
        longTonField.text = string;
    }
    // Do the same thing if a negative sign is the
    // first character, followed by a decimal point.
    if ([string hasPrefix:@"-"])
    {
        NSRange range = [string rangeOfString:@"."];
        if (range.location == 1)
        {
            [string insertString:@"0" atIndex:1];
            longTonField.text = string;
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
            longTonField.text = string;
        }
    } // End search for duplicate decimal points
    
    // Check for negative signs in the middle of the string
    NSRange stringRange = [string rangeOfString:@"-"];
    
    if ((stringRange.location != NSNotFound) && (stringRange.location > 0))
    {
        [string deleteCharactersInRange:NSMakeRange(stringRange.location, 1)];
        longTonField.text = string;
    } // End search for embeded negative signs
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:[longTonField.text doubleValue]];
    
    [self setLongTon:x];
    
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setMaximumFractionDigits:6];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    [scientificFormatter setMaximumFractionDigits:6];
    [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    
    if (fabs(milligram.doubleValue) < 0.000001)
    {
        NSString *mString = [scientificFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    else
    {
        NSString *mString = [decimalFormatter stringFromNumber:milligram];
        [milligramField setText:mString];
    }
    
    if (fabs(gram.doubleValue) < 0.000001)
    {
        NSString *gString = [scientificFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    else
    {
        NSString *gString = [decimalFormatter stringFromNumber:gram];
        [gramField setText:gString];
    }
    
    if (fabs(ounce.doubleValue) < 0.000001)
    {
        NSString *oString = [scientificFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    else
    {
        NSString *oString = [decimalFormatter stringFromNumber:ounce];
        [ounceField setText:oString];
    }
    
    if (fabs(pound.doubleValue) < 0.000001)
    {
        NSString *pString = [scientificFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    else
    {
        NSString *pString = [decimalFormatter stringFromNumber:pound];
        [poundField setText:pString];
    }
    
    if (fabs(kilogram.doubleValue) < 0.000001)
    {
        NSString *kString = [scientificFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    else
    {
        NSString *kString = [decimalFormatter stringFromNumber:kilogram];
        [kilogramField setText:kString];
    }
    
    if (fabs(stone.doubleValue) < 0.000001)
    {
        NSString *sString = [scientificFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    else
    {
        NSString *sString = [decimalFormatter stringFromNumber:stone];
        [stoneField setText:sString];
    }
    
    if (fabs(shortTon.doubleValue) < 0.000001)
    {
        NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    else
    {
        NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
        [shortTonField setText:sTString];
    }
    
    if (fabs(metricTon.doubleValue) < 0.000001)
    {
        NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    else
    {
        NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
        [metricTonField setText:mTString];
    }
    
    if ((fabs(longTon.doubleValue) == 0))
    {
        [milligramField setText:@""];
        [gramField setText:@""];
        [ounceField setText:@""];
        [poundField setText:@""];
        [kilogramField setText:@""];
        [stoneField setText:@""];
        [shortTonField setText:@""];
        [metricTonField setText:@""];
    }
}

- (void)negativeField:(id)sender
{
    if ([milligramField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:milligramField.text];
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
        milligramField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[milligramField.text doubleValue]];
        
        [self setMilligram:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(milligram.doubleValue) == 0))
        {
            [gramField setText:@""];
            [ounceField setText:@""];
            [poundField setText:@""];
            [kilogramField setText:@""];
            [stoneField setText:@""];
            [shortTonField setText:@""];
            [metricTonField setText:@""];
            [longTonField setText:@""];
        }
    }
    else if ([gramField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:gramField.text];
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
        gramField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[gramField.text doubleValue]];
        
        [self setGram:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(gram.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [ounceField setText:@""];
            [poundField setText:@""];
            [kilogramField setText:@""];
            [stoneField setText:@""];
            [shortTonField setText:@""];
            [metricTonField setText:@""];
            [longTonField setText:@""];
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
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(ounce.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [gramField setText:@""];
            [poundField setText:@""];
            [kilogramField setText:@""];
            [stoneField setText:@""];
            [shortTonField setText:@""];
            [metricTonField setText:@""];
            [longTonField setText:@""];
        }
    }
    else if ([poundField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:poundField.text];
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
        poundField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[poundField.text doubleValue]];
        
        [self setPound:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(pound.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [gramField setText:@""];
            [ounceField setText:@""];
            [kilogramField setText:@""];
            [stoneField setText:@""];
            [shortTonField setText:@""];
            [metricTonField setText:@""];
            [longTonField setText:@""];
        }
    }
    else if ([kilogramField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:kilogramField.text];
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
        kilogramField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[kilogramField.text doubleValue]];
        
        [self setKilogram:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(kilogram.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [gramField setText:@""];
            [ounceField setText:@""];
            [poundField setText:@""];
            [stoneField setText:@""];
            [shortTonField setText:@""];
            [metricTonField setText:@""];
            [longTonField setText:@""];
        }
    }
    else if ([stoneField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:stoneField.text];
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
        stoneField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[stoneField.text doubleValue]];
        
        [self setStone:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(stone.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [gramField setText:@""];
            [ounceField setText:@""];
            [poundField setText:@""];
            [kilogramField setText:@""];
            [shortTonField setText:@""];
            [metricTonField setText:@""];
            [longTonField setText:@""];
        }
    }
    else if ([shortTonField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:shortTonField.text];
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
        shortTonField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[shortTonField.text doubleValue]];
        
        [self setShortTon:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(shortTon.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [gramField setText:@""];
            [ounceField setText:@""];
            [poundField setText:@""];
            [kilogramField setText:@""];
            [stoneField setText:@""];
            [metricTonField setText:@""];
            [longTonField setText:@""];
        }
    }
    else if ([metricTonField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:metricTonField.text];
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
        metricTonField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[metricTonField.text doubleValue]];
        
        [self setMetricTon:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(longTon.doubleValue) < 0.000001)
        {
            NSString *lTString = [scientificFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        else
        {
            NSString *lTString = [decimalFormatter stringFromNumber:longTon];
            [longTonField setText:lTString];
        }
        
        if ((fabs(metricTon.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [gramField setText:@""];
            [ounceField setText:@""];
            [poundField setText:@""];
            [kilogramField setText:@""];
            [stoneField setText:@""];
            [shortTonField setText:@""];
            [longTonField setText:@""];
        }
    }
    else if ([longTonField isFirstResponder])
    {
        NSMutableString *string = [NSMutableString stringWithString:longTonField.text];
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
        longTonField.text = string;
        
        
        // Perform the calculations for the other text fields.
        NSNumber *x = [[NSNumber alloc] initWithDouble:[longTonField.text doubleValue]];
        
        [self setLongTon:x];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setMaximumFractionDigits:6];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
        [scientificFormatter setMaximumFractionDigits:6];
        [scientificFormatter setNumberStyle:NSNumberFormatterScientificStyle];
        
        if (fabs(milligram.doubleValue) < 0.000001)
        {
            NSString *mString = [scientificFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        else
        {
            NSString *mString = [decimalFormatter stringFromNumber:milligram];
            [milligramField setText:mString];
        }
        
        if (fabs(gram.doubleValue) < 0.000001)
        {
            NSString *gString = [scientificFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        else
        {
            NSString *gString = [decimalFormatter stringFromNumber:gram];
            [gramField setText:gString];
        }
        
        if (fabs(ounce.doubleValue) < 0.000001)
        {
            NSString *oString = [scientificFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        else
        {
            NSString *oString = [decimalFormatter stringFromNumber:ounce];
            [ounceField setText:oString];
        }
        
        if (fabs(pound.doubleValue) < 0.000001)
        {
            NSString *pString = [scientificFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        else
        {
            NSString *pString = [decimalFormatter stringFromNumber:pound];
            [poundField setText:pString];
        }
        
        if (fabs(kilogram.doubleValue) < 0.000001)
        {
            NSString *kString = [scientificFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        else
        {
            NSString *kString = [decimalFormatter stringFromNumber:kilogram];
            [kilogramField setText:kString];
        }
        
        if (fabs(stone.doubleValue) < 0.000001)
        {
            NSString *sString = [scientificFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        else
        {
            NSString *sString = [decimalFormatter stringFromNumber:stone];
            [stoneField setText:sString];
        }
        
        if (fabs(shortTon.doubleValue) < 0.000001)
        {
            NSString *sTString = [scientificFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        else
        {
            NSString *sTString = [decimalFormatter stringFromNumber:shortTon];
            [shortTonField setText:sTString];
        }
        
        if (fabs(metricTon.doubleValue) < 0.000001)
        {
            NSString *mTString = [scientificFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        else
        {
            NSString *mTString = [decimalFormatter stringFromNumber:metricTon];
            [metricTonField setText:mTString];
        }
        
        if ((fabs(longTon.doubleValue) == 0))
        {
            [milligramField setText:@""];
            [gramField setText:@""];
            [ounceField setText:@""];
            [poundField setText:@""];
            [kilogramField setText:@""];
            [stoneField setText:@""];
            [shortTonField setText:@""];
            [metricTonField setText:@""];
        }
    }
}

@end
