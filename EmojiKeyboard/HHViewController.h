//
//  HHViewController.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface HHViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *iCarousel;

@end
