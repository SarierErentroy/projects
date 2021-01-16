//michal micha 207617622 
//sari erentreu 318927845
//150060.31.5780.01, 150060.31.5780.43

import ballerina/io;
import ballerina/file;
import ballerina/log;
import ballerina/lang.'int;

int sumLable=0;
function closeRc(io:ReadableCharacterChannel ch) 
{
    var cr = ch.close();
    if (cr is error) 
    {
        log:printError("Error occurred while closing the channel: ", err = cr);
    }
}

function closeWc(io:WritableCharacterChannel ch)  
{
    var cr = ch.close();
    if (cr is error)
     {
        log:printError("Error occurred while closing the channel: ", err = cr);
    }
}


function removVm(string word)returns string
{
    int i=0;
    int j=1;
    string result="";
    while(word.substring(i,j)!=".")
    {
        result+=word.substring(i,j);
        i+=1;
        j+=1;
    }
    return result;
}

function word(string word)returns string
{
    int i=0;
    int j=1;
    string result="";
    while(j<=word.length() && word.substring(i,j)!=" ")
    {
        result+=word.substring(i,j);
        i+=1;
        j+=1;
        
    }
    return result;
}

function addBal()returns string
{
    string result="\n"+"//add"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"D=M"+"\n"+"A=A-1"+"\n"+"M=D+M"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
    return result;

}

function subBal()returns string
{
    string result="\n"+"//sub"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n" + "A=A-1" + "\n" + "M=M-D" + "\n"+"@SP"+"\n"+"M=M-1"+"\n";
    return result;
}

function negBal()returns string
{
    string result="\n"+"//neg"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n" + "M=-D" + "\n" ;
    return result;
}

function eqBal()returns string
{
    string result="\n"+"//eq"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n"+ "A=A-1" + "\n"+  "D=M-D" + "\n" +"@IF_TRUE"+ sumLable.toString()+"\n"
                   +"D;JEQ"+"\n"+"D=0"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"A=A-1"+"\n"+"M=D"+"\n"+"@IF_FALSE"+sumLable.toString()+"\n"
                   +"0;JMP"+"\n"+"(IF_TRUE"+sumLable.toString()+")"+"\n"+"D=-1"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"A=A-1"+"\n"+"M=D"+"\n" +"(IF_FALSE"+sumLable.toString()+")"
                   +"\n"+"@SP"+"\n"+"M=M-1"+"\n"; 
    sumLable+=1;                  
    return result;
}

function gtBal()returns string
{
    string result="\n"+"//gt"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n"+ "A=A-1" + "\n"+  "D=M-D" + "\n" +"@IF_TRUE"+ sumLable.toString()+"\n"
                   +"D;JGT"+"\n"+"D=0"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"A=A-1"+"\n"+"M=D"+"\n"+"@IF_FALSE"+sumLable.toString()+"\n"
                   +"0;JMP"+"\n"+"(IF_TRUE"+sumLable.toString()+")"+"\n"+"D=-1"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"A=A-1"+"\n"+"M=D"+"\n"+"(IF_FALSE"+sumLable.toString()+")"
                   +"\n"+"@SP"+"\n"+"M=M-1"+"\n"; 
    sumLable+=1;                  
    return result;
}

function ltBal()returns string
{
    string result="\n"+"//lt"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n"+ "A=A-1" + "\n"+  "D=M-D" + "\n" +"@IF_TRUE"+ sumLable.toString()+"\n"
                   +"D;JLT"+"\n"+"D=0"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"A=A-1"+"\n"+"M=D"+"\n"+"@IF_FALSE"+sumLable.toString()+"\n"
                   +"0;JMP"+"\n"+"(IF_TRUE"+sumLable.toString()+")"+"\n"+"D=-1"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"A=A-1"+"\n"+"M=D"+"\n"+"(IF_FALSE"+sumLable.toString()+")"
                   +"\n"+"@SP"+"\n"+"M=M-1"+"\n"; 
    sumLable+=1;                  
    return result;
}

function andBal()returns string
{
    string result="\n"+"//and"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n" + "A=A-1" + "\n" + "M=D&M" + "\n"+"@SP"+"\n"+"M=M-1"+"\n";
    return result;
}

function orBal()returns string
{
    string result="\n"+"//or"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n" + "A=A-1" + "\n" + "M=D|M" + "\n"+"@SP"+"\n"+"M=M-1"+"\n";
    return result;
}

function notBal()returns string
{
    string result="\n"+"//not"+"\n"+"@SP" + "\n" + "A=M-1" + "\n" + "D=M" + "\n" + "M=!D" + "\n" ;
    return result;
}


function pushthisBal(string num)returns string
{
    string result="\n"+"//push this "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@THIS"+"\n"+"A=M+D"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
    return result;
}

function pushthatBal(string num)returns string
{
    string result="\n"+"//push that "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@THAT"+"\n"+"A=M+D"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
    return result;
}

function pushtempBal(string num)returns string
{
     string result="\n"+"//push temp "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@5"+"\n"+"A=D+A"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
     return result;
}
 
function pushlocalBal (string num)returns string
{
    string result="\n"+"//push local "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@LCL"+"\n"+"A=M+D"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
    return result;
}

function pushstaticBal (string num,string name)returns string
{
    string result="\n"+"//push static "+num+"\n"+"@"+name+"."+num+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
    return result;
}

function pushpointerBal(string num)returns string
{
    string help = "";
    if(num.startsWith("1"))
    {
        help="THAT";
    }
    if(num.startsWith("0"))
    {
        help="THIS";
    }
    string result="\n"+"//push "+help+" "+num+"\n"+"@"+help+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
    return result;

}

function pushconstantBal(string num)returns string
{
    string result="\n"+"//push constant "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
    return result;
}

function pushargumentBal(string num)returns string
{
    string result="\n"+"//push argument "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@ARG"+"\n"+"A=M+D"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n";
     return result;
}



function popthisBal(string num)returns string
{
    string result="\n"+"//pop this "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@THIS"+"\n"+"D=M+D"+"\n"+"@TEMP"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"D=M"+"\n"+"@TEMP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
     return result;
}

function popthatBal(string num)returns string
{
    string result="\n"+"//pop that "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@THAT"+"\n"+"D=M+D"+"\n"+"@TEMP"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"D=M"+"\n"+"@TEMP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
     return result;
}

function poptempBal(string num)returns string
{
    string result="\n"+"//pop temp "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@5"+"\n"+"D=A+D"+"\n"+"@TEMP"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"D=M"+"\n"+"@TEMP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
     return result;
}
function poplocalBal(string num)returns string
{
    string result="\n"+"//pop local "+num+"\n"+"@"+num+"\n"+"D=A"+"\n"+"@LCL"+"\n"+"D=M+D"+"\n"+"@TEMP"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"D=M"+"\n"+"@TEMP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
     return result;
}

function popstaticBal(string num,string name)returns string
{
    string result="\n"+"//pop static "+num+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"D=M"+"\n"+"@"+name+"."+num+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
    return result;
}

function poppointerBal(string num)returns string
{
     string help="";
    if(num.startsWith("1"))
    {
        help="THAT";
    }
    if(num.startsWith("0"))
    {
        help="THIS";
    }
    string result="\n"+"//pop "+help+" "+num+"\n"+"@SP"+"\n"+"A=M-1"+"\n"+"D=M"+"\n"+"@"+help+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
    return result;
}

function popargumentBal(string num)returns string
{
    string result="\n"+"//pop argument "+num+"\n"+"@" + num + "\n" + "D=A" + "\n" + "@ARG" + "\n" + "D=M+D" + "\n" + "@TEMP" + "\n" + "M=D" + "\n" + "@SP" + "\n" + "A=M-1" + "\n" +"D=M"+"\n"+"@TEMP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M-1"+"\n";
     return result;
}

function gotoBal(string nameLable, string nameFile)returns string
{
     string result="\n"+"//goto "+nameLable+"\n"+"@"+nameFile+"."+nameLable+"\n"+"0;JMP"+"\n";
     return result;
}

function ifGotoBal(string nameLable, string nameFile)returns string
{
     string result="\n"+"//if-goto "+nameLable+"\n"+"@SP"+"\n"+"M=M-1"+"\n"+"A=M"+"\n"+"D=M"+"\n"+"@"+nameFile+"."+nameLable+"\n"+"D;JNE"+"\n";
     return result;
}

function labelBal(string nameLable, string nameFile)returns string
{
     string result="\n"+"//label  "+nameLable+"\n"+"("+nameFile+"."+word(nameLable)+")"+"\n";
     return result;
}

function calBal(string line)returns string
{
    string func=word(line);
     string funcNum=line.substring(func.length()+1,line.length()-1);
     int sofi=0;
     int |error funcNumSub='int:fromString(funcNum);
     if(funcNumSub is int)
     {
       sofi= funcNumSub+5;
     }
     else 
     {
        string funcNum2=word(line.substring(func.length()+1,line.length()-1));
        int |error  funcNumSub2='int:fromString(funcNum2);
        if(funcNumSub2 is int)
        {
            sofi=funcNumSub2+5;
        }
     }
    
    string result= "\n"+"//call  "+line+"\n"+
                   "//push return address"+"\n"+"@"+func+".ReturnAddress"+sumLable.toString()+"\n"+"D=A"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n"+
                   "//push LCL"+"\n"+"@LCL"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n"+
                   "//push ARG"+"\n"+"@ARG"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n"+
                   "//push THIS"+"\n"+"@THIS"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n"+
                   "//push THAT"+"\n"+"@THAT"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"A=M"+"\n"+"M=D"+"\n"+"@SP"+"\n"+"M=M+1"+"\n"+
                   "//ARG=SP-n-5"+"\n"+"@SP"+"\n"+"D=M"+"\n"+"@"+sofi.toString()+"\n"+"D=D-A"+"\n"+"@ARG"+"\n"+"M=D"+"\n"+
                   "//LCL=SP"+"\n"+"@SP"+"\n"+"D=M"+"\n"+"@LCL"+"\n"+"M=D"+"\n"+
                   "//goto g"+"\n"+"@"+func+"\n"+"0;JMP"+"\n"+
                   "//label ReturnAddress"+"\n"+"("+func+".ReturnAddress"+sumLable.toString()+")"+"\n";
     sumLable+=1;
     return result;
}

function functionBal(string line, string nameFile)returns string
{
    string func=word(line);
    string funcNum=line.substring(func.length()+1,line.length());
    string result= "\n"+"//function  "+line+"\n"+
                   "//label"+func+"\n"+"("+func+")"+"\n"+"@"+funcNum+"\n"+"D=A"+"\n"+"@"+func+".End"+"\n"+"D;JEQ"+"\n"+"("+func+".LOOP"+")"+"\n"+
                   "@SP"+"\n"+"A=M"+"\n"+"M=0"+"\n"+"@SP"+"\n"+"M=M+1"+"\n"+"@"+func+".LOOP"+"\n"+"D=D-1;JNE"+"\n"+ "("+func+".End"+")"+"\n"; 
    return result;             
}

function returnBal()returns string
{
     string result= "\n"+"//return  "+"\n"+
                    "//fram=LCL"+"\n"+"@LCL"+"\n"+"D=M"+"\n"+
                    "//ret=*(fram-5)"+"\n"+"//ram[13]=(local-5)"+"\n"+"@5"+"\n"+"A=D-A"+"\n"+"D=M"+"\n"+"@13"+"\n"+"M=D"+"\n"+
                    "//*arg=pop()"+"\n"+"@SP"+"\n"+"M=M-1"+"\n"+"A=M"+"\n"+"D=M"+"\n"+"@ARG"+"\n"+"A=M"+"\n"+"M=D"+"\n"+
                    "//SP=ARG+1"+"\n"+"@ARG"+"\n"+"D=M"+"\n"+"@SP"+"\n"+"M=D+1"+"\n"+
                    "//THAT=*(fram-1)"+"\n"+"@LCL"+"\n"+"M=M-1"+"\n"+"A=M"+"\n"+"D=M"+"\n"+"@THAT"+"\n"+"M=D"+"\n"+
                    "//THIS=*(fram-2)"+"\n"+"@LCL"+"\n"+"M=M-1"+"\n"+"A=M"+"\n"+"D=M"+"\n"+"@THIS"+"\n"+"M=D"+"\n"+
                    "//ARG=*(fram-3)"+"\n"+"@LCL"+"\n"+"M=M-1"+"\n"+"A=M"+"\n"+"D=M"+"\n"+"@ARG"+"\n"+"M=D"+"\n"+
                    "//LCL=*(fram-4)"+"\n"+"@LCL"+"\n"+"M=M-1"+"\n"+"A=M"+"\n"+"D=M"+"\n"+"@LCL"+"\n"+"M=D"+"\n"+
                    "//go-to ret"+"\n"+"@13"+"\n"+"A=M"+"\n"+"0;JMP"+"\n";
     return result;
}

function pushBal(string line, string name)returns string
{
    string result="";
    if(line.substring(5,9)== "this")
    {
         result=pushthisBal(line.substring(10,line.length()));
    }
    else if(line.substring(5,9)== "that")
    {
         result=pushthatBal(line.substring(10,line.length()));
    }
    else if(line.substring(5,9)== "temp")
    {
         result=pushtempBal(line.substring(10,line.length()));
    }

    else if(line.substring(5,10)== "local")
    {
         result=pushlocalBal(line.substring(11,line.length()));
    }
    else if(line.substring(5,11)== "static")
    {
         result=pushstaticBal(line.substring(12,line.length()),name);
    }
    else if(line.substring(5,12)== "pointer")
    {
         result=pushpointerBal(line.substring(13,line.length()));
    }
     else if(line.substring(5,13)== "constant")
    {
         result=pushconstantBal(line.substring(14,line.length()));
    }
      else if(line.substring(5,13)== "argument")
    {
         result=pushargumentBal(line.substring(14,line.length()));
    }
    return result;
}



function popBal(string line, string name)returns string
{
    string result="";
    if(line.substring(4,8)== "this")
    {
         result=popthisBal(line.substring(9,line.length()));
    }
    else if(line.substring(4,8)== "that")
    {
         result=popthatBal(line.substring(9,line.length()));
    }
    else if(line.substring(4,8)== "temp")
    {
         result=poptempBal(line.substring(9,line.length()));
    }

    else if(line.substring(4,9)== "local")
    {
         result=poplocalBal(line.substring(10,line.length()));
    }
    else if(line.substring(4,10)== "static")
    {
         result=popstaticBal(line.substring(11,line.length()),name);
    }
    else if(line.substring(4,11)== "pointer")
    {
         result=poppointerBal(line.substring(12,line.length()));
    }
      else if(line.substring(4,12)== "argument")
    {
         result=popargumentBal(line.substring(13,line.length()));
    }
    return result;

    

}


function checkBal(string line, string name)returns string
{
    string result="";
    if(line.startsWith("add"))
     {
         result=addBal();
     }
     if(line.startsWith("sub"))
     {
         result=subBal();
     }
     if(line.startsWith("neg"))
     {
         result=negBal();
     }
     if(line.startsWith("eq"))
     {
         result=eqBal();
     }
     if(line.startsWith("gt"))
     {
         result=gtBal();
     }
     if(line.startsWith("lt"))
     {
         result=ltBal();
     }
     if(line.startsWith("and"))
     {
         result=andBal();
     }
     if(line.startsWith("or"))
     {
         result=orBal();
     }
     if(line.startsWith("not"))
     {
         result=notBal();
     }
     
     
     if(line.startsWith("push"))
     {
         result=pushBal(line,name);
     }
      if(line.startsWith("pop"))
     {
         result=popBal(line,name);
     }
     if(line.startsWith("goto"))
     {
         result=gotoBal(line.substring(5,line.length()),name);
     }
      if(line.startsWith("if-goto"))
     {
         result=ifGotoBal(line.substring(8,line.length()-1),name);
     }

      if(line.startsWith("label"))
     {
         result=labelBal(line.substring(6,line.length()-1),name);
     }

      if(line.startsWith("call"))
     {
         result=calBal(line.substring(5,line.length()));
     }

      if(line.startsWith("function"))
     {
         result=functionBal(line.substring(9,line.length()),name);
     }

     if(line.startsWith("return"))
     {
         result=returnBal();
     }




     return result;
     
}











public function main() returns @tainted error?{
     
     string choice = io:readln("Please enter your file ");
     file:FileInfo[]|error readDirResults = file:readDir(<@untained>  choice);
     string help="";
     string text = "@256"+"\n"+"D=A"+"\n"+"@SP"+"\n"+"M=D"+"\n"+calBal("Sys.init 0 ");
       //string text="";
     if(readDirResults  is file:FileInfo[])
     {
         
        foreach var f in readDirResults
        {
           
           if(f.getName().endsWith(".vm"))
            {
                help = "./"+choice+"/"+f.getName();
                io:ReadableByteChannel readVmFile =
                                check io:openReadableFile(<@untained>  help);
                io:ReadableCharacterChannel sourceVmChannel =
                                new(readVmFile, "UTF-8");
                boolean flag = true;
                boolean flag2 = true;
                
                while (flag)
                {
                       
                    string line="";
                    string | error char = sourceVmChannel.read(1);
                    while(char!="\n" && flag && char!="/")
                    {
                        if(char is string)
                        {
                            if(char=="/")
                            {
                                flag2=false;
                            }
                            if(flag2)
                            {
                                line += char;
                            }
                        }
                        else 
                        {
                           flag = false;
                        }
                        char = sourceVmChannel.read(1);
                    }
                    
                    
                    flag2=true;
                    string result = checkBal(line,removVm(f.getName()));
                          text+=result;
                       

                }
                 help=choice+".asm";
                 string help1="./"+choice+"/"+help;
                string|error createFileResults = file:createFile(<@untained>  help1); 
                io:WritableByteChannel writableFileResult =
                                check io:openWritableFile(<@untained>  help1);
                io:WritableCharacterChannel destinationChannel =
                                        new(writableFileResult, "UTF-8");

                     var writeCharResult1 =  check destinationChannel.write(text, 0);
                      closeRc(sourceVmChannel);
                      closeWc(destinationChannel);
        
            }     
        }
     }
}