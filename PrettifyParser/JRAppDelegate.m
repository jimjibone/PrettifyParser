//
//  JRAppDelegate.m
//  PrettifyParser
//
//  Created by James Reuss on 29/11/2012.
//  Copyright (c) 2012 James Reuss. All rights reserved.
//

#import "JRAppDelegate.h"

@implementation JRAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (IBAction)getHTML:(id)sender {
	if ([_scrollable state] == NSOnState) {
		[_htmlTextView setString:@"<pre class=\"prettyprint linenums pre-scrollable\"><ol class=\"linenums\"><li class=\"L0\">"];
	} else {
		[_htmlTextView setString:@"<pre class=\"prettyprint linenums\"><ol class=\"linenums\"><li class=\"L0\">"];
	}
	
	lineNo = 0;
	NSTextStorage *storage = [_codeTextView textStorage];
	[storage enumerateAttributesInRange:(NSRange){0,[storage length]} options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		NSString *string = [[storage string] substringWithRange:range];
		NSColor *colour;
		if ([attrs objectForKey:@"NSColor"]) {
			colour = [attrs objectForKey:@"NSColor"];
		} else {
			colour = [NSColor colorWithCalibratedRed:0. green:0. blue:0. alpha:1.];
		}
		
		// Uncomment to use for debug and find Hue values for colours.
		//NSLog(@"\"%@\" = R:%.2f G:%.2f B:%.2f = B:%.2f H:%.2f = %@", string, [colour redComponent], [colour greenComponent], [colour blueComponent], [colour brightnessComponent], [colour hueComponent], [colour hexColor]);
		
		// Take out characters used by HTML.
		NSString *currentText = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
		currentText = [currentText stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
		currentText = [currentText stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
		currentText = [currentText stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
		
#define colourInRange(colour,is) (colour>is-0.01)&&(colour<is+0.01)
		NSMutableString *currentSpan = [NSMutableString stringWithString:@"<span style=\"color:"];
		if ([colour brightnessComponent] == 0.0) {
			// Then it is black!
			[currentSpan appendString:@"#000000"];
		} else if (colourInRange([colour hueComponent], 0.86)) {
			// It's Pink
			[currentSpan appendString:@"#AA0D91"];
		} else if (colourInRange([colour hueComponent], 0.52)) {
			// It's Cyan
			[currentSpan appendString:@"#3E6D74"];
		} else if (colourInRange([colour hueComponent], 0.72)) {
			// It's Dark Purple
			[currentSpan appendString:@"#2E0D6D"];
		} else if (colourInRange([colour hueComponent], 0.00)) {
			// It's Red
			[currentSpan appendString:@"#C41915"];
		} else if (colourInRange([colour hueComponent], 0.74)) {
			// It's Light Purple
			[currentSpan appendString:@"#5B2599"];
		} else if (colourInRange([colour hueComponent], 0.33)) {
			// It's Green
			[currentSpan appendString:@"#007400"];
		} else if (colourInRange([colour hueComponent], 0.06)) {
			// It's Brown
			[currentSpan appendString:@"#643820"];
		} else if (colourInRange([colour hueComponent], 0.69)) {
			// It's Blue
			[currentSpan appendString:@"#1C00CF"];
		} else if (colourInRange([colour hueComponent], 0.67)) {
			// It's Blue, but a Link
			[currentSpan appendString:@"#0E0EFF"];
		} else {
			[currentSpan appendString:@"#999999"];
		}
		[currentSpan appendString:@";\">"];
		// check for new lines and add line numbers.
		NSRange newLine = [string rangeOfString:@"\n"];
		if (newLine.location != NSNotFound) {
			lineNo++;
			currentText = [currentText stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"</span></li><li class=\"L%d\">%@", lineNo, currentSpan]];
		}
		[currentSpan appendString:currentText];
		[currentSpan appendString:@"</span>"];
		[_htmlTextView insertText:currentSpan];
	}];
	
	[_htmlTextView insertText:@"</ol></pre>"];
}

@end
