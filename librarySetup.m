%%***************************************************************************************
%% file         librarySetup.m
%% brief        Initialization that is automatically executed when a Simulink model in 
%%              the same directory is opened.
%%
%%---------------------------------------------------------------------------------------
%%                          C O P Y R I G H T
%%---------------------------------------------------------------------------------------
%%  Copyright 2019 (c) by HAN Automotive     http://www.han.nl          All rights reserved
%%  Copyrigth 2024 (c) by GOcontroll B.V.    http://www.gocontroll.com  All rights reserved
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
%%
%% This file has been altered by GOcontroll to also support Linux based host machines and 
%% to support adding new blockset folders.
%%
%%***************************************************************************************

% First restore the path to factory default
% restoredefaultpath;
% clear RESTOREDEFAULTPATH_EXECUTED

% add Linux Target blockset related directories to the MATLAB path
OS = computer();
if OS=="GLNXA64" % if the host is Linux
    path1 = getenv('LD_LIBRARY_PATH');
    path = ['/lib/x86_64-linux-gnu' ':' path1];
    setenv('LD_LIBRARY_PATH',path);
end
addpath([pwd filesep 'blockset']);
addpath([pwd filesep 'blockset' filesep 'blocks']);
addpath([pwd filesep 'blockset' filesep 'code']);
addpath([pwd filesep 'blockset' filesep 'utility_functions']);

%if gocontroll_mex_version doesn't exist or the result of it is false, recompile the mex files
if ~(exist('gocontroll_mex_version', "file") == 3) || ~gocontroll_mex_version()
	disp("Compiling c mex functions...");
	version = ['-DVERSION=''"' ert_linux_target_version() '"'''];
	include_scanutil = ['-I' fullfile(matlabroot,'toolbox','shared','can','src','scanutil')];
	include_can_data = ['-I' fullfile(matlabroot, 'toolbox', 'rtw', 'targets', 'common', 'can', 'datatypes')];
	can_msg = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', 'common', 'can', 'datatypes', 'can_msg.c');
	can_util = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', 'common', 'can', 'datatypes', 'sfun_can_util.c');
	% compile mex files
	d = dir(['blockset' filesep 'blocks']);
	files = {d.name};
	for idx = 1:length(files)
		name = char(files(1,idx));
		if contains(name, ".c") && contains(name, "sfcn")
			[~, fname, ~] = fileparts(name);
			%compile the level 2 S functions
			fprintf("\nCompiling %s\n", fname);
			mex(include_scanutil, include_can_data, fullfile(pwd, 'blockset', 'blocks', [fname '.c']), can_msg, can_util, '-outdir', fullfile(pwd, 'blockset', 'blocks'));
			fprintf("Compiled %s\n", fname);
		end
	end
	% compile version mex last so on failure it doesnt exist and prevent recompilation
	fprintf("\nCompiling gocontroll_mex_version\n");
	mex(fullfile(pwd, 'blockset', 'blocks', 'gocontroll_mex_version.c'), '-outdir', fullfile(pwd, 'blockset', 'blocks'), version);
	disp("Finished compiling c mex functions!");
end

% find every folder that matches the blockset_* format and execute the
% librarySetup.m script located in this folder
% If a user wishes to add their own blockset elements see the GOcontroll
% Wiki on how to get started (link to be added).
d = dir("blockset_*");
folders = {d.name};
for idx = 1:length(folders)
    name=char(folders(1,idx));
	setupScript = [pwd filesep name filesep 'librarySetup.m'];
    if isfile(setupScript)
    	run(setupScript);
    else
    	warndlg(sprintf('No library setup script found for %s', name),'Warning');
    end
end

clear setupScript idx d folders name path path1 OS files fname version include_can_data include_scanutil can_msg can_util

warning off Simulink:SL_LoadMdlParameterizedLink;
warning off Simulink:Commands:LoadMdlParameterizedLink;

%%******************************* end of librarySetup.m **************************************

