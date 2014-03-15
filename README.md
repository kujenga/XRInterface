An iOS app with an interface for facilitating customized XML-RPC interaction with servers

Created by Aaron M. Taylor and Jason R. Briggs for a project at Williams College
part of Distributed Systems cs339 under Professor Jeannie Albrecht

To connect with the Bookstore server front end also created for cs339, the app provides a custom interface.
It defaults with a connection to the server rath.williams.edu, but this can be changed within viewDidLoad of the XRIMasterViewController.

Further custom interfaces can be added programatically in a way that mimics the current implementation of the XRIBookstoreViewController.
Steps:
Create a prototype row and give it an appropriate identifier in the Main_iPhone storyboard
Add a case in cellForRowAtIndexPath in the MasterViewController for this prototye row
Create a new UIViewController in the storyboard and link the two with a push segue with an appropriate identifier
Add a NSDictionry object instnatiated with the proper attributes to the _connections array the MasterViewController in proper location
Add a case to prepareForSegue that passes the appropriate NSDIctionary from _connections to the new view controller
Customize the newUIView controller to handle the incoming attributes and create the appropriate XML-RPC connections

Other connections can be added from within the app through the plus icon in the upper right. The connection details and methods are specified, which in turn are used to create a basic user interface assosiated with that row item.

Uses the open source XML-RPC library hosted at https://github.com/corristo/xmlrpc
for connections to user-inputted servers