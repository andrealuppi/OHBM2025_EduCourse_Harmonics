function[myfig] = fcn_plot_brain_ENIGMA(myBrainMap, atlas_name, mytitle, optional_colormap)

%%%%%%%%%%%%%%%%%%%%%
%% INPUTS:
% myBrainMap: a vector of N brain values, one per regions
% atlas_name: a string; options are 'Schaefer', 'DesikanKilliany', 'Glasser'
% mytitle (string, optional): a title for the plot
% optional_colormap: a string, name of a colormap from ENIGMA toolbox;
% default is 'parula'
%%%%%%%%%%%%%%%%%%%%%

if exist('optional_colormap', 'var')
else    optional_colormap = [];
end
if isempty(optional_colormap)
    optional_colormap = 'parula';
end

%Ensure it is vertical
[rows,cols] = size(myBrainMap);
if rows < cols
    myBrainMap = myBrainMap';
end

% Set range for colormap
color_range = [nanmin(myBrainMap), nanmax(myBrainMap)];




canProceed=true;

% Identify atlas
switch atlas_name
    case 'DesikanKilliany'
        parcellation = 'aparc_fsa5';
    case 'Schaefer'
        parcellation = ['schaefer_', num2str(numel(myBrainMap)), '_fsa5'];
    case 'Glasser'
        parcellation = 'glasser_360_fsa5';

    otherwise

        disp(['Parcellation ', atlas_name, ' is not implemented!'])
        canProceed = false;

end

% Implement plotting with ENIGMA toolbox
if canProceed==true

    try
        parc2surf=parcel_to_surface(myBrainMap,  parcellation);
        hemi = '2x2'; %Default layout for plotting

        myfig=figure;
        if ischar(optional_colormap)
            plot_cortical_hemi_al857(parc2surf, hemi,...
                'surface_name', 'fsa5',...
                'cmap', optional_colormap, ...
                'color_range', color_range);
        else
            plot_cortical_hemi_al857(parc2surf, hemi,...
                'surface_name', 'fsa5',...
                'cmap', 'parula', ... use a placeholder colormap
                'color_range', color_range);

            %now add the true colormap
            colormap(optional_colormap)
        end
        if exist('mytitle', 'var'); title(mytitle); end
    catch
        disp(['Some error occurred: could not plot on brain surface'])
        figure; imagesc(myBrainMap)

    end


else

    disp(['Some error occurred: could not plot on brain surface'])
    figure; imagesc(myBrainMap)

end

end %eof

%% HELPER FUNCTIONS
function [a, cb] = plot_cortical_hemi_al857(data, hemi, varargin);
%
% Usage:
%   [a, cb] = plot_cortical(data, varargin);
%
% Description:
%   Plot cortical surface with lateral and medial views (authors: @MICA-MNI, @saratheriver)
%
% Inputs:
%   data (double array) - vector of data, size = [1 x v]
%
% Name/value pairs:
%   surface_name (string, optional) - Name of surface {'fsa5', 'conte69}.
%       Default is 'fsa5'.
%   label_text (string, optional) - Label text for colorbar. Default is empty.
%   background (string, double array, optional) - Background color.
%       Default is 'white'.
%   color_range (double array, optional) - Range of colorbar. Default is
%       [min(data) max(data)].
%   cmap (string, double array, optional) - Colormap name. Default is 'RdBu_r'.
%
% Outputs:
%   a (axes) - vector of handles to the axes, left to right, top to bottom
%   cb (colorbar) - colorbar handle
%
% Sara Lariviere  |  saratheriver@gmail.com

p = inputParser;
addParameter(p, 'surface_name', 'fsa5', @ischar);
addParameter(p, 'label_text', "", @ischar);
addParameter(p, 'background', 'white', @ischar);
addParameter(p, 'color_range', [min(data) max(data)], @isnumeric);
addParameter(p, 'cmap', 'RdBu_r', @ischar);

% Parse the input
parse(p, varargin{:});
in = p.Results;

% load surfaces
if strcmp(in.surface_name, 'fsa5')
    surf = SurfStatAvSurf({'fsa5_lh', 'fsa5_rh'});
elseif strcmp(in.surface_name, 'conte69')
    surf = SurfStatAvSurf({'conte69_lh', 'conte69_rh'});
elseif strcmp(in.surface_name, 'ss')
    surf = SurfStatAvSurf({'fsa5_with_sctx_sphere_lh', 'fsa5_with_sctx_sphere_lh'});
end

v=length(data);
vl=1:(v/2);
vr=vl+v/2;
t=size(surf.tri,1);
tl=1:(t/2);
tr=tl+t/2;
clim=[min(data),max(data)];
if clim(1)==clim(2)
    clim=clim(1)+[-1 0];
end


% h=0.25; %height
% w=0.20; %width


switch lower(hemi)


    case '2x2'

        h=0.37; %height
        w=0.30; %width

        a(1)=axes('position',[0.1+0.33*w 0.25 w h]);%[0.1+w 0.3 w h]);
        trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
            double(data(vl)),'EdgeColor','none');
        view(-90,0)
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(2)=axes('position',[0.1+1.33*w 0.25 w h]);%[0.1+2*w 0.3 w h]);
        trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
            double(data(vl)),'EdgeColor','none');
        view(90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(3)=axes('position',[0.1+0.33*w 0.25+0.9*h w h]);
        trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
            double(data(vr)),'EdgeColor','none');
        view(-90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(4)=axes('position',[0.1+1.33*w 0.25+0.9*h w h]);
        trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
            double(data(vr)),'EdgeColor','none');
        view(90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

    case '1x4'

        h=0.25; %height
        w=0.20; %width

        a(1)=axes('position',[0.1 0.3 w h]);
        trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
            double(data(vl)),'EdgeColor','none');
        view(-90,0)
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(2)=axes('position',[0.1+w 0.3 w h]);
        trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
            double(data(vl)),'EdgeColor','none');
        view(90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(3)=axes('position',[0.1+2*w 0.3 w h]);
        trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
            double(data(vr)),'EdgeColor','none');
        view(-90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(4)=axes('position',[0.1+3*w 0.3 w h]);
        trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
            double(data(vr)),'EdgeColor','none');
        view(90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

    case 'lh'

        h=0.37; %height
        w=0.30; %width

        a(1)=axes('position',[0.1+0.33*w 0.25 w h]);
        trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
            double(data(vl)),'EdgeColor','none');
        view(-90,0)
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(2)=axes('position',[0.1+1.33*w 0.25 w h]);
        trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
            double(data(vl)),'EdgeColor','none');
        view(90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;


    case 'rh'

        h=0.37; %height
        w=0.30; %width

        a(1)=axes('position',[0.1+0.33*w 0.25 w h]);
        trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
            double(data(vr)),'EdgeColor','none');
        view(-90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

        a(2)=axes('position',[0.1+1.33*w 0.25 w h]);
        trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
            double(data(vr)),'EdgeColor','none');
        view(90,0);
        daspect([1 1 1]); axis tight; camlight; axis vis3d off;
        lighting phong; material dull; shading flat;

end


for i=1:length(a)
    set(a(i),'CLim',clim);
    set(a(i),'Tag',['SurfStatView ' num2str(i) ]);
end


cb=colorbar('location','South');
set(cb,'Position',[0.35 0.18 0.3 0.03]);
set(cb,'XAxisLocation','bottom');
h=get(cb,'Title');
set(h,'String', in.label_text);

whitebg(gcf, in.background);
set(gcf,'Color', in.background, 'InvertHardcopy', 'off');

dcm_obj = datacursormode(gcf);
set(dcm_obj, 'UpdateFcn', @SurfStatDataCursor, 'DisplayStyle', 'window');

%% set colorbar range
cb = colorbar_range(in.color_range)

%% set colormaps
enigma_colormap(in.cmap)

%al857: position colorbar (was being overridden by colorbar_range)
set(cb, 'location','South');
%set(cb,'Position',[0.35 0.18 0.3 0.03]);

set(cb,'Position',[0.42 0.29 0.16 0.02]);

return
end
