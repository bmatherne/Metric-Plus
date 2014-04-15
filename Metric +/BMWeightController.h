//
//  BMWeightController.h
//  Metric +
//
//  Created by Beau Matherne on 7/19/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMWeightController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *milligramField;
    IBOutlet UITextField *gramField;
    IBOutlet UITextField *ounceField;
    IBOutlet UITextField *poundField;
    IBOutlet UITextField *kilogramField;
    IBOutlet UITextField *stoneField;
    IBOutlet UITextField *shortTonField;
    IBOutlet UITextField *metricTonField;
    IBOutlet UITextField *longTonField;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationBar *navBar;
    
    IBOutlet UILabel *milligramLabel;
    IBOutlet UILabel *gramLabel;
    IBOutlet UILabel *ounceLabel;
    IBOutlet UILabel *poundLabel;
    IBOutlet UILabel *kilogramLabel;
    IBOutlet UILabel *stoneLabel;
    IBOutlet UILabel *shortTonLabel;
    IBOutlet UILabel *metricTonLabel;
    IBOutlet UILabel *longTonLabel;
    
    IBOutlet UIButton *clearButton;
    
    UIToolbar *keyboardToolbar;
}

@property (nonatomic, strong) NSNumber *milligram, *gram, *ounce, *pound, *kilogram, *stone, *shortTon, *metricTon, *longTon;
@property (nonatomic, strong) UITextField *milligramField;
@property (nonatomic, strong) UITextField *gramField;
@property (nonatomic, strong) UITextField *ounceField;
@property (nonatomic, strong) UITextField *poundField;
@property (nonatomic, strong) UITextField *kilogramField;
@property (nonatomic, strong) UITextField *stoneField;
@property (nonatomic, strong) UITextField *metricTonField;
@property (nonatomic, strong) UITextField *shortTonField;
@property (nonatomic, strong) UITextField *longTonField;

- (IBAction)clearTextFields;
- (void)milligramFieldDidChange:(id)sender;
- (void)gramFieldDidChange:(id)sender;
- (void)ounceFieldDidChange:(id)sender;
- (void)poundFieldDidChange:(id)sender;
- (void)kilogramFieldDidChange:(id)sender;
- (void)stoneFieldDidChange:(id)sender;
- (void)shortTonFieldDidChange:(id)sender;
- (void)metricTonFieldDidChange:(id)sender;
- (void)longTonFieldDidChange:(id)sender;
- (void)negativeField:(id)sender;
- (void)resignKeyboard:(id)sender;

@end
