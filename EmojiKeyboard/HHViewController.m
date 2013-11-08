//
//  HHViewController.m
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import "HHViewController.h"
#import "HHDemoKeyboardBuilder.h"
#import "HHEmojiKeyboard.h"
#import "HHEmojiKeyboardItemGroupView.h"

@interface HHViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)switchKeyboard:(id)sender;

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.iCarousel.type = iCarouselTypeCoverFlow2;
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

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //generate 100 buttons
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    NSUInteger count = [HHDemoKeyboardBuilder sharedEmoticonsKeyboard].keyItemGroupViews.count;

    return count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
//    CGSize size = carousel.contentOffset;
	HHEmojiKeyboardItemGroupView *pagerViews = (HHEmojiKeyboardItemGroupView *)view;
    if (pagerViews == nil) {
        pagerViews = [[HHDemoKeyboardBuilder sharedEmoticonsKeyboard].keyItemGroupViews objectAtIndex:index];
    }
    NSLog(@"%@", NSStringFromCGRect(pagerViews.frame));
	return pagerViews;
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

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
