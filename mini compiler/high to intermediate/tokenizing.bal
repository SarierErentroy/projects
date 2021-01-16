//import ballerina/io;

string [] keyword=["class","constructor","function","method","field","static","var","int","char","boolean","void","true","false","null","this","let","do","if","else","while","return"];
string [] symbol=["{","}","(",")","[","]",".",",",";","+","-","*","/","&","|","<",">","=","~"];
string [] integerConstant=["1","2","3","4","5","6","7","8","9","0"];
string [] constant=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","_"];


function giveWord(string word)returns string
{
    int i=0;
    int j=1;
    string result="";
    while(j<=word.length() && word.substring(i,j)!=" ")
    {
        i+=1;
        j+=1;
    }

    i+=1;
    j+=1;

    while(j<=word.length() && word.substring(i,j)!="<")
    {
        result+=word.substring(i,j);
        i+=1;
        j+=1;
    }
    if(result.length()>=1)
    {
        result=result.substring(0, result.length()-1);
    }
    
    return result;
}

function tokenizing(string rtokenizing1)returns string
{
    string rtokenizing = rtokenizing1;
    string help="";
    string result="";
    string resultSofi="";

    while(rtokenizing !="")
    {
        result="";
        if(rtokenizing.substring(0,1).toBytes().toString()!="32")
        {
             if(rtokenizing.substring(0,1).toBytes().toString()=="9")
             {
                rtokenizing=rtokenizing.substring(1,rtokenizing.length());
             }
             else 
             {
                 
             result=keywordTokenizing(rtokenizing);
             if(!(result==""))
             {
               help=giveWord(result);
               rtokenizing=rtokenizing.substring(help.length(),rtokenizing.length());
             }
             else
             {
                result=symbolTokenizing(rtokenizing);
                if(!(result==""))
                {
                   rtokenizing=rtokenizing.substring(1,rtokenizing.length());
                }
                else
                {
                     result=integerConstantTokenizing(rtokenizing);
                    if(!(result==""))
                    {
                         help=giveWord(result);
                        rtokenizing=rtokenizing.substring(help.length(),rtokenizing.length());
                    }
                    else
                    {
                         result=constantTokenizing(rtokenizing);
                        if(!(result==""))
                        {
                           help=giveWord(result);
                           rtokenizing=rtokenizing.substring(help.length(),rtokenizing.length());
                        }
                        else
                        {
                                result=stringConstantTokenizing(rtokenizing);
                                help=giveWord(result);
                                rtokenizing=rtokenizing.substring(help.length()+2,rtokenizing.length());
                    
                        }

                    }

                }
              
          }
    
       }
    }
       else
        {
           rtokenizing=rtokenizing.substring(1,rtokenizing.length()); 
        }
        
         
         if(result!="")
         {
            resultSofi+=result;
         }
        
     }

    
    return resultSofi;
    
}

function keywordTokenizing(string rtokenizing1)returns string
{
    boolean flag=false;
    string result="";
    string rtokenizing=rtokenizing1;
    int i=0;
    while(i<keyword.length() && flag==false)
    {
        if(rtokenizing.length()>=keyword[i].length())
        {
            if(rtokenizing.substring(0,keyword[i].length())==keyword[i])
           {
             if((rtokenizing.substring(keyword[i].length(), keyword[i].length()+1).toBytes().toString()=="32") && !(isSymbol(rtokenizing.substring(keyword[i].length(),keyword[i].length()+1))) && (rtokenizing.substring(keyword[i].length(),keyword[i].length()+1)!="\""))          
             {
                flag=true;
                result="<keyword> " + rtokenizing.substring(0,keyword[i].length())+" </keyword>"+"\n";
             }
            }

        }
           
        
        i+=1;
    }
    
     return result;
}

function isSymbol(string tav)returns boolean
{
    int i=0;
    while(i<symbol.length())
    {
        if(symbol[i]==tav)
        {
            return true;
        }
        i+=1;
    }
    return false;
}


function symbolTokenizing(string rtokenizing1)returns string
{ 
    boolean flag=false;
    string result="";
    string rtokenizing=rtokenizing1;
    int i=0;
    while(i<symbol.length() && flag==false)
    {
        if(rtokenizing.substring(0,1)==symbol[i])
        {
             if(symbol[i]=="<")          
             {
                result="<symbol> "+"&lt;"+" </symbol>"+"\n";
               
             }
             else if(symbol[i]==">")          
             {
                result="<symbol> "+"&gt;"+" </symbol>"+"\n";
               
             }
             else if(symbol[i]=="&")          
             {
                result="<symbol> "+"&amp;"+" </symbol>"+"\n";
               
             }
             else
             {
                 result="<symbol> "+symbol[i]+" </symbol>"+"\n";
             }
                flag=true;

        }
        i+=1;
    }
    
     return result;
}


function integerConstantTokenizing(string rtokenizing1)returns string
{
    string help="";
    string result="";
    boolean flag=false;
    string rtokenizing=rtokenizing1;
    int i=0;
    while(flag==false)
    {
        if(isInteger(rtokenizing.substring(0,1)))
        {
            help+=rtokenizing.substring(0,1);
            rtokenizing=rtokenizing.substring(1,rtokenizing.length());
        }
        else
        {
            flag=true;
        }
    }
    if(help!="")
    {
       result="<integerConstant> " + help + " </integerConstant>"+"\n";
    }
    return result;
}


function isInteger(string tav)returns boolean
{
    int i=0;
    while(i<integerConstant.length())
    {
        if(integerConstant[i]==tav)
        {
            return true;
        }
        i+=1;
    }
    return false;
}



function constantTokenizing(string rtokenizing1)returns string
{
    string help="";
    string result="";
    boolean flag=false;
    (string)rtokenizing=rtokenizing1;
    int i=0;
    while(flag==false)
    {
        if(isconstant(rtokenizing.substring(0,1)))
        {
            help+=rtokenizing.substring(0,1);
            rtokenizing=rtokenizing.substring(1,rtokenizing.length());
        }
        else
        {
            flag=true;
        }
    }
    if(help!="")
    {
       result = "<identifier> " +help+" </identifier>"+"\n";
    }
    return result;
}


function isconstant(string tav)returns boolean
{
    int i=0;
    while(i<constant.length())
    {
        if(constant[i]==tav)
        {
            return true;
        }
        i+=1;
    }
    return false;
}

function stringConstantTokenizing(string rtokenizing1)returns string
{
    string help="";
    string result="";
    boolean flag=false;
    string rtokenizing=rtokenizing1;
    int i=0;
    if(rtokenizing.substring(0,1)=="\"")
    {
        rtokenizing=rtokenizing.substring(1,rtokenizing.length());
       while(rtokenizing.length()>=1 && rtokenizing.substring(0,1)!="\"")
       {
            help+=rtokenizing.substring(0,1);
            rtokenizing=rtokenizing.substring(1,rtokenizing.length());
       }
       result="<stringConstant> " +help+" </stringConstant>"+"\n";
    }
    return result;
}


function tabTokenizing(string rtokenizing1)returns boolean
{
    string help="";
    boolean flag=false;
    (string)rtokenizing=rtokenizing1;
    int i=0;
     while(rtokenizing.substring(0,1)!=" ")
       {
         rtokenizing=rtokenizing.substring(1,rtokenizing.length());
         flag=true;
       }
    return flag;
}

function lineTokenizing(string rtokenizing1)
{
    string help="";
    boolean flag=false;
    (string)rtokenizing=rtokenizing1;
    int i=0;
     while(rtokenizing.substring(0,1)!="\n")
       {
         rtokenizing=rtokenizing.substring(1,rtokenizing.length());
       }
}