//
//  SpaceBlockerAppDelegate.h
//  SpaceBlocker
//
//  Created by charlie on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

@interface SpaceBlockerAppDelegate : NSObject  {
    NSWindow *window;
	CFMachPortRef eventTap;
	CFRunLoopSourceRef runLoopSource;
	BOOL isEnabled;
	IBOutlet NSTextField *statusLabel;	
	IBOutlet NSButton *enableButton;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction) enableSpaceBlocker:(id)sender;
@end
