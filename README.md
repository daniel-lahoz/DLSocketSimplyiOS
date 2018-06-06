## DLSocketSimplyiOS ##

*This is a unifished work in progress*

This is very a simple demo of the implementation of an **Socket.io** App for iOS.

I use the **Socket.IO-Client-Swift** library from @nuclearace to make the connection tho the server.

You can see the library here [Socket.IO-Client-Swift](https://github.com/nuclearace/Socket.IO-Client-Swift)

As server I use my simple Socket.io ChatRoom demo, you can see it here [DLSocketSimplyServerDemo](https://github.com/daniel-lahoz/DLSocketSimplyServerDemo) 

## How to use

You probably need to install the pods.

```
$ cd DLSocketSimplyiOS
$ pod install
```

Also you may need to change the connectio point, by default is
 `http://localhost:3000`. 

## Features

- Multiple users can join a specify chat room by each entering a unique username and chatroom on website load.
- Users can type chat messages to that chat room.
- A notification is sent to all users when a user joins or leaves
the chatroom.

### Make One Yourself ###

Be free of use this simple example as you pleased.
