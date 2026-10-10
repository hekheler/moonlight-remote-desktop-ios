//
//  MainFrameViewController.h
//  Moonlight
//
//  Created by Diego Waxemberg on 1/17/14.
//  Copyright (c) 2014 Moonlight Stream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoveryManager.h"
#import "PairManager.h"
#import "StreamConfiguration.h"
#import "UIComputerView.h"
#import "UIAppView.h"
#import "AppAssetManager.h"
#import "SWRevealViewController.h"

@interface MainFrameViewController : UICollectionViewController <DiscoveryCallback, PairCallback, HostCallback, AppCallback, AppAssetCallback, NSURLConnectionDelegate, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
#if !TARGET_OS_TV
@property (weak, nonatomic) IBOutlet UIBarButtonItem *upButton;
#endif

// Adds a PC by address; with pair set it is opened right away to pair.
- (void) addHostWithAddress:(NSString*)hostAddress pair:(BOOL)pair;
#if !TARGET_OS_TV
// Other displays of the PC being streamed: further Sunshine instances on the
// same machine, one per monitor, each added and paired as a PC.
- (NSArray<TemporaryHost*>*) otherDisplaysOfSelectedHost;
// Starts Desktop on this PC once the current stream has closed.
- (void) switchToHostAfterStream:(TemporaryHost*)host;
#endif
@end
