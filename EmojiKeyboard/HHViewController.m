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
    self.iCarousel.backgroundColor = [UIColor grayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.textView becomeFirstResponder];
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
    NSUInteger count = [HHDemoKeyboardBuilder sharedEmoticonsKeyboard].keyItemGroupViews.count;

    return count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
//    CGSize size = carousel.contentOffset;
    /*
    UIScrollView *itemView = (UIScrollView *)view;
    if (itemView == nil) {
        itemView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        itemView.contentSize = CGSizeMake(150 * 10, 150);
        itemView.backgroundColor = [UIColor redColor];
    }
    
    return itemView;
     */
    
	HHEmojiKeyboardItemGroupView *pagerViews = (HHEmojiKeyboardItemGroupView *)view;
    if (pagerViews == nil) {
        pagerViews = [[HHEmojiKeyboardItemGroupView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        pagerViews.keyItemGroup = [[HHDemoKeyboardBuilder sharedEmoticonsKeyboard].keyItemGroups objectAtIndex:index];

    }
    
    NSLog(@"%@", NSStringFromCGRect(pagerViews.frame));
	return pagerViews;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
}
#pragma mark -
#pragma mark - Action
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
