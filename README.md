Electron
===========

Source -> Signals -> Buses

This is basically just a structure that I've considered in lieu of existing FRP libraries.
Rather than creating signals from event emitters, I believe that those emitters should connect to `sources`.
The aforementioned sources pass values to `signals`, which modify values on reaction.
Signals can be wired together using merge on themselves, or connected into `buses` which can then be used to
call functions on groups of signals simultaneously or to combine them.

I also intend to support named signals on sources for the easy of containing and managing them better.

# WIP
