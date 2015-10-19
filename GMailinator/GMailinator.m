#import "GMailinator.h"
#import <objc/objc-runtime.h>
#import <AppKit/AppKit.h>

NSBundle *GetGMailinatorBundle(void)
{
    return [NSBundle bundleForClass:[GMailinator class]];
}

@implementation GMailinator
{
    NSDate *_tabDate;
}

+ (void)initialize {
    [GMailinator registerBundle];
    SearchManager* sm = [[SearchManager alloc] init];
    [sm setContextMenu: nil];
    objc_setAssociatedObject(GetGMailinatorBundle(), @"searchManager", sm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    // Add shortcuts to the mailbox list
    Class c = NSClassFromString(@"MailTableView");
    SEL originalSelector = @selector(keyDown:);
    SEL overrideSelector = @selector(overrideMailKeyDown:);
    Method originalMethod = class_getInstanceMethod(c, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);

    class_addMethod(c, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    class_replaceMethod(c, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod));

    // Add shortcuts to the messages list
    c = NSClassFromString(@"MessagesTableView");
    originalSelector = @selector(keyDown:);
    overrideSelector = @selector(overrideMessagesKeyDown:);
    originalMethod = class_getInstanceMethod(c, originalSelector);
    overrideMethod = class_getInstanceMethod(self, overrideSelector);

    class_addMethod(c, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    class_replaceMethod(c, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod));

    // Add shortcuts to the messages list
    c = NSClassFromString(@"MessageViewer");
    originalSelector = @selector(keyDown:);
    overrideSelector = @selector(overrideMessagesKeyDown:);
    originalMethod = class_getInstanceMethod(c, originalSelector);
    overrideMethod = class_getInstanceMethod(self, overrideSelector);

    class_addMethod(c, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    class_replaceMethod(c, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod));

    // Add shortcuts to the message editor
    c = NSClassFromString(@"MessageWebHTMLView");
    originalSelector = @selector(keyDown:);
    overrideSelector = @selector(overrideMessageEditorKeyDown:);
    originalMethod = class_getInstanceMethod(c, originalSelector);
    overrideMethod = class_getInstanceMethod(self, overrideSelector);
    
    class_addMethod(c, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    class_replaceMethod(c, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod));
}

+ (void)registerBundle
{
    if(class_getClassMethod(NSClassFromString(@"MVMailBundle"), @selector(registerBundle)))
        [NSClassFromString(@"MVMailBundle") performSelector:@selector(registerBundle)];

    //[[self class] load];
}


- (void)overrideMailKeyDown:(NSEvent*)event {
    unichar key = [[event characters] characterAtIndex:0];
    id messageViewer = [[self performSelector:@selector(delegate)] performSelector:@selector(delegate)];

    switch (key) {
        case 'e':
        case 'y': {
            [messageViewer performSelector:@selector(archiveMessages:) withObject:nil];
            break;
        }
//        case 'h': {
//            NSEvent *newEvent = [NSEvent eventWithCGEvent: CGEventCreateKeyboardEvent(NULL, 115, true)];
//            [self overrideMailKeyDown: newEvent];
//            break;
//        }
//        case 'l': {
//            NSEvent *newEvent = [NSEvent eventWithCGEvent: CGEventCreateKeyboardEvent(NULL, 119, true)];
//            [self overrideMailKeyDown: newEvent];
//            break;
//        }
        case 'k': {
            NSEvent *newEvent = [NSEvent eventWithCGEvent: CGEventCreateKeyboardEvent(NULL, 126, true)];
            [self overrideMailKeyDown: newEvent];
            break;
        }
        case 'K': {
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 126, true);
            CGEventSetFlags(cgEvent, kCGEventFlagMaskShift);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMailKeyDown: newEvent];
            break;
        }
        case 'j': {
            NSEvent *newEvent = [NSEvent eventWithCGEvent: CGEventCreateKeyboardEvent(NULL, 125, true)];
            [self overrideMailKeyDown: newEvent];
            break;
        }
        case 'J': {
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 125, true);
            CGEventSetFlags(cgEvent, kCGEventFlagMaskShift);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMailKeyDown: newEvent];
            break;
        }
        case '#': {
            [messageViewer performSelector:@selector(deleteMessages:) withObject:nil];
            break;
        }
        case 'c': {
            [messageViewer performSelector:@selector(showComposeWindow:) withObject:nil];
            break;
        }
        case 'r': {
            [messageViewer performSelector:@selector(replyMessage:) withObject:nil];
            break;
        }
        case 'f': {
            [messageViewer performSelector:@selector(forwardMessage:) withObject:nil];
            break;
        }
        case 'a': {
            [messageViewer performSelector:@selector(replyAllMessage:) withObject:nil];
            break;
        }
        case '/': {
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 3, true);
            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskAlternate);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMailKeyDown: newEvent];
            break;
        }
        case 's': { // star message
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x25, true); // l
            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskShift);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMailKeyDown: newEvent];
            break;
        }
//        case 'o': { // open message - TODO: doesn't work.  Likely need to find the class function selecctor for open message to do it.
//            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x1f, true); // o
//            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand);
//            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
//            [self overrideMailKeyDown: newEvent];
//            break;
//        }
//        case 'z': { // undo - TODO: doesn't work.  Likely need to find the class function selecctor for undo to do it.
//            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x6, true); // z
//            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand);
//            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
//            [self overrideMailKeyDown: newEvent];
//            break;
//        }
        case 'm':
        case 'U':
        case 'I': { // mark as read/unread
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x20, true); // u
            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskShift);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMailKeyDown: newEvent];
            break;
        }
        default:
            [self overrideMailKeyDown:event];
            break;
            
    }
}

- (void)overrideMessagesKeyDown:(NSEvent*)event {
    unichar key = [[event characters] characterAtIndex:0];

    switch (key) {
        case 'e':
        case 'y': {
            [self performSelector:@selector(archiveMessages:) withObject:nil];
            break;
        }
        // These don't work so well, but it looks like this is a Mail bug; the
        // menu option for Select next/previous message in conversation just jumps
        // to the next/previous thread instead.  Also, it looks like capturing left/
        // right doesn't work for MessageViewer for some reason.
//        case 'k': {
//            [self performSelector:@selector(selectNextInThread:) withObject:nil];
//            break;
//        }
//        case 'j': {
//            [self performSelector:@selector(selectPreviousInThread:) withObject:nil];
//            break;
//        }
        case '#': {
            [self performSelector:@selector(deleteMessages:) withObject:nil];
            break;
        }
        case 'c': {
            [self performSelector:@selector(showComposeWindow:) withObject:nil];
            break;
        }
        case 'r': {
            [self performSelector:@selector(replyMessage:) withObject:nil];
            break;
        }
        case 'f': {
            [self performSelector:@selector(forwardMessage:) withObject:nil];
            break;
        }
        case 'a': {
            [self performSelector:@selector(replyAllMessage:) withObject:nil];
            break;
        }
        case '/': {
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 3, true);
            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskAlternate);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMessagesKeyDown: newEvent];
            break;
        }
        case 's': {
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x25, true); // l
            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskShift);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMessagesKeyDown: newEvent];
            break;
        }
        case 'm':
        case 'U':
        case 'I': { // mark as read/unread
            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x20, true); // u
            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskShift);
            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
            [self overrideMailKeyDown: newEvent];
            break;
        }
        default:
            [self overrideMessagesKeyDown:event];
            break;

    }
}

// Gmail shortcuts reference
// https://support.google.com/mail/answer/6594?hl=en
// Other shortcuts to add
//Shift + i	Mark as read	Marks your message as 'read' and skip to a newer message.
//Shift + u	Mark as unread	Marks your message as 'unread' so you can go back to it later.
//z	Undo	Undoes your previous action, if possible (works for actions with an 'undo' link).
// I like 'm' for marking read and unread.

// TODO: Figure out how to refactor out these things.  I need to learn objective-c first. :)
// the common key downs for Messages and Mail Key Down
// Gmail shortcut keys: #, c, r, f, a, /, s, m, o
//- (void)overrideCommonKeyDowns: (NSEvent*)event {
//    unichar key = [[event characters] characterAtIndex:0];
//    
//    switch (key) {
//
//        case '#': {
//            [self performSelector:@selector(deleteMessages:) withObject:nil];
//            break;
//        }
//        case 'c': {
//            [self performSelector:@selector(showComposeWindow:) withObject:nil];
//            break;
//        }
//        case 'r': {
//            [self performSelector:@selector(replyMessage:) withObject:nil];
//            break;
//        }
//        case 'f': {
//            [self performSelector:@selector(forwardMessage:) withObject:nil];
//            break;
//        }
//        case 'a': {
//            [self performSelector:@selector(replyAllMessage:) withObject:nil];
//            break;
//        }
//        case '/': {
//            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 3, true);
//            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskAlternate);
//            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
//            [self overrideMessagesKeyDown: newEvent];
//            break;
//        }
//        case 's': {
//            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x25, true); // l
//            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskShift);
//            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
//            [self overrideMessagesKeyDown: newEvent];
//            break;
//        }
//        case 'm': { // mark as read
//            CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 0x20, true); // u
//            CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskShift);
//            NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
//            [self overrideMailKeyDown: newEvent];
//            break;
//        }
//        default:
//            [self overrideCommonKeyDowns:event];
//            break;
//            
//    }
//}



- (void)overrideMessageEditorKeyDown:(NSEvent*)event {
    unichar key = [[event characters] characterAtIndex:0];

    switch (key) {
        case '\t': {
            _tabDate = [NSDate date];
            [self overrideMessageEditorKeyDown:event];
            break;
        }
        case '\r': {
            if (_tabDate) {
                double timePassed_ms = [_tabDate timeIntervalSinceNow] * -1000.0;
                if (timePassed_ms < 500) {
                    CGEventRef cgEvent = CGEventCreateKeyboardEvent(NULL, 2, true); // D
                    CGEventSetFlags(cgEvent, kCGEventFlagMaskCommand | kCGEventFlagMaskShift);
                    NSEvent *newEvent = [NSEvent eventWithCGEvent: cgEvent];
                    [self overrideMessageEditorKeyDown: newEvent];
                    break;
                } else {
                    _tabDate = nil; // avoid unnecessary calculations later
                }
            }
            [self overrideMessageEditorKeyDown:event];
            break;
        }
        default:
            [self overrideMessageEditorKeyDown:event];
            break;
    }
}


@end
