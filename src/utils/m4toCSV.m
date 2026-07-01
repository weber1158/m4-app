function [myCSV,metadata] = m4toCSV(folder_path)
%Convert all m4 files in a folder to a CSV-ready table
%
%Syntax
% [data,metadata] = M4TOCSV(folder_path)
%
%
%Note: the `metadata` output is the metadata for the first file only
%
%
%Example 
% iceCoreData = M4TOCSV('C:\User\JohnDoe\Multisizer4\IceCore\')
%

  % Get the names of the files in the specified directory
  directory = folder_path;
  files = dir(fullfile(directory,'*.xls'));
  filenames = {files.name}';

  % Data extraction
  starting_point = 1;
  n = numel(filenames);
  fprintf('Reading file %s (%d of %d)\n', filenames{starting_point}(1:end-8), starting_point, n)
  % Check if file is corrupted
    if check_ascii([directory '\' filenames{1}])
      error(sprintf('>> File "%s" contains non-ASCII characters! The file was likely corrupted by compression effects when copied/pasted. Check the file for unusal structure and characters, then try copying the data again from the Coulter Counter computer.\n', filenames{1}))
    end
  % Extract data from first file
  [myCSV,metadata] = readm4xls([directory '\' filenames{starting_point}]);
  num_size_bins = metadata.NumSizeBins;
  var_units = repmat({'Counts (Volumetric, 50 uL)'},[num_size_bins 1]);
  myCSV.Properties.VariableUnits = var_units;
  myCSV.File = {metadata.FileName}; % add (1:end-4) to omit '.#m4'
  myCSV = movevars(myCSV,'File','Before','0.63-0.8');
  % Loop through remaining files in folder
  for i = (starting_point+1):n
    fprintf('Reading file %s (%d of %d)\n', filenames{i}(1:end-8), i, n)
    % Check if file is corrupted
    if check_ascii([directory '\' filenames{i}])
      warning(sprintf('>> File "%s" contains non-ASCII characters! This means that the file was likely corrupted during compression when copying/pasting from the Coulter Counter computer to the flash drive. Skipping to next file.\n', filenames{i}))
      continue
    end
    iCSV = readm4xls([directory '\' filenames{i}]);
    iCSV.Properties.VariableUnits = var_units;
    iCSV.File = filenames{i}(1:end-4);
    iCSV = movevars(iCSV,'File','Before','0.63-0.8');
    myCSV = [myCSV; iCSV];
  end
  fprintf('Finished!\n')
end