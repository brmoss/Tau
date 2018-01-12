% Function to extract the values from Tau sol.dat file

function [table] = ExtractPvals(filename)
    fid  = fopen( filename, 'r' ) ;
    line = fgetl(fid);
    while(sum(line(1:9)=='VARIABLES')<9)
        line = fgetl(fid);
    end
    j=1;
    n=1;
    while n<length(line)
        char = line(n);
        if line(n) == '"'
            n=n+1;
            char = line(n);
            i=1;
            while line(n) ~= '"'
                vararray(i) = line(n);
                i=i+1;
                n=n+1;
                char = line(n);
            end
            variables(j) = string(vararray);
            clear vararray;
            j=j+1;
        end
        if n < length(line) 
            n=n+1;
        end
        char = line(n);
    end
     variables = genvarname(cellstr(variables));  
    
    A = fscanf(fid,'%f');
    for index = 1:length(variables)
        s.variables{index} = index;
        n=1;
        for n=1:length(A)/length(variables)
            array(n,index) = A((n-1)*length(variables) + index);
        end
        
    end
    table = array2table(array,'VariableNames',variables);
end

