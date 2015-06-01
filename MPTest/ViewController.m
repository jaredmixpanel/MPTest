//
//  ViewController.m
//  MPTest
//
//  Created by Jared McFarland on 1/21/15.
//  Copyright (c) 2015 Jared McFarland. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import <Mixpanel/Mixpanel.h>
#import <Mixpanel/MPTweakInline.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)fire:(id)sender;
// @property (weak, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) Mixpanel *mixpanel;
@property (strong, nonatomic) NSArray *number;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;


@end

@implementation ViewController

-(Mixpanel *)mixpanel
{
    if (!_mixpanel) {
        _mixpanel = [Mixpanel sharedInstance];
    }
    return _mixpanel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    UILabel *label = [[UILabel alloc] init];
    BOOL l1 = MPTweakValue(@"Label 1",NO);
    if (l1) {
        label.text = @"TRUE";
    } else if (!l1)
    {
        label.text = @"FALSE";
    }
    [label setFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 200, 100)];
    [label sizeToFit];
    [self.view addSubview:label];

    UILabel *tweakLabel = [[UILabel alloc] init];
    BOOL l2 = MPTweakValue(@"Label 2",YES);
    if (l2) {
        tweakLabel.text = @"TRUE";
    } else if (!l2)
    {
        tweakLabel.text = @"FALSE";
    }
    [tweakLabel setFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/4, 200, 100)];
    [tweakLabel sizeToFit];
    [self.view addSubview:tweakLabel];
    
//    UILabel *tweakLabel2 = [[UILabel alloc] init];
//    //tweakLabel.text = @"INT = 0";
//    tweakLabel2.text = MPTweakValue(@"TweakLabel Text",@"SHIT");
//    [tweakLabel2 setFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/4, 200, 100)];
//    [tweakLabel2 sizeToFit];
//    [self.view addSubview:tweakLabel2];
    
    
    self.number = @[@0];
    
    [self.mixpanel registerSuperProperties:@{@"Events Sent": @0}];

    //[self.mixpanel.people set: @{@"List":@[@"item1",@"item2",@"item3"]}];
}

- (IBAction)fire:(id)sender {
    
    NSString *event = @"Event Name";
    
    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionary];
    
    [mutableProperties setObject:@"AB" forKey:@"mp_country_code"];
    
    [mutableProperties setObject:@"Jared City" forKey:@"$city"];
    
    [mutableProperties setObject:@"McFarlandia" forKey:@"$region"];
    
    [[Mixpanel sharedInstance] track:event properties:mutableProperties];
    
    NSMutableDictionary *superProps = [[self.mixpanel currentSuperProperties] mutableCopy];
    superProps[@"propToIncrement"] = @([superProps[@"propToIncrement"] intValue] + 1);
    [self.mixpanel registerSuperProperties:superProps];
    
}
- (void)fire2:(id)sender {
    NSLog(@"FIRE2!");
    [self.mixpanel.people set:@"People Property" to:@"hello"];
    [self.mixpanel.people set:@{@"$first_name":@"Jared",@"$last_name":@"McFarland",@"$email":@"jared@mixpanel.com"}];
    
    [self.mixpanel.people trackCharge:@200 withProperties:@{@"$time":[NSDate date]}];
    //[self.mixpanel flush];
}

- (void)incrementEventsCountBy:(int)amount
{
    NSNumber *eventsSentCount = [self.mixpanel currentSuperProperties][@"Events Sent"];
    eventsSentCount = @(eventsSentCount.intValue + amount);
    [self.mixpanel registerSuperProperties:@{@"Events Sent": eventsSentCount}];
}
@end
