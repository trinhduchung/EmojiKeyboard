//
//  HHViewController.m
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import "HHViewController.h"
#import "HHDemoKeyboardBuilder.h"

@interface HHViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)switchKeyboard:(id)sender;

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchKeyboard:(id)sender {
    if (self.textView.isFirstResponder) {
        if (self.textView.emoticonsKeyboard) [self.textView switchToDefaultKeyboard];
        else [self.textView switchToEmoticonsKeyboard:[HHDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    }else{
        [self.textView switchToEmoticonsKeyboard:[HHDemoKeyboardBuilder sharedEmoticonsKeyboard]];
        [self.textView becomeFirstResponder];
    }
    
}
@end
