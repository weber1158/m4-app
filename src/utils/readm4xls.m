function [data,meta] = readm4xls(filename)
%Read data from Multisizer 4
%
%Syntax
%  [data,metadata] = READM4XLS(filename)
%

  % Local function
  function i = meta_idx(C,str)
      i = find(contains(string(C(:,1)),str));
  end
  % Metadata
  if nargout == 2
    C = readcell(filename,'FileType','text');
    meta.CollectionDate    = C{meta_idx(C,'Multisizer 4'),2};
    meta.FileName          = C{meta_idx(C,'File name:'),2};
    meta.ElectrolyteMatrix = C{meta_idx(C,'Electrolyte:'),2};
    meta.ElectrolyteVolume = C{meta_idx(C,'Electrolyte volume:'),2};
    meta.ControlMode       = C{meta_idx(C,'Control mode:'),2};
    meta.ApertureDiameter  = C{meta_idx(C,'Aperture diameter:'),2};
    meta.ApertureCurrent   = C{meta_idx(C,'Aperture current:'),2};
    meta.ElapsedTime       = C{meta_idx(C,'Elapsed time:'),2};
    meta.NumSizeBins       = C{meta_idx(C,'Size bins:'),2};
    meta.TotalPulses       = C{meta_idx(C,'Total pulses:'),2};
  end

  % Raw data
  raw = readtable(filename,'FileType','text',...
    'NumHeaderLines',37,'Delimiter','tab',...
    'ReadRowNames',true,...
    'ReadVariableNames',false);
  raw = renamevars(raw,'Var1','Counts');

  % Get size bins
  size_bins_lower = string(raw.Properties.RowNames(1:end-1));
  size_bins_upper = string(raw.Properties.RowNames(2:end));
  size_bins = join([size_bins_lower size_bins_upper],'-')';

  % Save data to table with appropriate column labels
  data = array2table(raw.Counts(1:end-1)','VariableNames',size_bins);
end