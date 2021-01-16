import ballerina/io;


public type SymbolTable object {
    
    table<Symbol> tableS = table {{name, varType, kind, index},[]};
    
    function __init() 
    {
        self.tableS = table {
        {name, varType, kind, index}, []};
    }

    function define(string kind, string varType, string name, int index) {
        Symbol newSymbol = {name: name, varType: varType, kind: kind, index: index};
        var help = self.tableS.add(newSymbol);
        if (help is error) {
            io:println("error:", newSymbol);
        }
    }

    function varCount(string kind) returns int {
        int counter = 0;
        foreach Symbol symbol in self.tableS {
            if (symbol.kind == kind) {
                counter += 1;
            }
        }
        return counter;
    }

    function kindOf(string name) returns string {
        string resultKind="";
        foreach Symbol symbol in self.tableS 
        {
             if(symbol.name == name)
             {
                resultKind=symbol.kind;
             }
        }
        return resultKind; 
    }

    function typeOf(string name) returns string {
        string resulttype="";
        foreach Symbol symbol in self.tableS 
        {
             if(symbol.name == name)
             {
                resulttype=symbol.varType;
             }
        }
        return resulttype; 
    }

    function indexOf(string name) returns string {
        string resultIndex="";
        foreach Symbol symbol in self.tableS 
        {
             if(symbol.name == name)
             {
                resultIndex=symbol.index.toString();
             }
        }
        return resultIndex;        
    }
};


type Symbol record {
    string name;
    string varType; 
    string kind; 
    int index; 
};