# What is Chocobot-Timer?

A Plugin for [Chocobot](https://github.com/Gotos/Chocobot) for createing messages send after a certain time and a certain number of messages have passed.

# How-To

Chocobot-Timer adds six new commands:

!addtimer, !deltimer and !listtimer.

Use !addtimer [name] [timeInterval] [msgInterval] [Message] to add a new timer with the name [name]. After [timeInterval] minutes Chocobot will check if at least [msgInterval] messages have passed since the timer has last triggered. If yes, it will trigger again and Chocobots writes [Message] to the chat.

To override an existing timer, just add a new timer with the same name.

To delete a timer, use !deltimer [name].

!listtimer lists all the names of installed timers.

!testtimer [name] will test the timer [name]: That means, Chocobot will send the timers message to the chat.

!stoptimer [name] will deactivate a timer without removing it. It will not be triggered until started again via !starttimer [name].

# Install

Just place the Timer-folder inside the "Plugins"-folder of Chocobot. If "Plugins" doesn't exist, create it. Also make sure to rename the Timer-folder to "Timer".

# Download

Just have a look at the [Releases page](https://github.com/Gotos/Chocobot-Timer/releases)
