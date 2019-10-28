function varargout = BloodCancer(varargin)
% BLOODCANCER MATLAB code for BloodCancer.fig
%      BLOODCANCER, by itself, creates a new BLOODCANCER or raises the existing
%      singleton*.
%
%      H = BLOODCANCER returns the handle to a new BLOODCANCER or the handle to
%      the existing singleton*.
%
%      BLOODCANCER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLOODCANCER.M with the given input arguments.
%
%      BLOODCANCER('Property','Value',...) creates a new BLOODCANCER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BloodCancer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BloodCancer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BloodCancer

% Last Modified by GUIDE v2.5 06-Dec-2018 10:48:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BloodCancer_OpeningFcn, ...
                   'gui_OutputFcn',  @BloodCancer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BloodCancer is made visible.
function BloodCancer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BloodCancer (see VARARGIN)

% Choose default command line output for BloodCancer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BloodCancer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BloodCancer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clc
% clear all
[x,y] = uigetfile('*');
f=strcat(y,x);
I=imread(f);
axes(handles.axes1);
imshow(I);


% --- Executes on button press in Grayscaled.
function Grayscaled_Callback(hObject, eventdata, handles)
% hObject    handle to Grayscaled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=getimage(handles.axes1);
G=rgb2gray(d);
axes(handles.axes2);
imshow(G);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=getimage(handles.axes2);
B=im2bw(d); %convert to BW
[~,threshold]=edge(B,'sobel'); %calculate threshold
fudgeFactor=.5; %to tune threshold value
BWs=edge(B,'sobel',threshold*fudgeFactor);
axes(handles.axes3);
imshow(BWs);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=getimage(handles.axes3);
se90=strel('line', 3, 90);
se0=strel('line', 3, 0);
BWsdil=imdilate(d, [se90,se0]); %dilate the gradient image
BWdfill=imfill(BWsdil, 'holes'); %fill holes in gradient image
BWnobord=imclearborder(BWdfill, 6); %clear borderline
seD=strel('diamond', 1); %to smoothen image
BWfinal=imerode(BWnobord, seD); 
BWfinal=imerode(BWfinal, seD); 
axes(handles.axes4);
imshow(BWfinal);


% --- Executes on button press in Result.
function Result_Callback(hObject, eventdata, handles)
% hObject    handle to Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=getimage(handles.axes4);
[centers, radii] = imfindcircles(d,[35 60],'ObjectPolarity','dark',...
    'Sensitivity',0.9);
imshow(d);
h = viscircles(centers,radii);
cell=length(d);

[l,NUM]=bwlabel(d,4);
cancer=(NUM/cell)*1000;
if (ge(cancer,51))
    disp('Not recoverable')
    if(ge(cancer, 76))
        disp('4th stage')
        disp('cancer % is')
        disp(cancer)
    else
        disp('3rd stage')
        disp('cancer % is')
        disp(cancer)
    end;
elseif (le(cancer, 50))
    disp('Recoverable')
    if(le(cancer,25))
        disp('1st stage')
        disp('cancer % is')
        disp(cancer)
    else
        disp('2nd stage')
        disp('cancer % is')
        disp(cancer)
    end;
    set(handles.edit6,'string',cancer)
end;


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
d = getimage(handles.axes4)
[centers, radii] = imfindcircles(d,[35 60],'ObjectPolarity','dark',...
    'Sensitivity',0.9);
imshow(d);
h = viscircles(centers,radii);
cell=length(d);

[l,NUM]=bwlabel(d,4);
cancer=(NUM/cell)*1000;
if (ge(cancer,51))
    fprintf(handles.text4,'Not Recoverable');
else
    set(handles.text4,'string','recoverable');
end;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
