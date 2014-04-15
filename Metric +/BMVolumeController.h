//
//  BMVolumeController.h
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMVolumeController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *milliliterField;
    IBOutlet UITextField *teaspoonField;
    IBOutlet UITextField *centiliterField;
    IBOutlet UITextField *tablespoonField;
    IBOutlet UITextField *ounceField;
    IBOutlet UITextField *cupField;
    IBOutlet UITextField *pintField;
    IBOutlet UITextField *literField;
    IBOutlet UITextField *gallonField;
    IBOutlet UITextField *kiloliterField;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationBar *navBar;
    
    IBOutlet UILabel *milliliterLabel;
    IBOutlet UILabel *teaspoonLabel;
    IBOutlet UILabel *centiliterLabel;
    IBOutlet UILabel *tablespoonLabel;
    IBOutlet UILabel *ounceLabel;
    IBOutlet UILabel *cupLabel;
    IBOutlet UILabel *pintLabel;
    IBOutlet UILabel *literLabel;
    IBOutlet UILabel *gallonLabel;
    IBOutlet UILabel *kiloliterLabel;
    
    IBOutlet UIButton *clearButton;
    
    UIToolbar *keyboardToolbar;
}

@property (nonatomic, strong) NSNumber *milliliter, *teaspoon, *centiliter, *tablespoon, *ounce, *cup, *pint, *liter, *gallon, *kiloliter;
@property (nonatomic, strong) UITextField *milliliterField;
@property (nonatomic, strong) UITextField *teaspoonField;
@property (nonatomic, strong) UITextField *centiliterField;
@property (nonatomic, strong) UITextField *tablespoonField;
@property (nonatomic, strong) UITextField *ounceField;
@property (nonatomic, strong) UITextField *cupField;
@property (nonatomic, strong) UITextField *pintField;
@property (nonatomic, strong) UITextField *literField;
@property (nonatomic, strong) UITextField *gallonField;
@property (nonatomic, strong) UITextField *kiloliterField;

- (IBAction)clearTextFields;
- (void)milliliterFieldDidChange:(id)sender;
- (void)teaspoonFieldDidChange:(id)sender;
- (void)centiliterFieldDidChange:(id)sender;
- (void)tablespoonFieldDidChange:(id)sender;
- (void)ounceFieldDidChange:(id)sender;
- (void)cupFieldDidChange:(id)sender;
- (void)pintFieldDidChange:(id)sender;
- (void)literFieldDidChange:(id)sender;
- (void)gallonFieldDidChange:(id)sender;
- (void)kiloliterFieldDidChange:(id)sender;
- (void)negativeField:(id)sender;
- (void)resignKeyboard:(id)sender;

@end
