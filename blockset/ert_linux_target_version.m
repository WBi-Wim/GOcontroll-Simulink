%%***************************************************************************************
%% file         ert_linux_target_version.m
%% brief        Changelog and versioning of the Simulink blockset.
%%
%%---------------------------------------------------------------------------------------
%%                          C O P Y R I G H T
%%---------------------------------------------------------------------------------------
%%  Copyright 2024 (c) by GOcontroll     http://www.gocontroll.com    All rights reserved
%%
%%---------------------------------------------------------------------------------------
%%                            L I C E N S E
%%---------------------------------------------------------------------------------------
%% Permission is hereby granted, free of charge, to any person obtaining a copy of this
%% software and associated documentation files (the "Software"), to deal in the Software
%% without restriction, including without limitation the rights to use, copy, modify, merge,
%% publish, distribute, sublicense, and/or sell copies of the Software, and to permit
%% persons to whom the Software is furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in all copies or
%% substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
%% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
%% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
%% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
%% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
%% DEALINGS IN THE SOFTWARE.
%%
%%***************************************************************************************

function [version] = ert_linux_target_version()

version = 'GOcontroll V4.4.0-rc5';

%% V4.4.0 Update -:
% BREAKING Fixed mask errors in the 10 channel input, reset pulse counter and all the output blocks have been fixed this can reset certain parameters.
% In the case of the reset pulse counter block the library link has to be repaired, by changing 'Puls' to 'Pulse' in the link path
% BREAKING Fixed output module groundshift datatype, it is now an int16
% BREAKING Diagnostic blocks now follow the SAE J1939 DTC standard, this dramatically changes how they work
% Added standardised a version block to help with in model version management
% Added config parameter to Memory read, which reads a config parameter from /etc/go-simulink/
% User can now configure a simulink codegen/cache folder to prevent cluttering of the project folder
% Added read accelerometer block for reading out the accelerometer on the moduline mini

%% V4.3.2 Update 8-8-2024:
% The Execute shell command block now forks the process before calling system() to not block the main thread.
% Fixed missing semicolon in sfcn_can_send.tlc

%% V4.3.1 Update 24-7-2024:
% Removed duplicated upload function, auto upload now uses the manual upload script
% Added template for a project with a stable blockset
% Improved the developer experience when working on the blockset, compiler paths are now auto updated when loading the project

%% V4.3.0 Update 18-6-2024:
% XCP server can now use UDP or TCP
% Zig code can be used during the build process
% Removed module initialization from ert_main.tlc
% Removed diag/emu memory initialization from ert_main.tlc
% XCP server now always runs at a 0.01 sample time
% Extracted some common tlc functions
% Fixed the version not appearing on the bridge module block mask
% Added TCP blocks as a more reliable alternative to UDP
% Fixed bus error/segmentation fault caused by small buffer in the XCP stack
% Added second supply control to the 10 channel input module for firmware version 0.0.4+
% Improved module firmware version checks
% Removed the buffer full message from the legacy CAN send block

%% V4.2.0 Update 5-6-2024:
% Documentation fix on the license block
% Zig compiler is now an option, because of this it should now also be compatible with macos hosts
% Removed a bit of deprecated code from slblocks.m
% Fixed some issues from reworking the old CAN blocks
% Fixed some compiler warnings
% Some documentation improvements

%% V4.1.0 Update 29-5-2024:
% The GOcontroll blockset is now installable as a matlab toolbox which also installs the required compiler.
% XCP server is now a block so it can be deactivated.
% Improvements to UDP blocks and the template.

%% V4.0.0 Update 16-5-2024:
% New CAN blocks added, these can use dbc files.
% Improved tmf for toolboxes
% New UDP blocks, now allow you the have full control
% Bunch of improved masks
% Memory diagnostic growing file fix
% Added supply voltage output on the output module monitor, this output only works with hardware version 7+,
% This causes an extra output to appear on these block which probably has to be fixed when updating to this blockset.

%% V3.7.0 Update 10-3-2024:
% Improved 4-20mA module mask and functionality. This update requires 4-20 mA module HW 3 and firmware V1.0.0

%% V3.6.0 Update 6-2-2024:
% Added status output to 4-20 mA input module
% Added module slot to SPI communication
% Tested block with 4-20 mA serie production module HW 3 and firmware V0.0.3

%% V3.5.1 Update 24-1-2024:
% Minor improvements to the xcp stack, replaced some odd buffer copy code with memcpy

%% V3.5.0 Update 17-1-2024:
% Fixed the mask for the 10 channel in and output modules to reflect hardware version 4 and 3 respectively

%% V3.4.0 Update 9-1-2024:
% Fixed 4-20mA module pinout in the blocks
% Fixed CAN block breaking their library links
% Note for user updating to this blockset that have CAN blocks in their models:
% Navigate to one of your CAN blocks and right click the chain symbol at the bottom left of the block.
% Select the Restore Link option, this will open up a menu. Somewhere above select a checkbox that says something like show all broken links, check this.
% There should now be a list with all your CAN blocks, for everyone select the resolve option !!!not the push option!!!.
% Then apply, all links should now be restored to the library

%% V3.3.2 Update 3-1-2024:
% Fixed potential segfault in the UDP code

%% V3.3.1 Update 2-1-2024:
% Improved model startup time
% Removed unnecessary code from ert_linux_main.tlc
% Renamed the BusObject used for testing

%% V3.3.0 Update 19-12-2023:
% Now enforcing the Moduline Display name in software. This will break this blockset for the small number of boards currently in circulation.
% These boards can be brought up to date so they will work again with newer blocksets by contacting support@gocontroll.com

%% V3.2.8 Update 14-12-2023:
% UDP receive ID can now be switched between parameter or input port

%% V3.2.7 Update 4-12-2023:
% Having multiple modules configured for 1 module slot now causes a compilation error instead of giving you a headache trying to debug a problem that is difficult to trace

%% V3.2.6 Update 17-11-2023:
% Automatic build script demo added with multicore compiling support
% README fixes
% Improved build platform independence

%% V3.2.5 Update 14-11-2023:
% Fixed an error in the module initialisation and backwards compatability protocol from 3.2.1
% Improvements to the ergonomics of the UDP blocks
% Improved template makefile

%% V3.2.4 Update 31-10-2023:
% Fixed potential error risk in module spi communication
% Added new diagnostic block to the Generic blockset
% Bridge module monitor block is now implemented
% Some improvements to the README

%% V3.2.3 Update 23-10-2023:
% ManualUpload now as an optional port argument, allowing uploads to a different port than 8001.
% The Simulink Upload setting now have a port field that allows auto upload to a different port than 8001.

%% V3.2.2 Update 18-10-2023:
% Fixed the pinout on the 6-Channel-output channel mask
% Fixed the frequency range description on the channel function option of the 6 and 10 channel input modules.

%% V3.2.1 Update 22-9-2023:
% Made the module communication backwards compatible with older firmware versions, so the last line of V3.1.0 doesnt apply anymore.

%% V3.2.0 Update 21-9-2023:
% Added new moduline display to the list of controllers (1.05)
% Added a block to set the brightness of the display on the moduline display boards

%% V3.1.0 Update 22-8-2023:
% Added UDP to the main library under GOcontroll_Moduline_target/Network/UDP/
% Added The possibility for new block sets to include a hook into the make process to generate a just pre compile time header file for example
% Improved librarySetup.m and slblocks.m scripts that warn users with their own blockset if there is initialization files missing
% Work started on MQTT implementation for simulink, however this is not available for use yet
% 6-channel in- and output modules now use the proper SPI protocol, this means that from this version on these modules need to have firmware version 2.0.0+

%% V3.0.0 Update 26-6-2023:
% First open source release
% License headers fixed for open source validity

%% V2.26.2 Update 25-6-2023:
% Small fix on 4-20 mA block to enable both 16V supplies

%% V2.26.1 Update 23-6-2023:
% Fixed the XCP server, now no longer freezes the model_step on a silent disconnect and allows for a reconnect after 5~ seconds

%% V2.26.0 Update 22-6-2023:
% Added 4-20 mA input module blocks and code tot the blockset

%% V2.25.0 Update 16-6-2023:
% Fixed more license headers.
% Fixed asap2post script (missing ID length and address in the resulting a2l file).
% Fixed the terminate function to first terminate the threads before running the terminate functions.
% Fixed the tmf to not crash if there is no additional blockset_* folder.
% Removed a lot of unused code, switched to dynamically linked libiio for license reasons
% Switched to new expandable blockset architecture
% V3 will be the first Open source release coming soon(tm)

%% V2.24.24 Update 29-3-2023:
% Verify License block now supports 128, 192 and 256 bit encryption keys.
% Removed Proprietary software not meant to be open sourced so the blockset can soon be open sourced.

%% V2.24.23 Update 7-3-2023:
% Added execute shell command block
% Improved Verify License block interface
% Added Manual_Upload.m which allows for manual model uploads by typing Manual_Upload IPaddress in the Matlab command window
% Fixed some documentation

%% V2.23.23 Update 7-3-2023:
% Small fix on the IR module communicated version (V1.10)

%% V2.23.22 Update 7-2-2023:
% Small improvements and a small fix to the check license block.
% Fixed the auto-upload so it no longer gets stuck if curl cant reach the controller at the given IP.

%% V2.23.21 Update 15-1-2023:
% Changed peak and hold mechanism to current control mode. This update only changed some namings. For peak and hold in
% current control mode, an output module firmware update to >= V1.2.2 is needed.

%% V2.22.21 Update 18-12-2022:
% Added the GOcontroll Moduline Screen to the blockset.
% - Added HW version 1.02 and 1.03 to HW identification
% - Added controller type and pin definitions to the module blocks

%% V2.21.21 Update 12-12-2022:
% Small fix on identifiers of 10 channel input module

%% V2.21.20 Update 25-11-2022:
% Changed libiio from dynamically linked library to statically linked so it runs without any dependencies on the controller

%% V2.21.19 Update 9-12-2022:
% Added license block, this enables the user to put an encrypted license on the controller, and a key into the software. This can verify if that controller is allowed to run that piece of software.
% Added libiio to access the MCP3004 without hardcoding the filepath. (libiio is broken in this version use 2.21.20)
% Added documentation and setup functions to use the blockset in C directly, instead of just in simulink.
% Added moduleslot, and moduletype (where it applies) to the module structs

%% V2.20.19 Update 25-11-2022:
% Fix on positive only temperature during IR communication with dispenser. uint16_t changed to int16

%% V2.20.18 Update 10-11-2022:
% Added GOcontroll mini HW 1.07, 1.10 and 1.11 hardware check during initialization

%% V2.19.18 Update 19-10-2022:
% Small fix on 10 channel input module communication identifier of low level module-application processor communication

%% V2.19.17 Update 23-9-2022:
% Merged latest version of blockset with CAN blocks that included RTR. This addition to the blockset (V1.17.14 Update 18-5-2022) was lost during new commits.
% This feature is now added again.

%% V2.19.16 Update 19-8-2022:
% Added feature. Now also uploads a2l file to controller.

%% V2.18.16 Update 18-8-2022:
% Major update. Blockset can now be used on Linux and Windows based operating systems.

%% V1.18.16 Update 11-8-2022:
% Created extra thread to read ADC values from the onboard ADC convertor. This improvement seperates the ADC read action on high frequency from
% model thread.

%% V1.17.16 Update 27-6-2022:
% Changed LIN master function block with underlaying library. Block is now able to handle variable data lengths for each ID. There was also a problem
% with timing multiple LIN transmissions during step cycle. All the blocks are fired at the start of the scheduler step. the actual transmission is now
% phased in one transmission during each step cycle. It means that if e.g. 4 transmissions are send with a sample time of 100ms, each 100ms only one
% transmission takes place. In this case, the timestamp for one particular message is 400ms

%% V1.17.15 Update 27-6-2022:
% Added IR emitter control block for dedicated IR H2 communication module. (This module is IP protected)

%% V1.16.15 Update 23-5-2022:
% Added hardware check on GOcontroll Moduline IV V3.03

%% V1.16.14 Update 24-4-2022:
% Added check on availability of CAN interfaces. If not, error counter is increased and it wil stop trying to initialize/use CAN interface

%% V1.15.14 Update 13-3-2022:
% Added moduline mini V 1.06 to hardware detection.

%% V1.15.13 Update 4-3-2022:
% Added feature. Running model on controller retrieves hardware version during startup. The initialisation is now automatically
% Ported to the right hardware.

%% V1.14.13 Update 22-1-2022:
% Added feature. LIN communication block for Fuelsystems based on LIN - dispenser communication.

%% V1.13.13 Update 21-1-2022:
% Added feature. LIN master block is now added to the blockset.

%% V1.12.13 Update 2-1-2022:
% Added first version of 10 channel output module block to blockset

%% V1.11.13 Update 30-12-2021:
% 6 channel output module is now able to provide vaiable frequency on it's outputs. frequency goes from 0 to 500 Hz. This function is available in
% output module firmware version v1.2.2

%% V1.10.13 Update 18-12-2021:
% 10 channel input module is testend with Simulink block. Smal fixes on the source code and the block mask for proper working.

%% V1.10.12 Update 7-12-2021:
% Blockset is extended with MCP3004 ADC convertor on Moduline IV HW3.06 and Moduline Mini HW1.05

%% V1.9.12 Update 12-11-2021:
% Input module pulscounter reset had a bug when selecting Moduline Mini. The selection of the controller defined the type of input module.
% This is wrong. In het future there will be a pulscounter reset block for the 6 channel and for the 10 channel input module.

%% V1.9.11 Update 12-11-2021:
% Added Moduline Mini pinning information to input and output modules.

%% V1.9.10 Update 31-10-2021:
% Small fix. The peak and hold for the new half bridge configuration was nof configurable in the mask. Changed mask callback on channel function
% change.

%% V1.9.9 Update 31-10-2021:
% Feature change. Peak and hold had two functionalities. low side and high side. These functions are changed to half bridge peak and hold
% functionality. Most of actuators that need peak and hold are coil based so half bridge is prefered.
% THIS FUNCTION NEEDS OUTPUTMODULE FIRMWARE V1.1.1 or higher.

%% V1.8.9 Update 15-9-2021:
% Sometimes the modules didn't quit from the bootloader. This is caused by a busy SPI bus during initialization of the controller. Especially
% during cold start, several processes claiming recources from the controller. In the end, miscommunication triggerd a malfunctioning module.
% The initialization checks now if the module is entering module specific application. If not, an extra reset procedure is triggered.

%% V1.8.8 Update 15-9-2021:
% Fix. During startup, sometimes the modules are not properly initialized. It seems that the cancelation of the bootloader is not
% always properly receieved. The bootloader exit command is now send twice to now for shure that the module is exiting the bootloader mode.
% This update also shorten the boot delay that was one second. (main.tlc) it is now 100 ms.
% Another change is the delay between the first and second initialization message of the output module. Increased from 100 to 500 us.

%% V1.8.7 Update 15-9-2021:
% Small fix. changed some blocks to prevent verbose configuration output during build.

%% V1.8.6 Update 12-9-2021:
% Added feature. The 10 channel input module block is added to the library.

%% V1.7.6 Update 10-9-2021:
% Small bug fix. The communication checksum check on the output module was executed with one variable for all modules. The
% communication check has now a dedicated variable for each module.

%% V1.7.5 Update 10-9-2021:
% Small change. The order of options in the Simulink setting block is changed. Now more logic.

%% V1.7.4 Update 5-9-2021:
% Added feature. The version of the blockset is now printed in the function block to see what the actual blockset version is.

%% V1.6.4 Update 5-9-2021:
% Added feature. There is a new build option to select automatic upload of .elf files to the target. When this option is selected,
% The host will use the ip addres for XCP communication to automatically upload the model to the controller.

%% V1.5.4 Update 5-9-2021:
% Added feature. compiled model is now running on dedicated core(4) Be aware that etc/systemd/system.conf needs to reserve CPU 4.
% CPUAffinity=0-2 needs to be set.

%% V1.4.4 Update 5-9-2021:
% Added fix for not starting LED's. Led driver was not initialized in Simulink based start.

%% V1.4.3 Update 1-9-2021:
% Added feature option to select persistance or non-persistance memory when writing to memory. Updated library blocks for variable to memory.

%% V1.3.3 Update 28-8-2021:
% Added interface check on CAN. Since the program is now started earlier, it could be that the can is not yet initialized.
% When the interface is not there, the reconfiguration of the interface is tried again.

%% V1.3.2 Update 12-8-2021:
% Added feature 100 Hz option to bridge module frequency selection. This update requires at least bridge module
% firmware version 0.0.4

%% V1.2.2 Update 11-8-2021:
% Added feature 100 Hz option to output module frequency selection. This update requires at least output module
% firmware version 1.0.0

%% V1.1.2 Update 16-6-2021:
% Added feature - communication check on outputmodule on master side.

%% V1.0.1 Update 15-6-2021:
% Exluded combined channel from output function block. This function is tested but it damaged the output modules. This
% functionality is not intended for future use!

%% V1.0.0 Update 18-5-2021:
% KL15 and KL30 gives fluctuating output.
% This bug is caused due to a negative voltage applied onto the ADC convertor. ADC provides a signed int value which was
% converted into unsigned. Result was a high voltage output when the KL15 was going negative.

%% Fix: Check for negative value when value is extracted from ADC
