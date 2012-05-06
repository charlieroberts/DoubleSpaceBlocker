//
//  SpaceBlockerAppDelegate.m
//  SpaceBlocker
//
//  Created by charlie on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpaceBlockerAppDelegate.h"

BOOL shouldBlockSpace = NO;

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef theEvent, void *refcon) {
	UniCharCount l;
	UniChar unicodeString[1];
	CGEventKeyboardGetUnicodeString (theEvent, 1, &l, unicodeString);
	
	if(unicodeString[0] == ' ') {
        if(shouldBlockSpace) {
            return NULL;
        }else{
            shouldBlockSpace = YES;
        }
    }else{
        shouldBlockSpace = NO;
    }

    return theEvent;
}


@implementation SpaceBlockerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	eventTap = CGEventTapCreate(kCGHIDEventTap,
						kCGHeadInsertEventTap, 
						kCGEventTapOptionDefault, 
						CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventKeyUp),
						myCGEventCallback,
						nil);

	runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);

	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
	CGEventTapEnable(eventTap, true);
	
	isEnabled = YES;
	[enableButton setTitle:@"Disable DoubleSpaceBlocker"];
}

- (IBAction) enableSpaceBlocker:(id)sender {
	if(!isEnabled) {
		eventTap = CGEventTapCreate(kCGHIDEventTap,
							kCGHeadInsertEventTap, 
							kCGEventTapOptionDefault, 
							CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventKeyUp),
							myCGEventCallback,
							nil);

		runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);

		CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
		CGEventTapEnable(eventTap, true);
		
		isEnabled = YES;
		[enableButton setTitle:@"Disable DoubleSpaceBlocker"];		
	}else{
		if(CFMachPortIsValid(eventTap)) {
			CFMachPortInvalidate(eventTap);
			CFRunLoopSourceInvalidate(runLoopSource);
			CFRelease(eventTap);
			CFRelease(runLoopSource);
		}
		[enableButton setTitle:@"Enable SpaceBlocker"];		
		isEnabled = NO;		
	}
}

- (void)dealloc {
	if(CFMachPortIsValid(eventTap)) {
		CFMachPortInvalidate(eventTap);
		CFRunLoopSourceInvalidate(runLoopSource);
		CFRelease(eventTap);
		CFRelease(runLoopSource);
	}
	[super dealloc];
}
@end
