
//michal micha 207617622 
//sari erentreu 318927845
//150060.31.5780.01, 150060.31.5780.43

import ballerina/io;
import ballerina/file;
import ballerina/log;

//tokenizing----------------------------------------------------------------------------------------------



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

function removJack(string word)returns string
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



function removT1(string word)returns string
{
    boolean flag=false;
    int i=0;
    int j=1;
    string result="";
    while(flag==false)
    {
        if (word.substring(i,j)=="T")
        {
             if (word.substring(i+1,j+1)=="1")
             {
                 flag=true;
             }
             else
              {
                 result+=word.substring(i,j);
                 i+=1;
                 j+=1;
              }
        }
        else
        {
            result+=word.substring(i,j);
                 i+=1;
                 j+=1;
        }
        
    }
    return result;
}





public function main() returns @tainted error?
{
     
     string resultToXml="";
     string choice = io:readln("Please enter your file ");
     file:FileInfo[]|error readDirResults = file:readDir(<@untained>  choice);
    
     if(readDirResults  is file:FileInfo[])
     {
         
        foreach var f in readDirResults
        {
           
           if(f.getName().endsWith(".jack"))
            {
                string help = "./"+choice+"/"+f.getName();
                io:ReadableByteChannel readJackFile =
                                check io:openReadableFile(<@untained>  help);
                io:ReadableCharacterChannel sourceJackChannel =
                                new(readJackFile, "UTF-8");

                help="./"+choice+"/"+removJack(f.getName())+"T1.xml";       
                string|error createFileResults = file:createFile(<@untained>  help);
                string help1="./"+help;
              
                io:ReadableByteChannel readT1File =
                                check io:openReadableFile(<@untained>  help1);
                io:ReadableCharacterChannel sourceT1Channel =
                                new(readT1File, "UTF-8");
                                
                
                io:WritableByteChannel writableFileResult =
                                check io:openWritableFile(<@untained>  help1);
                io:WritableCharacterChannel destinationChannel =
                                        new(writableFileResult, "UTF-8");
            
                
                help="./"+choice+"/"+removJack(f.getName())+".vm";
                string|error createParsingResults = file:createFile(<@untained>  help);
                 help1="./"+help;

                io:WritableByteChannel writableFileResultParsing =
                                check io:openWritableFile(<@untained>  help);
                io:WritableCharacterChannel destinationChannelParsing =
                                        new(writableFileResultParsing, "UTF-8");
            
                string text="";
                boolean flag = true;
                string | error char = sourceJackChannel.read(1);
                while (flag)
                {
                    if(char=="/")
                    {
                       string | error char2 = sourceJackChannel.read(1); 
                       if(char2=="/")
                       {
                           while(char!="\n" && flag)
                            {
                                char = sourceJackChannel.read(1);
                            }
                       }
                       else if(char2=="*")
                       {
                           while(char != "*" || char2 != "/")
                           {
                               char=char2;
                               char2 = sourceJackChannel.read(1);
                           }
                           
                       }
                    

                      else
                      {
                            if(char2 is string && char is string)
                           {
                               text = text+char+char2;
                           }
                      }

                    }
                    else if(char is string )
                    {

                        text+=char;
                    }
                    else
                    {
                         flag = false;
                    }
                   char = sourceJackChannel.read(1);

                }

                resultToXml = "<tokens>"+"\n"+tokenizing(text)+"</tokens>"+"\n";
                var writeCharResult1 =  check destinationChannel.write(resultToXml, 0);
                      closeRc(sourceJackChannel);
                      closeWc(destinationChannel);
            //parsing

                
                

                text="";
                flag = true;
                char = sourceT1Channel.read(1);
                while (flag)
                {
                    if(char=="/")
                    {
                       string | error char2 = sourceT1Channel.read(1); 
                       if(char2=="/")
                       {
                           while(char!="\n" && flag)
                            {
                             if(char is string) 
                             {
                               string s="";
                             }
                             else 
                             {
                                flag = false;
                             }
                            char = sourceT1Channel.read(1);
                           }
                       }
                       else if(char2=="*")
                       {
                           char = sourceT1Channel.read(1);
                           while(char!="/" && flag)
                            {
                             if(char is string) 
                             {
                               string s="";
                             }
                             else 
                             {
                                flag = false;
                             }
                            char = sourceT1Channel.read(1);
                           }
                       }

                        else
                        {
                            if(char2 is string && char is string)
                            {
                                text = text+char+char2;
                            }
                        }

                    }
                       
                    else if(char is string )
                    {

                        text+=char;
                    }
                    else
                    {
                         flag = false;
                    }
                   char = sourceT1Channel.read(1);

                }
                parsing p=new();
                resultToXml = p.parsing(text);
                var writeCharResult11 =  check destinationChannelParsing.write(resultToXml, 0);
                      closeRc(sourceT1Channel);
                      closeWc(destinationChannelParsing);



              

            }     
        }
     }
}