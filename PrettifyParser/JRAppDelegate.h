//
//  JRAppDelegate.h
//  PrettifyParser
//
//  Created by James Reuss on 29/11/2012.
//  Copyright (c) 2012 James Reuss. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Hex)
- (NSString *) hexColor;
@end
@implementation NSColor (Hex)
- (NSString *) hexColor {
    // Convert colour to RGBA
    NSColor *rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    return [NSString stringWithFormat:@"#%0.2X%0.2X%0.2X",
            (int)([rgb redComponent] * 255),
            (int)([rgb greenComponent] * 255),
            (int)([rgb blueComponent] * 255)];
}
@end

@interface JRAppDelegate : NSObject <NSApplicationDelegate> {
	unsigned int lineNo;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *codeTextView;
@property (assign) IBOutlet NSTextView *htmlTextView;
@property (assign) IBOutlet NSButton *scrollable;

- (IBAction)getHTML:(id)sender;

@end
