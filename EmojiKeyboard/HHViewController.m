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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.iCarousel.type = iCarouselTypeCoverFlow2;
    self.iCarousel.backgroundColor = [UIColor grayColor];
    
    [[HHDemoKeyboardBuilder sharedEmoticonsKeyboard] setKeyboardCategorySelectedBlock:^(HHEmojiKeyboardItemGroup *keyItemGroup, NSInteger selectedIndex) {
        [self.iCarousel setCurrentItemIndex:selectedIndex];
    }];
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

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    NSUInteger count = [HHDemoKeyboardBuilder sharedEmoticonsKeyboard].keyItemGroups.count;

    return count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view { 
	HHEmojiKeyboardItemGroupView *pagerViews = (HHEmojiKeyboardItemGroupView *)view;
    if (pagerViews == nil) {
        pagerViews = [[HHEmojiKeyboardItemGroupView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        pagerViews.keyItemGroup = [[HHDemoKeyboardBuilder sharedEmoticonsKeyboard].keyItemGroups objectAtIndex:index];

    }
    
	return pagerViews;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectItemAtIndex %d", index);
    
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    NSLog(@"carouselWillBeginDragging");
    [self.textView resignFirstResponder];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    NSLog(@"carouselDidEndScrollingAnimation");
    [self performSelector:@selector(showKeyBoard:) withObject:carousel afterDelay:1.0];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    NSLog(@"%d", carousel.currentItemIndex);
    
}

- (void) showKeyBoard:(iCarousel *)carousel {
    [self.textView switchToEmoticonsKeyboard:[HHDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    [[HHDemoKeyboardBuilder sharedEmoticonsKeyboard] switchToCategoryAtIndex:carousel.currentItemIndex];
    [self.textView becomeFirstResponder];
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
