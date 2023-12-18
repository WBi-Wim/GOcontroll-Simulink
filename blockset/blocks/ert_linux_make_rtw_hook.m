%%***************************************************************************************
%% file         ert_linux_make_rtw_hook.m
%% brief        Hook file with functionality that is invoked during the build process
%%              of an embedded coder real-time target.
%%
%%---------------------------------------------------------------------------------------
%%                          C O P Y R I G H T
%%---------------------------------------------------------------------------------------
%%  Copyright 2018 (c) by HAN Automotive     http://www.han.nl     All rights reserved
%%  Copyright 2023 (c) by GOcontroll      http://www.gocontroll.com     All rights reserved
%%
%%---------------------------------------------------------------------------------------
%%                            L I C E N S E
%%---------------------------------------------------------------------------------------
%% This file is part of the HANcoder Matlab/Simulink Blockset environment. For the
%% licensing terms, please contact HAN Automotive.
%%
%% This software has been carefully tested, but is not guaranteed for any particular
%% purpose. HAN Automotive does not offer any warranties and does not guarantee the
%% accuracy, adequacy, or completeness of the software and is not responsible for any
%% errors or omissions or the results obtained from use of the software.
%%
%%***************************************************************************************
function ert_linux_make_rtw_hook(hookMethod,modelName,rtwroot,templateMakefile,buildOpts,buildArgs)
% ERT_MAKE_RTW_HOOK - This is the standard ERT hook file for the RTW build
% process (make_rtw), and implements automatic configuration of the
% models configuration parameters.  When the buildArgs option is specified
% as 'optimized_fixed_point=1' or 'optimized_floating_point=1', the model
% is configured automatically for optimized code generation.
%
% This hook file (i.e., file that implements various RTW callbacks) is
% called by RTW for system target file ert.tlc.  The file leverages
% strategic points of the RTW process.  A brief synopsis of the callback
% API is as follows:
%
% ert_make_rtw_hook(hookMethod, modelName, rtwroot, templateMakefile,
%                   buildOpts, buildArgs)
%
% hookMethod:
%   Specifies the stage of the RTW build process.  Possible values are
%   entry, before_tlc, after_tlc, before_make, after_make and exit, etc.
%
% modelName:
%   Name of model.  Valid for all stages.
%
% rtwroot:
%   Reserved.
%
% templateMakefile:
%   Name of template makefile.  Valid for stages 'before_make' and 'exit'.
%
% buildOpts:
%   Valid for stages 'before_make' and 'exit', a MATLAB structure
%   containing fields
%
%   modules:
%     Char array specifying list of generated C files: model.c, model_data.c,
%     etc.
%
%   codeFormat:
%     Char array containing code format: 'RealTime', 'RealTimeMalloc',
%     'Embedded-C', and 'S-Function'
%
%   noninlinedSFcns:
%     Cell array specifying list of non-inlined S-Functions.
%
%   compilerEnvVal:
%     String specifying compiler environment variable value, e.g.,
%     D:\Applications\Microsoft Visual
%
% buildArgs:
%   Char array containing the argument to make_rtw.  When pressing the build
%   button through the Configuration Parameter Dialog, buildArgs is taken
%   verbatim from whatever follows make_rtw in the make command edit field.
%   From MATLAB, it's whatever is passed into make_rtw.  For example, its
%   'optimized_fixed_point=1' for make_rtw('optimized_fixed_point=1').
%
%   This file implements these buildArgs:
%     optimized_fixed_point=1
%     optimized_floating_point=1
%
% You are encouraged to add other configuration options, and extend the
% various callbacks to fully integrate ERT into your environment.
  switch hookMethod
   case 'error'
      fprintf('########################### ERROR\n');
    % Called if an error occurs anywhere during the build.  If no error occurs
    % during the build, then this hook will not be called.  Valid arguments
    % at this stage are hookMethod and modelName. This enables cleaning up
    % any static or global data used by this hook file.
    disp(['### Real-Time Workshop build procedure for model: ''' modelName...
          ''' aborted due to an error.']);

   case 'entry'
      fprintf('########################### ENTRY\n');
    % Called at start of code generation process (before anything happens.)
    % Valid arguments at this stage are hookMethod, modelName, and buildArgs.

    % The following warning must be given if the evaluation version is
    % used, comment for licensed use.
    %uiwait(warndlg('This version is for evaluation purposes only','HANcoder','modal'));
    % The following warning is given for the student version, comment for
    % licensed use.
    %uiwait(warndlg(sprintf('You are using an educational version of HANcoder\n\nCommercial usage is not allowed in any way\n\nContact hancoder@han.nl for more information'),'HANcoder','modal'));

	% Clear the UDP variables
	if evalin('base','exist(''UDPBUFFNUM'',''var'')==1')
		assignin('base','UDPBUFFNUM',0);
	end

	if evalin('base','exist(''UDPBUFFSIZE'',''var'')==1')
		assignin('base','UDPBUFFSIZE',0);
	end

	% Check if the code generation is started from the correct path

	model_path = get_param(bdroot, 'FileName');
	model_path = regexprep(model_path, ['\' filesep modelName '.slx'],''); %windows needs the '\' and linux seems fine with or without it
	model_path = regexprep(model_path, ['\' filesep modelName '.mdl'],'');

	if (~(strcmp(pwd,model_path)))
		errorMessage = strcat('The current folder is incorrect, please', ...
		' set the current folder to:', model_path);
		error(errorMessage);
    end

    % Call function to add all variables which are not declared by the
    % user to the workspace as Simulink.Signals/Parameters. This way the
    % missing signals and parameters will become visible in HANtune
		fprintf('########################### ASAP\n');
    AddASAP2Elements(modelName);

    fprintf(['\n### Starting Real-Time Workshop build procedure for ', ...
                  'model: %s\n'],modelName);
    fprintf('### Checking for the use of HANcoder blocks...\n');


   case 'before_tlc'
    % Called just prior to invoking TLC Compiler (actual code generation.)
    % Valid arguments at this stage are hookMethod, modelName, and
    % buildArgs


   case 'after_tlc'
    % Called just after to invoking TLC Compiler (actual code generation.)
    % Valid arguments at this stage are hookMethod, modelName, and
    % buildArgs
	%% get the necessary information from the model
    % [nrOfUDPReceiveBuffers,UDPBuffSize] = searchUDPreceive(modelName);
    % UDPBuffSize = getUDPBuffSize(modelName);

	if evalin('base','exist(''UDPBUFFNUM'',''var'')==1')
		nrOfUDPReceiveBuffers = evalin('base','UDPBUFFNUM') + 1;
	else
		nrOfUDPReceiveBuffers = 0;
	end

	if evalin('base','exist(''UDPBUFFSIZE'',''var'')==1')
		UDPBuffSize = evalin('base','UDPBUFFSIZE') + 1;
	else
		UDPBuffSize = 0;
	end

	nrOfCANreceiveBlocks = searchCANreceive(modelName);
		% Add software version to the SYS_config.h file.
    fprintf('\n### Adding data to SYS_config.h...\n');
    formatOut = 'ddmmyy_HHMMSS';
    daten = datestr(now, formatOut);
    stationID = strcat(modelName,daten);
    assignin('base','kXcpStationId',stationID);
    % Get XCP port
    XCPport = get_param(modelName,'tlcXcpTcpPort');

	% Open file in write mode 'w'
    file = fopen('SYS_config.h', 'w');
    if file == -1
         error('### failed to open SYS_config.h');
    end
	if numel(stationID) > 255
		msg = sprintf('Error: Station ID is larger than 255 characters. Use a shorter name as ID!\n');
			% Display error message in the matlab command window.
			fprintf(msg);
			% Abort and display pop-up window with error message.
			error(msg);
	end
	fprintf(file, '#ifndef __SYS_CONFIG_H__ \n#define __SYS_CONFIG_H__\n');
	fprintf(file, '#define kXcpStationIdString            "%s"\n', stationID);
	fprintf(file, '#define kXcpStationIdLength            %d\n', numel(stationID));
	fprintf(file, '#define XCP_PORT_NUM                   %d\n', XCPport);
	fprintf(file, '#define CANBUFSIZE                     %d\n', nrOfCANreceiveBlocks);
    fprintf(file, '#define UDPBUFFNUM                     %d\n', nrOfUDPReceiveBuffers);
    fprintf(file, '#define UDPBUFFSIZE                    %d\n', UDPBuffSize);
	fprintf(file, '#endif');
	fclose(file);

    d = dir(['..' filesep 'blockset_*']);
    folders = {d.name};
    for i = 1:length(folders)
        name=char(folders(1,i));
		make_hook_script_orig = [pwd filesep '..' filesep name filesep 'makeHook.m'];
		make_hook_script_dest = [pwd filesep 'makeHook.m'];
        if isfile(make_hook_script_orig)
		copyfile(make_hook_script_orig, make_hook_script_dest);
		run(make_hook_script_dest);
		delete(make_hook_script_dest);
		else
			fprintf('No makeHook script found for %s\n',name);
		end
    end

   case 'before_make'
    % Called after code generation is complete, and just prior to kicking
    % off make process (assuming code generation only is not selected.)  All
    % arguments are valid at this stage.
	delete('*.obj')

   case 'after_make'
    % Called after make process is complete. All arguments are valid at
    % this stage.
    % Adding the memory addresses to the ASAP2 file
	fprintf('### Post-processing ASAP2 file\n');
	ASAP2file = sprintf('%s.a2l', modelName);
	MAPfile = ['..' filesep modelName '.map'];
	% Get XCP port
    XCPport = get_param(modelName,'tlcXcpTcpPort');
	% Get XCP address
	XCPaddress = get_param(modelName,'tlcXcpTcpAddress');
    % Read the kXcpStationId from the workspace
    stationID = evalin('base', 'kXcpStationId');
	% Get the Linux target from the model parameters tab
	LinuxTarget = get_param(modelName,'tlcLinuxTarget');

    % Postprocess the ASAP2file
    ASAP2Post(ASAP2file, MAPfile, LinuxTarget, stationID, 0, 0, XCPport,XCPaddress);

    % Moving the A2L file to the user directory and the map file away
    copyfile([modelName '.a2l'],['..' filesep modelName '.a2l']);
	movefile(['..' filesep modelName '.map'],[modelName '.map']);

   case 'exit'
    % Called at the end of the RTW build process.  All arguments are valid
    % at this stage.
    disp(['### Successful completion of Real-Time Workshop build ',...
          'procedure for model: ', modelName]);

    ert_linux_target_upload(modelName);
  end
end
%%******************************* end of ert_linux_make_rtw_hook.m ****************************


%% Search for CANreceive blocks %%
% This function searches for CAN receive blocks and adds a define to the
% SYS_config.h file with the number of blocks found %
function nrOfCANreceiveBlocks = searchCANreceive(modelName)
    % build an array with all the blocks that have a Tag starting with HANcoder_TARGET_
    blockArray = find_system(modelName, 'RegExp', 'on', 'FollowLinks', 'on', 'LookUnderMasks', 'all', 'MaskType', 'CAN receive');
    % only perform check if at least 1 or more HANcoder Target blocks were used
    nrOfCANreceiveBlocks = length(blockArray);
end