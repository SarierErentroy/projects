import ballerina/io;
int i=0;
int staticS=0;
int fieldS=0;
int varS=0;
int argumentS=0;
int class_symbol=0;
int method_symbol=0;
int ifstatement1=-1;
int whilestatment1=-1;
int listNum=0;


public type parsing object {

    SymbolTable class_symbol_table = new();
    SymbolTable method_symbol_table = new();

function __init()
{
    
}

function classConstructor()
{
    staticS=0;
    fieldS=0;
    varS=0;
    argumentS=0;
    class_symbol=0;
    method_symbol=0;
}



function kindOf(string varName)returns string
{
    string resultKind="";
    resultKind=self.class_symbol_table.kindOf(varName);
    if(resultKind=="")
    {
        resultKind=self.method_symbol_table.kindOf(varName);
    }
    return resultKind;
}

function indexOf(string varName)returns string
{
    int j=0;
    string resultIndex="";
    resultIndex=self.class_symbol_table.indexOf(varName);
    if(resultIndex=="")
    {
        resultIndex=self.method_symbol_table.indexOf(varName);
    }
    return resultIndex;
}


function typeOf(string varName)returns string
{
    string resultType="";
    resultType=self.class_symbol_table.typeOf(varName);
    if(resultType=="")
    {
        resultType=self.method_symbol_table.typeOf(varName);
    }
    return resultType;
}


function parsing(string text)returns string
{
    self.classConstructor();
    string text1=text;
    string result="";
    string help="";
    i=0;
    string className="";
    text1=text1.substring(9,text1.length());

    text1=text1.substring(self.line(text1).length(),text1.length());
    className=giveWord(text1);
    text1=text1.substring(self.line(text1).length(),text1.length());
    text1=text1.substring(self.line(text1).length(),text1.length());

    help="";
    help=self.classVarDec(text1);
    while(help!="")
    {
      text1=text1.substring(help.length(),text1.length());
      help="";
      help=self.classVarDec(text1);
    }
    help="";
    int j=i;  
    help=self.subroutineDec(text1,className);
    while(help!="")
    {
      result= result+help;
      while(j<i)
      {
          help=self.line(text1);
          text1=text1.substring(help.length(),text1.length());
          j+=1;
      }
      
      help="";
      j=i;
      help=self.subroutineDec(text1,className);
    }
    return result;
}


function classVarDec(string text)returns string
{
    string help="";
    string result="";
    string text1=text;
    string typeS="";
    string kindS="";
    string name="";
    if(giveWord(text1)=="static"||giveWord(text1)=="field")
    {
        kindS=giveWord(text1);
        result+=self.line(text1);
        text1=text1.substring(self.line(text1).length(),text1.length());

        typeS=giveWord(text1);
        result+=self.line(text1);
        text1=text1.substring(self.line(text1).length(),text1.length());

        name=giveWord(text1);
        result+=self.line(text1);
        text1=text1.substring(self.line(text1).length(),text1.length());
        if(kindS=="static")
        {
            int s=staticS;
            int c=class_symbol;
            self.class_symbol_table.define(kindS, typeS, name,staticS);
            staticS+=1;
            class_symbol+=1;
        }
        else if(kindS=="field")
        {
            self.class_symbol_table.define("this", typeS, name,fieldS);
            fieldS+=1;
            class_symbol+=1;
        }

        while(giveWord(text1)!=";")
        {
            help=self.line(text1);
            result+=help;
            text1=text1.substring(help.length(),text1.length());
             help=self.line(text1);
            result+=help;
            name=giveWord(text1);
            text1=text1.substring(help.length(),text1.length());
            if(kindS=="static")
            {
            self.class_symbol_table.define(kindS, typeS, name,staticS);
            staticS+=1;
            class_symbol+=1;
            }
            else if(kindS=="field")
            {
            self.class_symbol_table.define("this", typeS, name,fieldS);
            fieldS+=1;
            class_symbol+=1;
            }

            
        }

        help=self.line(text1);
        result+=help;
    }
    return result;
}


function line(string text)returns string
{
    int i=0;
    int j=1;
    string result="";
    while(text.length()>=1 && text.substring(i,j)!="\n")
    {
        result+=text.substring(i,j);
        i+=1;
        j+=1;
    }
    return result+"\n";
}

function subroutineDec(string text,string className)returns string
{
    string help="";
    string result="";
    string text1=text;
    if(giveWord(text1)=="constructor"||giveWord(text1)=="function"||giveWord(text1)=="method")
    {
        argumentS=0;
        varS=0;
        whilestatment1=-1;
        ifstatement1=-1;
        self.method_symbol_table=new();
         if(giveWord(text1)=="method")
        {
            self.method_symbol_table.define("argument",className,"this",argumentS);
            argumentS+=1;
            method_symbol+=1;
        }

         i+=4;
         help=self.line(text1);
         string kindOfFunction=giveWord(text1);
         text1=text1.substring(help.length(),text1.length());

         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());

         help=self.line(text1);
         string nameOfFunction=giveWord(text1);
         text1=text1.substring(help.length(),text1.length());

         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());

        help="";
        help=self.parameterList(text1);
        text1=text1.substring(help.length(),text1.length());
        
        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i=i+1;
        help="";
        help=self.subroutineBody(text1,className,kindOfFunction,nameOfFunction);
        result=help;

    }
    return result;
}




function parameterList(string text)returns string
{
    string text1=text;
    string help="";
    string result="";
    string kindS="arg";
    string typeS="";
    string name="";

     if(giveWord(text1)!=")")
    {
        i+=1;
        typeS=giveWord(text1);
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length()); 

        i+=1;
        name=giveWord(text1);
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length());

        self.method_symbol_table.define("argument",typeS,name,argumentS);
        argumentS+=1;
        method_symbol+=1;  
    }

    while(giveWord(text1)==",")
    {
        i+=1;
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length()); 

        i+=1;
        typeS=giveWord(text1);
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length()); 

        i+=1;
        name=giveWord(text1);
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length());

        self.method_symbol_table.define("argument",typeS,name,argumentS);
        argumentS+=1;
        method_symbol+=1;  
 

    }
    return result;
}

function subroutineBody(string text,string className,string kindOfFunction,string nameOfFunction)returns string
{
    string text1=text;
    string help="";
    string result="";
    
    help=self.line(text1);
    i+=1;
    text1=text1.substring(help.length(),text1.length());
    help="";
    help=self.varDec(text1);
    while(help!="")
    {
      text1=text1.substring(help.length(),text1.length());
      help="";
      help=self.varDec(text1);
    }
    
    
    result=result+"function "+className+"."+nameOfFunction+" " +varS.toString()+"\n";
    
    if( kindOfFunction == "method")
    {
        result=result+"push argument 0"+"\n"+"pop pointer 0"+"\n";
	}

	else if(kindOfFunction == "constructor")  
    {
        result=result+"push constant "+fieldS.toString()+"\n"+"call Memory.alloc 1"+"\n"+"pop pointer 0"+"\n";
	}
    help="";
    help=self.statments(text1,className);
    result=result + help;
    i+=1;
    return result;
}

function varDec(string text)returns string
{
    string text1=text;
    string help="";
    string result="";
    string typeS="";
    string name="";
    
    if(giveWord(text1)=="var")
    {
        
        i+=1;
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length()); 

        i+=1;
        typeS=giveWord(text1);
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length()); 

        i+=1;
        name=giveWord(text1);
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length());

        self.method_symbol_table.define("local",typeS,name,varS);
        varS+=1;
        method_symbol+=1;  
 
    }

    while(giveWord(text1)==",")
    {
        i+=1;
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length()); 

        i+=1;
        name=giveWord(text1);
        help=self.line(text1);
        result=result+help;
        text1=text1.substring(help.length(),text1.length());

        self.method_symbol_table.define("local",typeS,name,varS);
        varS+=1;
        method_symbol+=1;  
 

    }
    if(result!="")
    {
         i+=1;
         result=result+self.line(text1);
    }
    
    return result;
}

function statments(string text,string className)returns string
{
    string text1=text;
    string help="";
    string result="";
    int j=i;
    string line1=giveWord(text1);
    while(line1=="let" || line1=="if" || line1=="while" || line1=="do" || line1=="return")
    {
        j=i;
        help = self.statment(text1,className);
        result=result+help;
        while(j<i)
        {
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            j+=1;
        } 
        line1=giveWord(text1);
    }
    return result;
}

function statment(string text,string className)returns string
{
    string text1=text;
    string help="";
    string result="";
    if(giveWord(text1)=="let")
    {
        help=self.letStatment(text1);
        result=result+help;
    }

    if(giveWord(text1)=="if")
    {
        help=self.ifStatment(text1,className);
        result=result+help;
    }

    if(giveWord(text1)=="while")
    {
        help=self.whileStatment(text1,className);
        result=result+help;
    }

    if(giveWord(text1)=="do")
    {
        help=self.doStatment(text1,className);
        result=result+help+"pop temp 0"+"\n";
    }

    if(giveWord(text1)=="return")
    {
        help=self.returnStatment(text1);
        result=result+help;
    }
    return result;
}

function letStatment(string text)returns string
{
    string text1=text;
    string help="";
    string result="";
    string varName="";
    boolean flag=false;
    int j=0;
    i+=2;

    help=self.line(text1);
    text1=text1.substring(help.length(),text1.length());
   
    help=self.line(text1);
    varName=giveWord(text1);
    text1=text1.substring(help.length(),text1.length());
   

   
    if(giveWord(text1)=="[")  
    {
        flag=true;
        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
       
        i+=1;
        j=i;

        help=self.expression(text1);
        result+=help;
        while(j<i)
        {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
        }
        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;

        result=result + "push " + self.kindOf(varName) + " " + self.indexOf(varName)+"\n";
		result=result + "add"+"\n";
    }  

        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        
        i+=1;
        j=i;
        help = self.expression(text1);
        result=result+help;
        while(j<i)
        {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
        }

        if (flag)
        {
            result=result+ "pop temp 0" +"\n"+"pop pointer 1"+"\n"+ "push temp 0" + "\n"+ "pop that 0"+"\n";
	    } 
        else
        {
            result=result+ "pop "+ self.kindOf(varName)+" "+ self.indexOf(varName)+"\n";
	    }

        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;
        return result;
}

function ifStatment(string text,string className)returns string
{
    string text1=text;
     string help="";
     string result="";
    int j=0;
    i+=2;
    int ifstatement =0;
	ifstatement1+=1;
	ifstatement = ifstatement1;

    while(j<2)
    {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
    }

        j=i;
        help=self.expression(text1);
        result=result+help;
        while(j<i)
        {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
        }

        result=result + "if-goto IF_TRUE"+ ifstatement.toString()+"\n";
	    result=result + "goto IF_FALSE"+ ifstatement.toString()+"\n";
	    result=result + "label IF_TRUE"+ ifstatement.toString()+"\n"; 

        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;

        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;

        j=i;
        help=self.statments(text1,className);
        result=result+help;

        while(j<i)
        {
          help=self.line(text1);
          text1=text1.substring(help.length(),text1.length());
          j+=1;
        }
        help=self.line(text1);
        i+=1;
        text1=text1.substring(help.length(),text1.length());


        boolean ifelse=false;
        
        if(giveWord(text1)=="else")
        {
            result=result+ "goto IF_END"+ifstatement.toString()+"\n";
		    ifelse=true;
        }

         result=result+ "label IF_FALSE"+ifstatement.toString()+"\n";
         
        if(giveWord(text1)=="else")
        {
            j=0;
            i+=2;
            while(j<2)
            {
                help=self.line(text1);
                text1=text1.substring(help.length(),text1.length());
                j+=1;
            } 
            
        
             j=i;
            help=self.statments(text1,className);
            result=result+help;
            
            while(j<i)
            {
                help=self.line(text1);
                text1=text1.substring(help.length(),text1.length());
                j+=1;
            }
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;

            
        }
        if(ifelse)
        {
            result=result+ "label IF_END"+ifstatement.toString()+"\n";
        }
        

        return result;
}


function whileStatment(string text,string className)returns string
{

    string text1=text;
    string help="";
    string result="";
    int j=0;
    
    int whilestatment =0;
	whilestatment1+=1;
	whilestatment = whilestatment1;

    result=result+ "label WHILE_EXP"+ whilestatment.toString()+"\n";
    i+=2;
    while(j<2)
    {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
    }

        j=i;
        help=self.expression(text1);
        result=result + help;
        while(j<i)
        {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
        }

        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;

        result=result+ "not"+"\n";
	    result=result+ "if-goto WHILE_END" + whilestatment.toString()+"\n";

        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;

        j=i;
        help=self.statments(text1,className);
        result=result+help;

        while(j<i)
        {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
        }

        help=self.line(text1);
        i+=1;
        text1=text1.substring(help.length(),text1.length());
        
        result=result + "goto WHILE_EXP"+  whilestatment.toString()+"\n";
	     result=result + "label WHILE_END"+  whilestatment.toString()+"\n";
         
    return result;
    
}


function doStatment(string text,string className)returns string
{
    string text1=text;
    string help="";
    string result="";
    string functionName1="";
	string functionName2="";

    help=self.line(text1);
    text1=text1.substring(help.length(),text1.length());
    i+=1;
	
    functionName1=giveWord(text1);
    help=self.line(text1);
    text1=text1.substring(help.length(),text1.length());
    i+=1;

	 if(giveWord(text1)=="(")
		{
			help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
            result=result+"push pointer 0"+"\n";
            help=self.expressionList(text1);
            listNum+=1;
            result=result+help+"call "+className+"."+functionName1+" "+listNum.toString()+"\n";
			listNum = 0;
			i+=1;
		}
	else if(giveWord(text1)==".")
		{
			help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
			functionName2=giveWord(text1);
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
			help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
            
			if(self.kindOf(functionName1)!="") 
            {
                result=result+"push "+self.kindOf(functionName1)+" "+self.indexOf(functionName1).toString()+"\n";
				functionName1 =self.typeOf(functionName1);
				listNum+=1;
			}

			help=self.expressionList(text1);
            result=result+help;
            result=result+"call "+functionName1+"."+functionName2+" "+listNum.toString()+"\n";
			listNum = 0;
			i+=1;
	}
	 i+=1;
     return result;

}


function returnStatment(string text)returns string
{

    string text1=text;
    string help="";
    string result="";
    help=self.line(text1);
    text1=text1.substring(help.length(),text1.length());
    i+=1;
    if(giveWord(text1)!=";")
    {
        help=self.expression(text1);
        result=result+help;
    }
    else
    {
        result=result+"push constant 0"+"\n";
    }
    result=result+"return"+"\n";
    i+=1;
    return result;
}


function expression(string text)returns string
{
    string text1=text;
    string help="";
    string result="";
    int j=i;
    string operator="";
    if(giveWord(text1)==")")
    {
        return result;
    }
    help=self.term(text1);
    result=result+help;
    while(j<i)
    {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
    }
    while(giveWord(text1)=="+"||giveWord(text1)=="-"||giveWord(text1)=="*"||giveWord(text1)=="/"||giveWord(text1)=="&amp;"||giveWord(text1)=="&lt;"|| giveWord(text1)=="&gt;"|| giveWord(text1)=="=" ||giveWord(text1)=="|")
    {
        //  Main.double(2) + 1];  // a[5] = 8 * 5 = 40
        operator=giveWord(text1);
        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;
        j=i;
        help=self.term(text1);
        result=result+help;
        while(j<i)
        {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
        }

        if (operator=="+") 
        {
			result=result+"add"+"\n";
		} 
        else if (operator=="-")  
        {
			result=result+"sub"+"\n";
		}
        else if (operator=="*")
        {
			result=result+"call Math.multiply 2"+"\n";
		} 
        else if (operator=="/") 
        {
			result=result+"call Math.divide 2"+"\n";
		}
        else if (operator=="&amp;")
        {
			result=result+"and"+"\n";
		}
        else if (operator=="|") 
        {
			result=result+"or"+"\n";
		}
        else if (operator=="&lt;")
        {
			result=result+"lt"+"\n";
		}
        else if (operator=="&gt;") 
        {
			result=result+"gt"+"\n";
		} 
        else if (operator=="=")
        {
			result=result+"eq"+"\n";
		}

    }
    
    return result;
}

function subroutineCall(string text)returns string
{
    string text1=text;
    string help="";
    string result="";
    int j=0;

    help=self.line(text1);
    text1=text1.substring(help.length(),text1.length());
    i+=1;
    if(giveWord(text1)=="(")
    {
        help=self.line(text1);
        text1=text1.substring(help.length(),text1.length());
        i+=1;
        help="";
        help=self.expressionList(text1);
        if(help!="")
        {
            result=result + help;
        }
        i+=1;
    }
    else
    {
        while(j<3)
        {
         help=self.line(text1);
         text1=text1.substring(help.length(),text1.length());
         j+=1;
         i+=1;
        }
        help="";
        help=self.expressionList(text1);
        if(help!="")
        {
            result=result+help;
        }
        i+=1;
    }
        
    return result;
}

function expressionList(string text)returns string
{
    string text1=text;
    string help="";
    string result="";
    int j=i;
    if(giveWord(text1)!=")")
    {
        listNum+=1;
        help=self.expression(text1);
        if(help!="")
        {
        result=result+help;
        while(j<i)
        {
           help=self.line(text1);
           text1=text1.substring(help.length(),text1.length());
           j+=1;
        }
        }
       while(giveWord(text1)!=")")
        {
            help=self.line(text1);
            i+=1;
            text1=text1.substring(help.length(),text1.length());
            j=i;
            help=self.expression(text1);
            result=result+ help;
             while(j<i)
             {
                help=self.line(text1);
                text1=text1.substring(help.length(),text1.length());
                j+=1;
             }
             listNum+=1;
        }
    }
    return result;
}

function term(string text)returns string
{
    string text1=text;
    string help="";
    string result="";
    string unary="";
    if((text1.length()>=17 && text1.substring(0,17)=="<integerConstant>"))
    {
        i+=1;
        result=result+"push constant "+giveWord(text1)+"\n";
    }
    else if(text1.length()>=17 && text1.substring(0,16)=="<stringConstant>")
    {
        string str=giveWord(text1);
        if(str.length()>0)
        {
            result=result+"push constant "+str.length().toString()+"\n"+"call String.new 1"+"\n";
        }
        int k=0;
        int m=1;
         while(m<=str.length())
        {
            result=result+"push constant "+str.substring(k,m).toBytes().toString()+"\n"+"call String.appendChar 2"+"\n";
            m+=1;
            k+=1;
        }
        i+=1;
    }
    else if (giveWord(text1)=="true")
    {
        result=result+"push constant 0"+"\n"+"not"+"\n";
        i+=1;
    }
    else if (giveWord(text1)=="false"||giveWord(text1)=="null")
    {
        result=result+"push constant 0"+"\n";
        i+=1;
    }
    else if (giveWord(text1)=="this") 
    {
        result=result+"push pointer 0"+"\n";
        i+=1;
    }
    else if (giveWord(text1)=="(")
    {
        help=self.line(text1);
        i+=1;
        text1=text1.substring(help.length(),text1.length());
        help=self.expression(text1);
        result=result+help;
        i+=1;
        
    }
    else if(giveWord(text1)=="-"||giveWord(text1)=="~")
    {
        unary=giveWord(text1);
        help=self.line(text1);
        i+=1;
        text1=text1.substring(help.length(),text1.length());
        help=self.term(text1);
        result=result+help;
        if(unary=="-")
        {
            result=result+"neg"+"\n";
        }
        else if(unary=="~")
        {
            result=result+"not"+"\n";
        }
    }
    else
    {
        string temp2="";
        string text2=text1;
        help=self.line(text2);
        text2=text2.substring(help.length(),text2.length());
        
         
        if(giveWord(text2)=="[")
        {
             
            temp2=giveWord(text1);
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;

            help=self.expression(text1);
            result=result+help;
            i+=1;
            result=result+"push "+self.kindOf(temp2)+" "+self.indexOf(temp2)+"\n"+"add"+"\n"+"pop pointer 1"+"\n"+"push that 0"+"\n";

        }
        else if(giveWord(text2)=="(")
        {
            result=result+"push argument 0"+"\n";
            temp2=giveWord(text1);
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
            help=self.expressionList(text1);
            result+=help;
            result=result+"call "+temp2+" "+varS.toString()+"\n";
            i+=1;
        }
        else if(giveWord(text2)==".")
        {
            temp2=giveWord(text1);

            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;

            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;

            string text3=giveWord(text1);
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
            help=self.line(text1);
            text1=text1.substring(help.length(),text1.length());
            i+=1;
            if (self.kindOf(temp2)!="") 
            {
                result=result+"push "+self.kindOf(temp2)+" "+self.indexOf(temp2)+"\n";
			    temp2=self.typeOf(temp2);
			    listNum+=1;
            }
            help=self.expressionList(text1);
            result+=help;
            result=result+"call "+temp2+"."+text3+" "+listNum.toString()+"\n";
		    listNum = 0;
            i+=1;

        }
        else
        {
            help=giveWord(text1);
            result=result+"push "+self.kindOf(help)+" "+self.indexOf(help)+"\n";
            i+=1;
        }
        
    }
    return result;
}

};